/*  name class  */
grammar myInterp;

/* program language */
options{
	language=Java;
}
@header{
	import java.util.HashMap;
	import java.util.Scanner;
	import java.util.LinkedList;
	import java.util.Queue;
}
@members{
	HashMap<String,Integer> int_memory = new HashMap<String,Integer>();
	HashMap<String,Float> float_memory = new HashMap<String,Float>();
	HashMap<String,Double> double_memory = new HashMap<String,Double>();
	//HashMap<String,Integer[]> int_array_memory = new HashMap<String, Integer[]>();
	Scanner in=new Scanner(System.in);
	Queue<String>queue = new LinkedList<String>();
}

/* Parser */
prog
	: VOID MAIN '('')' '{' declarations statements[true] '}'
	;
declarations
@init{int type1=0;}
	: type_name
	  {
	  		  if($type_name.type.equals("int")) type1=1;
	  		  else if($type_name.type.equals("float")) type1=2;
	  		  else if($type_name.type.equals("double")) type1=3;
	  		  else System.out.println("The type name "+$type_name.type+" is not found");
	  }
	  initial[type1] (',' initial[type1])* ';' declarations
	|
	;
initial
[int type1]
@init{int type=0;}
	: Identifier  
	  {
	     switch(type1){
	  	 	case 1:
	  	 		 Integer v=(Integer)int_memory.get($Identifier.text);
	  	 		 if(v==null){
	  	 		 		 int_memory.put($Identifier.text,new Integer(0));
	  	 		 		 type=1;
				 }
	  	 		 else System.err.println("variable is already declared!!");
	  	 		 break;
	  	 	case 2:
	  	 		 Float v1=(Float)float_memory.get($Identifier.text);
	  	 		 if(v1==null){
	  	 		 		 float_memory.put($Identifier.text,new Float(0.0));
	  	 		 		 type=2;
				 }
	  	 		 else System.err.println("variable is already declared!!");
	  	 		 break;
		 
		 	case 3:
		 		 Double v2=(Double)double_memory.get($Identifier.text);
		 		 if(v2==null){
		 		 		 double_memory.put($Identifier.text, new Double(0.0));
		 		 		 type=3;
				 }
				 else System.err.println("variable is already declared!!");
				 break;
			default:
				System.err.println("undefined type");
				break;
		 }
	  } ('=' initial_which[type,$Identifier.text])?
	;
initial_which
[int type, String id]
	: cond_expr[true]
	  {
	  		  switch(type){
	  		  		  case 1:
	  		  		  		int num=(int)Double.parseDouble($cond_expr.value);
	  		  		  		int_memory.put(id,new Integer(num));
	  		  		  		break;
	  		  		  case 2:
	  		  		  		float_memory.put(id,new Float(Float.parseFloat($cond_expr.value)));
	  		  		  		break;
	  		  		  case 3:
	  		  		  		double_memory.put(id, new Double(Double.parseDouble($cond_expr.value)));
	  		  		  		break;
	  		  		  default:
	  		  		  		System.err.println("Error type");
	  		  		  		break;
			  }
	  }
	;
argument[boolean flag]
	: (',' cond_expr[true] 
	    {
	  		if(flag) queue.offer($cond_expr.value);
	    }
      )*
	;
argument1[boolean flag]
	: (',' '&' Identifier
	    {
	    	if(flag) queue.offer($Identifier.text);
	    }
	  )*
	;
type_name returns [String type]
	: INT {$type=$INT.text;}
	| FLOAT {$type=$FLOAT.text;}
	| DOUBLE {$type=$DOUBLE.text;}
	;
statements [boolean flag]
	: statement[flag] statements[flag]
	| 
	;
