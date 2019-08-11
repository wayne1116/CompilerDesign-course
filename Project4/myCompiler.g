/*  name class  */
grammar myCompiler;

/* program language */
options{
	language = Java;
}

/* import package */
@header{
	import java.util.HashMap;
	import java.util.ArrayList;
	import java.util.LinkedList;
	import java.util.Stack;
}

/* global variable */
@members{
	// symbol table
	HashMap<String, ArrayList> symtab = new HashMap<String, ArrayList>();
	// label number
	int labelCount = 0;
	// local memory location
	int storageIndex = 1;
	// assembly instrucctions
	List<String> TextCode = new ArrayList<String>();
	// Type
	public enum Type{
		Int, Float, Double, Intarray, Floatarray, Doublearray, Error;
	}
	// relationOp
	public enum Relation{
		Le_op, Ge_op, Gt_op, Lt_op; 
	}
	// equality
	public enum Equality{
		Eq_op, Ne_op;
	}

	public enum Assignment{
		Assign, Pu_assign, Ne_assign, Di_assign, Mu_assign;
	}

	void prologue()
	{
		TextCode.add(";.source");
		TextCode.add(".class public static myResult");
		TextCode.add(".super java/lang/Object");
		TextCode.add(".method public static main([Ljava/lang/String;)V");

		// the size of stack and local memory
		TextCode.add(".limit stack 100");
		TextCode.add(".limit locals 100");
	}

	void epilogue()
	{
		TextCode.add("return");
		TextCode.add(".end method");
	}

	String newlabel()
	{
		++labelCount;
		return (new String("L")) + Integer.toString(labelCount);
	}

	public List<String> getTextCode()
	{
		return TextCode;
	}
	// printf arguments
	Stack<Type> stack = new Stack<Type>();
	Stack<String> stack1 = new Stack<String>();
	
	//for loop
	public void exec(String str, int tokenIndex){
			try{
					int oldPosition = this.input.index();
					this.input.seek(tokenIndex);
					if(str.equals("increment")){
							this.assignment_expr(true);
					}
					this.input.seek(oldPosition);
			} 
			catch(Exception e){
					System.err.println("cannot exec code");
			}
			
	}

	// scanf
	boolean scanfstart = false;
}

program
    : VOID MAIN '(' ')' { prologue(); }
    '{' declarations statements[false, ""] '}' { epilogue(); }
    ;

declarations
	: type initial[$type.attr_type] (',' initial[$type.attr_type])* ';' declarations
	|
	;
type
returns [Type attr_type]
	: INT { $attr_type = Type.Int; }
	| FLOAT { $attr_type = Type.Float; }
	| DOUBLE { $attr_type = Type.Double; }
	;

initial
[Type the_type]
	: Identifier 
	  {
	  		if(symtab.containsKey($Identifier.text)){
	  				System.err.println("error: " + $Identifier.text + " redeclared identifier!!");
	  				System.exit(0);
			}
	  }
	  array[the_type, $Identifier.text]
	;

array
[Type the_type, String id]
@init{ boolean flag =false; }
	: ('=' a=arith_expr[true] { flag = true; })?
	  {
	  		ArrayList the_list = new ArrayList();
	  		the_list.add(the_type);
	  		the_list.add(storageIndex);
			symtab.put(id, the_list);
	  		switch(the_type){
	  				case Int:
	  							if(flag){
	  									switch($a.attr_type){
	  											case Float:
	  														TextCode.add("f2i");
	  														break;
	  											case Double:
	  														TextCode.add("d2i");
	  														break;
										}
								}
	  							else TextCode.add("iconst_0");
	  							TextCode.add("istore " + storageIndex);
	  							break;
	  				case Float:
	  							if(flag){
	  									switch($a.attr_type){
	  											case Int:
	  														TextCode.add("i2f");
	  														break;
	  											case Double:
	  														TextCode.add("d2f");
	  														break;
										}
								}
	  							else TextCode.add("fconst_0");
	  							TextCode.add("fstore " + storageIndex);
	  							break;
	  				case Double:
	  							if(flag){
	  									switch($a.attr_type){
	  											case Int:
	  														TextCode.add("i2d");
	  														break;
	  											case Float:
	  														TextCode.add("f2d");
	  														break;
										}
								}
	  							else TextCode.add("dconst_0"); // ldc -> int, float
	  							TextCode.add("dstore " + storageIndex);
	  							storageIndex = storageIndex + 1;  // double need two address!!
	  							break;
			}
			storageIndex = storageIndex + 1;
	  }
	| '[' Dec_number ']'
	  {
	  		ArrayList the_list = new ArrayList();
            
	  	    TextCode.add("ldc " + $Dec_number.text);
	  		switch(the_type){
	  				case Int:
	  							TextCode.add("newarray int" );
	  							TextCode.add("astore " + storageIndex);
	  							the_list.add(Type.Intarray);
	  							the_list.add(storageIndex);
	  							break;
	  				case Float:
	  							TextCode.add("newarray float");
	  							TextCode.add("astore " + storageIndex);
	  							the_list.add(Type.Floatarray);
	  							the_list.add(storageIndex);
	  							break;
	  				case Double:
	  							TextCode.add("newarray double");
	  							TextCode.add("astore " + storageIndex);
	  							the_list.add(Type.Doublearray);
	  							the_list.add(storageIndex);
	  							break;
	  				default: 
	  							System.err.println("error: type is not found!!");
	  							System.exit(0);
			}
			storageIndex = storageIndex + 1;
			symtab.put(id,the_list);
	  }
    ;

