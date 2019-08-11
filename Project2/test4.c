//#include<stdio.h>
int main()
{
		int a, b;
		int c;
		if(a>b) printf("a>b\n");
		if(a<b){
			printf("a<b\n");
        }
		if(a==b)
			printf("a=b\n");

        c=a+b;
		switch(c){
				case 1: a=a+1;
				        break;
				case 2: b=b+1;
				        break;
				default: c=-1;
				        break;
		}
}
