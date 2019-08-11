void main()
{
		double i, j, k;
		i=20*(5.0+3.444-2.4889)+40/20;
		j=10;
		k=20;
		printf("i= %f\tj= %f\tk= %f\n", i, j, k);
		if(i!=k){
				if(i==j){
						printf("i==j\n");
						i=0.11;
						j=0.22;
						k=0.33;
				}
				else{
					printf("i!=j\n");
					i=1.1;
					j=2.2;
					k=3.3;
				}
		}
		printf("i= %f j=%f k=%f\n", i, j, k);
}
