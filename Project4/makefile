step1:
	java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
step2:
	javac -cp ./antlr-3.5.2-complete.jar:. myCompiler_test.java

test1: test1.c
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test1.c > myResult.j
	java -jar ./jasmin-2.4/jasmin.jar myResult.j
	java myResult

test2: test2.c
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test2.c > myResult.j
	java -jar ./jasmin-2.4/jasmin.jar myResult.j
	java myResult

test3: test3.c
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test3.c > myResult.j
	java -jar ./jasmin-2.4/jasmin.jar myResult.j
	java myResult

clean:
	rm -rf *.class *.tokens myCompilerLexer.java myCompilerParser.java *.j