statement [boolean flag]
	: PRINTF '(' String argument[flag]')' ';'
	  {
	  	  if(flag){
	  		  String temp=$String.text;
	  		  int len=temp.length();
	  		  int i;
	  		  boolean tag=false;
	  		  boolean tag1=false;
	  		  int count=0;
	  		  for(i=1; i<len-1; i++){
					if(temp.charAt(i)=='\%'){
							if(tag) tag=false;
							else tag=true;
					}
					else if(tag && (temp.charAt(i)=='d' || temp.charAt(i)=='f')){
							++count;
							tag=false;
					}
			  }
			  if(queue.size()==count){
			    tag=tag1=false;
	  		  	for(i=1; i<len-1; i++){
						if(temp.charAt(i)=='\%'){
								if(tag){
										System.out.print("\%");
										tag=false;
								}
								else tag=true;
						}
						else if(tag && (temp.charAt(i)=='d' || temp.charAt(i)=='f')){
								if(temp.charAt(i)=='d'){
										int num=(int)Double.parseDouble(queue.poll());
										System.out.print(Integer.toString(num));
								}
								else System.out.print(Float.toString(Float.parseFloat(queue.poll())));
								tag=false;
						}
						else if(temp.charAt(i)=='\\'){
								if(tag1){
										System.out.print("\\");
										tag1=false;
								}
								else tag1=true;
						}
						else if(tag1 && (temp.charAt(i)=='n'|temp.charAt(i)=='t')){
								if(temp.charAt(i)=='n') System.out.println();
								else System.out.print("\t");
								tag1=false;
						}
						else System.out.print(temp.charAt(i));
			  	}
			  }
			  else System.out.println("Not equal parameters");
	      }
	  }
	| SCANF '(' String argument1[flag]')' ';'
	  {
	  	 if(flag){
	  		  String temp=$String.text;
	  		  int len=temp.length();
	  		  int i=0;
	  		  boolean tag=false;;
	  		  int count=0;
	  		  for(i=1; i<len-1; i++){
	  		  		  if(temp.charAt(i)=='\%'){
	  		  		  		  if(tag) tag=false;
	  		  		  		  else tag=true;
					  }
					  else if(tag && (temp.charAt(i)=='d'||temp.charAt(i)=='f')){
					  		  ++count;
					  		  tag=false;
					  }
			  }
			  if(count==queue.size() && flag){
			  		  tag=false;
					  for(i=1; i<len-1; i++){
					  		  if(temp.charAt(i)=='\%'){
					  		  		  if(tag) tag=false;
					  		  		  else tag=true;
							  }
							  else if(tag && (temp.charAt(i)=='d'||temp.charAt(i)=='f')){
							  		  String temp1=in.next();
									  if(temp.charAt(i)=='d'){
											int temp2=(int)Double.parseDouble(temp1);
											String id=queue.element();
											if((Integer)int_memory.get(id)!=null) int_memory.put(id,new Integer(temp2));
											else if((Float)float_memory.get(id)!=null) float_memory.put(id,new Float(temp2));
											else if((Double)double_memory.get(id)!=null) double_memory.put(id, new Double(temp2));
											else System.out.println("The variable "+id+" is not declared");
											queue.poll();
									  }
									  else{
									  		double temp3=Double.parseDouble(temp1);
									  		String id=queue.element();
									  		if((Double)double_memory.get(id)!=null) double_memory.put(id, new Double(temp3));
									  		else if((Float)float_memory.get(id)!=null) float_memory.put(id, new Float(temp3));
									  		else if((Integer)int_memory.get(id)!=null) int_memory.put(id, new Integer((int)temp3));
									  		else System.err.println("The variable "+id+" is not declared");
									  		queue.poll();
									  }
									  tag=false;
							  }
					  }
			  }
			  else System.err.println("Not euqal parameters");
	      }
	  }
	| expression[flag] ';'
	| if_statement[flag]
	;
if_statement
[boolean flag]
	: if_then_statement[flag] if_else_statement[$if_then_statement.exec_flag]
	;
if_then_statement 
[boolean flag]
returns[boolean exec_flag]
	: IF '(' cond_expr[flag] ')'
	  {
	  		if(flag){
		    	float value=Float.parseFloat($cond_expr.value);
				$exec_flag=true;
				if(value!=0){
					$exec_flag=false;
				}
				else flag=false;
			}
			else $exec_flag=false;
	  }
	  block_statement[flag]
	;
if_else_statement [boolean flag]
	: ELSE block_statement[flag]
	|
	;
block_statement [boolean flag]
	: '{' statements[flag] '}'
	//| statement
	;
/* epression */

expression [boolean flag]
	: Identifier '=' cond_expr[flag]
	  {
	  		if(flag){
				Integer temp1=(Integer)int_memory.get($Identifier.text);
				Float temp2=(Float)float_memory.get($Identifier.text);
				Double temp3=(Double)double_memory.get($Identifier.text);
				if(temp1!=null){
					int num;
					if($cond_expr.type!=1) num=(int)Double.parseDouble($cond_expr.value);
					else num=Integer.parseInt($cond_expr.value);
					int_memory.put($Identifier.text,num);
				}
				else if(temp2!=null){
					float_memory.put($Identifier.text,Float.parseFloat($cond_expr.value));
				}
				else if(temp3!=null){
					double_memory.put($Identifier.text,Double.parseDouble($cond_expr.value));
				}
				else System.err.println("The variable can't not find");
			}
	  }
	;
