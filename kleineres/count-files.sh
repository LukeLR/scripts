for i in $(find "$1" -maxdepth "$2" -type d); do 
	echo -n "$i: "; 
	(find "$i" -type f | wc -l) ; 
done
