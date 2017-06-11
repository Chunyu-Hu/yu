#!/bin/bash

nr_cpu=$(grep -w processor /proc/cpuinfo | wc -l)
cpu_start=1
export cpu_end=$((nr_cpu - 1))
export cpu_curr=$cpu_start
# seconds to run
duration=120

loop=10

#jitter control
dt_25=0
dt_10=0
dt_5=0
dt_2=0
dt_1=0
dt_m25=0
dt_m10=0
dt_m5=0
dt_m2=0
thr_25=0
thr_10=0
thr_5=0
thr_2=0
thr_1=0

trap "exec 9>&-;exec <9&-;exit" 2
# smp number control
mkfifo hello
exec 9<>hello
rm hello -f

function Usage()
{
	case $1 in
	run|*)
		echo "$0 run [opts] <cmd>
Execute nr <cmd> per second
opts:
    -d | --duration                       How long to run.
    -t | --tps                            Smp numbers per second."
	;;
	esac
	exit
}

function LogInfo()
{
	echo "Info: [$(date +%h%m%s)]" $*
}

function LogDebug()
{
	if ((verbose)); then
		echo $*
	fi
}

function ParseDuration()
{
	local tm=$1
	if echo "$tm" | grep -E "h$"; then
		tm=${tm//h}
		duration=$((tm * 3600))
	elif echo "$tm" | grep -E "d$"; then
		tm=${tm//d}
		duration=$((tm * 3600 * 24))
	elif echo "$tm" | grep -E "s$"; then 
		tm=${tm//s}
		duration=$tm
	else
		duration=${duration:-$tm}
	fi
}

default_cmd="curl -s -X GET localhost"
speed=10

function short_loop()
{
	for v in $(seq 1 $loop); do
		val=$(date +%s)
		val=$((val / 1121))
		val=$((val * 11))
	done
}

function AdjustUsleep()
{
	# Begin to reduce tokens to let fewer process to run
	if ((us_sleep > 500000)); then
		if ((cocurrent > 1)); then
			read -u9
			((cocurrent--))
		fi
		((us_sleep > 1000000)) && us_sleep=950000
	fi
}

function SpeedDown()
{
	if ((delta > 25)); then
		((dt_25 > thr_25)) && us_sleep=$((us_sleep + 500000)) &&
		dt_10=0 || ((dt_25++))
		((batch > 2)) && batch=$((batch - 2)) 
		AdjustUsleep
	elif ((delta > 10)); then
		((dt_10 > thr_10))  && us_sleep=$((us_sleep + 500000)) &&
		dt_10=0 && loop=$((loop+20)) || ((dt_10++))
		((batch > 5)) && batch=$((batch -1))
		AdjustUsleep
	elif ((delta > 5)); then
		((dt_5 > thr_5))  && us_sleep=$((us_sleep + 250000)) &&
		dt_5=0 && loop=$((loop+10)) || ((dt_5++))
		AdjustUsleep
	elif ((delta >= 2)); then
		((dt_2 > thr_2))  && us_sleep=$((us_sleep + 120000)) &&
		dt_2=0 && loop=$((loop+5))|| ((dt_2++))
		AdjustUsleep
	else
		((dt_1 > thr_1)) && loop=$((loop + 1)) &&
		dt_1=0 || ((dt_1++))
	fi
}

function SpeedUp()
{
	if ((delta < -25)); then
		((dt_m25 > thr_25))  && us_sleep=$((us_sleep - us_sleep)) &&
			batch=$((batch + 3)) && dt_m25=0 || ((dt_m25++))
	elif ((delta < -10)); then
		((dt_m10 > thr_10))  && us_sleep=$((us_sleep - 90000)) &&
		dt_m10=0 || ((dt_m10++))
	elif ((delta < -5)); then
		((dt_m5 > thr_5))  && us_sleep=$((us_sleep - 40000)) &&
		dt_m5=0 || ((dt_m5++))
	elif ((delta <= -2)); then
		((dt_m2 > thr_2))  && us_sleep=$((us_sleep - 20000)) &&
		dt_m2=0 || ((dt_m2++))
	else
		((dt_m1 > thr_1)) && us_sleep=$((us_sleep - 10000)) &&
		dt_m1=0 || ((dt_m1++))
	fi

	if ((us_sleep < 0)); then
		us_sleep=0
		batch=$((batch+ 2 ))
		echo "Speed reach high boundary! Can't speed up. Increase batch size to $batch"
	fi
}

function SpeedControl()
{
	delta=$((tps - speed))
	if ((delta > 0)); then
		SpeedDown $*
	else
		SpeedUp $*
	fi
	if ((speed > 50)); then
		loop=0
		us_sleep=0
	fi
	usleep $us_sleep
}

function SpeedReport()
{
	true
}

function CalDuration()
{
    local start=$1
	local end=${2:-$(date +%s.%N)}
	local start_s=$(echo $start| cut -d '.' -f 1)
	local start_ns=$(echo $start| cut -d '.' -f 2)
	local end_s=$(echo $end| cut -d '.' -f 1)
	local end_ns=$(echo $end| cut -d '.' -f 2)
    local time_micro=$(( (10#$end_s-10#$start_s)*1000000 + (10#$end_ns/1000 - 10#$start_ns/1000) ))
	local time_ms=$(expr $time_micro/1000  | bc)
	#echo "$time_micro microseconds"
    echo "$time_ms"
}

function RunOneBatch()
{
	for i in $(seq 1 $batch); do
		local busy=0
		local begin=$(date +%s.%N)
		read -u9
		local end=$(date +%s.%N)
		local dr=$(CalDuration $begin $end)
		if (( dr > 5)); then
			LogDebug "Debug: Queue for token. blocked=$dr ms, jobs="$(jobs -p)""
			buzy=1
		fi
		runs=$((runs+1))
		((cpu_curr++))
		if [ $cpu_curr -gt $cpu_end ]; then
			cpu_curr=0
		fi
		LogDebug "Running: $i $cmd"
		{
			run_cmd="taskset -c $cpu_curr ${cmd:-$default_cmd}"
			eval $run_cmd
			echo 1>&9
		} &
		short_loop
	done
	wait
}

function PrintInfo()
{
	((quiet)) && return
	echo -n "Running: $cmd (total: $run_total) "
	echo "Batch=$batch, speed=$speed, duration=$cur_duration, run_total=$run_total, \
tps_whole=$tps_whole, tps=$tps, interval=$us_sleep, binterval=$loop, smp=$cocurrent"
}

# should be used in RunTest
function RunOneWindow()
{
	win_start_time="$(date +%s)"
	win_start_time_ns="$(date +%s.%N)"
	while (( $(( $(date +%s) - win_start_time )) < wind )); do
		RunOneBatch
	done
	win_dur=$(CalDuration $win_start_time_ns)
	tps=$((runs / wind))
	cur_duration=$(( $(date +%s) - start_time))

	run_total=$((run_total + runs))
	tps_whole=$(( run_total / $((cur_duration + 1)) ))

	PrintInfo
	SpeedControl
	runs=0
}

function RunTest()
{
	LogInfo "start test run ..."

	us_sleep=100000
	wind=2
	runs=0
	run_total=0
	batch=10
	cocurrent=10

	start_time="$(date +%s)"
	end_time=$((start_time + duration))
	# smp number to $cocurrent every moment.
	for c in $(seq 1 $cocurrent); do
		echo "token" 1>&9
	done

	while (( $(date +%s) < end_time )); do
		RunOneWindow
	done

	LogInfo "end test run ..."
}

function Main()
{
	case "$1" in
		run)
		shift
		while [ $# != 0 ]; do
			case "$1" in
			-h | --help) Usage ;;
			-d | --duration) duartion=$2; shift 2;;
			-t | --tps) speed=$2; shift 2;;
			-q | --quiet) quiet=1; shift;;
			-v | --verbose) verbose=1; shift;;
			-*)	 Usage ;;
			*)   cmd+="$1 "; shift;;
			esac
		done
		RunTest
		;;
		*)
		Usage
		;;
	esac
}

Main "$@"

