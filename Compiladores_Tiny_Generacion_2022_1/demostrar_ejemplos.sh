#!/bin/bash

echo "=== Demostración de Ejemplos del Compilador Tiny ==="
echo ""

# Cambiar al directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Los siguientes ejemplos demuestran diferentes funcionalidades del compilador:"
echo ""

echo "1. EJEMPLO_FOR - Bucles for con incremento personalizado"
echo "   Archivo: ejemplo_fuente/ejemplo_for.tiny"
echo "   Funcionalidad: Bucles for con step personalizado"
echo "   Código generado: ejemplo_generado/ejemplo_for.tm"
cat ejemplo_fuente/ejemplo_for.tiny | sed 's/^/   | /'
echo ""

echo "2. EJEMPLO_FUNCION - Funciones y variables globales"
echo "   Archivo: ejemplo_fuente/ejemplo_funcion.tiny"
echo "   Funcionalidad: Definición de funciones, variables globales, llamadas a funciones"
echo "   Código generado: ejemplo_generado/ejemplo_funcion.tm"
head -10 ejemplo_fuente/ejemplo_funcion.tiny | sed 's/^/   | /'
echo "   | ..."
echo ""

echo "3. EJEMPLO_OPERADORES - Operadores matemáticos, relacionales y lógicos"
echo "   Archivo: ejemplo_fuente/ejemplo_operadores.tiny"
echo "   Funcionalidad: +, -, *, /, %, **, >, >=, <=, !=, =, &&, ||, !"
echo "   Código generado: ejemplo_generado/ejemplo_operadores.tm"
head -15 ejemplo_fuente/ejemplo_operadores.tiny | sed 's/^/   | /'
echo "   | ..."
echo ""

echo "4. EJEMPLO_VECTORES - Arrays y estructuras de control"
echo "   Archivo: ejemplo_fuente/ejemplo_vectores.tiny"
echo "   Funcionalidad: Arrays, bucles repeat-until, acceso a elementos"
echo "   Código generado: ejemplo_generado/ejemplo_vectores.tm"
head -10 ejemplo_fuente/ejemplo_vectores.tiny | sed 's/^/   | /'
echo "   | ..."
echo ""

echo "5. PROGRAMA_EXTENDIDO - Ejemplo completo (mantenido para compatibilidad)"
echo "   Archivo: ejemplo_fuente/programa_extendido.tiny"
echo "   Funcionalidad: Todas las características del compilador"
echo "   Código generado: ejemplo_generado/programa_extendido.tm"
echo "   | {Programa completo que demuestra todas las funcionalidades}"
echo "   | ..."
echo ""

echo "=== Comandos para Usar el Sistema ==="
echo ""
echo "Compilar todos los ejemplos:"
echo "  ./compilar_ejemplos.sh"
echo ""
echo "Probar un ejemplo específico:"
echo "  ./probar_ejemplo.sh ejemplo_funcion"
echo "  ./probar_ejemplo.sh ejemplo_operadores"
echo "  ./probar_ejemplo.sh ejemplo_vectores"
echo "  ./probar_ejemplo.sh ejemplo_for"
echo ""
echo "Ver ejemplos disponibles:"
echo "  ./probar_ejemplo.sh"
echo ""
echo "Ejecutar todos los ejemplos:"
echo "  ./ejecutar_con_salida.sh"
echo ""

echo "=== Archivos Generados ==="
echo ""
echo "Archivos .tm generados (código objeto para la máquina TM):"
if ls ejemplo_generado/*.tm 1> /dev/null 2>&1; then
    ls -la ejemplo_generado/*.tm | grep -E "(ejemplo_|programa_)" | sed 's/^/  /'
else
    echo "  No hay archivos .tm generados. Ejecute ./compilar_ejemplos.sh primero."
fi

echo ""
echo "Logs de compilación:"
if ls salida/*_compilacion.txt 1> /dev/null 2>&1; then
    ls -la salida/*_compilacion.txt | sed 's/^/  /'
else
    echo "  No hay logs disponibles. Ejecute ./compilar_ejemplos.sh primero."
fi

echo ""
echo "=== Sistema Listo ==="
echo "El compilador Tiny está configurado para trabajar con múltiples ejemplos"
echo "que demuestran diferentes funcionalidades del lenguaje."

# Hacer el script ejecutable
chmod +x "$0"