# Generación de Código del Compilador TINY Extendido

## 1. Introducción

La generación de código es la fase final del compilador donde se transforma el Árbol de Sintaxis Abstracta (AST) en código ejecutable para la máquina virtual TM (Tiny Machine). Esta fase está implementada principalmente en `Generador.java` y utiliza los nodos AST definidos en el paquete `nodosAST`.

## 2. Arquitectura de la Máquina Virtual TM

### 2.1 Modelo de Memoria

```
|t1    |<- MP (Máxima posición de memoria)
|t1    |<- desplazamientoTmp (tope actual)
|free  |    Pila temporal
|free  |
|...   |
|x     |    Variables globales
|y     |<- GP (Global Pointer)
```

### 2.2 Registros

- **AC** (Accumulator): Registro acumulador principal
- **AC1**: Registro acumulador auxiliar
- **PC** (Program Counter): Contador de programa
- **GP** (Global Pointer): Apuntador a variables globales
- **MP** (Memory Pointer): Apuntador al tope de memoria

### 2.3 Instrucciones TM

#### Instrucciones RO (Register Only)
```
ADD, SUB, MUL, DIV  - Operaciones aritméticas
JLT, JLE, JGT, JGE, JEQ, JNE - Saltos condicionales
IN, OUT - Entrada/Salida
```

#### Instrucciones RM (Register Memory)
```
LD, ST - Carga y almacenamiento
LDA, LDC - Carga de dirección y constante
JMP - Salto incondicional
```

## 3. Estructura del Generador de Código

### 3.1 Clase Principal `Generador.java`

```java
public class Generador {
    private static int desplazamientoTmp = 0;
    private static TablaSimbolos tablaSimbolos = null;
    private static int contadorEtiquetas = 0;
    private static Stack<Integer> pilaBreak = new Stack<>();
    private static Stack<Integer> pilaContinue = new Stack<>();
    
    // Manejo de funciones
    private static Map<String, NodoFuncion> funcionesRegistradas = new HashMap<>();
    private static Map<String, Integer> inicioFuncion = new HashMap<>();
    private static Set<String> funcionesEmitidas = new HashSet<>();
}
```

### 3.2 Método Principal de Generación

```java
public static void generarCodigoObjeto(NodoBase raiz){
    generarPreludioEstandar();
    generar(raiz);
    UtGen.emitirRO("HALT", 0, 0, 0, "");
}
```

## 4. Generación de Código para Variables

### 4.1 Variables Globales y Locales

Las variables se almacenan en memoria a partir de la dirección GP:

```java
// Asignación simple: x := 10
generarAsignacion(NodoBase nodo){
    generar(n.getExpresion());  // Genera código para calcular valor
    direccion = tablaSimbolos.getDireccion(n.getIdentificador());
    UtGen.emitirRM("ST", AC, direccion, GP, "asignacion");
}
```

### 4.2 Manejo de la Pila Temporal

```java
// Guardar valor temporal
UtGen.emitirRM("ST", AC, desplazamientoTmp--, MP, "push");

// Recuperar valor temporal
UtGen.emitirRM("LD", AC, ++desplazamientoTmp, MP, "pop");
```

## 5. Generación de Código para Vectores/Arrays

### 5.1 Declaración de Arrays

Los arrays ocupan posiciones consecutivas en memoria:

```java
// global arr: array[10]
// Ocupa direcciones 0-9 en memoria
if(decl.isEsArray() && tamaño > 1){
    direccion += (tamaño - 1);
}
```

### 5.2 Acceso a Elementos

```java
// arr[i]
generarIdentificador(NodoBase nodo){
    if(n.getDesplazamiento() != null){
        generar(n.getDesplazamiento());  // Calcula índice
        direccion = tablaSimbolos.getDireccion(n.getNombre());
        UtGen.emitirRM("LDC", AC1, direccion, 0, "base del array");
        UtGen.emitirRO("ADD", AC, AC, AC1, "dirección calculada");
        UtGen.emitirRM("LD", AC, 0, AC, "cargar elemento");
    }
}
```

### 5.3 Asignación a Arrays

