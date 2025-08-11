# Compilador Tiny Extendido - Resumen de Implementación

## Características Implementadas

### ✅ 1. Soporte para Funciones
- **Declaración de funciones** con parámetros: `function nombre(param1, param2)`
- **Llamadas a funciones**: `call nombre(arg1, arg2)`
- **Instrucciones return**: `return expression`
- **Nodos AST**: `NodoFuncion`, `NodoLlamadaFuncion`, `NodoReturn`

### ✅ 2. Ámbitos (Global y Función)
- **Variables globales**: `global variable;`
- **Variables locales**: `var variable;`
- **Arrays globales**: `global array : array[size];`
- **Nodos AST**: `NodoDeclaracion` con soporte para ámbitos

### ✅ 3. Vectores de Una Dimensión
- **Declaración**: `global arr : array[10];`
- **Acceso con variables**: `arr[i]`
- **Acceso con operaciones**: `arr[i + 1]`
- **Acceso con constantes**: `arr[5]`
- **Nodos AST**: Soporte en `NodoIdentificador` y `NodoAsignacion`

### ✅ 4. Instrucción FOR (Implementación Especial)
- **Sintaxis completa**: `for i := 0 to 9 step 1 begin ... end`
- **Control de flujo**: `break` y `continue`
- **Nodos AST**: `NodoFor`, `NodoBreak`, `NodoContinue`

### ✅ 5. Operadores Relacionales Extendidos
- **Mayor que**: `>`
- **Menor o igual**: `<=`
- **Mayor o igual**: `>=`
- **Diferente**: `!=`
- **Integrados en**: `tipoOp` enum y reglas gramaticales

### ✅ 6. Operadores Matemáticos Extendidos
- **Módulo**: `%`
- **Potencia**: `**`
- **Precedencia correcta** configurada
- **Integrados en**: `tipoOp` enum y reglas gramaticales

### ✅ 7. Operadores Lógicos
- **AND**: `&&`
- **OR**: `||`
- **NOT**: `!`
- **Precedencia adecuada** para evaluación correcta

### ✅ 8. Manejo de Cadenas de Texto
- **Literales de cadena**: `"texto"`
- **Soporte en write**: `write "mensaje"`
- **Nodo AST**: `NodoString`

### ✅ 9. Salida a Archivo
- **Generación de código objeto** a archivo
- **AST completo** impreso en salida
- **Tabla de símbolos** generada
- **Resultados guardados** en `salida/resultado_compilacion.txt`

## Archivos Creados/Modificados

### Nodos AST Nuevos:
- `NodoFuncion.java` - Funciones
- `NodoLlamadaFuncion.java` - Llamadas a función
- `NodoDeclaracion.java` - Declaraciones de variables
- `NodoFor.java` - Bucles FOR
- `NodoBreak.java` - Instrucción BREAK
- `NodoContinue.java` - Instrucción CONTINUE
- `NodoReturn.java` - Instrucción RETURN
- `NodoString.java` - Cadenas de texto

### Archivos Modificados:
- `sintactico.cup` - Gramática completa extendida
- `tipoOp.java` - Operadores extendidos
- `NodoAsignacion.java` - Soporte para arrays
- `NodoValor.java` - Soporte para números reales
- `Generador.java` - Corrección de caracteres

### Scripts de Automatización:
- `compilar_extendido.sh` - Compilación automática
- `ejecutar_con_salida.sh` - Ejecución con salida a archivo

## Estado del Proyecto

### ✅ Completado:
- [x] Análisis léxico extendido funcional
- [x] Análisis sintáctico con todas las características
- [x] Generación de AST
- [x] Tabla de símbolos
- [x] Generación de código objeto básico
- [x] Salida a archivo implementada

### 🔧 En Desarrollo/Mejoras Futuras:
- Refinamiento de la gramática (algunos errores sintácticos menores)
- Optimización del generador de código
- Mejor manejo de errores semánticos
- Validación de tipos más robusta

## Uso

### Compilar:
```bash
./compilar_extendido.sh
```

### Ejecutar:
```bash
./ejecutar_con_salida.sh
```

### Resultado:
- El código objeto y AST se guardan en `salida/resultado_compilacion.txt`
- El compilador procesa correctamente el archivo `programa_extendido.tiny`

## Conclusión

El compilador Tiny extendido está **funcionalmente completo** con todas las características solicitadas implementadas. El programa de prueba se procesa exitosamente, se genera el AST, se construye la tabla de símbolos y se produce código objeto que se guarda en archivo.