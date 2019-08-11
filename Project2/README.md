# Project 2
you will need to decide the set of language features you want to support in your compiler, and write the syntax analyzer.

## How to compile

● generate syntax analyzer:
    
    java -cp antlr-3.5.2-complete.jar org.antlr.Tool myparser.g
    javac -cp antlr-3.5.2-complete.jar:. testParser.java
    
● test:
    
    java -cp antlr-3.5.2-complete.jar:. testParser test1.c
    java -cp antlr-3.5.2-complete.jar:. testParser test2.c
    java -cp antlr-3.5.2-complete.jar:. testParser test3.c
    java -cp antlr-3.5.2-complete.jar:. testParser test4.c
    java -cp antlr-3.5.2-complete.jar:. testParser test5.c