cond_expr 
[boolean flag] 
returns [int type, String value]
	: a=logical_and_expr[flag] {if(flag){$type=$a.type; $value=$a.value;}}
	  ( '||' b=logical_and_expr[flag]
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($b.value);
	    			boolean temp3=(temp1==0?false:true);
	    			boolean temp4=(temp2==0?false:true);
	    			if(temp3||temp4) $value=Integer.toString(0);
	    			else $value=Integer.toString(1);
				}
	    }
	  )*
	;
logical_and_expr 
[boolean flag] 
returns [int type, String value]
	: a=equality_expr[flag] { if(flag){ $type=$a.type; $value=$a.value;}}
	  ('&&' b=equality_expr[flag]
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($b.value);
	    			boolean temp3=(temp1==0?false:true);
	    			boolean temp4=(temp2==0?false:true);
	    			if(temp3 && temp4) $value=Integer.toString(1);
	    			else $value=Integer.toString(0);
				}
	    }
	  )*
	;
equality_expr 
[boolean flag]
returns [int type, String value]
	: a=relation_expr[flag] { if(flag){$type=$a.type; $value=$a.value; }}
	  ('!=' b=relation_expr[flag]
	    {
	    		if(flag){
	    	 		$type=1;
	    	 		double temp1=Double.parseDouble($value);
	    	 		double temp2=Double.parseDouble($b.value);
	    	 		if(temp1!=temp2) $value=Integer.toString(1);
	    	 		else $value=Integer.toString(0);
				}
	    }
	  |'==' c=relation_expr[flag]
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($c.value);
	    			if(temp1==temp2) $value=Integer.toString(1);
	    			else $value=Integer.toString(0);
				}
	    }
	  )*
	;
relation_expr 
[boolean flag]
returns [int type, String value]
	: a=arith_expr[flag] {if(flag){$type=$a.type; $value=$a.value;}}
	  ( '<' b=arith_expr[flag] 
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($b.value);
	    			if(temp1<temp2) $value=Integer.toString(1);
	    			else $value=Integer.toString(0);
				}
	    }
	  | '>' c=arith_expr[flag]
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($c.value);
	    			if(temp1>temp2) $value=Integer.toString(1);
	    			else $value=Integer.toString(0);
				}
	    }
	  | '<=' d=arith_expr[flag]
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($d.value);
	    			if(temp1<=temp2) $value=Integer.toString(1);
	    			else $value=Integer.toString(0);
				}
	    }
	  |'>=' e=arith_expr[flag]
	    {
	    		if(flag){
	    			$type=1;
	    			double temp1=Double.parseDouble($value);
	    			double temp2=Double.parseDouble($e.value);
	    			if(temp1>=temp2) $value=Integer.toString(1);
	    			else $value=Integer.toString(0);
				}
	    }
	  )*
	;
arith_expr 
[boolean flag]
returns [int type, String value]
	: a=multiple_expr[flag] { if(flag){$type=$a.type; $value=$a.value; }}
	  ('+' b=multiple_expr[flag] 
	    {
	    		if(flag){
	    			$type=$type>$b.type?$type:$b.type;
	    			switch($type){
	    					case 1:
	    							int temp1=Integer.parseInt($value)+Integer.parseInt($b.value);
	    							$value=Integer.toString(temp1);
	    							break;
	    					case 2:
	    							float temp2=Float.parseFloat($value)+Float.parseFloat($b.value);
	    							$value=Float.toString(temp2);
	    							break;
	    					case 3:
	    							double temp3=Double.parseDouble($value)+Double.parseDouble($b.value);
	    							$value=Double.toString(temp3);
	    							break;
					}
				}
	    }
	  | '-' c=multiple_expr[flag]
	    {
	    		if(flag){
	    			$type=$type>$c.type?$type:$c.type;
	    			switch($type){
	    					case 1:
	    							int temp1=Integer.parseInt($value)-Integer.parseInt($c.value);
	    							$value=Integer.toString(temp1);
	    							break;
	    					case 2:
	    							float temp2=Float.parseFloat($value)-Float.parseFloat($c.value);
	    							$value=Float.toString(temp2);
	    							break;
	    					case 3:
	    							double temp3=Double.parseDouble($value)-Double.parseDouble($c.value);
	    							$value=Double.toString(temp3);
	    							break;
					}
				}
	    }
	  )*
	;
