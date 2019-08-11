# Project 1
you will need to choose the set of language features you want to support in your compiler, and write the lexical analyzer.

## Makefile

● generate lexical analyzer:
    
    java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool mylexer.g
    javac -cp ./antlr-3.5.2-complete.jar testLexer.java mylexer.java
    
● test:
    
    java -cp ./antlr-3.5.2-complete.jar:. testLexer input1.c
    java -cp ./antlr-3.5.2-complete.jar:. testLexer input2.c
    java -cp ./antlr-3.5.2-complete.jar:. testLexer input3.c