statements
[boolean tag, String label_break]
	: statement[tag, label_break] statements[tag, label_break]
	|
	;

statement
[boolean flag, String label_break]
	: PRINTF '(' STRING  arguments')' ';'
	  {
			String temp=$STRING.text;
			int count=0;
			int i=0;
			int len=temp.length();
			boolean tag=false;
			temp = temp.substring(1,len-1);
			len = len-2;

			for(i=0; i<len; i++){
					if(temp.charAt(i)=='\%'){
							if(tag) tag=false;
							else tag=true;
					}
					else if(tag && (temp.charAt(i)=='d' || temp.charAt(i)=='f')){
							++count;
							tag=false;
					}
			}
			
			if(count==stack.size()){
					tag=false;
					String print;
					int start=0;
					int templocation=storageIndex;
					Stack<Type> typestack = new Stack<Type>();
					Type attr_type;
					for(i=0; i<count; i++){
							attr_type = stack.pop();
							switch(attr_type){
									case Int:
												TextCode.add("istore " + templocation);
												break;
									case Float:
												TextCode.add("fstore " + templocation);
												break;
									case Double:
												TextCode.add("dstore " + templocation);
												++templocation;
												break;
							}
							typestack.push(attr_type);
							templocation++;
					}

					for(i=0; i<len; i++){
							if(temp.charAt(i)=='\%'){
									if(tag) tag=false;
									else tag=true;
							}
							else if(tag && temp.charAt(i)=='d'){
									print = "\"" + temp.substring(start,i-1) + "\"";
									start = i+1;
									TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
									TextCode.add("ldc " + print);
									TextCode.add("invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");
									
									TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
									--templocation;
									switch(typestack.pop()){
											case Int:	
														TextCode.add("iload " + templocation);
														break;
											case Float:	
														TextCode.add("fload " + templocation);
														TextCode.add("f2i");
														break;
											case Double:
														--templocation;
														TextCode.add("dload " + templocation);
														TextCode.add("d2i");
														break;
									}
									TextCode.add("invokevirtual java/io/PrintStream/print(I)V");
									tag=false;
							}
							else if(tag && temp.charAt(i)=='f'){
									print = "\"" + temp.substring(start,i-1) + "\"";
									start = i+1;
									TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
									TextCode.add("ldc " + print);
									TextCode.add("invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");
									
									TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
									--templocation;
									switch(typestack.pop()){
											case Int:
														TextCode.add("iload " + templocation);
														TextCode.add("i2f");
														TextCode.add("invokevirtual java/io/PrintStream/print(F)V");
														break;
											case Float:
														TextCode.add("fload " + templocation);
														TextCode.add("invokevirtual java/io/PrintStream/print(F)V");
														break;
											case Double:
														--templocation;
														TextCode.add("dload " + templocation);
														TextCode.add("invokevirtual java/io/PrintStream/print(D)V");
														break;
									}
									tag=false;
							}
					}
					print = "\"" + temp.substring(start, i) + "\"";
					TextCode.add("getstatic java/lang/System/out Ljava/io/PrintStream;");
					TextCode.add("ldc " + print);
					TextCode.add("invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");
			}
			else{
					System.err.println("error: the number of parameter is not correct!!");
					System.exit(0);
			}
	  }
	| SCANF '(' STRING arguments1 ')' ';'
	  {
	  		String temp=$STRING.text;
			int count=0;
			int i=0;
			int len=temp.length();
			boolean tag=false;
			temp = temp.substring(1,len-1);
			len = len -2;
	  		
			for(i=0; i<len; i++){
					if(temp.charAt(i)=='\%'){
							if(tag) tag=false;
							else tag=true;
					}
					else if(tag && (temp.charAt(i)=='d' || temp.charAt(i)=='f')){
							++count;
							tag=false;
					}
			}
	  

			if(count==stack1.size()){
					if(!scanfstart){
							scanfstart=true;
							TextCode.add("new java/util/Scanner");
							TextCode.add("dup");
							TextCode.add("getstatic java/lang/System.in Ljava/io/InputStream;");
							TextCode.add("invokespecial java/util/Scanner.<init>(Ljava/io/InputStream;)V");
							TextCode.add("astore_0");
					}

					tag=false;
					int start=0;
					int templocation=storageIndex;
					Stack<String> idstack = new Stack<String>();
					Type attr_type;
					String id;
					Object temp1;
					int the_mem =0;

					for(i=0; i<count; i++){
							id = stack1.pop();
							attr_type=(Type)symtab.get(id).get(0);
							switch(attr_type){
									case Intarray:
									case Floatarray:
									case Doublearray:
												TextCode.add("istore " + templocation);
												++templocation;
												TextCode.add("astore " + templocation);
												++templocation;
												break;
							}
							idstack.push(id);
					}

					for(i=0; i<len; i++){
							if(temp.charAt(i)=='\%'){
									if(tag) tag=false;
									else tag=true;
							}
							else if(tag && temp.charAt(i)=='d'){
									id = idstack.pop();
									attr_type = (Type) symtab.get(id).get(0);
									temp1 = symtab.get(id).get(1);
									the_mem = Integer.parseInt(String.valueOf(temp1));
									if(attr_type==Type.Int || attr_type==Type.Float || attr_type==Type.Double){
										TextCode.add("aload_0");
										TextCode.add("invokevirtual java/util/Scanner.next()Ljava/lang/String;");
										TextCode.add("invokestatic java/lang/Double.parseDouble(Ljava/lang/String;)D");
										TextCode.add("d2i");
									}
									switch(attr_type){
											case Int:		
														TextCode.add("istore " + the_mem);
														break;
											case Float:
														TextCode.add("i2f");
														TextCode.add("fstore " + the_mem);
														break;
											case Double:
														TextCode.add("i2d");
														TextCode.add("dstore " + the_mem);
														break;
											case Intarray:
											case Floatarray:
											case Doublearray:
														--templocation;
														TextCode.add("aload " + templocation);
														--templocation;
														TextCode.add("iload " + templocation);
														TextCode.add("aload_0");
														TextCode.add("invokevirtual java/util/Scanner.next()Ljava/lang/String;");
														TextCode.add("invokestatic java/lang/Double.parseDouble(Ljava/lang/String;)D");
														TextCode.add("i2d");
														switch(attr_type){
																case Intarray:
																				TextCode.add("iastore");
																				break;
																case Floatarray:
																				TextCode.add("i2f");
																				TextCode.add("fastore");
																				break;
																case Doublearray:
																				TextCode.add("i2d");
																				TextCode.add("dastore");
																				break;
														}
														break;
									}
									tag=false;
							}
							else if(tag && temp.charAt(i)=='f'){
									id = idstack.pop();
									attr_type = (Type) symtab.get(id).get(0);
									temp1 = symtab.get(id).get(1);
									the_mem = Integer.parseInt(String.valueOf(temp1));
									//if(attr_type==Type.Int || attr_type==Type.Intarray){
									//		System.err.println("warning: the type is not correct!!");
									//		System.exit(0);
									//}
									if(attr_type==Type.Int || attr_type==Type.Float || attr_type==Type.Double){
											TextCode.add("aload_0");
											TextCode.add("invokevirtual java/util/Scanner.next()Ljava/lang/String;");
											TextCode.add("invokestatic java/lang/Double.parseDouble(Ljava/lang/String;)D");
									}
									switch(attr_type){
											case Int:
														TextCode.add("d2i");
														TextCode.add("istore " + the_mem);
														break;
											case Float:
														TextCode.add("d2f");
														TextCode.add("fstore " + the_mem);
														break;
											case Double:
														TextCode.add("dstore " + the_mem);
														break;
											case Intarray:
											case Floatarray:
											case Doublearray:
														--templocation;
														TextCode.add("aload " + templocation);
														--templocation;
														TextCode.add("iload " + templocation);
														TextCode.add("aload_0");
														TextCode.add("invokevirtual java/util/Scanner.next()Ljava/lang/String;");
														TextCode.add("invokestatic java/lang/Double.parseDouble(Ljava/lang/String;)D");
														switch(attr_type){
																case Intarray:
																				TextCode.add("d2i");
																				TextCode.add("iastore");
																				break;
																case Floatarray:
																				TextCode.add("d2f");
																				TextCode.add("fastore");
																				break;
																case Doublearray:
																				TextCode.add("dastore");
																				break;
														}
														break;
									}
							}
					}
			}
			else{
					System.err.println("error: The numbers of parameter are not correct!!");
					System.exit(0);
			}
	  }
	| assignment_expr[true] ';'
	| if_statement[flag, label_break]
	| for_statement
	| while_statement
	| BREAK ';'
	  {
	  		if(flag) TextCode.add("goto " + label_break);
			else {
					System.err.println("error: there is no loop or switch case!!");
					System.exit(0);
			}
	  }
	;

