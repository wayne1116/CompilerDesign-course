/*  name class  */
grammar myparser;

/* program language */
options{
	language=Java;
}

/* import packet */
@header{

}

@members{
	boolean TRACEON = true;
}

/* start */
program
  : Int Main '(' ')' '{' declarations statements'}'
  { if(TRACEON) System.out.println("program:\tInt Main'('')' '{' declarations statements '}'");};

 
/* declaration */
declarations
  : type initial (','initial)* ';' declarations
  { if(TRACEON) System.out.println("declarations:\ttype initial (',' initial)* ';' declarations");}
  | { if(TRACEON) System.out.println("declarations:\t");}; // empty

initial
  : Identifier array_expr('=' initial_which)? { if(TRACEON) System.out.println("initial:\tIdentifier ('=' initial_which)?");}
  ;
initial_which
  : initial_list { if(TRACEON) System.out.println("initial_which:\tinitial_list");}
  | arith_expr { if(TRACEON) System.out.println("initial_which:\tarith_expr");}
  | String { if(TRACEON) System.out.println("initial_which:\tString");}
  ;
initial_list
  : '{' initial_content '}' { if(TRACEON) System.out.println("initial_list:\t'{' initial_content '}'");}
  ;
initial_content
  : arith_expr (',' arith_expr)* { if(TRACEON) System.out.println("initial_content:\tarith_expr (',' arith_expr)*");}
  | String (',' String) { if(TRACEON) System.out.println("initial_content:\tString (',' String)");}
  ;
/* assign_operator */
assign_operator
  : '=' {if(TRACEON) System.out.println("assign_operator:\t'='");}
  | '*=' {if(TRACEON) System.out.println("assign_operator:\t'*='");}
  | '/=' {if(TRACEON) System.out.println("assign_operator:\t'/='");}
  | '%=' {if(TRACEON) System.out.println("assign_operator:\t'\%=;");}
  | '+=' {if(TRACEON) System.out.println("assign_operator:\t'+=;");}
  | '-=' {if(TRACEON) System.out.println("assign_operator:\t'-=;");}
  | '<<=' {if(TRACEON) System.out.println("assign_operator:\t'<<=;");}
  | '>>=' {if(TRACEON) System.out.println("assign_operator:\t'>>=;");}
  | '&=' {if(TRACEON) System.out.println("assign_operator:\t'&=;");}
  | '^=' {if(TRACEON) System.out.println("assign_operator:\t'^=;");}
  | '|=' {if(TRACEON) System.out.println("assign_operator:\t'|=;");}
  ;

/* relation_operator */
relation_operator
  : '>' {if(TRACEON) System.out.println("relation_operator:\t'>'");}
  | '<' {if(TRACEON) System.out.println("relation_operator:\t'<'");}
  | '<=' {if(TRACEON) System.out.println("relation_operator:\t'<='");}
  | '>=' {if(TRACEON) System.out.println("relation_operator:\t'>='");}
  ;

/* add_and_subs */
add_sub_operator
  : '+' {if(TRACEON) System.out.println("add_sub_operator:\t'+'");}
  | '-' {if(TRACEON) System.out.println("add_sub_operator:\t'-'");}
  ;

/* mul_div_mod_operaotr*/
mul_div_mod_operator
  : '*' {if(TRACEON) System.out.println("mul_div_mod_operator:\t'*'");}
  | '/' {if(TRACEON) System.out.println("mul_div_mod_operator:\t'/'");}
  | '%' {if(TRACEON) System.out.println("mul_div_mod_operator:\t'\%'");}
  ;

equality_operator
  : '==' {if(TRACEON) System.out.println("equality_operator:\t'=='");}
  | '!=' {if(TRACEON) System.out.println("equality_operator:\t'!='");}
  ;

/* statement */
statements
  : statement statements { if(TRACEON) System.out.println("statements:\tstatement statements");}
  | { if(TRACEON) System.out.println("statements:\t");}
  ;
statement
  : expression ';'{ if(TRACEON) System.out.println("statement:\texpression ;");}
  | switch_statement {if(TRACEON) System.out.println("statement:\tswitch_statement");}
  | if_statement {if(TRACEON) System.out.println("statement:\tif_statement");}
  | for_statement {if(TRACEON) System.out.println("statement:\tfor_statement");}
  | while_statement {if(TRACEON) System.out.println("statement:\twhile_statement");}
  | do_while_statement ';' {if(TRACEON) System.out.println("statement:\tdo_while_statement';'");}
  | label_statement {if(TRACEON) System.out.println("statement:\tlabel_statement");}
  | jump_statement ';'  {if(TRACEON) System.out.println("statement:\tjump_statement';'");}
  ;
