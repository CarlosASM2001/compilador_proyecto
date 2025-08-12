# Análisis Sintáctico del Compilador TINY Extendido

## 1. Introducción

El análisis sintáctico es la segunda fase del proceso de compilación. Su función es verificar que la secuencia de tokens producida por el analizador léxico corresponde a la estructura gramatical correcta del lenguaje. En nuestro compilador TINY extendido, esta fase está implementada en el archivo `sintactico.cup` usando la herramienta **CUP** (Constructor of Useful Parsers), generando las clases `parser.java`, `sym.java`, y trabajando en conjunto con `TablaSimbolos.java`.

## 2. Componentes del Análisis Sintáctico

### 2.1 Archivo `sintactico.cup`

Define la gramática del lenguaje mediante:
- **Terminales**: Tokens provenientes del léxico
- **No terminales**: Símbolos de la gramática
- **Producciones**: Reglas gramaticales
- **Acciones semánticas**: Construcción del AST

### 2.2 Clase `sym.java`

Generada automáticamente por CUP, contiene las constantes numéricas para cada token:

```java
public class sym {
    public static final int IF = 2;
    public static final int THEN = 3;
    public static final int ELSE = 4;
    public static final int END = 5;
    // ... más constantes ...
}
```

### 2.3 Clase `parser.java`

Parser generado por CUP que implementa un analizador LALR(1). Contiene:
- Tablas de análisis
- Método `parse()` principal
- Manejo de errores sintácticos

### 2.4 Clase `TablaSimbolos.java`

Estructura de datos que almacena información sobre:
- Variables declaradas (globales y locales)
- Funciones definidas
- Arrays y sus tamaños
- Direcciones de memoria asignadas

## 3. Gramática del Lenguaje

### 3.1 Estructura General del Programa

```
program ::= declaration_seq main 
         | main
```

Un programa puede tener:
- Declaraciones seguidas del programa principal
- Solo el programa principal

### 3.2 Declaraciones

#### Declaraciones Globales
```
global_declaration ::= GLOBAL ID SEMI
                    | GLOBAL ID COLON ARRAY LBRACKET NUM RBRACKET SEMI
```

Permiten declarar:
- Variables globales simples
- Arrays globales con tamaño específico

#### Declaraciones de Funciones
```
function_declaration ::= FUNCTION ID LPAREN parameter_list RPAREN 
                        BEGIN stmt_seq END
                      | FUNCTION ID LPAREN RPAREN 
                        BEGIN stmt_seq END
```

Las funciones pueden tener:
- Parámetros (incluyendo arrays)
- Cuerpo con secuencia de sentencias

### 3.3 Programa Principal

```
main ::= BEGIN stmt_seq END
```

El programa principal es obligatorio y contiene la secuencia de sentencias principal.

## 4. Sentencias del Lenguaje

### 4.1 Tipos de Sentencias

```
stmt ::= if_stmt | repeat_stmt | for_stmt | assign_stmt 
      | read_stmt | write_stmt | call_stmt | return_stmt 
      | break_stmt | continue_stmt | var_declaration
```

### 4.2 Sentencia IF

```
if_stmt ::= IF exp THEN stmt_seq END
         | IF exp THEN stmt_seq ELSE stmt_seq END
```

Soporta condicionales simples y con rama else.

### 4.3 Sentencia REPEAT

```
repeat_stmt ::= REPEAT stmt_seq UNTIL exp
```

Ciclo que se repite hasta que la condición sea verdadera.

### 4.4 Sentencia FOR

```
for_stmt ::= FOR ID ASSIGN exp TO exp STEP exp stmt_seq END
          | FOR ID ASSIGN exp TO exp stmt_seq END
```

Ciclo for con:
- Variable de control
- Valor inicial y final
- Incremento opcional (por defecto 1)

### 4.5 Asignación

```
assign_stmt ::= ID ASSIGN exp
             | ID LBRACKET exp RBRACKET ASSIGN exp
```

Permite asignar valores a:
- Variables simples
- Elementos de arrays

### 4.6 Entrada/Salida

```
read_stmt ::= READ ID
write_stmt ::= WRITE exp
```

### 4.7 Llamada a Funciones

```
call_stmt ::= CALL ID LPAREN argument_list RPAREN
           | CALL ID LPAREN RPAREN
```

### 4.8 Control de Flujo en Funciones

```
return_stmt ::= RETURN exp | RETURN
break_stmt ::= BREAK
continue_stmt ::= CONTINUE
```

## 5. Expresiones

### 5.1 Jerarquía de Expresiones

```
exp ::= logical_exp
logical_exp ::= relational_exp AND relational_exp | ...
relational_exp ::= simple_exp comparison_op simple_exp | ...
simple_exp ::= term PLUS term | ...
term ::= factor TIMES factor | ...
factor ::= NUM | ID | function_call | ...
```

### 5.2 Precedencia de Operadores

```cup
precedence left OR;
precedence left AND;
precedence right NOT;
precedence left EQ, NE, LT, LE, GT, GE;
precedence left PLUS, MINUS;
precedence left TIMES, OVER, MOD;
precedence right POW;
```

