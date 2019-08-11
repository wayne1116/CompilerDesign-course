step1: myparser.g
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool myparser.g
step2: testParser.java
	javac -cp antlr-3.5.2-complete.jar:. testParser.java
test1: test1.c
	java -cp antlr-3.5.2-complete.jar:. testParser test1.c
test2: test2.c
	java -cp antlr-3.5.2-complete.jar:. testParser test2.c
test3: test3.c
	java -cp antlr-3.5.2-complete.jar:. testParser test3.c
test4: test4.c
	java -cp antlr-3.5.2-complete.jar:. testParser test4.c
test5: test5.c
	java -cp antlr-3.5.2-complete.jar:. testParser test5.c
clean:
	rm -rf *.class *.tokens myparserLexer.java myparserParser.java

