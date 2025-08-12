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
* -> declaracion: resultado
* Declaracion de variable: resultado (local)
4:      LDC       0,0(0)        local: inicializar variable resultado a cero
5:      ST        0,1(5)        local: almacenar en direccion 1
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
13:     ST        0,1(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
14:     LD        0,1(5)        cargar id: val[resultado]
* <- identificador
15:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> declaracion: temp
* Declaracion de variable: temp (local)
16:     LDC       0,0(0)        local: inicializar variable temp a cero
17:     ST        0,2(5)        local: almacenar en direccion 2
* <- declaracion
* -> asignacion
* -> Operacion: por
* -> identificador
18:     LD        0,3(5)        cargar id: val[num]
* <- identificador
19:     ST        0,-2(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
20:     LDC       0,2(0)        cargar constante: 2
* <- constante
21:     LD        1,-2(6)       op: pop o cargo de la pila el valor izquierdo en AC1
22:     MUL       0,1,0         op: *
* <- Operacion: por
23:     ST        0,2(5)        asignacion: almaceno el valor para el id temp
* <- asignacion
* -> asignacion
* -> Operacion: mas
* -> identificador
24:     LD        0,0(5)        cargar id: val[x]
* <- identificador
25:     ST        0,-2(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
26:     LDC       0,1(0)        cargar constante: 1
* <- constante
27:     LD        1,-2(6)       op: pop o cargo de la pila el valor izquierdo en AC1
28:     ADD       0,1,0         op: +
* <- Operacion: mas
29:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> return
* -> identificador
30:     LD        0,2(5)        cargar id: val[temp]
* <- identificador
31:     LD        1,0(6)        return: recuperar direccion de retorno
32:     LDA       7,0(1)        return: salto a direccion de retorno
* <- return
* <- programa
* Fin de la ejecucion.
33:     HALT      0,0,0         
