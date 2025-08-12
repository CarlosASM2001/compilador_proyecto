* * Compilacion TINY para la maquina TM
* * Prefacio estandar
0:      LDC       5,0(0)        init: GP = 0
1:      LDC       6,1023(0)      init: MP = 1023 (tope de memoria)
* * Fin del prefacio estandar
* Generando nodo tipo: NodoPrograma
* -> programa
* Procesando nodo tipo: NodoDeclaracion
* Generando nodo tipo: NodoDeclaracion
* -> declaracion: x
* Declaracion de variable: x (global)
2:      LDC       0,0(0)        global: inicializar variable x a cero
3:      ST        0,0(5)        global: almacenar en direccion 0
* <- declaracion
* Generando nodo tipo: NodoDeclaracion
* -> declaracion: resultado
* Declaracion de variable: resultado (local)
4:      LDC       0,0(0)        local: inicializar variable resultado a cero
5:      ST        0,1(5)        local: almacenar en direccion 1
* <- declaracion
* Generando nodo tipo: NodoDeclaracion
* -> declaracion: temp
* Declaracion de variable: temp (local)
6:      LDC       0,0(0)        local: inicializar variable temp a cero
7:      ST        0,2(5)        local: almacenar en direccion 2
* <- declaracion
* Generando nodo tipo: NodoDeclaracion
* -> declaracion: num
* Declaracion de variable: num (local)
8:      LDC       0,0(0)        local: inicializar variable num a cero
9:      ST        0,3(5)        local: almacenar en direccion 3
* <- declaracion
* Generando nodo tipo: NodoAsignacion
* -> asignacion
* Generando nodo tipo: NodoValor
* -> constante
10:     LDC       0,5(0)        cargar constante: 5
* <- constante
11:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* Generando nodo tipo: NodoAsignacion
* -> asignacion
* Generando nodo tipo: NodoIdentificador
* -> identificador
12:     LD        0,0(5)        cargar id: val[x]
* <- identificador
13:     ST        0,3(5)        asignacion: almaceno el valor para el id num
* <- asignacion
* Generando nodo tipo: NodoAsignacion
* -> asignacion
* Generando nodo tipo: NodoOperacion
* -> Operacion: por
* Generando nodo tipo: NodoIdentificador
* -> identificador
14:     LD        0,3(5)        cargar id: val[num]
* <- identificador
15:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* Generando nodo tipo: NodoValor
* -> constante
16:     LDC       0,2(0)        cargar constante: 2
* <- constante
17:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
18:     MUL       0,1,0         op: *
* <- Operacion: por
19:     ST        0,2(5)        asignacion: almaceno el valor para el id temp
* <- asignacion
* Generando nodo tipo: NodoAsignacion
* -> asignacion
* Generando nodo tipo: NodoOperacion
* -> Operacion: mas
* Generando nodo tipo: NodoIdentificador
* -> identificador
20:     LD        0,0(5)        cargar id: val[x]
* <- identificador
21:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* Generando nodo tipo: NodoValor
* -> constante
22:     LDC       0,1(0)        cargar constante: 1
* <- constante
23:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
24:     ADD       0,1,0         op: +
* <- Operacion: mas
25:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* Generando nodo tipo: NodoAsignacion
* -> asignacion
* Generando nodo tipo: NodoIdentificador
* -> identificador
26:     LD        0,2(5)        cargar id: val[temp]
* <- identificador
27:     ST        0,1(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* Generando nodo tipo: NodoEscribir
* -> escribir
* Generando nodo tipo: NodoIdentificador
* -> identificador
28:     LD        0,1(5)        cargar id: val[resultado]
* <- identificador
29:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* Generando nodo tipo: NodoEscribir
* -> escribir
* Generando nodo tipo: NodoIdentificador
* -> identificador
30:     LD        0,0(5)        cargar id: val[x]
* <- identificador
31:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* Fin del programa principal
32:     HALT      0,0,0         
* <- programa
