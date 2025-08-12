* * Compilacion TINY para la maquina TM
* * Prefacio estandar
0:      LDC       5,0(0)        init: GP = 0
1:      LDC       6,1023(0)      init: MP = 1023 (tope de memoria)
* * Fin del prefacio estandar
* -> programa
* -> declaracion: contador
* Declaracion de variable: contador (global)
2:      LDC       0,0(0)        global: inicializar variable contador a cero
3:      ST        0,0(5)        global: almacenar en direccion 0
* <- declaracion
* -> declaracion: resultado
* Declaracion de variable: resultado (global)
4:      LDC       0,0(0)        global: inicializar variable resultado a cero
5:      ST        0,1(5)        global: almacenar en direccion 1
* <- declaracion
* registrada funcion: factorial
* registrada funcion: sumar
* -> declaracion: x
* Declaracion de variable: x (local)
6:      LDC       0,0(0)        local: inicializar variable x a cero
7:      ST        0,9(5)        local: almacenar en direccion 9
* <- declaracion
* -> declaracion: y
* Declaracion de variable: y (local)
8:      LDC       0,0(0)        local: inicializar variable y a cero
9:      ST        0,10(5)       local: almacenar en direccion 10
* <- declaracion
* -> asignacion
* -> constante
10:     LDC       0,0(0)        cargar constante: 0
* <- constante
11:     ST        0,0(5)        asignacion: almaceno el valor para el id contador
* <- asignacion
* -> leer
12:     IN        0,0,0         leer: lee un valor entero 
13:     ST        0,9(5)        leer: almaceno el valor entero leido en el id x
* <- leer
* -> asignacion
* -> llamada funcion: factorial
* Procesando argumentos de la llamada
* -> identificador
14:     LD        0,9(5)        cargar id: val[x]
* <- identificador
15:     ST        0,-3(6)       call: guardar argumento
16:     LDA       0,3(7)        call: calcular return addr (PC+3)
17:     ST        0,-4(6)       call: push return addr
18:     LDA       7,0(7)        call: salto a funcion factorial
* <- llamada funcion
19:     ST        0,1(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
20:     LD        0,1(5)        cargar id: val[resultado]
* <- identificador
21:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> identificador
22:     LD        0,0(5)        cargar id: val[contador]
* <- identificador
23:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> leer
24:     IN        0,0,0         leer: lee un valor entero 
25:     ST        0,10(5)       leer: almaceno el valor entero leido en el id y
* <- leer
* -> asignacion
* -> llamada funcion: sumar
* Procesando argumentos de la llamada
* -> identificador
26:     LD        0,9(5)        cargar id: val[x]
* <- identificador
* -> identificador
27:     LD        0,10(5)       cargar id: val[y]
* <- identificador
28:     ST        0,-4(6)       call: guardar argumento
* -> identificador
29:     LD        0,10(5)       cargar id: val[y]
* <- identificador
30:     ST        0,-5(6)       call: guardar argumento
31:     LDA       0,3(7)        call: calcular return addr (PC+3)
32:     ST        0,-6(6)       call: push return addr
33:     LDA       7,44(7)       call: salto a funcion sumar
* <- llamada funcion
34:     ST        0,1(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
35:     LD        0,1(5)        cargar id: val[resultado]
* <- identificador
36:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> identificador
37:     LD        0,0(5)        cargar id: val[contador]
* <- identificador
38:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* <- programa
* Fin de la ejecucion.
39:     HALT      0,0,0         
