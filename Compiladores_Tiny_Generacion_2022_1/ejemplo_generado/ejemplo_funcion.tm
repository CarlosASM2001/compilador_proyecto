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
8:      LDA       1,2(7)        call: calcular direccion de retorno (PC+2)
* -> identificador
9:      LD        0,0(5)        cargar id: val[x]
* <- identificador
10:     ST        0,2(5)        call: guardar argumento en parametro
* DEBUG: saltando a direccion 18 para funcion duplicar
11:     LDA       7,6(7)        call: salto a funcion duplicar
* <- llamada funcion
12:     ST        0,4(5)        asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
13:     LD        0,4(5)        cargar id: val[resultado]
* <- identificador
14:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> escribir
* -> identificador
15:     LD        0,0(5)        cargar id: val[x]
* <- identificador
16:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* Fin del programa principal
17:     HALT      0,0,0         
* Inicio de las funciones
* -> funcion: duplicar
* -> declaracion: num
* Declaracion de variable: num (local)
18:     LDC       0,0(0)        local: inicializar variable num a cero
19:     ST        0,2(5)        local: almacenar en direccion 2
* <- declaracion
* DEBUG: Funcion duplicar registrada en direccion 20
* -> declaracion: temp
* Declaracion de variable: temp (local)
20:     LDC       0,0(0)        local: inicializar variable temp a cero
21:     ST        0,3(5)        local: almacenar en direccion 3
* <- declaracion
* -> asignacion
* -> Operacion: por
* -> identificador
22:     LD        0,2(5)        cargar id: val[num]
* <- identificador
23:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
24:     LDC       0,2(0)        cargar constante: 2
* <- constante
25:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
26:     MUL       0,1,0         op: *
* <- Operacion: por
27:     ST        0,3(5)        asignacion: almaceno el valor para el id temp
* <- asignacion
* -> asignacion
* -> Operacion: mas
* -> identificador
28:     LD        0,0(5)        cargar id: val[x]
* <- identificador
29:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
30:     LDC       0,1(0)        cargar constante: 1
* <- constante
31:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
32:     ADD       0,1,0         op: +
* <- Operacion: mas
33:     ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> return
* -> identificador
34:     LD        0,3(5)        cargar id: val[temp]
* <- identificador
35:     LDA       7,0(1)        return: salto a direccion de retorno
* <- return
* Return implicito al final de la funcion
36:     LD        7,0(1)        return: salto usando direccion en AC1
* <- funcion: duplicar
* <- programa
