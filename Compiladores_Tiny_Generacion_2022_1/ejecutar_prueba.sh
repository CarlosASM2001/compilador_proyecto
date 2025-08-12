#!/bin/bash

echo "=== Ejecutando Compilador Tiny con Todos los Ejemplos ==="

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

# Ejecutar el parser para todos los archivos .tiny
echo "Ejecutando compilador para todos los ejemplos..."
for archivo_tiny in ejemplo_fuente/*.tiny; do
    if [[ -f "$archivo_tiny" ]]; then
        nombre_base=$(basename "$archivo_tiny" .tiny)
        archivo_salida="salida/prueba_${nombre_base}.txt"
        
        echo "Compilando: $archivo_tiny"
        java -cp "src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar" ve.edu.unet.parser "$archivo_tiny" > "$archivo_salida" 2>&1
        
        echo "Salida del compilador para $nombre_base:"
        echo "----------------------------------------"
        cat "$archivo_salida"
        echo ""
    fi
done

echo "=== Ejecución completada ==="
echo "Resultados guardados en salida/prueba_*.txt"