arguments
	: (',' arith_expr[true]{ stack.push($arith_expr.attr_type); })*
	;

arguments1
	: (',' '&' Identifier array2[$Identifier.text, true] 
	  {
	  		if(!symtab.containsKey($Identifier.text)){
	  				System.err.println("error: The variable is not declared");
	  				System.exit(0);
			}
	  		stack1.push($Identifier.text);
	  }
	  )+
	;

for_statement
@init{ String label; }
	: For '(' a=assignment_expr[true] ';' {label=newlabel(); TextCode.add(label+":");}
	  condition_expr[true] ';'  b=assignment_expr[false]')' 
	  block_statement[true, $condition_expr.label_loc]
	  { 
	  		exec("increment", $b.start.getTokenIndex());
	  		TextCode.add("goto " + label);
	  		TextCode.add($condition_expr.label_loc + ":"); 
	  }
	;

while_statement
@init{String label; }
	: While'('{label=newlabel();TextCode.add(label+":");}condition_expr[true]')'block_statement[true, $condition_expr.label_loc]
	  {
	  		TextCode.add("goto " + label);
	  		TextCode.add($condition_expr.label_loc + ":");
	  }
	;

if_statement
[boolean tag, String label_break]
	: if_then_statement[tag, label_break] if_else_statement[$if_then_statement.label_loc, tag, label_break]
	;