```java
// arr[i] := valor
generarAsignacion(NodoBase nodo){
    if(n.esAsignacionArray()){
        generar(n.getExpresion());  // Calcula valor
        UtGen.emitirRM("ST", AC, desplazamientoTmp--, MP, "guardar valor");
        
        generar(n.getIndice());  // Calcula índice
        direccion = tablaSimbolos.getDireccion(n.getIdentificador());
        UtGen.emitirRM("LDC", AC1, direccion, 0, "base del array");
        UtGen.emitirRO("ADD", AC, AC, AC1, "calcular dirección");
        
        UtGen.emitirRM("LD", AC1, ++desplazamientoTmp, MP, "recuperar valor");
        UtGen.emitirRM("ST", AC1, 0, AC, "almacenar en array");
    }
}
```

## 6. Generación de Código para Condicionales

### 6.1 Estructura IF-THEN-ELSE

```java
generarIf(NodoBase nodo){
    // 1. Generar código para la condición
    generar(n.getPrueba());
    
    // 2. Salto condicional si falso
    localidadSaltoElse = UtGen.emitirSalto(1);
    
    // 3. Generar código para THEN
    generar(n.getParteThen());
    
    if(n.getParteElse() != null){
        // 4. Salto incondicional al final
        localidadSaltoEnd = UtGen.emitirSalto(1);
        
        // 5. Completar salto a ELSE
        UtGen.cargarRespaldo(localidadSaltoElse);
        UtGen.emitirRM_Abs("JEQ", AC, localidadActual, "if: jmp a else");
        UtGen.restaurarRespaldo();
        
        // 6. Generar código para ELSE
        generar(n.getParteElse());
    }
}
```

### 6.2 Ejemplo de Código Generado

```
; if x > 5 then write x else write 0 end
LD  0,0(5)      ; cargar x
ST  0,0(6)      ; guardar en pila temp
LDC 0,5(0)      ; cargar 5
LD  1,0(6)      ; recuperar x
SUB 0,1,0       ; x - 5
JLE 0,3(7)      ; saltar si x <= 5
LD  0,0(5)      ; cargar x
OUT 0,0,0       ; escribir x
LDA 7,1(7)      ; saltar al final
LDC 0,0(0)      ; cargar 0
OUT 0,0,0       ; escribir 0
```

## 7. Generación de Código para Ciclos

### 7.1 Ciclo FOR

```java
generarFor(NodoBase nodo){
    // Etiquetas para control de flujo
    int etiquetaInicio = contadorEtiquetas++;
    int etiquetaFin = contadorEtiquetas++;
    int etiquetaContinue = contadorEtiquetas++;
    
    // Apilar etiquetas para break/continue
    pilaBreak.push(etiquetaFin);
    pilaContinue.push(etiquetaContinue);
    
    // 1. Inicialización
    generar(n.getValorInicial());
    UtGen.emitirRM("ST", AC, direccionVar, GP, "inicializar variable");
    
    // 2. Inicio del bucle
    localidadInicio = UtGen.emitirSalto(0);
    
    // 3. Verificar condición
    UtGen.emitirRM("LD", AC, direccionVar, GP, "cargar variable");
    generar(n.getValorFinal());
    UtGen.emitirRO("SUB", AC, AC1, AC, "variable - final");
    localidadSaltoFin = UtGen.emitirSalto(1);
    
    // 4. Cuerpo del bucle
    generar(n.getCuerpo());
    
    // 5. Incremento
    localidadContinue = UtGen.emitirSalto(0);
    UtGen.emitirRM("LD", AC, direccionVar, GP, "cargar variable");
    generar(n.getIncremento());
    UtGen.emitirRO("ADD", AC, AC1, AC, "incrementar");
    UtGen.emitirRM("ST", AC, direccionVar, GP, "guardar variable");
    
    // 6. Salto al inicio
    UtGen.emitirRM_Abs("LDA", PC, localidadInicio, "volver al inicio");
}
```

### 7.2 Break y Continue

```java
generarBreak(NodoBase nodo){
    if(!pilaBreak.isEmpty()){
        int etiquetaFin = pilaBreak.peek();
        UtGen.emitirRM_Abs("LDA", PC, etiquetaFin, "break: salir del ciclo");
    }
}

generarContinue(NodoBase nodo){
    if(!pilaContinue.isEmpty()){
        int etiquetaContinue = pilaContinue.peek();
        UtGen.emitirRM_Abs("LDA", PC, etiquetaContinue, "continue");
    }
}
```

## 8. Operaciones Matemáticas y Relacionales

### 8.1 Operaciones Aritméticas

