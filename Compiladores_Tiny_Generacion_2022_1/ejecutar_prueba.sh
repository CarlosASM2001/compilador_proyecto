#!/bin/bash

echo "=== Ejecutando Compilador Tiny Extendido ==="

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi

# Crear directorio de salida si no existe
mkdir -p salida

# Ejecutar el parser
echo "Ejecutando compilador..."
java -cp "src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar" ve.edu.unet.parser ejemplo_fuente/programa_extendido.tiny > salida/prueba_basica.txt 2>&1

echo "Salida del compilador:"
cat salida/prueba_basica.txt

echo ""
echo "=== Ejecución completada ==="
echo "Resultado guardado en: salida/prueba_basica.txt"