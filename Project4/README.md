# Project 4
you will need to choose the set of language features which you want to develop in this course, and write the whole compiler (including the code generator).

## How to compile

● generate compiler:
    
    java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
    javac -cp ./antlr-3.5.2-complete.jar:. myCompiler_test.java
    
● test:
    
    java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test1.c > myResult.j
    java -jar ./jasmin-2.4/jasmin.jar myResult.j
    java myResult
    
    java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test2.c > myResult.j
    java -jar ./jasmin-2.4/jasmin.jar myResult.j
    java myResult
    
    java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test3.c > myResult.j
    java -jar ./jasmin-2.4/jasmin.jar myResult.j
    java myResult
    