De menor a mayor precedencia:
1. OR (||)
2. AND (&&)
3. NOT (!)
4. Operadores relacionales (==, !=, <, <=, >, >=)
5. Suma y resta (+, -)
6. Multiplicación, división y módulo (*, /, %)
7. Potencia (**)

## 6. Construcción del AST

### 6.1 Nodos del AST

Cada producción crea nodos específicos del AST:

```java
// Ejemplo: Creación de nodo IF
if_stmt ::= IF exp:cond THEN stmt_seq:then_part END
{: RESULT = new NodoIf(cond, then_part); :}
```

### 6.2 Tipos de Nodos

- **NodoPrograma**: Raíz del AST
- **NodoDeclaracion**: Variables y arrays
- **NodoFuncion**: Definiciones de funciones
- **NodoIf**, **NodoRepeat**, **NodoFor**: Estructuras de control
- **NodoAsignacion**: Asignaciones
- **NodoOperacion**: Operaciones binarias
- **NodoIdentificador**: Referencias a variables
- **NodoValor**: Valores literales

## 7. Tabla de Símbolos

### 7.1 Estructura

```java
public class TablaSimbolos {
    private HashMap<String, RegistroSimbolo> tabla;
    private int direccion;  // Contador de memoria
}
```

### 7.2 Funcionalidades

#### Inserción de Símbolos
```java
public boolean InsertarSimbolo(String identificador, int numLinea)
```
- Verifica que no exista el símbolo
- Asigna dirección de memoria
- Incrementa contador de direcciones

#### Búsqueda de Símbolos
```java
public RegistroSimbolo BuscarSimbolo(String identificador)
```
- Retorna información del símbolo
- Incluye dirección de memoria

#### Manejo de Arrays
```java
// Arrays ocupan múltiples posiciones
if(decl.isEsArray() && tamaño > 1){
    direccion += (tamaño - 1);
}
```

### 7.3 Carga de la Tabla

La tabla se carga mediante un recorrido del AST:
1. Declaraciones globales
2. Parámetros de funciones
3. Variables locales
4. Variables de control (for)

## 8. Manejo de Errores

### 8.1 Errores Sintácticos

```cup
stmt ::= error
{: System.out.println("Error sintáctico en sentencia");
   RESULT = null; :}
```

### 8.2 Recuperación de Errores

CUP intenta recuperarse de errores mediante:
- Descarte de tokens hasta encontrar un punto seguro
- Continuación del análisis después del error

## 9. Integración con Otros Componentes

### 9.1 Con el Analizador Léxico

```java
parser_obj = new parser(new LexicoExtendido(inputStream, sf), sf);
```

### 9.2 Con el Generador de Código

```java
NodoBase root = parser_obj.action_obj.getASTroot();
TablaSimbolos ts = new TablaSimbolos();
ts.cargarTabla(root);
Generador.setTablaSimbolos(ts);
Generador.generarCodigoObjeto(root);
```

## 10. Ejemplo de Análisis

### 10.1 Código Fuente
```tiny
global x;
function suma(a, b)
begin
    return a + b
end

begin
    var resultado;
    x := 10;
    resultado := call suma(x, 5);
    write resultado
end
```

### 10.2 Proceso de Análisis

1. **Tokens recibidos**: GLOBAL, ID(x), SEMI, FUNCTION, ID(suma), ...
2. **Aplicación de reglas**:
   - `global_declaration` → declaración global
   - `function_declaration` → función suma
   - `main` → programa principal
3. **Construcción del AST**:
   - NodoPrograma (raíz)
     - NodoDeclaracion (x, global)
     - NodoFuncion (suma)
     - Secuencia principal

### 10.3 Tabla de Símbolos Resultante
```
Variable: x → Dirección: 0 (global)
Variable: suma → Dirección: 1 (función)
Variable: a → Dirección: 2 (parámetro)
Variable: b → Dirección: 3 (parámetro)
Variable: resultado → Dirección: 4 (local)
```

## 11. Ventajas del Diseño

### 11.1 Modularidad
- Separación clara entre análisis y generación
- Fácil extensión de la gramática
- AST independiente de la sintaxis concreta

### 11.2 Robustez
- Manejo de errores integrado
- Recuperación ante errores sintácticos
- Verificación de tipos básica

### 11.3 Eficiencia
- Parser LALR(1) eficiente
- Tabla de símbolos con acceso O(1)
- Construcción directa del AST

## 12. Limitaciones y Posibles Mejoras

### 12.1 Limitaciones Actuales
- No hay verificación de tipos completa
- No se validan llamadas a funciones (número de parámetros)
- No hay manejo de ámbitos anidados

### 12.2 Mejoras Propuestas
- Implementar sistema de tipos más robusto
- Añadir verificación semántica completa
- Soportar ámbitos anidados y closures
- Mejorar mensajes de error con sugerencias

## 13. Conclusión

El análisis sintáctico implementado proporciona una base sólida para el compilador TINY extendido. La combinación de CUP para el parsing, una gramática bien estructurada, y una tabla de símbolos eficiente permite analizar programas complejos con funciones, arrays, y múltiples estructuras de control. El diseño modular facilita futuras extensiones y mejoras al lenguaje.