switch_statement
  : Switch '(' condition_expr ')' '{' statements '}' {if(TRACEON) System.out.println("switch_statement:\tSwitch '('condition_expr')''{'statements'}");}
  ;
label_statement
  : Case (Dec_number | Character) ':' statement {if(TRACEON) System.out.println("label_statement:\tCase '('(Dec_nubmer|Character)')'':'statement");}
  | Default ':' statement {if(TRACEON) System.out.println("label_statement:\tDefault ':' statement");}
  ;
jump_statement
  : Break {if(TRACEON) System.out.println("jump_statement:\tBreak");}
  | Return return_expr {if(TRACEON) System.out.println("jump_statement:\tReturn return _expr");}
  ;
return_expr
  : condition_expr {if(TRACEON) System.out.println("return_expr:\tcondition_expr");} 
  | {if(TRACEON) System.out.println("retrun_expr:\t");}
  ;
if_statement
  : If '(' condition_expr ')' then1_statement{ if(TRACEON) System.out.println("if_statement:\t'('condition_expr')' then_statement");}
  ;
then1_statement
  : statement {if(TRACEON) System.out.println("then1_statement:\tstatement");}
  | '{' statements '}' {if(TRACEON) System.out.println("then1_statement:\t'{'statements'}'");}
  ;
for_statement
  : For '(' expression ';' condition_expr ';' condition_expr ')' then1_statement {if(TRACEON) System.out.println("for_statement:\tFor '('expression';'condition_expr';'condition_expr')'then1_statement");}
  ;
while_statement
  : While '(' condition_expr ')' then1_statement {if(TRACEON) System.out.println("while_statement:\tWhile '('cnodition_expr')' then1_statement");}
  ;
do_while_statement
  : Do then1_statement While '(' condition_expr ')' {if(TRACEON) System.out.println("do_while_statement:\tDo then1_statement While '('condition_expr')'");} 
  ;
lvalue
  : Identifier array_expr{ if(TRACEON) System.out.println("lvalue:\tIdentifer array_expr");}
  ;

/* expression */
expression
  : assignment_expr (',' assignment_expr)* { if(TRACEON) System.out.println("expression:\tassignment_expr (',' assignment_expr)*");}
  | func_expr (',' func_expr)*{ if(TRACEON) System.out.println("expression:\tfunc_expr (',' func_expr)*");}
  | ('++'|'--') Identifier array_expr {if(TRACEON) System.out.println("expression:\t('++'|'--') Identifier array_expr");}
  ;
assignment_expr
  : lvalue assign_operator condition_expr {if(TRACEON) System.out.println("assignment_expr:\tlvalue assign_operator condition_expr");}
  ;
condition_expr
  : logical_or_expr ('?' expression ':' condition_expr)? {if(TRACEON) System.out.println("condition_expr:\tlogical_or_expr ('?' expression ':' condition_expr)?");}
  ;
logical_or_expr
  : logical_and_expr ('||' logical_and_expr)* {if(TRACEON) System.out.println("logical_or_expr:\tlogical_and_expr ('||' logical_and_expr)*");}
  ;
logical_and_expr
  : equality_expr ('&&' equality_expr)* {if(TRACEON) System.out.println("logical_and_expr:\tequality_expr ('&&' equality_expr)*");}
  ;
equality_expr
  : relation_expr (equality_operator relation_expr)* { if(TRACEON) System.out.println("equality_expr:\trelation_expr (equality_operator relation_expr)*");}
  ;
relation_expr
  : arith_expr (relation_operator arith_expr)* { if(TRACEON) System.out.println("relation_expr:\tarith_expr (relation_operator arith_expr)*");}
  ;
arith_expr
  : multiple_expr (add_sub_operator multiple_expr)* { if(TRACEON) System.out.println("arith_expr:\tmultiple_expr(add_sub_operator multiple_expr)*");}
  ;
multiple_expr
  : cast_expr (mul_div_mod_operator cast_expr)* { if(TRACEON) System.out.println("multiple_expr:\tcast_expr (mul_div_mod_operator cast_expr)*");}
  ;
cast_expr
  : '(' type ')' cast_expr { if(TRACEON) System.out.println("cast:expr:\t'('type')' cast_expr");}
  | unary_expr {if(TRACEON) System.out.println("cast_expr:\tunary_expr");}
  ;
unary_expr
  : ('++'|'--') Identifier array_expr{ if(TRACEON) System.out.println("unary_expr:\t('++|'--')Identifier array_expr");}
  | Identifier array_expr ('++'|'--')?{ if(TRACEON) System.out.println("unary_expr:\tIdentifier array_expr('++'|'--')?");}
  | primary_expr { if(TRACEON) System.out.println("unary_expr:\tprimary_expr");}
  | func_expr { if(TRACEON) System.out.println("unary_expr:\tfunc_expr");}
  | '-'primary_expr { if(TRACEON) System.out.println("unary_expr:\t'-'primary_expr");}
  | Character { if(TRACEON) System.out.println("unary_expr:\tCharacter");}
  ;
