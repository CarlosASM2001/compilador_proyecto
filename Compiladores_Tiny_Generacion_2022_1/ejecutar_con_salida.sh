#!/bin/bash

echo "=== Compilando y Ejecutando Programa Extendido ==="

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Crear directorios de salida si no existen
mkdir -p salida
mkdir -p ejemplo_generado

echo "Ejecutando compilador..."
# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi
java -cp "src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar" ve.edu.unet.parser ejemplo_fuente/programa_extendido.tiny > salida/resultado_compilacion.txt 2>&1

echo "Resultados guardados en: salida/resultado_compilacion.txt"
echo ""
echo "Contenido del archivo de salida:"
echo "================================"
cat salida/resultado_compilacion.txt

echo ""
echo "Archivos .tm generados en ejemplo_generado/:"
ls -la ejemplo_generado/*.tm 2>/dev/null || echo "No se encontraron archivos .tm"

echo ""
echo "=== Compilación completada ==="