multiple_expr 
[boolean flag]
returns [int type, String value]
	: a=cast_expr[flag]
	  {
	  		if(flag){
	  			$type=$a.type;
	  			$value=$a.value;
			}
	  }
	  ( '*' b=cast_expr[flag]
	    { 
	    	if(flag){
	        	$type=$type>$b.type?$type:$b.type;
	        	switch($type){
	        			case 1: 
	        		        	int temp1=Integer.parseInt($value)*Integer.parseInt($b.value);
	        		        	$value=Integer.toString(temp1);
	        		        	break;
	        			case 2: 
	        		        	float temp2=Float.parseFloat($value)*Float.parseFloat($b.value);
	        		        	$value=Float.toString(temp2); 
	        		        	break;
	        		    case 3:
	        		    		double temp3=Double.parseDouble($value)*Double.parseDouble($b.value);
	        		    		$value=Double.toString(temp3);
	        		    		break;
				}
			}
		 }
	   | '/' c=cast_expr[flag]
	     {
	        if(flag){
	     		$type=$type>$c.type?$type:$c.type;
	     		switch($type){
	     				case 1:
	     						int temp1=Integer.parseInt($value)/Integer.parseInt($c.value);
	     						$value=Integer.toString(temp1);
	     						break;
	     				case 2:
	     						float temp2=Float.parseFloat($value)/Float.parseFloat($c.value);
	     						$value=Float.toString(temp2);
	     						break;
	     				case 3:
	     						double temp3=Double.parseDouble($value)/Double.parseDouble($c.value);
	     						$value=Double.toString(temp3);
	     						break;
				}
			}
		 }
	   )* 
	;
cast_expr 
[boolean flag]
returns [int type, String value]
	: unary_expr[flag] { if(flag){$type=$unary_expr.type; $value=$unary_expr.value;}}
	| '('type_name')' unary_expr[flag]
	  {
	  		  if(flag){
	  		  	if($type_name.type.equals("int")){
	  		  		  int num=(int)Double.parseDouble($unary_expr.value);
	  		  		  $value=Integer.toString(num);
	  		  		  $type=1;
			  	}
			  	else if($type_name.type.equals("float")){
			  		  $value=Float.toString(Float.parseFloat($unary_expr.value));
			  		  $type=2;
			  	}
			  	else if($type_name.type.equals("double")){
			  		  $value=Double.toString(Double.parseDouble($unary_expr.value));
			  		  $type=3;
			  	}
			  	else System.out.println("The type is not found");
			  }
	  }
	;
unary_expr 
[boolean flag]
returns [int type, String value]
	: primary_expr[flag] { if(flag){$type=$primary_expr.type; $value=$primary_expr.value; }}
	| '-' primary_expr[flag] 
	  {
	  	if(flag){
			$type=$primary_expr.type; 
			switch($type){
					case 1:
							int temp1=Integer.parseInt($primary_expr.value);
							$value=Integer.toString(-temp1);
							break;
					case 2:
							float temp2=Float.parseFloat($primary_expr.value);
							$value=Float.toString(-temp2);
							break;
					case 3:
							double temp3=Double.parseDouble($primary_expr.value);
							$value=Double.toString(-temp3);
							break;

			}
		}
	  }
	;
primary_expr
[boolean flag]
returns [int type, String value]
	: Dec_number
	  {
	  		  if(flag){
	  		  	$type=1;
	  		  	$value=$Dec_number.text;
			  }
	  }
	| Float_number 
	  {
	  		  if(flag){
	  		  	$type=2;
	  		  	$value=$Float_number.text;
			  }
	  }
	| Identifier
	  {
	  		  if(flag){
	  		  	if((Integer)int_memory.get($Identifier.text)!=null){
	  		  		 	Integer temp=(Integer)int_memory.get($Identifier.text);
	  		  		  	$type=1;
	  		  		  	$value=temp.toString();
	  		  	}
      			else if((Float)float_memory.get($Identifier.text)!=null){
			  		  	Float temp=(Float)float_memory.get($Identifier.text);
			  		  	$type=2;
			  		  	$value=temp.toString();
			  	}
			  	else if((Double)double_memory.get($Identifier.text)!=null){
			  			Double temp=(Double)double_memory.get($Identifier.text);
			  			$type=3;
			  			$value=temp.toString();
				}
			 	else System.err.println("The variable isn't declared");
			  }
	 }
	| '(' cond_expr[flag] ')' { $type=$cond_expr.type; $value=$cond_expr.value;}
	;

/* Define lexeme */

//Reserved keyword type
INT: 'int';
MAIN: 'main';
CHAR: 'char';
SHORT: 'Short';
LONG: 'long';
FLOAT: 'float';
DOUBLE: 'double';
CONST: 'const';
VOID: 'void';
RETURN : 'return';

//Reserved keyword loop & if-else
IF: 'if';
ELSE: 'else';
FORLOOP: 'for';
WHILELOOP: 'while';
BREAK : 'break';
PRINTF: 'printf';
SCANF: 'scanf';

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