if_then_statement
[boolean tag, String label_break]
returns [String label_loc]
	: If '(' condition_expr[true] { $label_loc = $condition_expr.label_loc; } ')' block_statement[tag, label_break]
	;

if_else_statement
[String label_loc, boolean tag, String label_break]
@init { String label; }
	: Else
	  {
	  		label = newlabel();
	  		TextCode.add("goto " + label);
	  		TextCode.add(label_loc + ":");
	  }
	  block_statement[tag, label_break] { TextCode.add(label + ":"); }
	| { TextCode.add(label_loc + ":"); }
	;

block_statement
[boolean tag, String label_break]
	: '{' statements[tag, label_break] '}'
	;

condition_expr
[boolean cond]
returns [String label_loc, Type attr_type]
	: a=logical_and_expr { $attr_type = $a.attr_type; }
	  ( '||' b=logical_and_expr
	    {
	    	TextCode.add("ior");
	    	$attr_type = Type.Int;
	    }
	  )* {
	  		  	if(cond){
	  	 			String label = newlabel();
	  	 			TextCode.add("ifeq " + label);
					$label_loc = label;
				}
	     }
	;

logical_and_expr
returns [Type attr_type]
	: a=equality_expr { $attr_type = $a.attr_type; }
	  ('&&' b=equality_expr
	   {
	   		TextCode.add("iand");
	   		$attr_type = Type.Int;
	   }
	  )*
	;

equality_expr
returns [Type attr_type]
@init{ boolean flag = true ; }
	: a=cond_expr { $attr_type = $a.attr_type; }
	  (equalityOp b=cond_expr
	   {
	   		int templocation = storageIndex;
	   		flag = false;
			
			switch($b.attr_type){
					case Int:	TextCode.add("i2f");
					case Float:	TextCode.add("fstore " + templocation);
								break;
					case Double:TextCode.add("d2f");
								TextCode.add("fstore " + templocation);
								break;
					default:	
								System.err.println("error: equality_expr!!");
								System.exit(0);
			}
			switch(attr_type){
					case Int:	TextCode.add("i2f");
					case Float:	break;
					case Double:TextCode.add("d2f");
								break;
					default:	
								System.err.println("error: equality_expr!!");
								System.exit(0);
			}
			TextCode.add("fload " + templocation);
			TextCode.add("fcmpl");
			TextCode.add("dup");
			TextCode.add("imul");

			switch($equalityOp.eqop_type){
					case Eq_op: TextCode.add("ineg");
								TextCode.add("iconst_1");
								TextCode.add("iadd");
					case Ne_op: break;
			}
			$attr_type = Type.Int;
	   }
	  )* {
	  	 		if(flag){
	  	 				switch(attr_type){
	  	 						case Int:	TextCode.add("i2f");
	  	 						case Float:	break;
	  	 						case Double:
	  	 									TextCode.add("d2f");
	  	 									break;
	  	 						default: 
	  	 									System.err.println("error: equality_expr!!");
	  	 									System.exit(0);
						}
						TextCode.add("fconst_0");
						TextCode.add("fcmpl");
						$attr_type = Type.Int;
				}
	     }
	;

