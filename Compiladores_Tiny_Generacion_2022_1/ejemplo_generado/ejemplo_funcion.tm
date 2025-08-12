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
* -> funcion: duplicar
* -> declaracion: temp
* Declaracion de variable: temp (local)
4:      LDC       0,0(0)        local: inicializar variable temp a cero
5:      ST        0,3(5)        local: almacenar en direccion 3
* <- declaracion
* -> asignacion
* -> Operacion: por
* -> identificador
6:      LD        0,2(5)        cargar id: val[num]
* <- identificador
7:      ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
8:      LDC       0,2(0)        cargar constante: 2
* <- constante
9:      LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
10:     MUL       0,1,0         op: *
* <- Operacion: por
11:     ST        0,3(5)        asignacion: almaceno el valor para el id temp
* <- asignacion
* -> asignacion
* -> Operacion: mas
* -> identificador
12:     LD        0,0(5)        cargar id: val[x]
* <- identificador
13:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
14:     LDC       0,1(0)        cargar constante: 1
* <- constante
15:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
16:     ADD       0,1,0         op: +
* <- Operacion: mas
17:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> return
* -> identificador
18:     LD        0,3(5)        cargar id: val[temp]
* <- identificador
19:     LDA       7,0(1)        return: salto a direccion de retorno
* <- return
* Return implicito al final de la funcion
20:     LD        7,0(1)        return: salto usando direccion en AC1
* <- funcion: duplicar
4:      LDA       7,16(7)       salto al programa principal
* -> declaracion: resultado
* Declaracion de variable: resultado (local)
21:     LDC       0,0(0)        local: inicializar variable resultado a cero
22:     ST        0,4(5)        local: almacenar en direccion 4
* <- declaracion
* -> asignacion
* -> constante
23:     LDC       0,5(0)        cargar constante: 5
* <- constante
24:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> asignacion
* -> llamada funcion: duplicar
25:     LDA       1,2(7)        call: calcular direccion de retorno (PC+2)
* -> identificador
26:     LD        0,0(5)        cargar id: val[x]
* <- identificador
27:     ST        0,2(5)        call: guardar argumento en parametro
28:     LDA       7,-25(7)      call: salto a funcion duplicar
* <- llamada funcion
29:     ST        0,4(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
30:     LD        0,4(5)        cargar id: val[resultado]
* <- identificador
31:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> identificador
32:     LD        0,0(5)        cargar id: val[x]
* <- identificador
33:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* Fin del programa principal
34:     HALT      0,0,0         
* <- programa
