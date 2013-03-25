MAXJOBID=646413
i="645334"
while [ $i -le $MAXJOBID ]
do
	qdel $i

i=$(( $i + 1 ))
done


