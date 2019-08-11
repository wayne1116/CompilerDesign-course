# Project 3
In this project, you should implement a C interpreter. The supported input file should at least contain the following features:
(1) integer and floating-point data types: int, float.
(2) Statements for arithmetic computation. (ex: a = b+2*(100-1))
(3) Comparison expression. (ex: a > b)
(4) if-then-else program construct.
(5) printf() function with one/two parameters. (support types: %d, %f)
(6) scanf() function. (support types: %d, %f)

## How to compile

● generate the interpreter:
    
    java -cp antlr-3.5.2-complete.jar org.antlr.Tool myInterp.g
    javac -cp antlr-3.5.2-complete.jar:. myInterp_test.java
    
● test:
    
    java -cp antlr-3.5.2-complete.jar:. myInterp_test test1.c
    java -cp antlr-3.5.2-complete.jar:. myInterp_test test2.c
    java -cp antlr-3.5.2-complete.jar:. myInterp_test test3.c
    
