#!/bin/bash

# Script para limpiar y organizar el proyecto del compilador extendido

echo "=== LIMPIEZA Y ORGANIZACIÓN DEL PROYECTO ==="

# Cambiar al directorio del script si no estamos ya ahí
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Limpiar archivos de compilación
echo "Limpiando archivos .class..."
find . -name "*.class" -type f -delete

# Limpiar archivos temporales
echo "Limpiando archivos temporales..."
rm -f src/ve/edu/unet/*.java~ 
rm -f salida/*.txt 2>/dev/null || true

# Crear directorios de organización si no existen
echo "Verificando estructura de directorios..."
mkdir -p salida
mkdir -p resultados_pruebas
mkdir -p documentacion

# Detectar el separador de classpath según el OS
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    CLASSPATH_SEP=";"
else
    CLASSPATH_SEP=":"
fi

# Mostrar estructura final
echo ""
echo "=== ESTRUCTURA DEL PROYECTO ==="
echo "."
echo "├── src/                    # Código fuente Java"
echo "│   └── ve/edu/unet/       # Paquete principal"
echo "│       ├── nodosAST/      # Nodos del AST"
echo "│       └── *.java         # Clases del compilador"
echo "├── grammar/               # Especificaciones de gramática"
echo "│   ├── lexico_extendido.flex   # Analizador léxico"
echo "│   └── sintactico.cup          # Analizador sintáctico"
echo "├── tools/                 # Herramientas de desarrollo"
echo "│   ├── jflex-full-1.8.2.jar   # JFlex"
echo "│   ├── java-cup-11b.jar       # Java CUP"
echo "│   └── tiny64.exe             # Máquina virtual TM"
echo "├── lib/                   # Bibliotecas runtime"
echo "│   └── java-cup-11b-runtime.jar"
echo "├── ejemplo_fuente/        # Códigos fuente de prueba"
echo "├── ejemplo_generado/      # Códigos objeto generados"
echo "├── salida/               # Resultados de compilación"
echo "├── documentacion/        # Documentación del proyecto"
echo "└── resultados_pruebas/   # Resultados de las pruebas"
echo ""
echo "=== SCRIPTS DISPONIBLES ==="
echo "• ./compilar_extendido.sh     - Compilar el compilador completo"
echo "• ./generar_lexico.sh         - Generar solo el analizador léxico"
echo "• ./ejecutar_con_salida.sh    - Ejecutar compilador y mostrar salida"
echo "• ./ejecutar_prueba.sh        - Ejecutar pruebas básicas"
echo "• ./limpiar_proyecto.sh       - Limpiar archivos temporales"
echo ""
echo "=== COMANDOS ÚTILES ==="
echo "• Compilar manualmente:"
echo "  javac -cp lib/java-cup-11b-runtime.jar src/ve/edu/unet/*.java src/ve/edu/unet/nodosAST/*.java"
echo "• Probar: java -cp \"src${CLASSPATH_SEP}lib/java-cup-11b-runtime.jar\" ve.edu.unet.parser ejemplo_fuente/programa_extendido.tiny"
echo ""
echo "=== LIMPIEZA COMPLETADA ==="