#include <stdio.h>
int main(){
	long size;
	char path[2049];
	while(scanf("%ld*[ \n\t]%2048s", &size, path) == 2) {
		printf("read: %ld %2048s\n", size, path);
	}
	printf("terminated: %ld %2048s\n", size, path);
}