equalityOp
returns [Equality eqop_type]
	: '==' { $eqop_type = Equality.Eq_op;}
	| '!=' { $eqop_type = Equality.Ne_op;}
	;

cond_expr
returns [Type attr_type]
	: a=arith_expr[true] { $attr_type = $a.attr_type; }
	  (relationOp b=arith_expr[true]
	   {
	   		int templocation = storageIndex;
			
	   		switch($b.attr_type){
	   				case Int: 	TextCode.add("i2f");
	   				case Float:	TextCode.add("fstore " + templocation);
	   							break;
	   				case Double:
	   							TextCode.add("d2f");
	   							TextCode.add("fstore " + templocation);
	   							break;
	   				default:	
	   							System.err.println("error: cond_expr!!");
	   							System.exit(0);
			}
			switch($attr_type){
					case Int:	TextCode.add("i2f");
					case Float:	break;
					case Double:
								TextCode.add("d2f");
								break;
					default: 
								System.err.println("error: cond_expr!!");
								System.exit(0);
			}
			TextCode.add("fload " + templocation);
			TextCode.add("fcmpl");
			// a>b 1
			// a<b -1
			// a==b 0
			switch($relationOp.reop_type){
					case Le_op: // a<=b
								TextCode.add("ineg");
					case Ge_op: // a>=b
								TextCode.add("i2f");      
								TextCode.add("ldc -1.0");
								TextCode.add("fcmpl");
								break;
					case Lt_op: // a<b
								TextCode.add("ineg");
					case Gt_op: // a>b
								TextCode.add("i2f");
								TextCode.add("ldc 1.0");
								TextCode.add("fcmpl");
								TextCode.add("i2f");
								TextCode.add("ldc -1.0");
								TextCode.add("fcmpl");
								break;
			}
			$attr_type = Type.Int;
	   }
	  )*
	;

relationOp
returns [Relation reop_type]
	: '>' { $reop_type = Relation.Gt_op; }
	| '<' { $reop_type = Relation.Lt_op; }
	| '>='{ $reop_type = Relation.Ge_op; }
	| '<='{ $reop_type = Relation.Le_op; }
	;

assignment_expr
[boolean flag]
	: Identifier 
	  {
	  		  if(flag){
	  		  		if(!symtab.containsKey($Identifier.text)){
	  		  		  		System.err.println("error: The variable is not declared!!");
	  		  		  		System.exit(0);
			  		}
			  }
	  }
	  array2[$Identifier.text, flag] assignOp a=arith_expr[flag]
	  {
	  		if(flag){
	  			Type the_type = Type.Error;
				Object temp;
				int the_mem = 0;
				Type type1 = $a.attr_type;

				the_type = (Type) symtab.get($Identifier.text).get(0);
				temp = symtab.get($Identifier.text).get(1);
				the_mem = Integer.parseInt(String.valueOf(temp));

				if(the_type==$a.attr_type && $assignOp.assign_type!=Assignment.Assign){
						switch(the_type){
								case Int:
											TextCode.add("iload " + the_mem);
											TextCode.add("swap");
											switch($assignOp.assign_type){
													case Pu_assign:
																	TextCode.add("iadd");
																	break;
													case Ne_assign:
																	TextCode.add("isub");
																	break;
													case Mu_assign:
																	TextCode.add("imul");
																	break;
													case Di_assign:
																	TextCode.add("idiv");
																	break;
											}
											break; 
								case Float:
											TextCode.add("fload " + the_mem);
											TextCode.add("swap");
											switch($assignOp.assign_type){
													case Pu_assign:
																	TextCode.add("fadd");
																	break;
													case Ne_assign:
																	TextCode.add("fsub");
																	break;
													case Mu_assign:
																	TextCode.add("fmul");
																	break;
													case Di_assign:
																	TextCode.add("fdiv");
																	break;
											}
											break;
								case Double:
											TextCode.add("dstore " + storageIndex);
											TextCode.add("dload " + the_mem);
											TextCode.add("dload " + storageIndex); // cannot use swap
											switch($assignOp.assign_type){
													case Pu_assign:
																	TextCode.add("dadd");
																	break;
													case Ne_assign:
																	TextCode.add("dsub");
																	break;
													case Mu_assign:
																	TextCode.add("dmul");
																	break;
													case Di_assign:
																	TextCode.add("ddiv");
																	break;
											}
											break;
					
								case Intarray:
											TextCode.add("istore " + storageIndex);
											TextCode.add("dup2");
											TextCode.add("iaload");
											TextCode.add("iload " + storageIndex);
											switch($assignOp.assign_type){
													case Pu_assign:
																	TextCode.add("iadd");
																	break;
													case Ne_assign:
																	TextCode.add("isub");
																	break;
													case Mu_assign:
																	TextCode.add("imul");
																	break;
													case Di_assign:
																	TextCode.add("idiv");
																	break;
											}
											break;
						}
				}
				else if($assignOp.assign_type!=Assignment.Assign){
						switch($a.attr_type){
								case Int:
											TextCode.add("i2d");
											break;
								case Float:
											TextCode.add("f2d");
											break;
						}
						TextCode.add("dstore " + storageIndex);
						switch(the_type){
								case Int:
											TextCode.add("iload " + the_mem);
											TextCode.add("i2d");
											break;
								case Float:
											TextCode.add("fload " + the_mem);
											TextCode.add("f2d");
											break;
								case Double: 
											TextCode.add("dload " + the_mem);
											break;
								case Intarray:
											TextCode.add("dup2");
											TextCode.add("iaload");
											TextCode.add("i2d");
											break;
								case Floatarray:
											TextCode.add("dup2");
											TextCode.add("faload");
											TextCode.add("f2d");
											break;
								case Doublearray:
											TextCode.add("dup2");
											TextCode.add("daload");
											break;
						}
						TextCode.add("dload " + storageIndex);
						switch($assignOp.assign_type){
								case Pu_assign:
												TextCode.add("dadd");
												break;
								case Ne_assign:
												TextCode.add("dsub");
												break;
								case Mu_assign:
												TextCode.add("dmul");
												break;
								case Di_assign:
												TextCode.add("ddiv");
												break;
						}
						type1=Type.Double;
				}

				switch(the_type){
						case Int:
						case Intarray:
									if(the_type!=type1){
											switch(type1){
													case Float:
																TextCode.add("f2i");
																break;
													case Double:
																TextCode.add("d2i");
																break;
											}
									}
									if($array2.turn==1) TextCode.add("istore " + the_mem);
									else TextCode.add("iastore");
									break;
						case Float:	
						case Floatarray:
									if(the_type!=type1){
											switch(type1){
													case Int:
																TextCode.add("i2f");
																break;
													case Double:
																TextCode.add("d2f");
																break;
											}
									}
									if($array2.turn==1) TextCode.add("fstore " + the_mem);
									else TextCode.add("fastore");
									break;
						case Double:
						case Doublearray:
									if(the_type!=type1){
											switch(type1){
													case Int:
																TextCode.add("i2d");
																break;
													case Float:
																TextCode.add("f2d");
																break;
											}
									}
									if($array2.turn==1) TextCode.add("dstore " + the_mem);
									else TextCode.add("dastore");
									break;
						default:  	
									System.err.println("error: assignment_expr!!");
									System.exit(0);
				}
	  		}
	  }
	;

