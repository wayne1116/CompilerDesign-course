file: mylexer.g
	java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool mylexer.g
compile: mylexer.java testLexer.java
	javac -cp ./antlr-3.5.2-complete.jar testLexer.java mylexer.java
exe1: input1.c 
	java -cp ./antlr-3.5.2-complete.jar:. testLexer input1.c
exe2: input2.c
	java -cp ./antlr-3.5.2-complete.jar:. testLexer input2.c
exe3: input3.c
	java -cp ./antlr-3.5.2-complete.jar:. testLexer input3.c
clean:
	rm -f *.class mylexer.java mylexer.tokens	

