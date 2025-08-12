#!/bin/bash

# Script para compilar un archivo .tiny específico

if [[ $# -eq 0 ]]; then
    echo "=== Probador de Ejemplos Tiny Individual ==="
    echo ""
    echo "Uso: $0 <nombre_archivo>"
    echo ""
    echo "Ejemplos disponibles:"
    for archivo in ejemplo_fuente/*.tiny; do
        if [[ -f "$archivo" ]]; then
            nombre_base=$(basename "$archivo" .tiny)
            echo "  • $nombre_base"
        fi
    done
    echo ""
    echo "Ejemplo de uso:"
    echo "  $0 ejemplo_funcion"
    echo "  $0 ejemplo_operadores"
    exit 1
fi

# Obtener el nombre del archivo desde el parámetro
NOMBRE_ARCHIVO="$1"

# Quitar la extensión .tiny si fue incluida
NOMBRE_ARCHIVO="${NOMBRE_ARCHIVO%.tiny}"

# Archivos de entrada y salida
ARCHIVO_TINY="ejemplo_fuente/${NOMBRE_ARCHIVO}.tiny"
ARCHIVO_LOG="salida/${NOMBRE_ARCHIVO}_compilacion.txt"
ARCHIVO_TM="ejemplo_generado/${NOMBRE_ARCHIVO}.tm"

echo "=== Compilando Ejemplo Individual: $NOMBRE_ARCHIVO ==="

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Verificar que el archivo existe
if [[ ! -f "$ARCHIVO_TINY" ]]; then
    echo "Error: No se encontró el archivo $ARCHIVO_TINY"
    echo ""
    echo "Archivos .tiny disponibles:"
    for archivo in ejemplo_fuente/*.tiny; do
        if [[ -f "$archivo" ]]; then
            nombre_base=$(basename "$archivo" .tiny)
            echo "  • $nombre_base"
        fi
    done
    exit 1
fi

# Crear directorios de salida si no existen
mkdir -p salida
mkdir -p ejemplo_generado

# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi

echo "Archivo fuente: $ARCHIVO_TINY"
echo "Log de compilación: $ARCHIVO_LOG"
echo "Código generado: $ARCHIVO_TM"
echo ""

# Mostrar el contenido del archivo fuente
echo "=== Contenido del archivo fuente ==="
cat "$ARCHIVO_TINY"
echo ""
echo "=== Iniciando compilación ==="

# Compilar el archivo
java -cp "src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar" ve.edu.unet.parser "$ARCHIVO_TINY" > "$ARCHIVO_LOG" 2>&1

# Verificar el resultado
if [[ $? -eq 0 ]]; then
    echo "✓ Compilación completada sin errores de ejecución"
    
    # Verificar si se generó el archivo .tm
    if [[ -f "$ARCHIVO_TM" ]]; then
        echo "✓ Archivo .tm generado exitosamente"
        echo ""
        echo "=== Información del archivo generado ==="
        ls -la "$ARCHIVO_TM"
        echo ""
        echo "=== Primeras líneas del código .tm generado ==="
        head -20 "$ARCHIVO_TM"
        echo ""
        echo "Para ver el archivo completo: cat $ARCHIVO_TM"
    else
        echo "⚠ La compilación se completó pero no se generó el archivo .tm"
        echo "Revisa el log para más detalles."
    fi
else
    echo "✗ Error durante la compilación"
fi

echo ""
echo "=== Log de compilación ==="
cat "$ARCHIVO_LOG"

echo ""
echo "=== Compilación completada ==="
echo "Archivos generados:"
echo "  • Log: $ARCHIVO_LOG"
if [[ -f "$ARCHIVO_TM" ]]; then
    echo "  • Código TM: $ARCHIVO_TM"
fi

# Hacer el script ejecutable
chmod +x "$0"