assignOp
returns [Assignment assign_type]
	: '='  { $assign_type = Assignment.Assign; }
	| '+=' { $assign_type = Assignment.Pu_assign; }
	| '-=' { $assign_type = Assignment.Ne_assign; }
	| '/=' { $assign_type = Assignment.Di_assign; }
	| '*=' { $assign_type = Assignment.Mu_assign; }
	;

array2
[String id, boolean flag]
returns [int turn]
	: { if(flag) $turn=1; }
	| '['
	  {
	  		if(flag){
	  			Object temp;
	  			int the_mem;
			
				temp = symtab.get(id).get(1);
				the_mem = Integer.parseInt(String.valueOf(temp));

				TextCode.add("aload " + the_mem);
				$turn=2;
			}
	  } arith_expr[flag] ']'
	    {
	    		if(flag){
	    				switch($arith_expr.attr_type){
	    						case Int: break;
	    						default: System.err.println("error: The index type of array is not integer!!");
	    								 System.exit(0);
						}
				}
		}
	;

arith_expr
[boolean flag]
returns [Type attr_type]
	: a=multExpr[flag] { if(flag) $attr_type = $a.attr_type; }
	  (  '+' b=multExpr[flag] 
	     { 
	     		if(flag){
	     			if($attr_type==$b.attr_type){
	     					switch($attr_type){
	     							case Int:
	     										TextCode.add("iadd");
	     										break;
	     							case Float:
	     										TextCode.add("fadd");
	     										break;
	     							case Double:
	     										TextCode.add("dadd");
	     										break;
	     							default: 
	     										System.err.println("error: arith_expr!!");
	     										System.exit(0);
							}
					}
	     			else{
	     					int templocation = storageIndex;
							switch($b.attr_type){
									case Int: 	TextCode.add("i2f");
									case Float:	TextCode.add("f2d");
									case Double:TextCode.add("dstore " + templocation);
												break;
									default: 
												System.err.println("error: arith_expr!!");
												System.exit(0);
							}
							switch($attr_type){
									case Int: 	TextCode.add("i2f");
									case Float:	TextCode.add("f2d");
									case Double:break;
									default: 
												System.err.println("error: arith_expr!!");
												System.exit(0);
							}
							TextCode.add("dload " + templocation);
							TextCode.add("dadd");
							$attr_type = Type.Double;
					}
				}
	     }
	    |'-' c=multExpr[flag]
	     {
	     		if(flag){
	     			if($attr_type==$c.attr_type){
	     					switch($attr_type){
	     							case Int:
	     										TextCode.add("isub");
	     										break;
	     							case Float:
	     										TextCode.add("fsub");
	     										break;
	     							case Double:
	     										TextCode.add("dsub");
	     										break;
	     							default: 
	     										System.err.println("error: arith_expr!!");
	     										System.exit(0);
							}
					}
	     			else{
	     					int templocation = storageIndex;
	     					switch($c.attr_type){
	     							case Int: 	TextCode.add("i2f");
	     							case Float:	TextCode.add("f2d");
	     							case Double:TextCode.add("dstore " + templocation);
	     										break;
	     							default: 
	     										System.err.println("error: arith_expr!!");
	     										System.exit(0);
							}
							switch($attr_type){
									case Int:	TextCode.add("i2f");
									case Float: TextCode.add("f2d");
									case Double:break;
									default: 
												System.err.println("error: arith_expr!!");
												System.exit(0);
							}
							TextCode.add("dload " + templocation);
							TextCode.add("dsub");
							$attr_type = Type.Double;
					}
				}
	     }
	  )*
	;

