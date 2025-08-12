* * Compilacion TINY para la maquina TM
* * Prefacio estandar
0:      LDC       5,0(0)        init: GP = 0
1:      LDC       6,1023(0)      init: MP = 1023 (tope de memoria)
* * Fin del prefacio estandar
* -> programa
* -> declaracion: x
* Declaracion de variable: x (local)
2:      LDC       0,0(0)        local: inicializar variable x a cero
3:      ST        0,0(5)        local: almacenar en direccion 0
* <- declaracion
* -> declaracion: y
* Declaracion de variable: y (local)
4:      LDC       0,0(0)        local: inicializar variable y a cero
5:      ST        0,1(5)        local: almacenar en direccion 1
* <- declaracion
* -> leer
6:      IN        0,0,0         leer: lee un valor entero 
7:      ST        0,0(5)        leer: almaceno el valor entero leido en el id x
* <- leer
* -> leer
8:      IN        0,0,0         leer: lee un valor entero 
9:      ST        0,1(5)        leer: almaceno el valor entero leido en el id y
* <- leer
* -> escribir
* -> Operacion: mas
* -> identificador
10:     LD        0,0(5)        cargar id: val[x]
* <- identificador
11:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> identificador
12:     LD        0,1(5)        cargar id: val[y]
* <- identificador
13:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
14:     ADD       0,1,0         op: +
* <- Operacion: mas
15:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> Operacion: por
* -> identificador
16:     LD        0,0(5)        cargar id: val[x]
* <- identificador
17:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> identificador
18:     LD        0,1(5)        cargar id: val[y]
* <- identificador
19:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
20:     MUL       0,1,0         op: *
* <- Operacion: por
21:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* <- programa
* Fin de la ejecucion.
22:     HALT      0,0,0         
