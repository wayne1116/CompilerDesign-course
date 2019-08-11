void main()
{
		int a[10];
		float b[10];
		double c[10];
		int i=0;

		for(i=0; i<10; i+=1){
				a[i]=0;
				b[i]=0;
				c[i]=0;
		}

		a[5]=10;
		a[3]=20;
		a[1]=a[3]*a[5];
		printf("a[%d] = a[%d]*a[%d] = %d\n", 1, 3, 5, a[1]);

		b[0]=20.1111;
		c[1]=20.2222;
		c[2]=20.3333;
		b[0]+=c[1]+c[2];
		printf("b[%d] += c[%d]+c[%d] = %f\n", 0, 1, 2, b[0]); 
}
