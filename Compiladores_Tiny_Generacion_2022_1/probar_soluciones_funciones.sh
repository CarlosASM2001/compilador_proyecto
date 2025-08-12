#!/bin/bash

echo "=== PRUEBA DE SOLUCIONES PARA FUNCIONES ==="
echo

# Compilar gramática si es necesario
if [ ! -f "src/ve/edu/unet/parser.class" ]; then
    echo "Compilando el parser..."
    cd grammar
    java -jar ../tools/java-cup-11b.jar -destdir ../src/ve/edu/unet -parser parser -expect 100 sintactico.cup
    java -jar ../tools/jflex-1.4.1.jar -d ../src/ve/edu/unet/ lexico_extendido.flex
    cd ..
fi

# Compilar clases Java
echo "Compilando clases Java..."
javac -cp lib/java-cup-11b-runtime.jar:src src/ve/edu/unet/*.java src/ve/edu/unet/nodosAST/*.java

echo
echo "=== SOLUCIÓN 1: Funciones después del HALT ==="
echo "Compilando ejemplo_fuente/test_funciones_orden.tiny"
echo
java -cp lib/java-cup-11b-runtime.jar:src ve.edu.unet.parser ejemplo_fuente/test_funciones_orden.tiny

echo
echo "=== SOLUCIÓN 2: Tabla de Saltos ==="
echo "Esta solución requiere modificar el parser para usar GeneradorConTablaSaltos"
echo "Se puede probar cambiando en parser.java la línea:"
echo "  Generador.generarCodigoObjeto(root);"
echo "por:"
echo "  GeneradorConTablaSaltos.generarCodigoObjeto(root);"

echo
echo "=== Ejecutando el código generado ==="
if [ -f "ejemplo_generado/test_funciones_orden.tm" ]; then
    echo "Ejecutando con la máquina TM..."
    cd tools
    ./tm ../ejemplo_generado/test_funciones_orden.tm
    cd ..
else
    echo "No se encontró el archivo generado"
fi