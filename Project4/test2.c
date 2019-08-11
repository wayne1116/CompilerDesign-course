void main()
{
		int i=0, j=0;
		int result=0;
		float ans =0.0, result1=0;

		for(i=0; i<10; i+=1){
				for(j=0; j<=200; j+=2){
						printf("The answer of i+j is : %d\n", i+j);
						if(j==10){
								printf("The j value %d equal to ten\nThe i value %d\n", j, i);
								break;
						}
				}
		}
		
		result1=0;
		while(ans<100){
				result1 += 2*(3.14+ans);
				ans+=1;
		}
		printf("The result1 value is %f\n", result1);
}
