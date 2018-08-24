
function Calibrate()
{
	while [ $# != 0 ]; do
		case "$1" in
			-h | --help) Usage;;
			-c | --cmd)shift; cmd=$*;;
			-t | --tps) speed=$1; shift;;
			*)
			;;
		esac
	done
	for i in $(seq 1 3); do
		load=$( { time for i in $(seq 1 5); do $cmd; done; } 2>&1  | \
			grep real -w | awk '{gsub(/s/,""); split($0, a, /m/);  print a[2] * 1000000}')
	done
	load=$((load / 5))
	if ((load > 1000000)); then
		echo "Run 0 times in 1 second!"
		exit 1
	else
		max_speed=$((1000000 / load))
		echo "At most run $max_speed times in 1 second."
		echo "Defined speed is $speed run per second."
		if ((speed > max_speed)); then
			echo "Can't run $speed times in 1 second."
			exit 1
		fi
		us_sleep=$((1000000 - $((speed * load)) ))
		us_sleep=$((us_sleep / 3))
		us_sleep=43488
	fi

	wind=10
	while true; do
		run=1000
		c_run=$((run + 1))
		dur=$((run / speed))
		tstart=$(date +%s)
		reason=0
		loop=0
		if ((wind > speed)); then
			wind=speed
		fi
		echo "Looping $loop: us_sleep=$us_sleep"
		while ((diff <= dur)); do
			${cmd}
			usleep $us_sleep
			curr=$(date +%s)
			diff=$((curr - tstart))
			tps=$(( $((c_run - run)) / $((diff + 1)) ))
			delta=$((tps - speed))
			((run--))
			echo "Try $((c_run - run)) Diff=$diff, tps=$tps: us_sleep=$us_sleep"
			if ((tps == speed)); then
				((hit++))
				((hit > 10)) && echo "Matched: us_sleep=$us_sleep" && exit
			else
				hit=0
			fi
			# Use speed s as a window.
			if (( $(($((diff+1)) % wind)) == 0 )); then
				if ((delta < -5)); then
					us_sleep=$((us_sleep - $((us_sleep / 4)) ))
					reason=1
					((wind++))
					echo "Speeding up with recuding sleep. us_sleep=$us_sleep"
					break
				elif ((delta > 5)); then
					us_sleep=$((us_sleep + $((us_sleep / 3)) ))
					reason=1
					((wind++))
					echo "Speeding up with recuding sleep. us_sleep=$us_sleep"
					break
				elif ((delta < -1)); then
					us_sleep=$((us_sleep - $((us_sleep / 5)) ))
					reason=1
					((wind++))
					echo "Speeding up with recuding sleep. us_sleep=$us_sleep"
					break
				elif ((delta > 1));  then
					us_sleep=$((us_sleep + $((us_sleep / 10)) ))
					reason=2
					echo "Slow down with up sleep. us_sleep=$us_sleep"
					((wind++))
					break
				elif ((delta == -1)); then
					us_sleep=$((us_sleep - 1000))
					echo "Speeding up with 1ms. us_sleep=$us_sleep"
					((us_sleep < 0 )) && echo "underflow!" && exit
					reason=3
					((wind++))
					break
				else
					us_sleep=$((us_sleep + 8000 ))
					echo "Speeding up with 8ms. us_sleep=$us_sleep"
					reason=4
					((wind++))
					break
				fi
			fi
			((run < -5)) && break
		done

		((loop++))

		((reason > 0)) && continue

		if ((run <= 5)) && ((run >= -5)); then
			echo "Matched: us_sleep=$us_sleep"
			break
		elif ((run < -5)); then
			us_sleep=$((us_sleep + 10000 ))
		else
			us_sleep=$((us_sleep - 10000 ))
			((us_sleep < 0 )) && echo "under flow" && exit
		fi
	done
}

function CreateRunerScript()
{
	cat > runner.sh << EOF 
#!/bin/bash
while true; do
	execute_times=0
	start=$(date +%s)
	end=$((start + 1))
	while [ $execute_times -lt 10 ]; do
		curl $url
	done
	((execute_times++))
	while [ "$(expr $(date +%s) \> $end)" != 1 ]; do
		usleep 10
	done
done
EOF
}

function WindowControl()
{
	local wlen=1
	local scnt=10
	local win_end=$((start_time + 1))
	local gap=10
	local cmd=$*
	local curr=$(date +%s)
	while [ "$(expr $curr \> win_end)" != 1 ]; do
		$cmd
	done	
}