```java
switch(n.getOperacion()){
    case mas:    UtGen.emitirRO("ADD", AC, AC1, AC, "op: +"); break;
    case menos:  UtGen.emitirRO("SUB", AC, AC1, AC, "op: -"); break;
    case por:    UtGen.emitirRO("MUL", AC, AC1, AC, "op: *"); break;
    case entre:  UtGen.emitirRO("DIV", AC, AC1, AC, "op: /"); break;
    case modulo: // a % b = a - (a/b)*b
        UtGen.emitirRM("ST", AC, desplazamientoTmp--, MP, "mod: guardar b");
        UtGen.emitirRO("DIV", AC, AC1, AC, "mod: a/b");
        UtGen.emitirRM("LD", AC1, ++desplazamientoTmp, MP, "mod: cargar b");
        UtGen.emitirRO("MUL", AC, AC, AC1, "mod: (a/b)*b");
        UtGen.emitirRO("SUB", AC, AC1, AC, "mod: a - (a/b)*b");
        break;
    case potencia: // Implementación iterativa
        // ... código de potencia ...
        break;
}
```

### 8.2 Operaciones Relacionales

```java
case menor:
    UtGen.emitirRO("SUB", AC, AC1, AC, "op: <");
    UtGen.emitirRM("JLT", AC, 2, PC, "verd si <");
    UtGen.emitirRM("LDC", AC, 0, 0, "falso");
    UtGen.emitirRM("LDA", PC, 1, PC, "saltar load de true");
    UtGen.emitirRM("LDC", AC, 1, 0, "verdadero");
    break;
```

### 8.3 Operaciones Lógicas

```java
case and:
    // Evaluación en cortocircuito
    UtGen.emitirRM("JEQ", AC1, 2, PC, "and: si izq es 0, resultado es 0");
    UtGen.emitirRM("JEQ", AC, 3, PC, "and: si der es 0, resultado es 0");
    UtGen.emitirRM("LDC", AC, 1, 0, "and: ambos true, resultado 1");
    UtGen.emitirRM("LDA", PC, 1, PC, "and: saltar false");
    UtGen.emitirRM("LDC", AC, 0, 0, "and: resultado 0");
    break;

case not:
    generar(n.getOpDerecho());
    UtGen.emitirRM("JEQ", AC, 2, PC, "not: saltar si es 0");
    UtGen.emitirRM("LDC", AC, 0, 0, "not: false");
    UtGen.emitirRM("LDA", PC, 1, PC, "not: saltar true");
    UtGen.emitirRM("LDC", AC, 1, 0, "not: true");
    break;
```

## 9. Funciones

### 9.1 Definición de Funciones

Las funciones se compilan de manera diferida (lazy compilation):

```java
// Registro de funciones durante el análisis
if (nodo instanceof NodoFuncion){
    NodoFuncion func = (NodoFuncion)nodo;
    funcionesRegistradas.put(func.getNombre(), func);
}
```

### 9.2 Llamada a Funciones

```java
generarLlamadaFuncion(NodoBase nodo){
    // 1. Procesar argumentos
    NodoBase arg = n.getArgumentos();
    while(arg != null){
        generar(arg);
        UtGen.emitirRM("ST", AC, desplazamientoTmp--, MP, "guardar arg");
        numArgs++;
        arg = arg.getHermanoDerecha();
    }
    
    // 2. Guardar dirección de retorno
    UtGen.emitirRM("LDA", AC, 3, PC, "calcular return addr");
    UtGen.emitirRM("ST", AC, desplazamientoTmp--, MP, "push return addr");
    
    // 3. Saltar a la función
    UtGen.emitirRM_Abs("LDA", PC, inicioFuncion, "saltar a función");
}
```

### 9.3 Prólogo y Epílogo de Funciones

```java
// Prólogo: copiar argumentos a parámetros
UtGen.emitirRM("LD", AC1, -numArgs, MP, "cargar RA");
UtGen.emitirRM("ST", AC1, 0, MP, "colocar RA en 0(MP)");

// Copiar cada argumento
for(int i = 0; i < params.size(); i++){
    UtGen.emitirRM("LD", AC, -i, MP, "cargar arg");
    UtGen.emitirRM("ST", AC, dirParam, GP, "guardar param");
}

// Epílogo: retornar
generarReturn(NodoBase nodo){
    if(n.getExpresion() != null){
        generar(n.getExpresion());  // Valor de retorno en AC
    }
    UtGen.emitirRM("LD", PC, 0, MP, "return: saltar a RA");
}
```

