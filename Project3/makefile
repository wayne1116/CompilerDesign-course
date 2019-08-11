step1: myInterp.g
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool myInterp.g
step2: myInterp_test.java
	javac -cp antlr-3.5.2-complete.jar:. myInterp_test.java
test1: test1.c
	java -cp antlr-3.5.2-complete.jar:. myInterp_test test1.c
test2: test2.c
	java -cp antlr-3.5.2-complete.jar:. myInterp_test test2.c
test3: test3.c
	java -cp antlr-3.5.2-complete.jar:. myInterp_test test3.c
clean:
	rm -rf *.class *.tokens myInterpLexer.java myInterpParser.java
