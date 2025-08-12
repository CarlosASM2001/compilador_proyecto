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
* registrada funcion: duplicar
* -> declaracion: resultado
* Declaracion de variable: resultado (local)
4:      LDC       0,0(0)        local: inicializar variable resultado a cero
5:      ST        0,4(5)        local: almacenar en direccion 4
* <- declaracion
* -> asignacion
* -> constante
6:      LDC       0,5(0)        cargar constante: 5
* <- constante
7:      ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> asignacion
* -> llamada funcion: duplicar
* Procesando argumentos de la llamada
* -> identificador
8:      LD        0,0(5)        cargar id: val[x]
* <- identificador
9:      ST        0,-1(6)       call: guardar argumento
10:     LDA       0,3(7)        call: calcular return addr (PC+3)
11:     ST        0,-2(6)       call: push return addr
12:     LDA       7,0(7)        call: salto a funcion duplicar
* <- llamada funcion
13:     ST        0,4(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
14:     LD        0,4(5)        cargar id: val[resultado]
* <- identificador
15:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> identificador
16:     LD        0,0(5)        cargar id: val[x]
* <- identificador
17:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* <- programa
* Fin de la ejecucion.
18:     HALT      0,0,0         