multExpr
[boolean flag]
returns [Type attr_type]
	: a=castExpr[flag] { if(flag) $attr_type = $a.attr_type; }
	  (  '*' b=castExpr[flag]
	     { 
	     		if(flag){
	     			if($attr_type==$b.attr_type){
	     					switch($attr_type){
	     							case Int:
	     										TextCode.add("imul");
	     										break;
	     							case Float:
	     										TextCode.add("fmul");
	     										break;
	     							case Double:
	     										TextCode.add("dmul");
	     										break;
	     							default: 
	     										System.err.println("error: multExpr!!");
	     										System.exit(0);
							}
					}
	     			else{
	     					int templocation = storageIndex ;
							switch($b.attr_type){
									case Int:	TextCode.add("i2f");
									case Float: TextCode.add("f2d");
									case Double:TextCode.add("dstore " + templocation);
												break;
									default: 
												System.err.println("error: multExpr!!");
												System.exit(0);
							}
							switch($attr_type){
									case Int:	TextCode.add("i2f");
									case Float:	TextCode.add("f2d");
									case Double:break;
									default: 
												System.err.println("error: multExpr!!");
												System.exit(0);
							}
							TextCode.add("dload " + templocation);
							TextCode.add("dmul");
							$attr_type = Type.Double;
					}
				}

	     }
	    |'/' c=castExpr[flag] 
	      {
	      		if(flag){
	      			if($attr_type==$c.attr_type){
	      					switch($attr_type){
	      							case Int:
	      										TextCode.add("idiv");
	      										break;
	      							case Float:
	      										TextCode.add("fdiv");
	      										break;
	      							case Double:
	      										TextCode.add("ddiv");
	      										break;
	      							default: 
	      										System.err.println("error: multExpr!!");
	      										System.exit(0);
							}
					}
	      			else{
							int templocation = storageIndex;
							switch($c.attr_type){
									case Int:	TextCode.add("i2f");
									case Float:	TextCode.add("f2d");
									case Double:TextCode.add("dload " + templocation);
												break;
									default: 
												System.err.println("error: multExpr!!");
												System.exit(0);
							}
							switch($attr_type){
									case Int: 	TextCode.add("i2f");
									case Float: TextCode.add("f2d");
									case Double:break;
									default: 
												System.err.println("error: multExpr!!");
												System.exit(0);
							}
							TextCode.add("dload " + templocation);
							TextCode.add("ddiv");
							$attr_type = Type.Double;
					}
				}
	      }
	  )*
	;

castExpr
[boolean flag]
returns [Type attr_type]
	: signExpr[flag] { if(flag) $attr_type = $signExpr.attr_type; }
	| '('type')'signExpr[flag]
	  {
	  		if(flag){
	  			$attr_type = $type.attr_type;
	  			switch($attr_type){
	  					case Int:
	  								if($signExpr.attr_type!=Type.Int){
	  										switch($signExpr.attr_type){
	  												case Float:
	  															TextCode.add("f2i");
	  															break;
	  												case Double:
	  															TextCode.add("d2i");
	  															break;
											}
									}
	  								break;
	  					case Float:
	  								if($signExpr.attr_type!=Type.Float){
	  										switch($signExpr.attr_type){
	  												case Int:
	  															TextCode.add("i2f");
	  															break;
	  												case Double:
	  															TextCode.add("d2f");
	  															break;
											}
									}
	  								break;
	  					case Double:
	  								if($signExpr.attr_type!=Type.Double){
	  										switch($signExpr.attr_type){
	  												case Int:
	  															TextCode.add("i2d");
	  															break;
	  												case Float:
	  															TextCode.add("f2d");
	  															break;
											}
									}
									break;
	  					default: 
	  								System.err.println("error: cast_expr!!");
	  								System.exit(0);
				}
			}
	  }
	;

