#!/bin/bash

echo "=== Compilando Todos los Ejemplos Tiny ==="

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Crear directorios de salida si no existen
mkdir -p salida
mkdir -p ejemplo_generado

echo "Ejecutando compilador para todos los ejemplos..."
# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi

# Compilar todos los archivos .tiny
echo "Archivos .tiny encontrados:"
for archivo_tiny in ejemplo_fuente/*.tiny; do
    if [[ -f "$archivo_tiny" ]]; then
        nombre_base=$(basename "$archivo_tiny" .tiny)
        echo "  • $nombre_base"
        
        # Compilar cada archivo
        echo "Compilando $archivo_tiny..."
        java -cp "src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar" ve.edu.unet.parser "$archivo_tiny" > "salida/${nombre_base}_compilacion.txt" 2>&1
        
        if [[ $? -eq 0 ]]; then
            echo "  ✓ $nombre_base compilado exitosamente"
        else
            echo "  ✗ Error compilando $nombre_base"
        fi
    fi
done


echo "=== Compilación de todos los ejemplos completada ==="