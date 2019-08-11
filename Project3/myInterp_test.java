import org.antlr.runtime.*;
public class myInterp_test{
		public static void main(String[] args) throws Exception{
				ANTLRFileStream input = new ANTLRFileStream(args[0]);
				myInterpLexer lexer = new myInterpLexer(input);
				CommonTokenStream tokens = new CommonTokenStream(lexer);
				myInterpParser parser = new myInterpParser(tokens);
				parser.prog();
		}
}