### 9.4 Paso de Parámetros

#### Arrays como Parámetros
```java
// Los arrays se pasan por referencia (dirección base)
if (pasarBaseArray && arg instanceof NodoIdentificador) {
    int base = tablaSimbolos.getDireccion(nombreArg);
    UtGen.emitirRM("LDC", AC, base, 0, "base addr de array");
}
```

## 10. Variables Globales vs Locales

### 10.1 Ámbito Global

```java
// Variables declaradas con 'global'
global x;
global arr: array[10];
```

Estas variables:
- Se almacenan en direcciones fijas desde GP
- Son accesibles desde cualquier función
- Mantienen su valor durante toda la ejecución

### 10.2 Variables Locales

```java
// Variables declaradas con 'var' dentro de funciones o main
begin
    var temp;
    var localArr: array[5];
end
```

Características:
- Se almacenan en el mismo espacio que las globales
- No hay manejo de stack frame (limitación actual)
- Persisten durante toda la ejecución

### 10.3 Parámetros de Funciones

```java
function suma(a, b)
begin
    return a + b
end
```

Los parámetros:
- Se copian desde la pila temporal a direcciones fijas
- Se comportan como variables locales
- No hay paso por referencia real (excepto arrays)

## 11. Optimizaciones Implementadas

### 11.1 Evaluación en Cortocircuito

Los operadores lógicos AND y OR implementan evaluación perezosa:
- AND: Si el operando izquierdo es falso, no evalúa el derecho
- OR: Si el operando izquierdo es verdadero, no evalúa el derecho

### 11.2 Compilación Diferida de Funciones

Las funciones solo se compilan cuando son llamadas por primera vez, reduciendo el código generado para funciones no utilizadas.

## 12. Limitaciones y Mejoras Futuras

### 12.1 Limitaciones Actuales

1. **Sin recursión real**: No hay stack frames dinámicos
2. **Sin tipos de datos**: Solo enteros
3. **Sin gestión dinámica de memoria**: Arrays de tamaño fijo
4. **Sin ámbitos anidados**: Variables locales comparten espacio global

### 12.2 Mejoras Propuestas

1. **Stack Frames**: Implementar marcos de pila para recursión
2. **Tipos de datos**: Agregar flotantes, strings, estructuras
3. **Gestión de memoria**: Heap para estructuras dinámicas
4. **Optimizaciones**: Eliminación de código muerto, propagación de constantes

## 13. Ejemplo Completo

### 13.1 Código Fuente TINY

```tiny
global nums: array[5];

function bubbleSort(arr, n)
begin
    var i, j, temp;
    for i := 0 to n-1
        for j := 0 to n-i-2
            if arr[j] > arr[j+1] then
                temp := arr[j];
                arr[j] := arr[j+1];
                arr[j+1] := temp
            end
        end
    end
end

begin
    var i;
    for i := 0 to 4
        nums[i] := 5 - i
    end;
    
    call bubbleSort(nums, 5);
    
    for i := 0 to 4
        write nums[i]
    end
end
```

### 13.2 Código TM Generado (fragmento)

```
* Preludio estándar
0:  LD  6,0(0)      ; cargar GP
1:  LDA 5,0(6)      ; copiar GP a MP
2:  ST  0,0(0)      ; limpiar dMem[0]

* Inicialización array
3:  LDC 0,0(0)      ; i := 0
4:  ST  0,10(5)     ; guardar i
...

* Llamada a bubbleSort
20: LDC 0,0(0)      ; base de nums
21: ST  0,-1(6)     ; push arg1
22: LDC 0,5(0)      ; n = 5
23: ST  0,-2(6)     ; push arg2
24: LDA 0,3(7)      ; return addr
25: ST  0,-3(6)     ; push RA
26: LDA 7,50(7)     ; saltar a bubbleSort

* Función bubbleSort
50: LD  1,-3(6)     ; cargar RA
51: ST  1,0(6)      ; RA en 0(MP)
...
```

## 14. Conclusión

La generación de código del compilador TINY extendido transforma exitosamente el AST en código ejecutable para la máquina TM. A pesar de sus limitaciones, el diseño es lo suficientemente robusto para soportar características avanzadas como funciones, arrays, y múltiples estructuras de control. La arquitectura modular facilita futuras extensiones y optimizaciones del generador de código.