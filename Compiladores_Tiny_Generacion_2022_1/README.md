# Compilador TINY - Generación 2022-3

Compilador extendido para el lenguaje TINY desarrollado como proyecto académico.

## Estructura del Proyecto

```
.
├── src/                    # Código fuente Java
│   └── ve/edu/unet/       # Paquete principal
│       ├── nodosAST/      # Nodos del AST
│       └── *.java         # Clases del compilador
├── grammar/               # Especificaciones de gramática
│   ├── lexico_extendido.flex   # Analizador léxico
│   └── sintactico.cup          # Analizador sintáctico
├── tools/                 # Herramientas de desarrollo
│   ├── jflex-full-1.8.2.jar   # JFlex
│   ├── java-cup-11b.jar       # Java CUP
│   └── tiny64.exe             # Máquina virtual TM
├── lib/                   # Bibliotecas runtime
│   └── java-cup-11b-runtime.jar
├── ejemplo_fuente/        # Códigos fuente de prueba
├── ejemplo_generado/      # Códigos objeto generados
├── salida/               # Resultados de compilación
├── documentacion/        # Documentación del proyecto
└── resultados_pruebas/   # Resultados de las pruebas
```

## Scripts Disponibles

### `./compilar_extendido.sh`
Compila el compilador completo desde las especificaciones de gramática.
- Genera el analizador léxico con JFlex
- Genera el analizador sintáctico con Java CUP
- Compila todas las clases Java

### `./ejecutar_con_salida.sh`
Ejecuta el compilador con el archivo de prueba y muestra la salida completa.
- Compatible con Windows y Linux (detecta automáticamente el separador de classpath)
- Guarda la salida en `salida/resultado_compilacion.txt`

### `./generar_lexico.sh`
Genera únicamente el analizador léxico desde la especificación JFlex.

### `./ejecutar_prueba.sh`
Ejecuta una prueba básica del compilador.

### `./limpiar_proyecto.sh`
Limpia archivos temporales y muestra la estructura del proyecto.

## Uso Rápido

1. **Compilar el compilador:**
   ```bash
   ./compilar_extendido.sh
   ```

2. **Ejecutar el compilador:**
   ```bash
   ./ejecutar_con_salida.sh
   ```

3. **Limpiar archivos temporales:**
   ```bash
   ./limpiar_proyecto.sh
   ```

## Compilación Manual

```bash
# Compilar las clases Java
javac -cp lib/java-cup-11b-runtime.jar src/ve/edu/unet/*.java src/ve/edu/unet/nodosAST/*.java

# Ejecutar el compilador (Linux/macOS)
java -cp "src:lib/java-cup-11b-runtime.jar" ve.edu.unet.parser ejemplo_fuente/programa_extendido.tiny

# Ejecutar el compilador (Windows)
java -cp "src;lib/java-cup-11b-runtime.jar" ve.edu.unet.parser ejemplo_fuente/programa_extendido.tiny
```

## Componentes del Compilador

- **Analizador Léxico**: Tokeniza el código fuente TINY
- **Analizador Sintáctico**: Construye el AST (Árbol de Sintaxis Abstracta)
- **Generador de Código**: Produce código objeto para la máquina virtual TM
- **Tabla de Símbolos**: Maneja identificadores y sus tipos

## Extensiones Implementadas

- Variables globales y locales
- Arrays unidimensionales
- Funciones con parámetros
- Estructuras de control: `for`, `if-else`, `repeat`
- Operadores aritméticos extendidos: `mod`, `pow`
- Operadores lógicos: `and`, `or`, `not`
- Entrada/salida: `read`, `write`
- Comentarios de línea y bloque

## Herramientas Utilizadas

- **JFlex 1.8.2**: Generador de analizadores léxicos
- **Java CUP 11b**: Generador de analizadores sintácticos
- **Java**: Lenguaje de implementación
- **TM**: Máquina virtual objetivo

## Archivos de Prueba

Los archivos de ejemplo están en `ejemplo_fuente/`:
- `programa_extendido.tiny`: Programa completo que demuestra todas las características

## Salida

El compilador genera:
1. **Análisis Léxico**: Lista de tokens reconocidos
2. **Análisis Sintáctico**: Construcción del AST
3. **Tabla de Símbolos**: Variables y funciones declaradas
4. **Código Objeto**: Instrucciones para la máquina virtual TM