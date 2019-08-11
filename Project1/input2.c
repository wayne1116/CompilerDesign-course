main()
{
	const int a=10;
	int i=0, j=0;
	for(i=0; i<a; i++){
		for(j=a; j>=0; j--){
			if(i>j) printf("yes\n");
			else if(i<j) printf("no\n");
			else printf("even\n");
		}
	}

	i=0;
	while(i<a){
		if(i>j) break;
		++i;
	}
}
