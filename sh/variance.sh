awk \
'BEGIN {
	sum=0
	ave=0
	s=0
	i=0
	min=$1
	max=$1
}
{
	if (NR == 1) {
		max=$1
		min=$1
	}
	if (min > $1) min=$1
	if (max < $1) max=$1
	sum+=$1
	a[NR]=$1
}
END {
	ave=sum/NR
	for(i=0; i<NR; i++) {
		s+=(a[$i]-ave)*(a[$i]-ave)
	}
	s=sqrt(s);
	printf"%s\t%s\t%s\t%s\t%s\n", "min", "max", "ave", "sum" ,"variance"
	printf"%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n", min, max, ave, sum, s/ave;
	sum=0;
}'
