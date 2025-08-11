#!/bin/bash

# Script para generar el analizador léxico extendido
echo "Generando analizador léxico extendido..."

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Generar el analizador léxico con JFlex
echo "Usando JFlex para generar el analizador léxico..."
java -jar tools/jflex-full-1.8.2.jar -d src/ve/edu/unet grammar/lexico_extendido.flex

echo "Analizador léxico generado exitosamente!"
echo "El archivo LexicoExtendido.java ha sido creado en src/ve/edu/unet/"

# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi

echo ""
echo "Para probar el analizador léxico:"
echo "1. Compilar: javac -cp lib/java-cup-11b-runtime.jar src/ve/edu/unet/sym.java src/ve/edu/unet/LexicoExtendido.java src/ve/edu/unet/PruebaLexico.java"
echo "2. Ejecutar: java -cp \"src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar\" ve.edu.unet.PruebaLexico ejemplo_fuente/programa_extendido.tiny"