signExpr
[boolean flag]
returns [Type attr_type]
	: a=primaryExpr[flag] {if(flag) $attr_type = $a.attr_type; }
	| '-' b=primaryExpr[flag] 
	  { 
	  		if(flag){
	  			$attr_type = $b.attr_type;
	  			switch($attr_type){
	  					case Int:
	  								TextCode.add("ineg"); 
	  								break;
	  					case Float:	
	  								TextCode.add("fneg");
	  								break;
	  					case Double:
	  								TextCode.add("dneg");
	  								break;
	  					default:	
	  								System.err.println("error: signExpr!!");
	  								System.exit(0);
				}
			}
	  }
	;

primaryExpr
[boolean flag]
returns [Type attr_type]
@init{boolean turn=false;}
	: Dec_number
	  {
	  		if(flag){
	  			$attr_type = Type.Int;
	  			TextCode.add("ldc " + $Dec_number.text);
			}
	  }
	| Float_number
	  {
	  		if(flag){
	  			$attr_type = Type.Float;
	  			TextCode.add("ldc " + $Float_number.text);
			}
	  }
	| Identifier
	  {
	  		if(flag){
	  			if(!symtab.containsKey($Identifier.text)){
	  					System.err.println("error: The variable is not declared!!");
	  					System.exit(0);
				}
			}
	  }
	  array1[flag, $Identifier.text] { if(flag) $attr_type=$array1.attr_type;}
	| '(' arith_expr[flag] ')' { if(flag) $attr_type=$arith_expr.attr_type;}
	;

array1
[boolean flag, String id]
returns [Type attr_type]
	: {
	  		if(flag){
	  			Type the_type = Type.Error;
	  			Object temp;
	  			int the_mem = 0;

				
				the_type = (Type) symtab.get(id).get(0);
				temp = symtab.get(id).get(1);
				the_mem = Integer.parseInt(String.valueOf(temp));
				
				$attr_type = the_type;
				switch(the_type){
						case Int:
									TextCode.add("iload " + the_mem);
									break;
						case Float:	
									TextCode.add("fload " + the_mem);
									break;
						case Double:
									TextCode.add("dload " + the_mem);
									break;
						default: 
									System.err.println("error: array1!!");
									System.exit(0);
				}
			}
	  }
	| '['
	  {
	  		if(flag){
	  				Object temp;
	  				int the_mem = 0;
	  				temp = symtab.get(id).get(1);
	  				the_mem = Integer.parseInt(String.valueOf(temp));

					TextCode.add("aload " + the_mem);
			}
	  } arith_expr[flag] ']'
	    {
	    		if(flag){
	    			switch($arith_expr.attr_type){
	    					case Int: 	break;
	    					default:	System.err.println("error: The index type of array is not integer");
	    								System.exit(0);
					}
	    			Type the_type = Type.Error;
					the_type = (Type) symtab.get(id).get(0);

	    			switch(the_type){
	    					case Intarray:
	    							$attr_type=Type.Int;
	    							TextCode.add("iaload");
	    							break;
	    					case Floatarray:
	    							$attr_type=Type.Float;
	    							TextCode.add("faload");
	    							break;
	    					case Doublearray:
	    							$attr_type=Type.Double;
	    							TextCode.add("daload");
	    							break;
	    					default:
	    							System.err.println("error: array2!!");
	    							System.exit(0);
					}
				}
		}
	;

//Reserved keyword
INT : 'int';
CHAR: 'char';
FLOAT: 'float';
DOUBLE: 'double';
VOID: 'void';
MAIN: 'main';
PRINTF: 'printf';
SCANF: 'scanf';
BREAK: 'break';

If: 'if';
Else: 'else';
For: 'for';
While: 'while';

// Compound Operators
PP_op : '++';
MM_op : '--';


// Another operator(multiple meaning)
And: '&';
Mul: '*';
Plus: '+';
Neg: '-';
Inv1: '~';
Inv2: '!';

//Charactor & String
Character : '\'' (EscapeSequence | ~('\''|'\\') ) '\'' ;

STRING	: '\u0022'(EscapeSequence | ~('\\'|'\u0022') )* '\u0022';

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
	: '/''*'(options{greedy=false;}:.)*'*''/' {skip();}
	;

Line_comment
	: '/''/' ~('\n'|'\r')* '\r'?'\n'{skip();}
	;

