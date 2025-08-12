# Análisis Léxico del Compilador TINY Extendido

## 1. Introducción

El análisis léxico es la primera fase del proceso de compilación. Su función principal es leer el código fuente carácter por carácter y agruparlos en unidades significativas llamadas **tokens** o **lexemas**. En nuestro compilador TINY extendido, esta fase está implementada en el archivo `lexico_extendido.flex` utilizando la herramienta **JFlex**.

## 2. Estructura del Archivo `lexico_extendido.flex`

### 2.1 Sección de Declaraciones

```java
package ve.edu.unet;
import java_cup.runtime.*;
import java.io.Reader;
```

Esta sección define el paquete e importa las librerías necesarias para la integración con CUP (Constructor of Useful Parsers).

### 2.2 Opciones de JFlex

```
%cup                    // Habilita compatibilidad con CUP
%class LexicoExtendido  // Nombre de la clase generada
%line                   // Habilita contador de líneas
%column                // Habilita contador de columnas
```

### 2.3 Código de Usuario

```java
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
%}
```

Este código se incluye directamente en la clase generada y proporciona:
- Constructor personalizado para integración con CUP
- Variables para factory de símbolos, contador de líneas y modo debug

### 2.4 Manejo de Fin de Archivo

```java
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}
```

Define qué hacer cuando se alcanza el fin del archivo.

## 3. Definición de Patrones

### 3.1 Patrones Básicos

```
digito          = [0-9]
numero          = {digito}+
numero_real     = {numero}\.{numero}
letra           = [a-zA-Z]
identificador   = {letra}({letra}|{digito}|_)*
nuevalinea      = \n | \n\r | \r\n
espacio         = [ \t]+
```

Estos patrones definen las expresiones regulares para:
- **Dígitos**: Cualquier número del 0 al 9
- **Números enteros**: Secuencia de uno o más dígitos
- **Números reales**: Números con punto decimal
- **Letras**: Caracteres alfabéticos mayúsculas y minúsculas
- **Identificadores**: Comienzan con letra, seguidos de letras, dígitos o guión bajo
- **Saltos de línea**: Diferentes formatos de nueva línea
- **Espacios**: Espacios y tabulaciones

## 4. Tokens del Lenguaje

### 4.1 Palabras Reservadas Originales

```
"if"     → IF
"then"   → THEN
"else"   → ELSE
"end"    → END
"repeat" → REPEAT
"until"  → UNTIL
"read"   → READ
"write"  → WRITE
```

### 4.2 Palabras Reservadas para Funciones

```
"function" → FUNCTION
"return"   → RETURN
"call"     → CALL
```

Estas palabras permiten la definición y llamada de funciones.

### 4.3 Palabras Reservadas para Ámbitos

```
"begin"  → BEGIN
"var"    → VAR
"global" → GLOBAL
```

Facilitan la declaración de variables en diferentes ámbitos (global/local).

### 4.4 Palabras Reservadas para Vectores

```
"array" → ARRAY
```

Permite la declaración de arreglos/vectores.

### 4.5 Palabras Reservadas para Estructuras de Control

```
"for"      → FOR
"to"       → TO
"step"     → STEP
"break"    → BREAK
"continue" → CONTINUE
```

Implementan el ciclo for con capacidad de interrumpir o continuar la iteración.

## 5. Operadores

### 5.1 Operadores de Asignación

```
":=" → ASSIGN
```

### 5.2 Operadores Relacionales

```
"="  → EQ  (igual)
"<"  → LT  (menor que)
">"  → GT  (mayor que)
"<=" → LE  (menor o igual)
">=" → GE  (mayor o igual)
"!=" → NE  (diferente)
```

### 5.3 Operadores Aritméticos

```
"+"  → PLUS   (suma)
"-"  → MINUS  (resta)
"*"  → TIMES  (multiplicación)
"/"  → OVER   (división)
"%"  → MOD    (módulo)
"**" → POW    (potencia)
```

### 5.4 Operadores Lógicos

```
"&&" → AND (y lógico)
"||" → OR  (o lógico)
"!"  → NOT (negación)
```

## 6. Delimitadores

