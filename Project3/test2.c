void main()
{
	int a=10, c=20.0;
	float b=20, d=30.24;
	double i, j, k;
	
	scanf("%f %f %d", &b, &a, &c);
	if(b<=10 && a>=10){
		a=(double)3.0*(a+5.0)+(1000+1000.1);
	}
	else{
		a=(double)3.66+10000+0.2178;
	}
	printf("The result is good %f %f\n", a, b);
}
