* * Compilacion TINY para la maquina TM
* * Prefacio estandar
0:      LDC       5,0(0)        init: GP = 0
1:      LDC       6,1023(0)      init: MP = 1023 (tope de memoria)
* * Fin del prefacio estandar
* -> programa
* -> declaracion: x
* Declaracion de variable: x (global)
2:      LDC       0,0(0)        global: inicializar variable x a cero
3:      ST        0,0(5)        global: almacenar en direccion 0
* <- declaracion
* -> declaracion: arr
* Declaracion de array: arr tamaño definido
* -> constante
4:      LDC       0,10(0)       cargar constante: 10
* <- constante
5:      LDC       0,0(0)        array: inicializar elemento 0 a cero
6:      ST        0,1(5)        array: almacenar en posicion 1
7:      LDC       0,0(0)        array: inicializar elemento 1 a cero
8:      ST        0,2(5)        array: almacenar en posicion 2
9:      LDC       0,0(0)        array: inicializar elemento 2 a cero
10:     ST        0,3(5)        array: almacenar en posicion 3
11:     LDC       0,0(0)        array: inicializar elemento 3 a cero
12:     ST        0,4(5)        array: almacenar en posicion 4
13:     LDC       0,0(0)        array: inicializar elemento 4 a cero
14:     ST        0,5(5)        array: almacenar en posicion 5
15:     LDC       0,0(0)        array: inicializar elemento 5 a cero
16:     ST        0,6(5)        array: almacenar en posicion 6
17:     LDC       0,0(0)        array: inicializar elemento 6 a cero
18:     ST        0,7(5)        array: almacenar en posicion 7
19:     LDC       0,0(0)        array: inicializar elemento 7 a cero
20:     ST        0,8(5)        array: almacenar en posicion 8
21:     LDC       0,0(0)        array: inicializar elemento 8 a cero
22:     ST        0,9(5)        array: almacenar en posicion 9
23:     LDC       0,0(0)        array: inicializar elemento 9 a cero
24:     ST        0,10(5)       array: almacenar en posicion 10
* <- declaracion
* salto inicial al programa principal
* registrada funcion: suma_vector
25:     LDA       7,-1(7)       salto al programa principal
* -> declaracion: i
* Declaracion de variable: i (local)
26:     LDC       0,0(0)        local: inicializar variable i a cero
27:     ST        0,11(5)       local: almacenar en direccion 11
* <- declaracion
* registrada funcion: suma_vector
* <- programa
* Fin de la ejecucion.
28:     HALT      0,0,0         
