/*  name class  */
lexer grammar mylexer;

/* program language */
options{
	language=Java;
}

/* Define lexeme */

//Reserved keyword type
Int : 'int';
Char: 'char';
Short: 'Short';
Long: 'long';
Float: 'float';
Double: 'double';
Signed: 'signed';
Unsigned: 'unsigned';
Struct : 'struct';
Union: 'union';
Extern : 'extern';
Static: 'static';
Register: 'register';
Const: 'const';
Volatile: 'volatile';
Sizeof : 'sizezof';
Return : 'return';

//Reserved keyword loop & if-else
If: 'if';
Else: 'else';
Forloop: 'for';
Whileloop: 'while';
Break : 'break';

// Compound Operators
Eq_op : '==';
Le_op : '<=';
Ge_op : '>=';
Ne_op : '!=';
Gt_op : '>';
Lt_op : '<';
Land: '&&';
Lor: '||';
PP_op : '++';
MM_op : '--';
Rshift_op : '<<';
Lshift_op : '>>';

// Puntuation
Lpara : '(';
Rpara : ')';
Semi : ';';
Comma: ',';
Lbpara: '{';
Rbpara: '}';
Lmpara : '[';
Rmpara : ']';

// Struct & union
Point1 : '.';
Point2 : '->';

// Assignment
Assign: '=';
Mu_assign: '*=';
Di_assign: '/=';
Mo_assign: '%=';
Pu_assign: '+=';
Ne_assign: '-=';
An_assign: '&=';
Xo_assign: '^=';
Or_assign: '|=';
Ls_assign: '<<=';
Rs_assign: '>>=';

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

