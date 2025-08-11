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
* Declaracion de array: arr tama▒o definido
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
* -> declaracion: i
* Declaracion de variable: i (local)
25:     LDC       0,0(0)        local: inicializar variable i a cero
26:     ST        0,11(5)       local: almacenar en direccion 11
* <- declaracion
* -> declaracion: num
* Declaracion de variable: num (local)
27:     LDC       0,0(0)        local: inicializar variable num a cero
28:     ST        0,12(5)       local: almacenar en direccion 12
* <- declaracion
* -> declaracion: resultado
* Declaracion de variable: resultado (local)
29:     LDC       0,0(0)        local: inicializar variable resultado a cero
30:     ST        0,13(5)       local: almacenar en direccion 13
* <- declaracion
* -> leer
31:     IN        0,0,0         leer: lee un valor entero
32:     ST        0,12(5)       leer: almaceno el valor entero leido en el id num
* <- leer
* -> for
* -> constante
33:     LDC       0,0(0)        cargar constante: 0
* <- constante
34:     ST        0,11(5)       for: inicializar variable i
* for: inicio del bucle
35:     LD        0,11(5)       for: cargar variable de control
36:     ST        0,0(6)        for: guardar variable en pila temp
* -> constante
37:     LDC       0,9(0)        cargar constante: 9
* <- constante
38:     LD        1,0(6)        for: cargar variable de pila temp
39:     SUB       0,1,0         for: variable - valor_final
* for: salto condicional al final
* -> asignacion
* -> Operacion: mas
* -> Operacion: por
* -> identificador
41:     LD        0,11(5)       cargar id: val[i]
* <- identificador
42:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
43:     LDC       0,2(0)        cargar constante: 2
* <- constante
44:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
45:     MUL       0,1,0         op: *
* <- Operacion: por
46:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
47:     LDC       0,1(0)        cargar constante: 1
* <- constante
48:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
49:     ADD       0,1,0         op: +
* <- Operacion: mas
50:     ST        0,0(6)        asignacion array: guardar valor
* -> identificador
51:     LD        0,11(5)       cargar id: val[i]
* <- identificador
52:     LDC       1,1(0)        asignacion array: cargar direccion base
53:     ADD       0,0,1         asignacion array: calcular direccion
54:     LD        1,0(6)        asignacion array: recuperar valor
55:     ST        1,0(0)        asignacion array: almacenar en posicion calculada
* <- asignacion
* for: punto de continue
56:     LD        0,11(5)       for: cargar variable para incremento
57:     ST        0,0(6)        for: guardar variable en pila temp
* -> constante
58:     LDC       0,1(0)        cargar constante: 1
* <- constante
59:     LD        1,0(6)        for: cargar variable de pila temp
60:     ADD       0,1,0         for: incrementar variable
61:     ST        0,11(5)       for: guardar variable incrementada
62:     LDA       7,-28(7)      for: salto al inicio
* for: fin del bucle
40:     JGT       0,22(7)       for: saltar si variable > final
* <- for
* -> if
* -> Operacion: and
* -> Operacion: mayorigual
* -> identificador
63:     LD        0,12(5)       cargar id: val[num]
* <- identificador
64:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
65:     LDC       0,0(0)        cargar constante: 0
* <- constante
66:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
67:     SUB       0,1,0         op: >=
68:     JGE       0,2(7)        saltar si AC>=0
69:     LDC       0,0(0)        caso falso
70:     LDA       7,1(7)        saltar caso verdadero
71:     LDC       0,1(0)        caso verdadero
* <- Operacion: mayorigual
72:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> Operacion: menorigual
* -> identificador
73:     LD        0,12(5)       cargar id: val[num]
* <- identificador
74:     ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
75:     LDC       0,10(0)       cargar constante: 10
* <- constante
76:     LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
77:     SUB       0,1,0         op: <=
78:     JLE       0,2(7)        saltar si AC<=0
79:     LDC       0,0(0)        caso falso
80:     LDA       7,1(7)        saltar caso verdadero
81:     LDC       0,1(0)        caso verdadero
* <- Operacion: menorigual
82:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
83:     JEQ       1,3(7)        and: si izquierdo es falso, resultado es falso
84:     JEQ       0,2(7)        and: si derecho es falso, resultado es falso
85:     LDC       0,1(0)        and: ambos verdaderos
86:     LDA       7,1(7)        and: saltar caso falso
87:     LDC       0,0(0)        and: resultado falso
* <- Operacion: and
* If: el salto hacia el else debe estar aqui
* -> escribir
* -> identificador
89:     LD        0,12(5)       cargar id: val[num]
* <- identificador
90:     OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> if
* -> Operacion: igual
* -> Operacion: modulo
* -> identificador
91:     LD        0,12(5)       cargar id: val[num]
* <- identificador
92:     ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
93:     LDC       0,2(0)        cargar constante: 2
* <- constante
94:     LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
95:     ST        0,0(6)        mod: guardar b
96:     ST        1,-1(6)       mod: guardar a
97:     DIV       0,1,0         mod: a/b
98:     LD        1,-1(6)       mod: recuperar a
99:     LD        2,0(6)        mod: recuperar b en r2
100:    MUL       0,0,2         mod: (a/b)*b
101:    SUB       0,1,0         mod: a - (a/b)*b
* <- Operacion: modulo
102:    ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
103:    LDC       0,0(0)        cargar constante: 0
* <- constante
104:    LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
105:    SUB       0,1,0         op: ==
106:    JEQ       0,2(7)        voy dos instrucciones mas alla if verdadero (AC==0)
107:    LDC       0,0(0)        caso de falso (AC=0)
108:    LDA       7,1(7)        Salto incodicional a direccion: PC+1 (es falso evito colocarlo verdadero)
109:    LDC       0,1(0)        caso de verdadero (AC=1)
* <- Operacion: igual
* If: el salto hacia el else debe estar aqui
* -> escribir
* -> constante
111:    LDC       0,1(0)        cargar constante: 1
* <- constante
112:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* If: el salto hacia el final debe estar aqui
110:    JEQ       0,3(7)        if: jmp hacia else
* -> escribir
* -> constante
114:    LDC       0,0(0)        cargar constante: 0
* <- constante
115:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
113:    LDA       7,2(7)        if: jmp hacia el final
* <- if
* -> asignacion
* -> Operacion: potencia
* -> identificador
116:    LD        0,12(5)       cargar id: val[num]
* <- identificador
117:    ST        0,0(6)        op: push en la pila tmp el resultado expresion izquierda
* -> constante
118:    LDC       0,2(0)        cargar constante: 2
* <- constante
119:    LD        1,0(6)        op: pop o cargo de la pila el valor izquierdo en AC1
120:    ST        0,0(6)        pow: guardar exp
121:    ST        1,-1(6)       pow: guardar base
122:    LDC       0,1(0)        pow: inicializar resultado = 1
123:    ST        0,-2(6)       pow: guardar res
* pow: inicio bucle
124:    LD        0,0(6)        pow: cargar exp
* pow: salto condicional a fin (exp==0)
126:    LD        0,-2(6)       pow: cargar res
127:    LD        1,-1(6)       pow: cargar base
128:    MUL       0,1,0         pow: res = res * base
129:    ST        0,-2(6)       pow: guardar res
130:    LD        1,0(6)        pow: cargar exp en AC1
131:    LDC       0,1(0)        pow: cargar 1
132:    SUB       0,1,0         pow: exp - 1
133:    ST        0,0(6)        pow: guardar exp
134:    LDA       7,-11(7)      pow: repetir
125:    JEQ       0,9(7)        pow: salir si exp == 0
135:    LD        0,-2(6)       pow: cargar resultado
136:    LD        1,-2(6)       pow: pop res
137:    LD        1,-1(6)       pow: pop base
138:    LD        1,0(6)        pow: pop exp
* <- Operacion: potencia
139:    ST        0,0(5)        asignacion: almaceno el valor para el id x
* <- asignacion
* -> escribir
* -> identificador
140:    LD        0,0(5)        cargar id: val[x]
* <- identificador
141:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* If: el salto hacia el final debe estar aqui
88:     JEQ       0,54(7)       if: jmp hacia else
* -> escribir
* -> constante
143:    LDC       0,999(0)      cargar constante: 999
* <- constante
144:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
142:    LDA       7,2(7)        if: jmp hacia el final
* <- if
* -> asignacion
* -> llamada funcion: suma_vector
* Procesando argumentos de la llamada
* -> identificador
145:    LD        0,1(5)        cargar id: val[arr]
* <- identificador
* -> constante
146:    LDC       0,10(0)       cargar constante: 10
* <- constante
147:    ST        0,0(6)        call: guardar argumento
* -> constante
148:    LDC       0,10(0)       cargar constante: 10
* <- constante
149:    ST        0,-1(6)       call: guardar argumento
150:    LDA       0,3(7)        call: calcular return addr (PC+3)
151:    ST        0,-2(6)       call: push return addr
* ERROR: llamada a funcion no definida: suma_vector
152:    LDA       7,0(7)        call: salto a funcion suma_vector
* <- llamada funcion
153:    ST        0,13(5)       asignacion: almaceno el valor para el id resultado
* <- asignacion
* -> escribir
* -> identificador
154:    LD        0,13(5)       cargar id: val[resultado]
* <- identificador
155:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* -> if
* -> Operacion: or
* -> Operacion: mayor
* -> identificador
156:    LD        0,12(5)       cargar id: val[num]
* <- identificador
157:    ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
158:    LDC       0,5(0)        cargar constante: 5
* <- constante
159:    LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
160:    SUB       0,1,0         op: >
161:    JGT       0,2(7)        saltar si AC>0
162:    LDC       0,0(0)        caso falso
163:    LDA       7,1(7)        saltar caso verdadero
164:    LDC       0,1(0)        caso verdadero
* <- Operacion: mayor
165:    ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> Operacion: menor
* -> identificador
166:    LD        0,12(5)       cargar id: val[num]
* <- identificador
167:    ST        0,-2(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
168:    LDC       0,0(0)        cargar constante: 0
* <- constante
169:    LD        1,-2(6)       op: pop o cargo de la pila el valor izquierdo en AC1
170:    SUB       0,1,0         op: <
171:    JLT       0,2(7)        voy dos instrucciones mas alla if verdadero (AC<0)
172:    LDC       0,0(0)        caso de falso (AC=0)
173:    LDA       7,1(7)        Salto incodicional a direccion: PC+1 (es falso evito colocarlo verdadero)
174:    LDC       0,1(0)        caso de verdadero (AC=1)
* <- Operacion: menor
175:    LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
176:    JNE       1,3(7)        or: si izquierdo es verdadero, resultado es verdadero
177:    JNE       0,2(7)        or: si derecho es verdadero, resultado es verdadero
178:    LDC       0,0(0)        or: ambos falsos
179:    LDA       7,1(7)        or: saltar caso verdadero
180:    LDC       0,1(0)        or: resultado verdadero
* <- Operacion: or
* If: el salto hacia el else debe estar aqui
* -> escribir
* -> constante
182:    LDC       0,1(0)        cargar constante: 1
* <- constante
183:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* If: el salto hacia el final debe estar aqui
181:    JEQ       0,3(7)        if: jmp hacia else
* <- if
* -> if
* -> Operacion: not
* -> Operacion: diferente
* -> identificador
185:    LD        0,12(5)       cargar id: val[num]
* <- identificador
186:    ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
187:    LDC       0,5(0)        cargar constante: 5
* <- constante
188:    LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
189:    SUB       0,1,0         op: !=
190:    JNE       0,2(7)        saltar si AC!=0
191:    LDC       0,0(0)        caso falso
192:    LDA       7,1(7)        saltar caso verdadero
193:    LDC       0,1(0)        caso verdadero
* <- Operacion: diferente
194:    JEQ       0,2(7)        not: saltar si es cero (falso)
195:    LDC       0,0(0)        not: resultado falso
196:    LDA       7,1(7)        not: saltar carga de verdadero
197:    LDC       0,1(0)        not: resultado verdadero
* <- Operacion: not
* If: el salto hacia el else debe estar aqui
* -> escribir
* -> constante
199:    LDC       0,5(0)        cargar constante: 5
* <- constante
200:    OUT       0,0,0         escribir: genero la salida de la expresion
* <- escribir
* If: el salto hacia el final debe estar aqui
198:    JEQ       0,3(7)        if: jmp hacia else
* <- if
* -> declaracion: i
* Declaracion de variable: i (local)
202:    LDC       0,0(0)        local: inicializar variable i a cero
203:    ST        0,11(5)       local: almacenar en direccion 11
* <- declaracion
* -> declaracion: total
* Declaracion de variable: total (local)
204:    LDC       0,0(0)        local: inicializar variable total a cero
205:    ST        0,14(5)       local: almacenar en direccion 14
* <- declaracion
* -> asignacion
* -> constante
206:    LDC       0,0(0)        cargar constante: 0
* <- constante
207:    ST        0,14(5)       asignacion: almaceno el valor para el id total
* <- asignacion
* -> for
* -> constante
208:    LDC       0,0(0)        cargar constante: 0
* <- constante
209:    ST        0,11(5)       for: inicializar variable i
* for: inicio del bucle
210:    LD        0,11(5)       for: cargar variable de control
211:    ST        0,-1(6)       for: guardar variable en pila temp
* -> Operacion: menos
* -> identificador
212:    LD        0,15(5)       cargar id: val[size]
* <- identificador
213:    ST        0,-2(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
214:    LDC       0,1(0)        cargar constante: 1
* <- constante
215:    LD        1,-2(6)       op: pop o cargo de la pila el valor izquierdo en AC1
216:    SUB       0,1,0         op: -
* <- Operacion: menos
217:    LD        1,-1(6)       for: cargar variable de pila temp
218:    SUB       0,1,0         for: variable - valor_final
* for: salto condicional al final
* -> asignacion
* -> Operacion: mas
* -> identificador
220:    LD        0,14(5)       cargar id: val[total]
* <- identificador
221:    ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> identificador
* -> identificador
222:    LD        0,11(5)       cargar id: val[i]
* <- identificador
223:    LDC       1,16(0)       identificador array: cargar direccion base
224:    ADD       0,0,1         identificador array: calcular direccion
* <- identificador
225:    LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
226:    ADD       0,1,0         op: +
* <- Operacion: mas
227:    ST        0,14(5)       asignacion: almaceno el valor para el id total
* <- asignacion
* -> if
* -> Operacion: menor
* -> identificador
* -> identificador
228:    LD        0,11(5)       cargar id: val[i]
* <- identificador
229:    LDC       1,16(0)       identificador array: cargar direccion base
230:    ADD       0,0,1         identificador array: calcular direccion
* <- identificador
231:    ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
232:    LDC       0,0(0)        cargar constante: 0
* <- constante
233:    LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
234:    SUB       0,1,0         op: <
235:    JLT       0,2(7)        voy dos instrucciones mas alla if verdadero (AC<0)
236:    LDC       0,0(0)        caso de falso (AC=0)
237:    LDA       7,1(7)        Salto incodicional a direccion: PC+1 (es falso evito colocarlo verdadero)
238:    LDC       0,1(0)        caso de verdadero (AC=1)
* <- Operacion: menor
* If: el salto hacia el else debe estar aqui
* -> continue
* continue: salto al incremento del bucle
* <- continue
* If: el salto hacia el final debe estar aqui
239:    JEQ       0,1(7)        if: jmp hacia else
* <- if
* -> if
* -> Operacion: mayor
* -> identificador
241:    LD        0,14(5)       cargar id: val[total]
* <- identificador
242:    ST        0,-1(6)       op: push en la pila tmp el resultado expresion izquierda
* -> constante
243:    LDC       0,200(0)      cargar constante: 200
* <- constante
244:    LD        1,-1(6)       op: pop o cargo de la pila el valor izquierdo en AC1
245:    SUB       0,1,0         op: >
246:    JGT       0,2(7)        saltar si AC>0
247:    LDC       0,0(0)        caso falso
248:    LDA       7,1(7)        saltar caso verdadero
249:    LDC       0,1(0)        caso verdadero
* <- Operacion: mayor
* If: el salto hacia el else debe estar aqui
* -> break
* break: salto al final del bucle
* <- break
* If: el salto hacia el final debe estar aqui
250:    JEQ       0,1(7)        if: jmp hacia else
* <- if
* for: punto de continue
252:    LD        0,11(5)       for: cargar variable para incremento
253:    ST        0,-1(6)       for: guardar variable en pila temp
* -> constante
254:    LDC       0,1(0)        cargar constante: 1
* <- constante
255:    LD        1,-1(6)       for: cargar variable de pila temp
256:    ADD       0,1,0         for: incrementar variable
257:    ST        0,11(5)       for: guardar variable incrementada
258:    LDA       7,-49(7)      for: salto al inicio
* for: fin del bucle
219:    JGT       0,39(7)       for: saltar si variable > final
* <- for
* -> return
* -> identificador
259:    LD        0,14(5)       cargar id: val[total]
* <- identificador
260:    LD        1,0(6)        return: recuperar direccion de retorno
261:    LDA       7,0(1)        return: salto a direccion de retorno
* <- return
* <- programa
* Fin de la ejecucion.
262:    HALT      0,0,0
