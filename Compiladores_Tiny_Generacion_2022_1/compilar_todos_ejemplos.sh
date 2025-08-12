#!/bin/bash

echo "=== Compilando todos los ejemplos Tiny ==="
echo ""

# Cambiar al directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Crear directorio de salida si no existe
mkdir -p ejemplo_generado

# Contador de éxitos y fallos
EXITOS=0
FALLOS=0

# Función para compilar un archivo
compilar_archivo() {
    local archivo=$1
    local nombre_base=$(basename "$archivo" .tiny)
    
    echo "Compilando: $archivo"
    
    # Compilar y capturar salida
    if java -cp "src:lib/*:tools/*" ve.edu.unet.parser "$archivo" > "salida/${nombre_base}_compilacion_nueva.txt" 2>&1; then
        # Verificar si se generó el archivo .tm
        if [ -f "ejemplo_generado/${nombre_base}.tm" ]; then
            echo "  ✓ Éxito: ${nombre_base}.tm generado"
            ((EXITOS++))
        else
            echo "  ✗ Error: No se generó el archivo .tm"
            ((FALLOS++))
        fi
    else
        echo "  ✗ Error en compilación"
        ((FALLOS++))
    fi
    
    # Verificar si hay errores de sintaxis en la salida
    if grep -q "Syntax error\|Error sintáctico" "salida/${nombre_base}_compilacion_nueva.txt" 2>/dev/null; then
        echo "  ⚠ Advertencia: Se detectaron errores de sintaxis"
    fi
    
    echo ""
}

# Compilar todos los archivos .tiny en ejemplo_fuente
echo "Archivos a compilar:"
ls ejemplo_fuente/*.tiny
echo ""

for archivo in ejemplo_fuente/*.tiny; do
    if [ -f "$archivo" ]; then
        compilar_archivo "$archivo"
    fi
done

# Resumen
echo "=== Resumen de compilación ==="
echo "Éxitos: $EXITOS"
echo "Fallos: $FALLOS"
echo ""

if [ $FALLOS -eq 0 ]; then
    echo "¡Todos los archivos se compilaron exitosamente!"
else
    echo "Algunos archivos tuvieron errores. Revisa los logs en la carpeta 'salida'."
fi

exit $FALLOS