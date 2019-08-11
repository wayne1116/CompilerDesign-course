
void main()
{
		int num;
		float s=0;
		double i=0;
		i+=num+2.34;
		printf("Please enter a number: ");
		scanf("%d %f", &num, &s);

		if(num>10){
				if(num > 20){
						s=10;
				}
				else{
						s=30;
				}
		}
		else{
				if(num>5){
						s=20;
				}
				else{
						s=40;
				}
				//s=20;
		}
		printf("The result is %f\n", s);
}