primary_expr
  : Dec_number { if(TRACEON) System.out.println("primary_expr:\tDec_number");}
  | Float_number { if(TRACEON) System.out.println("primary_expr:\tFloat_number");}
  | '('condition_expr')' { if(TRACEON) System.out.println("primary_expr:\t'('condition_expr')'");}
  ;
array_expr //
  : ( '['arith_expr']')+ {if(TRACEON) System.out.println("array_expr:\t('['arith_expr']')+");}
  | { if(TRACEON) System.out.println("array_expr:\t");}
  ;
func_expr
  : Printf '(' argument_expr_list')' {if(TRACEON) System.out.println("func_expr:\tPrintf '(' argument_expr_list ')'");}
  | Identifier '('argument_expr_list')' {if(TRACEON) System.out.println("func_expr:\tIdentifier '('argument_expr_list')'");}
  ;
argument_expr_list
  : arith_expr argument_expr_next { if(TRACEON) System.out.println("argument_expr_list:\tarith_expr argument_expr_next");}
  | String argument_expr_next { if(TRACEON) System.out.println("argument_expr_list:\tString argument_expr_next");}
  | {if(TRACEON) System.out.println("argument_expr_list:\t");}
  ;
argument_expr_next
  : (',' (arith_expr|String))*{ if(TRACEON) System.out.println("argument_expr_next:\t(',' (arith_expr|String))*");}
  ;

/* type */ 
type
  : Int { if(TRACEON) System.out.println("type:\tINT");}
  | Float { if(TRACEON) System.out.println("type:\tFloat");}
  | Double { if(TRACEON) System.out.println("type:\tDouble");}
  | Char { if(TRACEON) System.out.println("type:\tChar");}
  | Short { if(TRACEON) System.out.println("type:\tShort");}
  | Long { if(TRACEON) System.out.println("type:\tLong");}
  ;

/* Define lexeme */

//Reserved keyword type
Int : 'int';
Main: 'main';
Char: 'char';
Short: 'short';
Long: 'long';
Float: 'float';
Double: 'double';
Return : 'return';
Printf: 'printf';

//Reserved keyword loop & if-else
If: 'if';
Else: 'else';
For: 'for';
While: 'while';
Do : 'do';
Break : 'break';
Switch: 'switch';
Case: 'case';
Default: 'default';

// Compound Operators
Eq_op : '==';
Le_op : '<=';
Ge_op : '>=';
Ne_op : '!=';
Gt_op : '>';
Lt_op : '<';
Land: '&&';
Lor: '||';
Rshift_op : '<<';
Lshift_op : '>>';


// Math & bit operator
And: '&';
Mul: '*';
Plus: '+';
Neg: '-';
Div: '/';
Mod: '%';
Inv1: '~';
Inv2: '!';

//Charactor & String
Character : '\'' (EscapeSequence | ~('\''|'\\') ) '\'' ; 

String	: '\u0022'(EscapeSequence | ~('\\'|'\u0022') )* '\u0022'; 

fragment
EscapeSequence
	: '\\' ('b'|'t'|'n'|'f'|'r'|'\u0022'|'\''|'\\')
	| OctalEscape
	;

fragment
OctalEscape
	: '\\' ('0'..'3') ('0'..'7') ('0'..'7')
	| '\\' ('0'..'7') ('0'..'7')
	| '\\' ('0'..'7')
	;

//numbers
Hex_number : '0'('x'|'X')Hexdigit+IntegerType;
Dec_number : ('0'|'1'..'9'Digit*)IntegerType;
Oct_number : '0'('0'..'7')+IntegerType;

Float_number
	: Digit+'.'Digit*Exponent?FloatType?
	| '.'Digit+Exponent?FloatType?
	| Digit+Exponent?FloatType?
	;

fragment
Exponent : ('e'|'E') ('+'|'-')?('0'..'9')+;

fragment
Hexdigit : (Digit|'a'..'f'|'A'..'F');

fragment
IntegerType : ('u'|'U')?('l'|'L')?;

fragment
FloatType : ('f'|'F'|'d'|'D');

//Identifier
Identifier : Letter(Letter|Digit)*;

fragment
Letter
	: '$'
	| 'A'..'Z'
	| 'a'..'z'
	| '_'
	;

fragment
Digit : '0'..'9' ;

// WS & Comment
WS	: (' '|'\r'|'\t'|'\u000C'|'\n') {skip();}
	;

Comment
	: '/*'(options{greedy=false;}:.)*'*/'{skip();}
	;

Line_comment
	: '/''/' ~('\n'|'\r')* '\r'?'\n'{skip();}
	;

