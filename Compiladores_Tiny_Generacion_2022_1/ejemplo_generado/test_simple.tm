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
* -> if
* -> Operacion: mayor
* -> identificador
10:     LD        0,0(5)        cargar id: val[x]
* <- identificador
11:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> identificador
12:     LD        0,1(5)        cargar id: val[y]
* <- identificador
13:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
14:     SUB       0,1,0         op: >
15:     JGT       0,2(7)        saltar si AC>0
16:     LDC       0,0(0)        caso falso
17:     LDA       7,1(7)        saltar caso verdadero
18:     LDC       0,1(0)        caso verdadero
* <- Operacion: mayor
* If: el salto hacia el else debe estar aqui
* -> escribir
* -> constante
20:     LDC       0,1(0)        cargar constante: 1
* <- constante
21:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* If: el salto hacia el final debe estar aqui
19:     JEQ       0,3(7)        if: jmp hacia else
* -> escribir
* -> constante
23:     LDC       0,0(0)        cargar constante: 0
* <- constante
24:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
22:     LDA       7,2(7)        if: jmp hacia el final
* <- if
* <- programa
* Fin de la ejecucion.
25:     HALT      0,0,0         
