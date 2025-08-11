package ve.edu.unet;

import java_cup.runtime.*;
import java.io.Reader;
//import otros.*;

%%
/* Habilitar la compatibilidad con el interfaz CUP para el generador sintactico*/
%cup
/* Llamar Scanner a la clase que contiene el analizador Lexico */
%class LexicoExtendido

/*-- DECLARACIONES --*/
%{
	public LexicoExtendido(Reader r, SymbolFactory sf){
        this(r);
		this.sf=sf;
		lineanum=0;
		debug=true;
	}
	private SymbolFactory sf;
	private int lineanum;
	private boolean debug;

/******************************************************************
BORRAR SI NO SE NECESITA
	//TODO: Cambiar la SF por esto o ver que se hace
	//Crear un nuevo objeto java_cup.runtime.Symbol con información sobre el token actual sin valor
 	  private Symbol symbol(int type){
    		return new Symbol(type,yyline,yycolumn);
	  }
	//Crear un nuevo objeto java_cup.runtime.Symbol con información sobre el token actual con valor
	  private Symbol symbol(int type,Object value){
    		return new Symbol(type,yyline,yycolumn,value);
	  }
******************************************************************/
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

/* Acceso a la columna y fila actual de analisis CUP */
%line
%column

/* DEFINICIONES DE PATRONES */
digito		    = [0-9]
numero		    = {digito}+
numero_real     = {numero}\.{numero}
letra		    = [a-zA-Z]
identificador	= {letra}({letra}|{digito}|_)*
nuevalinea	    = \n | \n\r | \r\n
espacio		    = [ \t]+

%%

/* PALABRAS RESERVADAS ORIGINALES */
"if"            {	if(debug) System.out.println("token IF");
			return sf.newSymbol("IF",sym.IF);
			}
"then"          { if(debug) System.out.println("token THEN");
			return sf.newSymbol("THEN",sym.THEN);
			}
"else"          {	if(debug) System.out.println("token ELSE");
			return sf.newSymbol("ELSE",sym.ELSE);
			}
"end"           {	if(debug) System.out.println("token END");
			return sf.newSymbol("END",sym.END);
			}
"repeat"        {	if(debug) System.out.println("token REPEAT");
			return sf.newSymbol("REPEAT",sym.REPEAT);
			}
"until"         {	if(debug) System.out.println("token UNTIL");
			return sf.newSymbol("UNTIL",sym.UNTIL);
			}
"read"          {	if(debug) System.out.println("token READ");
			return sf.newSymbol("READ",sym.READ);
			}
"write"         {	if(debug) System.out.println("token WRITE");
			return sf.newSymbol("WRITE",sym.WRITE);
			}

/* NUEVAS PALABRAS RESERVADAS PARA FUNCIONES */
"function"      {	if(debug) System.out.println("token FUNCTION");
			return sf.newSymbol("FUNCTION",sym.FUNCTION);
			}
"return"        {	if(debug) System.out.println("token RETURN");
			return sf.newSymbol("RETURN",sym.RETURN);
			}
"call"          {	if(debug) System.out.println("token CALL");
			return sf.newSymbol("CALL",sym.CALL);
			}

/* NUEVAS PALABRAS RESERVADAS PARA ÁMBITOS */
"begin"         {	if(debug) System.out.println("token BEGIN");
			return sf.newSymbol("BEGIN",sym.BEGIN);
			}
"var"           {	if(debug) System.out.println("token VAR");
			return sf.newSymbol("VAR",sym.VAR);
			}
"global"        {	if(debug) System.out.println("token GLOBAL");
			return sf.newSymbol("GLOBAL",sym.GLOBAL);
			}

/* NUEVAS PALABRAS RESERVADAS PARA VECTORES */
"array"         {	if(debug) System.out.println("token ARRAY");
			return sf.newSymbol("ARRAY",sym.ARRAY);
			}

/* INSTRUCCIÓN ESPECIAL: FOR LOOP CON BREAK Y CONTINUE */
"for"           {	if(debug) System.out.println("token FOR");
			return sf.newSymbol("FOR",sym.FOR);
			}
"to"            {	if(debug) System.out.println("token TO");
			return sf.newSymbol("TO",sym.TO);
			}
"step"          {	if(debug) System.out.println("token STEP");
			return sf.newSymbol("STEP",sym.STEP);
			}
"break"         {	if(debug) System.out.println("token BREAK");
			return sf.newSymbol("BREAK",sym.BREAK);
			}
"continue"      {	if(debug) System.out.println("token CONTINUE");
			return sf.newSymbol("CONTINUE",sym.CONTINUE);
			}

/* OPERADORES ORIGINALES */
":="            {	if(debug) System.out.println("token ASSIGN");
			return sf.newSymbol("ASSIGN",sym.ASSIGN);
			}
"="             {	if(debug) System.out.println("token EQ");
			return sf.newSymbol("EQ",sym.EQ);
			}
"<"             {	if(debug) System.out.println("token LT");
			return sf.newSymbol("LT",sym.LT);
			}
"+"             {	if(debug) System.out.println("token PLUS");
			return sf.newSymbol("PLUS",sym.PLUS);
			}
"-"             {	if(debug) System.out.println("token MINUS");
			return sf.newSymbol("MINUS",sym.MINUS);
			}
"*"             {	if(debug) System.out.println("token TIMES");
			return sf.newSymbol("TIMES",sym.TIMES);
			}
"/"             {	if(debug) System.out.println("token OVER");
			return sf.newSymbol("OVER",sym.OVER);
			}

/* NUEVOS OPERADORES RELACIONALES */
">"             {	if(debug) System.out.println("token GT");
			return sf.newSymbol("GT",sym.GT);
			}
"<="            {	if(debug) System.out.println("token LE");
			return sf.newSymbol("LE",sym.LE);
			}
">="            {	if(debug) System.out.println("token GE");
			return sf.newSymbol("GE",sym.GE);
			}
"!="            {	if(debug) System.out.println("token NE");
			return sf.newSymbol("NE",sym.NE);
			}

/* NUEVOS OPERADORES MATEMÁTICOS */
"%"             {	if(debug) System.out.println("token MOD");
			return sf.newSymbol("MOD",sym.MOD);
			}
"**"            {	if(debug) System.out.println("token POW");
			return sf.newSymbol("POW",sym.POW);
			}

/* OPERADORES LÓGICOS */
"&&"            {	if(debug) System.out.println("token AND");
			return sf.newSymbol("AND",sym.AND);
			}
"||"            {	if(debug) System.out.println("token OR");
			return sf.newSymbol("OR",sym.OR);
			}
"!"             {	if(debug) System.out.println("token NOT");
			return sf.newSymbol("NOT",sym.NOT);
			}

/* DELIMITADORES ORIGINALES */
"("             {	if(debug) System.out.println("token LPAREN");
			return sf.newSymbol("LPAREN",sym.LPAREN);
			}
")"             {	if(debug) System.out.println("token RPAREN");
			return sf.newSymbol("RPAREN",sym.RPAREN);
			}
";"             {	if(debug) System.out.println("token SEMI");
			return sf.newSymbol("SEMI",sym.SEMI);
			}

/* NUEVOS DELIMITADORES PARA VECTORES Y FUNCIONES */
"["             {	if(debug) System.out.println("token LBRACKET");
			return sf.newSymbol("LBRACKET",sym.LBRACKET);
			}
"]"             {	if(debug) System.out.println("token RBRACKET");
			return sf.newSymbol("RBRACKET",sym.RBRACKET);
			}
"{"             {	if(debug) System.out.println("token LBRACE");
			return sf.newSymbol("LBRACE",sym.LBRACE);
			}
"}"             {	if(debug) System.out.println("token RBRACE");
			return sf.newSymbol("RBRACE",sym.RBRACE);
			}
","             {	if(debug) System.out.println("token COMMA");
			return sf.newSymbol("COMMA",sym.COMMA);
			}
":"             {	if(debug) System.out.println("token COLON");
			return sf.newSymbol("COLON",sym.COLON);
			}

/* LITERALES */
{numero_real}   {	if(debug) System.out.println("token REAL");
			return sf.newSymbol("REAL",sym.REAL,new String(yytext()));
			}
{numero}        {	if(debug) System.out.println("token NUM");
			return sf.newSymbol("NUM",sym.NUM,new String(yytext()));
			}
{identificador}	{	if(debug) System.out.println("token ID");
				return sf.newSymbol("ID",sym.ID,new String(yytext()));
			}

/* CADENAS DE TEXTO */
\"[^\"]*\"      {	if(debug) System.out.println("token STRING");
			return sf.newSymbol("STRING",sym.STRING,new String(yytext()));
			}

/* MANEJO DE ESPACIOS Y COMENTARIOS */
{nuevalinea}       {lineanum++;}
{espacio}    { /* saltos espacios en blanco*/}

/* COMENTARIOS MEJORADOS */
"{"[^}]*"}"  { /* comentarios de bloque */ if(debug) System.out.println("token COMENTARIO"); }
"//"[^\n]*   { /* comentarios de línea */ if(debug) System.out.println("token COMENTARIO_LINEA"); }

/* CARACTERES ILEGALES */
.               {System.err.println("Caracter Ilegal encontrado en analisis lexico: " + yytext() + " en línea " + lineanum + "\n");}