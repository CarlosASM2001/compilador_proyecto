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
* Salto inicial al programa principal
* -> funcion: duplicar
* -> declaracion: temp
* Declaracion de variable: temp (local)
5:      LDC       0,0(0)        local: inicializar variable temp a cero
6:      ST        0,3(5)        local: almacenar en direccion 3
* <- declaracion
* -> asignacion
* -> Operacion: por
* -> identificador
7:      LD        0,2(5)        cargar id: val[num]
* <- identificador
8:      ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
9:      LDC       0,2(0)        cargar constante: 2
* <- constante
10:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
11:     MUL       0,1,0         op: *
* <- Operacion: por
12:     ST        0,3(5)        asignacion: almaceno el valor para el id temp
* <- asignacion
* -> asignacion
* -> Operacion: mas
* -> identificador
13:     LD        0,0(5)        cargar id: val[x]
* <- identificador
14:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
15:     LDC       0,1(0)        cargar constante: 1
* <- constante
16:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
17:     ADD       0,1,0         op: +
* <- Operacion: mas
18:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> return
* -> identificador
19:     LD        0,3(5)        cargar id: val[temp]
* <- identificador
20:     LDA       7,0(1)        return: salto a direccion de retorno
* <- return
* Return implicito al final de la funcion
21:     LD        7,0(1)        return: salto usando direccion en AC1
* <- funcion: duplicar
4:      LDA       7,17(7)       salto inicial al main
* -> declaracion: resultado
* Declaracion de variable: resultado (local)
22:     LDC       0,0(0)        local: inicializar variable resultado a cero
23:     ST        0,4(5)        local: almacenar en direccion 4
* <- declaracion
* -> asignacion
* -> constante
24:     LDC       0,5(0)        cargar constante: 5
* <- constante
25:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> asignacion
* -> llamada funcion: duplicar
26:     LDA       1,2(7)        call: calcular direccion de retorno (PC+2)
* -> identificador
27:     LD        0,0(5)        cargar id: val[x]
* <- identificador
28:     ST        0,2(5)        call: guardar argumento en parametro
* Saltando a funcion duplicar en direccion 5
29:     LDA       7,-25(7)      call: salto a funcion duplicar
* <- llamada funcion
30:     ST        0,4(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
31:     LD        0,4(5)        cargar id: val[resultado]
* <- identificador
32:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> identificador
33:     LD        0,0(5)        cargar id: val[x]
* <- identificador
34:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* Fin del programa principal
35:     HALT      0,0,0         
* <- programa