```
"(" → LPAREN      ")" → RPAREN      (paréntesis)
"[" → LBRACKET    "]" → RBRACKET    (corchetes para arrays)
"{" → LBRACE      "}" → RBRACE      (llaves para bloques)
";" → SEMI                          (punto y coma)
"," → COMMA                         (coma)
":" → COLON                         (dos puntos)
```

## 7. Literales

### 7.1 Números

```java
{numero_real}   { return sf.newSymbol("REAL",sym.REAL,new String(yytext())); }
{numero}        { return sf.newSymbol("NUM",sym.NUM,new String(yytext())); }
```

Se reconocen números enteros y reales, devolviendo el valor como String.

### 7.2 Identificadores

```java
{identificador} { return sf.newSymbol("ID",sym.ID,new String(yytext())); }
```

### 7.3 Cadenas de Texto

```java
\"[^\"]*\"      { return sf.newSymbol("STRING",sym.STRING,new String(yytext())); }
```

Reconoce cadenas entre comillas dobles.

## 8. Manejo de Espacios y Comentarios

### 8.1 Espacios en Blanco

```java
{nuevalinea}    {lineanum++;}      // Incrementa contador de líneas
{espacio}       { /* ignora */ }   // Ignora espacios y tabs
```

### 8.2 Comentarios

```java
"{"[^}]*"}"  { /* comentarios de bloque */ }
"//"[^\n]*   { /* comentarios de línea */ }
```

Soporta dos tipos de comentarios:
- Comentarios de bloque entre llaves `{ }`
- Comentarios de línea con `//`

## 9. Manejo de Errores

```java
.   {System.err.println("Caracter Ilegal encontrado en analisis lexico: " 
     + yytext() + " en línea " + lineanum + "\n");}
```

Cualquier carácter no reconocido genera un mensaje de error indicando el carácter y la línea.

## 10. Proceso de Análisis Léxico

### 10.1 Flujo de Trabajo

1. **Lectura**: Lee el archivo fuente carácter por carácter
2. **Reconocimiento**: Intenta hacer match con los patrones definidos
3. **Tokenización**: Crea un objeto Symbol con:
   - Tipo de token
   - Valor (si aplica)
   - Información de posición (línea y columna)
4. **Retorno**: Devuelve el token al analizador sintáctico

### 10.2 Ejemplo de Tokenización

Para el código:
```
var x := 10;
if x > 5 then
    write x
end
```

Se generarían los tokens:
```
VAR (palabra reservada)
ID("x") (identificador)
ASSIGN (operador de asignación)
NUM("10") (número)
SEMI (delimitador)
IF (palabra reservada)
ID("x") (identificador)
GT (operador mayor que)
NUM("5") (número)
THEN (palabra reservada)
WRITE (palabra reservada)
ID("x") (identificador)
END (palabra reservada)
EOF (fin de archivo)
```

## 11. Integración con el Analizador Sintáctico

El analizador léxico se integra con CUP mediante:
1. La opción `%cup` que genera métodos compatibles
2. El uso de `SymbolFactory` para crear objetos Symbol
3. La clase `sym` generada por CUP que contiene las constantes de tokens

## 12. Consideraciones de Diseño

### 12.1 Ventajas del Diseño Actual

- **Modularidad**: Separación clara entre análisis léxico y sintáctico
- **Mantenibilidad**: Fácil agregar nuevos tokens o modificar patrones
- **Depuración**: Modo debug para rastrear tokens reconocidos
- **Robustez**: Manejo de diferentes formatos de nueva línea y errores

### 12.2 Posibles Mejoras

- Implementar recuperación de errores más sofisticada
- Agregar soporte para más tipos de literales (octales, hexadecimales)
- Mejorar mensajes de error con sugerencias
- Optimizar el reconocimiento de palabras reservadas con tabla hash

## 13. Conclusión

El analizador léxico implementado en `lexico_extendido.flex` proporciona una base sólida para el compilador TINY extendido. Su diseño permite reconocer todos los elementos léxicos necesarios para soportar características avanzadas como funciones, arrays, y estructuras de control adicionales, manteniendo la simplicidad y eficiencia del diseño original.