
package_cpus_mask=${1:-1f0fff000}
package_cpus_mask=$(echo $package_cpus_mask | awk 'BEGIN{FS="";}
	{
		for (i=1; i<=NF; i++)
		{
			printf "%s",$i
			if ((NF-i)%8 == 0 && i!=NF)
				printf ","
		}
	}
	END {printf "\n"}')

echo $package_cpus_mask
