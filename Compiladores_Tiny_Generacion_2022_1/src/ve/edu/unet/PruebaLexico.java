package ve.edu.unet;

import java_cup.runtime.*;
import java.io.*;

public class PruebaLexico {
    public static void main(String[] args) throws Exception {
        System.out.println("=== PRUEBA DEL ANALIZADOR LÉXICO EXTENDIDO ===\n");
        
        SymbolFactory sf = new DefaultSymbolFactory();
        LexicoExtendido lexer;
        
        if (args.length == 0) {
            System.out.println("Leyendo desde entrada estándar...");
            lexer = new LexicoExtendido(new InputStreamReader(System.in), sf);
        } else {
            System.out.println("Leyendo archivo: " + args[0]);
            lexer = new LexicoExtendido(new InputStreamReader(new FileInputStream(args[0])), sf);
        }
        
        System.out.println("Tokens reconocidos:\n");
        
        Symbol token;
        int contador = 0;
        
        do {
            token = lexer.next_token();
            contador++;
            
            String nombreToken = obtenerNombreToken(token.sym);
            String valor = token.value != null ? " (" + token.value.toString() + ")" : "";
            
            System.out.printf("%3d. %-15s%s%n", contador, nombreToken, valor);
            
        } while (token.sym != sym.EOF);
        
        System.out.println("\n=== ANÁLISIS COMPLETADO ===");
        System.out.println("Total de tokens procesados: " + contador);
    }
    
    private static String obtenerNombreToken(int simbolo) {
        switch(simbolo) {
            case sym.EOF: return "EOF";
            case sym.IF: return "IF";
            case sym.THEN: return "THEN";
            case sym.ELSE: return "ELSE";
            case sym.END: return "END";
            case sym.REPEAT: return "REPEAT";
            case sym.UNTIL: return "UNTIL";
            case sym.READ: return "READ";
            case sym.WRITE: return "WRITE";
            case sym.ASSIGN: return "ASSIGN";
            case sym.EQ: return "EQ";
            case sym.LT: return "LT";
            case sym.PLUS: return "PLUS";
            case sym.MINUS: return "MINUS";
            case sym.TIMES: return "TIMES";
            case sym.OVER: return "OVER";
            case sym.LPAREN: return "LPAREN";
            case sym.RPAREN: return "RPAREN";
            case sym.SEMI: return "SEMI";
            case sym.NUM: return "NUM";
            case sym.ID: return "ID";
            
            // Nuevos tokens para funciones
            case sym.FUNCTION: return "FUNCTION";
            case sym.RETURN: return "RETURN";
            case sym.CALL: return "CALL";
            
            // Nuevos tokens para ámbitos
            case sym.BEGIN: return "BEGIN";
            case sym.VAR: return "VAR";
            case sym.GLOBAL: return "GLOBAL";
            
            // Nuevos tokens para vectores
            case sym.ARRAY: return "ARRAY";
            
            // Instrucción especial: FOR LOOP
            case sym.FOR: return "FOR";
            case sym.TO: return "TO";
            case sym.STEP: return "STEP";
            case sym.BREAK: return "BREAK";
            case sym.CONTINUE: return "CONTINUE";
            
            // Nuevos operadores relacionales
            case sym.GT: return "GT";
            case sym.LE: return "LE";
            case sym.GE: return "GE";
            case sym.NE: return "NE";
            
            // Nuevos operadores matemáticos
            case sym.MOD: return "MOD";
            case sym.POW: return "POW";
            
            // Operadores lógicos
            case sym.AND: return "AND";
            case sym.OR: return "OR";
            case sym.NOT: return "NOT";
            
            // Nuevos delimitadores
            case sym.LBRACKET: return "LBRACKET";
            case sym.RBRACKET: return "RBRACKET";
            case sym.LBRACE: return "LBRACE";
            case sym.RBRACE: return "RBRACE";
            case sym.COMMA: return "COMMA";
            case sym.COLON: return "COLON";
            
            // Nuevos tipos de datos
            case sym.REAL: return "REAL";
            case sym.STRING: return "STRING";
            
            default: return "DESCONOCIDO(" + simbolo + ")";
        }
    }
}