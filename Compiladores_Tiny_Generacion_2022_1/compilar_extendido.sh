#!/bin/bash

echo "=== Compilando Compilador Tiny Extendido ==="

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi

echo "1. Generando analizador léxico con JFlex..."
java -jar tools/jflex-full-1.8.2.jar -d src/ve/edu/unet grammar/lexico_extendido.flex

echo "2. Generando analizador sintáctico con CUP..."
java -jar tools/java-cup-11b.jar -destdir src/ve/edu/unet -parser parser -symbols sym grammar/sintactico.cup

echo "3. Compilando clases Java..."
cd src/ve/edu/unet
javac -cp ../../../../lib/java-cup-11b-runtime.jar *.java nodosAST/*.java

echo "4. Volviendo al directorio raíz..."
cd ../../../..

echo "=== Compilación completada ==="

echo ""
echo "Para probar el compilador:"
echo "Ejemplos disponibles:"
for archivo in ejemplo_fuente/*.tiny; do
    if [[ -f "$archivo" ]]; then
        nombre_base=$(basename "$archivo" .tiny)
        echo "  java -cp \"src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar\" ve.edu.unet.parser ejemplo_fuente/${nombre_base}.tiny"
    fi
done
echo ""
echo "Scripts disponibles:"
echo "  ./compilar_ejemplos.sh     - Compila todos los ejemplos"
echo "  ./ejecutar_con_salida.sh   - Ejecuta y muestra resultados de todos"
echo "  ./probar_ejemplo.sh <nombre> - Prueba un ejemplo específico"
echo ""
echo "Ejemplo: ./probar_ejemplo.sh ejemplo_funcion"