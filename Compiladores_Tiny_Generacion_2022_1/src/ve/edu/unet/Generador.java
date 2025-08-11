package ve.edu.unet;

import ve.edu.unet.nodosAST.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Generador {
	/* Ilustracion de la disposicion de la memoria en
	 * este ambiente de ejecucion para el lenguaje Tiny
	 *
	 * |t1	|<- mp (Maxima posicion de memoria de la TM
	 * |t1	|<- desplazamientoTmp (tope actual)
	 * |free|
	 * |free|
	 * |...	|
	 * |x	|
	 * |y	|<- gp
	 * 
	 * */
	
	
	
	/* desplazamientoTmp es una variable inicializada en 0
	 * y empleada como el desplazamiento de la siguiente localidad
	 * temporal disponible desde la parte superior o tope de la memoria
	 * (la que apunta el registro MP).
	 * 
	 * - Se decrementa (desplazamientoTmp--) despues de cada almacenamiento y
	 * 
	 * - Se incrementa (desplazamientoTmp++) despues de cada eliminacion/carga en 
	 *   otra variable de un valor de la pila.
	 * 
	 * Pudiendose ver como el apuntador hacia el tope de la pila temporal
	 * y las llamadas a la funcion emitirRM corresponden a una inserccion 
	 * y extraccion de esta pila
	 */
	private static int desplazamientoTmp = 0;
	private static TablaSimbolos tablaSimbolos = null;
	
	// Variables para manejo de funciones
	private static int contadorEtiquetas = 0;
	private static java.util.Stack<Integer> pilaBreak = new java.util.Stack<Integer>();
	private static java.util.Stack<Integer> pilaContinue = new java.util.Stack<Integer>();

    // Compilación diferida de funciones
    private static final Map<String, NodoFuncion> funcionesRegistradas = new HashMap<>();
    private static final Map<String, Integer> inicioFuncion = new HashMap<>();
    private static final Set<String> funcionesEmitidas = new HashSet<>();
	
	public static void setTablaSimbolos(TablaSimbolos tabla){
		tablaSimbolos = tabla;
	}
	
	public static void generarCodigoObjeto(NodoBase raiz){
		System.out.println();
		System.out.println();
		System.out.println("------ CODIGO OBJETO DEL LENGUAJE TINY GENERADO PARA LA TM ------");
		System.out.println();
		System.out.println();
		generarPreludioEstandar();
		generar(raiz);
		/*Genero el codigo de finalizacion de ejecucion del codigo*/   
		UtGen.emitirComentario("Fin de la ejecucion.");
		UtGen.emitirRO("HALT", 0, 0, 0, "");
		System.out.println();
		System.out.println();
		System.out.println("------ FIN DEL CODIGO OBJETO DEL LENGUAJE TINY GENERADO PARA LA TM ------");
	}
	
	// Método sobrecargado para generar código a archivo .tm
	public static void generarCodigoObjetoAArchivo(NodoBase raiz, String nombreArchivo) throws IOException {
		try {
			// Inicializar salida a archivo
			UtGen.inicializarArchivoSalida(nombreArchivo);
			
			System.out.println("Generando código objeto en archivo: " + nombreArchivo);
			
			// Generar código objeto
			generarPreludioEstandar();
			generar(raiz);
			/*Genero el codigo de finalizacion de ejecucion del codigo*/   
			UtGen.emitirComentario("Fin de la ejecucion.");
			UtGen.emitirRO("HALT", 0, 0, 0, "");
			
			System.out.println("Archivo " + nombreArchivo + " generado exitosamente.");
		} finally {
			// Asegurar que el archivo se cierre
			UtGen.cerrarArchivoSalida();
		}
	}
	
	//Funcion principal de generacion de codigo
	//prerequisito: Fijar la tabla de simbolos antes de generar el codigo objeto 
	private static void generar(NodoBase nodo){
		if(tablaSimbolos!=null){
			if (nodo instanceof NodoPrograma){
				generarPrograma(nodo);
			}else if (nodo instanceof NodoDeclaracion){
				generarDeclaracion(nodo);
			}else if (nodo instanceof NodoFuncion){
				registrarFuncion((NodoFuncion) nodo);
			}else if (nodo instanceof NodoIf){
				generarIf(nodo);
			}else if (nodo instanceof NodoRepeat){
				generarRepeat(nodo);
			}else if (nodo instanceof NodoFor){
				generarFor(nodo);
			}else if (nodo instanceof NodoAsignacion){
				generarAsignacion(nodo);
			}else if (nodo instanceof NodoLeer){
				generarLeer(nodo);
			}else if (nodo instanceof NodoEscribir){
				generarEscribir(nodo);
			}else if (nodo instanceof NodoLlamadaFuncion){
				generarLlamadaFuncion(nodo);
			}else if (nodo instanceof NodoReturn){
				generarReturn(nodo);
			}else if (nodo instanceof NodoBreak){
				generarBreak(nodo);
			}else if (nodo instanceof NodoContinue){
				generarContinue(nodo);
			}else if (nodo instanceof NodoValor){
				generarValor(nodo);
			}else if (nodo instanceof NodoString){
				generarString(nodo);
			}else if (nodo instanceof NodoIdentificador){
				generarIdentificador(nodo);
			}else if (nodo instanceof NodoOperacion){
				generarOperacion(nodo);
			}else{
				System.out.println("BUG: Tipo de nodo a generar desconocido: " + nodo.getClass().getSimpleName());
			}
			/*Si el hijo de extrema izquierda tiene hermano a la derecha lo genero tambien*/
			if(nodo.TieneHermano())
				generar(nodo.getHermanoDerecha());
		}else
			System.out.println("ERROR: por favor fije la tabla de simbolos a usar antes de generar codigo objeto!!!");
	}

	private static void generarPrograma(NodoBase nodo){
		NodoPrograma n = (NodoPrograma)nodo;
		if(UtGen.debug) UtGen.emitirComentario("-> programa");
		
		// Generar declaraciones globales
		if(n.getGlobal_block() != null){
			generar(n.getGlobal_block());
		}
		
		// Registrar funciones (sin generar su cuerpo)
		if(n.getFunction_block() != null){
			generar(n.getFunction_block());
		}
		
		// Generar programa principal
		if(n.getMain() != null){
			generar(n.getMain());
		}
		
		if(UtGen.debug) UtGen.emitirComentario("<- programa");
	}

	private static void generarDeclaracion(NodoBase nodo){
		NodoDeclaracion n = (NodoDeclaracion)nodo;
		if(UtGen.debug) UtGen.emitirComentario("-> declaracion: " + n.getNombreVariable());
		
		// Obtener la dirección asignada por la tabla de símbolos
		int direccion = tablaSimbolos.getDireccion(n.getNombreVariable());
		
		if(n.isEsArray()){
			// Declaración de array
			UtGen.emitirComentario("Declaracion de array: " + n.getNombreVariable() + 
							  (n.getTamaño() != null ? " tamaño definido" : " tamaño por parámetro"));
			
			if(n.getTamaño() != null && n.isEsGlobal()){
				// Array global con tamaño definido - reservar espacio
				generar(n.getTamaño());  // Evaluar el tamaño
				int tamaño = ((NodoValor)n.getTamaño()).getValorEntero(); // Obtener valor constante
				
				// Inicializar elementos del array a cero
				for(int i = 0; i < tamaño; i++){
					UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "array: inicializar elemento " + i + " a cero");
					UtGen.emitirRM("ST", UtGen.AC, direccion + i, UtGen.GP, "array: almacenar en posicion " + (direccion + i));
				}
			}
		} else {
			// Declaración de variable simple
			UtGen.emitirComentario("Declaracion de variable: " + n.getNombreVariable() + 
							  (n.isEsGlobal() ? " (global)" : " (local)"));
			
			if(n.isEsGlobal()){
				// Variable global - inicializar a cero
				UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "global: inicializar variable " + n.getNombreVariable() + " a cero");
				UtGen.emitirRM("ST", UtGen.AC, direccion, UtGen.GP, "global: almacenar en direccion " + direccion);
			} else {
				// Variable local - reservar espacio en el frame actual
				UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "local: inicializar variable " + n.getNombreVariable() + " a cero");
				UtGen.emitirRM("ST", UtGen.AC, direccion, UtGen.GP, "local: almacenar en direccion " + direccion);
				// Nota: En una implementación más sofisticada, las variables locales 
				// deberían usar un frame pointer diferente del GP
			}
		}
		
		if(UtGen.debug) UtGen.emitirComentario("<- declaracion");
	}

    // Emite el cuerpo de una función (una sola vez) y registra su inicio
    private static void emitirFuncionSiNecesaria(String nombreFuncion) {
        if (funcionesEmitidas.contains(nombreFuncion)) {
            return;
        }
        NodoFuncion n = funcionesRegistradas.get(nombreFuncion);
        if (n == null) {
            UtGen.emitirComentario("ERROR: llamada a funcion no definida: " + nombreFuncion);
            return;
        }

        int inicio = UtGen.emitirSalto(0); // dirección actual donde comenzará la función
        inicioFuncion.put(nombreFuncion, inicio);
        funcionesEmitidas.add(nombreFuncion);

        UtGen.emitirComentario("=== INICIO FUNCION " + n.getNombre() + " ===");

        // Procesamiento de parámetros: pendiente (los argumentos ya se apilaron en la llamada)

        // Generar cuerpo de la función
        if (n.getCuerpo() != null) {
            generar(n.getCuerpo());
        }

        // Return implícito: recuperar dirección de retorno de la pila y saltar
        UtGen.emitirComentario("Return implicito de funcion");
        UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "funcion: recuperar direccion de retorno");
        UtGen.emitirRM("LD", UtGen.PC, 0, UtGen.AC1, "funcion: retorno");

        UtGen.emitirComentario("=== FIN FUNCION " + n.getNombre() + " ===");
    }

    // Registrar función en la primera pasada (sin generar código)
    private static void registrarFuncion(NodoFuncion funcion) {
        if (funcion.getNombre() == null) {
            UtGen.emitirComentario("ADVERTENCIA: funcion sin nombre");
            return;
        }
        funcionesRegistradas.put(funcion.getNombre(), funcion);
        UtGen.emitirComentario("registrada funcion: " + funcion.getNombre());
    }

	private static void generarFor(NodoBase nodo){
		NodoFor n = (NodoFor)nodo;
		if(UtGen.debug) UtGen.emitirComentario("-> for");
		
		// Etiquetas para control de flujo
		int etiquetaInicio = contadorEtiquetas++;
		int etiquetaFin = contadorEtiquetas++;
		int etiquetaContinue = contadorEtiquetas++;
		
		// Agregar etiquetas a las pilas para break y continue
		pilaBreak.push(etiquetaFin);
		pilaContinue.push(etiquetaContinue);
		
		// Inicialización de la variable de control
		generar(n.getValorInicial());
		int direccionVar = tablaSimbolos.getDireccion(n.getVariable());
		UtGen.emitirRM("ST", UtGen.AC, direccionVar, UtGen.GP, "for: inicializar variable " + n.getVariable());
		
		// Etiqueta de inicio del bucle
		int localidadInicio = UtGen.emitirSalto(0);
		UtGen.emitirComentario("for: inicio del bucle");
		
		// Verificar condición (variable <= valor_final)
		UtGen.emitirRM("LD", UtGen.AC, direccionVar, UtGen.GP, "for: cargar variable de control");
		UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "for: guardar variable en pila temp");
		
		generar(n.getValorFinal());
		UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "for: cargar variable de pila temp");
		
		// Comparación: si variable > valor_final, saltar al final
		UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "for: variable - valor_final");
		int localidadSaltoFin = UtGen.emitirSalto(1);
		UtGen.emitirComentario("for: salto condicional al final");
		
		// Cuerpo del bucle
		generar(n.getCuerpo());
		
		// Etiqueta para continue
		int localidadContinue = UtGen.emitirSalto(0);
		UtGen.emitirComentario("for: punto de continue");
		
		// Incremento de la variable
		UtGen.emitirRM("LD", UtGen.AC, direccionVar, UtGen.GP, "for: cargar variable para incremento");
		UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "for: guardar variable en pila temp");
		
		generar(n.getIncremento());
		UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "for: cargar variable de pila temp");
		UtGen.emitirRO("ADD", UtGen.AC, UtGen.AC1, UtGen.AC, "for: incrementar variable");
		UtGen.emitirRM("ST", UtGen.AC, direccionVar, UtGen.GP, "for: guardar variable incrementada");
		
		// Salto al inicio del bucle
		UtGen.emitirRM_Abs("LDA", UtGen.PC, localidadInicio, "for: salto al inicio");
		
		// Etiqueta de fin del bucle
		int localidadFin = UtGen.emitirSalto(0);
		UtGen.emitirComentario("for: fin del bucle");
		
		// Completar salto condicional
		UtGen.cargarRespaldo(localidadSaltoFin);
		UtGen.emitirRM_Abs("JGT", UtGen.AC, localidadFin, "for: saltar si variable > final");
		UtGen.restaurarRespaldo();
		
		// Remover etiquetas de las pilas
		pilaBreak.pop();
		pilaContinue.pop();
		
		if(UtGen.debug) UtGen.emitirComentario("<- for");
	}

	private static void generarLlamadaFuncion(NodoBase nodo){
		NodoLlamadaFuncion n = (NodoLlamadaFuncion)nodo;
		if(UtGen.debug) UtGen.emitirComentario("-> llamada funcion: " + n.getNombreFuncion());
		
		// 1) Procesar argumentos si existen (se apilan primero)
		int numArgs = 0;
		NodoFuncion defFuncion = funcionesRegistradas.get(n.getNombreFuncion());
		java.util.List<NodoDeclaracion> paramsOrden = new java.util.ArrayList<>();
		if (defFuncion != null && defFuncion.getParametros() != null) {
			NodoBase p = defFuncion.getParametros();
			while (p != null) {
				if (p instanceof NodoDeclaracion) paramsOrden.add((NodoDeclaracion)p);
				p = p.getHermanoDerecha();
			}
		}
		if(n.getArgumentos() != null){
			UtGen.emitirComentario("Procesando argumentos de la llamada");
			NodoBase arg = n.getArgumentos();
			int idx = 0;
			while(arg != null){
				// Si el parametro esperado es array, pasar la base (direccion) del array
				boolean pasarBaseArray = false;
				if (idx < paramsOrden.size()) {
					NodoDeclaracion pd = paramsOrden.get(idx);
					pasarBaseArray = pd.isEsArray();
				}
				if (pasarBaseArray && arg instanceof NodoIdentificador) {
					String nombreArg = ((NodoIdentificador)arg).getNombre();
					int base = tablaSimbolos.getDireccion(nombreArg);
					UtGen.emitirRM("LDC", UtGen.AC, base, 0, "call: base addr de array " + nombreArg);
				} else {
					generar(arg);
				}
				UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "call: guardar argumento");
				numArgs++;
				idx++;
				arg = arg.getHermanoDerecha();
			}
		}

		// 2) Calcular y apilar direccion de retorno: AC = PC + 3; push(AC)
		// i: LDA AC,(PC+3); i+1: ST AC,...; i+2: LDA PC,func -> retornar a i+3
		UtGen.emitirRM("LDA", UtGen.AC, 3, UtGen.PC, "call: calcular return addr (PC+3)");
		UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "call: push return addr");
		
		// Compilación diferida: emitir la función al final del código la primera vez que se use
		Integer inicio = inicioFuncion.get(n.getNombreFuncion());
		if (inicio == null) {
			// Guardar posicion actual (sitio de llamada) dejando UN hueco para la instruccion de salto
			int posLlamada = UtGen.emitirSalto(1);
			// Ir al final del código emitido hasta ahora
			UtGen.restaurarRespaldo();
			// Registrar inicio de la funcion
			inicio = UtGen.emitirSalto(0);
			inicioFuncion.put(n.getNombreFuncion(), inicio);
			funcionesEmitidas.add(n.getNombreFuncion());
			
			// Emitir prólogo de función: copiar argumentos a parámetros y fijar RA en 0(MP)
			if (defFuncion != null && !paramsOrden.isEmpty()) {
				// Mover direccion de retorno a 0(MP)
				UtGen.emitirRM("LD", UtGen.AC1, -numArgs, UtGen.MP, "prologo: cargar RA de -(numArgs)(MP)");
				UtGen.emitirRM("ST", UtGen.AC1, 0, UtGen.MP, "prologo: colocar RA en 0(MP)");
				// Copiar cada argumento a su slot en GP
				for (int i = 0; i < paramsOrden.size(); i++) {
					NodoDeclaracion pd = paramsOrden.get(i);
					int dirParam = tablaSimbolos.getDireccion(pd.getNombreVariable());
					int off = -i; // primer arg en 0(MP), segundo en -1(MP), etc.
					UtGen.emitirRM("LD", UtGen.AC, off, UtGen.MP, "prologo: cargar arg " + pd.getNombreVariable());
					UtGen.emitirRM("ST", UtGen.AC, dirParam, UtGen.GP, "prologo: guardar param " + pd.getNombreVariable());
				}
			}
			// Emitir cuerpo de la función
			NodoFuncion def = funcionesRegistradas.get(n.getNombreFuncion());
			if (def == null) {
				UtGen.emitirComentario("ERROR: llamada a funcion no definida: " + n.getNombreFuncion());
			} else {
				UtGen.emitirComentario("=== INICIO FUNCION " + def.getNombre() + " ===");
				if (def.getCuerpo() != null) {
					generar(def.getCuerpo());
				}
				UtGen.emitirComentario("Return implicito de funcion");
				UtGen.emitirRM("LD", UtGen.AC1, 0, UtGen.MP, "funcion: recuperar direccion de retorno");
				UtGen.emitirRM("LDA", UtGen.PC, 0, UtGen.AC1, "funcion: retorno");
				UtGen.emitirComentario("=== FIN FUNCION " + def.getNombre() + " ===");
			}
			// Volver al sitio de llamada y emitir el salto a la función
			UtGen.cargarRespaldo(posLlamada);
			UtGen.emitirRM_Abs("LDA", UtGen.PC, inicio, "call: salto a funcion " + n.getNombreFuncion());
			// Restaurar emision al final para continuar generando el resto del programa
			UtGen.restaurarRespaldo();
		} else {
			// Ya fue emitida antes: emitir solo el salto
			UtGen.emitirRM_Abs("LDA", UtGen.PC, inicio, "call: salto a funcion " + n.getNombreFuncion());
		}
		
		// 3) Restaurar desplazamiento temporal (limpiar argumentos en el generador)
		desplazamientoTmp += numArgs;
		
		if(UtGen.debug) UtGen.emitirComentario("<- llamada funcion");
	}

	private static void generarReturn(NodoBase nodo){
		NodoReturn n = (NodoReturn)nodo;
		if(UtGen.debug) UtGen.emitirComentario("-> return");
		
		// Evaluar expresión de retorno
		if(n.getExpresion() != null){
			generar(n.getExpresion());
		}
		
		// Recuperar direccion de retorno y saltar
		UtGen.emitirRM("LD", UtGen.AC1, 0, UtGen.MP, "return: recuperar direccion de retorno");
		UtGen.emitirRM("LDA", UtGen.PC, 0, UtGen.AC1, "return: salto a direccion de retorno");
		
		if(UtGen.debug) UtGen.emitirComentario("<- return");
	}

	private static void generarBreak(NodoBase nodo){
		if(UtGen.debug) UtGen.emitirComentario("-> break");
		
		if(!pilaBreak.isEmpty()){
			int etiquetaSalida = pilaBreak.peek();
			UtGen.emitirComentario("break: salto al final del bucle");
			// El salto se resolverá cuando se complete el bucle
		} else {
			UtGen.emitirComentario("ERROR: break fuera de bucle");
		}
		
		if(UtGen.debug) UtGen.emitirComentario("<- break");
	}

	private static void generarContinue(NodoBase nodo){
		if(UtGen.debug) UtGen.emitirComentario("-> continue");
		
		if(!pilaContinue.isEmpty()){
			int etiquetaContinue = pilaContinue.peek();
			UtGen.emitirComentario("continue: salto al incremento del bucle");
			// El salto se resolverá cuando se complete el bucle
		} else {
			UtGen.emitirComentario("ERROR: continue fuera de bucle");
		}
		
		if(UtGen.debug) UtGen.emitirComentario("<- continue");
	}

	private static void generarString(NodoBase nodo){
		NodoString n = (NodoString)nodo;
		if(UtGen.debug) UtGen.emitirComentario("-> string");
		
		// Para strings, emitimos cada carácter
		String texto = n.getValor().replace("\"", ""); // Remover comillas
		UtGen.emitirComentario("String: " + n.getValor());
		
		for(int i = 0; i < texto.length(); i++){
			UtGen.emitirRM("LDC", UtGen.AC, (int)texto.charAt(i), 0, "string: cargar caracter '" + texto.charAt(i) + "'");
			UtGen.emitirRO("OUT", UtGen.AC, 0, 0, "string: escribir caracter");
		}
		
		if(UtGen.debug) UtGen.emitirComentario("<- string");
	}

	private static void generarIf(NodoBase nodo){
    	NodoIf n = (NodoIf)nodo;
		int localidadSaltoElse,localidadSaltoEnd,localidadActual;
		if(UtGen.debug)	UtGen.emitirComentario("-> if");
		/*Genero el codigo para la parte de prueba del IF*/
		generar(n.getPrueba());
		localidadSaltoElse = UtGen.emitirSalto(1);
		UtGen.emitirComentario("If: el salto hacia el else debe estar aqui");
		/*Genero la parte THEN*/
		generar(n.getParteThen());
		localidadSaltoEnd = UtGen.emitirSalto(1);
		UtGen.emitirComentario("If: el salto hacia el final debe estar aqui");
		localidadActual = UtGen.emitirSalto(0);
		UtGen.cargarRespaldo(localidadSaltoElse);
		UtGen.emitirRM_Abs("JEQ", UtGen.AC, localidadActual, "if: jmp hacia else");
		UtGen.restaurarRespaldo();
		/*Genero la parte ELSE*/
		if(n.getParteElse()!=null){
			generar(n.getParteElse());
			localidadActual = UtGen.emitirSalto(0);
			UtGen.cargarRespaldo(localidadSaltoEnd);
			UtGen.emitirRM_Abs("LDA", UtGen.PC, localidadActual, "if: jmp hacia el final");
			UtGen.restaurarRespaldo();
    	}
		
		if(UtGen.debug)	UtGen.emitirComentario("<- if");
	}
	
	private static void generarRepeat(NodoBase nodo){
    	NodoRepeat n = (NodoRepeat)nodo;
		int localidadSaltoInicio;
		if(UtGen.debug)	UtGen.emitirComentario("-> repeat");
			localidadSaltoInicio = UtGen.emitirSalto(0);
			UtGen.emitirComentario("repeat: el salto hacia el final (luego del cuerpo) del repeat debe estar aqui");
			/* Genero el cuerpo del repeat */
			generar(n.getCuerpo());
			/* Genero el codigo de la prueba del repeat */
			generar(n.getPrueba());
			UtGen.emitirRM_Abs("JEQ", UtGen.AC, localidadSaltoInicio, "repeat: jmp hacia el inicio del cuerpo");
		if(UtGen.debug)	UtGen.emitirComentario("<- repeat");
	}		
	
	private static void generarAsignacion(NodoBase nodo){
		NodoAsignacion n = (NodoAsignacion)nodo;
		int direccion;
		if(UtGen.debug)	UtGen.emitirComentario("-> asignacion");		
		
		/* Genero el codigo para la expresion a la derecha de la asignacion */
		generar(n.getExpresion());
		
		if(n.esAsignacionArray()){
			// Asignación a array: arr[indice] = valor
			UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "asignacion array: guardar valor");
			
			// Calcular dirección del array
			generar(n.getIndice());
			direccion = tablaSimbolos.getDireccion(n.getIdentificador());
			UtGen.emitirRM("LDC", UtGen.AC1, direccion, 0, "asignacion array: cargar direccion base");
			UtGen.emitirRO("ADD", UtGen.AC, UtGen.AC, UtGen.AC1, "asignacion array: calcular direccion");
			
			// Cargar valor y almacenar en la dirección calculada
			UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "asignacion array: recuperar valor");
			UtGen.emitirRM("ST", UtGen.AC1, 0, UtGen.AC, "asignacion array: almacenar en posicion calculada");
		} else {
			// Asignación normal: var = valor
			direccion = tablaSimbolos.getDireccion(n.getIdentificador());
			UtGen.emitirRM("ST", UtGen.AC, direccion, UtGen.GP, "asignacion: almaceno el valor para el id "+n.getIdentificador());
		}
		
		if(UtGen.debug)	UtGen.emitirComentario("<- asignacion");
	}
	
	private static void generarLeer(NodoBase nodo){
		NodoLeer n = (NodoLeer)nodo;
		int direccion;
		if(UtGen.debug)	UtGen.emitirComentario("-> leer");
		UtGen.emitirRO("IN", UtGen.AC, 0, 0, "leer: lee un valor entero ");
		direccion = tablaSimbolos.getDireccion(n.getIdentificador());
		UtGen.emitirRM("ST", UtGen.AC, direccion, UtGen.GP, "leer: almaceno el valor entero leido en el id "+n.getIdentificador());
		if(UtGen.debug)	UtGen.emitirComentario("<- leer");
	}
	
	private static void generarEscribir(NodoBase nodo){
		NodoEscribir n = (NodoEscribir)nodo;
		if(UtGen.debug)	UtGen.emitirComentario("-> escribir");
		/* Genero el codigo de la expresion que va a ser escrita en pantalla */
		generar(n.getExpresion());
		/* Ahora genero la salida */
		UtGen.emitirRO("OUT", UtGen.AC, 0, 0, "escribir: genero la salida de la expresion");
		if(UtGen.debug)	UtGen.emitirComentario("<- escribir");
	}
	
	private static void generarValor(NodoBase nodo){
    	NodoValor n = (NodoValor)nodo;
    	if(UtGen.debug)	UtGen.emitirComentario("-> constante");
    	if (n.esReal()) {
    		UtGen.emitirRM("LDC", UtGen.AC, n.getValorReal().intValue(), 0, "cargar constante: "+n.getValor());
    	} else {
    		UtGen.emitirRM("LDC", UtGen.AC, n.getValorEntero(), 0, "cargar constante: "+n.getValor());
    	}
    	if(UtGen.debug)	UtGen.emitirComentario("<- constante");
	}
	
	private static void generarIdentificador(NodoBase nodo){
		NodoIdentificador n = (NodoIdentificador)nodo;
		int direccion;
		if(UtGen.debug)	UtGen.emitirComentario("-> identificador");
		
		if(n.getDesplazamiento() != null){
			// Acceso a array: arr[indice]
			generar(n.getDesplazamiento());
			direccion = tablaSimbolos.getDireccion(n.getNombre());
			UtGen.emitirRM("LDC", UtGen.AC1, direccion, 0, "identificador array: cargar direccion base");
			UtGen.emitirRO("ADD", UtGen.AC, UtGen.AC, UtGen.AC1, "identificador array: calcular direccion");
		} else {
			// Acceso normal a variable
			direccion = tablaSimbolos.getDireccion(n.getNombre());
			UtGen.emitirRM("LD", UtGen.AC, direccion, UtGen.GP, "cargar id: val["+n.getNombre()+"]");
		}
		
		if(UtGen.debug)	UtGen.emitirComentario("<- identificador");
	}
	
	private static void generarOperacion(NodoBase nodo){
		NodoOperacion n = (NodoOperacion) nodo;
		if(UtGen.debug)	UtGen.emitirComentario("-> Operacion: " + n.getOperacion());
		
		// Manejar operador NOT (unario)
		if(n.getOperacion() == tipoOp.not){
			generar(n.getOpDerecho());
			UtGen.emitirRM("JEQ", UtGen.AC, 2, UtGen.PC, "not: saltar si es cero (falso)");
			UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "not: resultado falso");
			UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "not: saltar carga de verdadero");
			UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "not: resultado verdadero");
			if(UtGen.debug)	UtGen.emitirComentario("<- Operacion: " + n.getOperacion());
			return;
		}
		
		/* Genero la expresion izquierda de la operacion */
		if(n.getOpIzquierdo() != null){
			generar(n.getOpIzquierdo());
			/* Almaceno en la pseudo pila de valor temporales el valor de la operacion izquierda */
			UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "op: push en la pila tmp el resultado expresion izquierda");
		}
		
		/* Genero la expresion derecha de la operacion */
		generar(n.getOpDerecho());
		
		/* Ahora cargo/saco de la pila el valor izquierdo */
		if(n.getOpIzquierdo() != null){
			UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "op: pop o cargo de la pila el valor izquierdo en AC1");
		}
		
		switch(n.getOperacion()){
			case	mas:	UtGen.emitirRO("ADD", UtGen.AC, UtGen.AC1, UtGen.AC, "op: +");		
							break;
			case	menos:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: -");
							break;
			case	por:	UtGen.emitirRO("MUL", UtGen.AC, UtGen.AC1, UtGen.AC, "op: *");
							break;
			case	entre:	UtGen.emitirRO("DIV", UtGen.AC, UtGen.AC1, UtGen.AC, "op: /");
							break;
			case	modulo:	// a % b = a - (a/b)*b
							UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "mod: guardar b");
							UtGen.emitirRM("ST", UtGen.AC1, desplazamientoTmp--, UtGen.MP, "mod: guardar a");
							UtGen.emitirRO("DIV", UtGen.AC, UtGen.AC1, UtGen.AC, "mod: a/b");
							UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "mod: recuperar a");
							UtGen.emitirRM("LD", 2, ++desplazamientoTmp, UtGen.MP, "mod: recuperar b en r2");
							UtGen.emitirRO("MUL", UtGen.AC, UtGen.AC, 2, "mod: (a/b)*b");
							UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "mod: a - (a/b)*b");
							break;
			case	potencia: {
							// AC = exponente (derecha), AC1 = base (izquierda)
							UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "pow: guardar exp");
							UtGen.emitirRM("ST", UtGen.AC1, desplazamientoTmp--, UtGen.MP, "pow: guardar base");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "pow: inicializar resultado = 1");
							UtGen.emitirRM("ST", UtGen.AC, desplazamientoTmp--, UtGen.MP, "pow: guardar res");
							int posRes = desplazamientoTmp + 1;
							int posBase = desplazamientoTmp + 2;
							int posExp = desplazamientoTmp + 3;
							int loopStart = UtGen.emitirSalto(0);
							UtGen.emitirComentario("pow: inicio bucle");
							UtGen.emitirRM("LD", UtGen.AC, posExp, UtGen.MP, "pow: cargar exp");
							int jmpEnd = UtGen.emitirSalto(1);
							UtGen.emitirComentario("pow: salto condicional a fin (exp==0)");
							// res = res * base
							UtGen.emitirRM("LD", UtGen.AC, posRes, UtGen.MP, "pow: cargar res");
							UtGen.emitirRM("LD", UtGen.AC1, posBase, UtGen.MP, "pow: cargar base");
							UtGen.emitirRO("MUL", UtGen.AC, UtGen.AC1, UtGen.AC, "pow: res = res * base");
							UtGen.emitirRM("ST", UtGen.AC, posRes, UtGen.MP, "pow: guardar res");
							// exp = exp - 1
							UtGen.emitirRM("LD", UtGen.AC1, posExp, UtGen.MP, "pow: cargar exp en AC1");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "pow: cargar 1");
							UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "pow: exp - 1");
							UtGen.emitirRM("ST", UtGen.AC, posExp, UtGen.MP, "pow: guardar exp");
							UtGen.emitirRM_Abs("LDA", UtGen.PC, loopStart, "pow: repetir");
							int loopEnd = UtGen.emitirSalto(0);
							UtGen.cargarRespaldo(jmpEnd);
							UtGen.emitirRM_Abs("JEQ", UtGen.AC, loopEnd, "pow: salir si exp == 0");
							UtGen.restaurarRespaldo();
							// resultado final en AC
							UtGen.emitirRM("LD", UtGen.AC, posRes, UtGen.MP, "pow: cargar resultado");
							// limpiar pila temporal (res, base, exp)
							UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "pow: pop res");
							UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "pow: pop base");
							UtGen.emitirRM("LD", UtGen.AC1, ++desplazamientoTmp, UtGen.MP, "pow: pop exp");
							break;
						}
			case	menor:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: <");
							UtGen.emitirRM("JLT", UtGen.AC, 2, UtGen.PC, "voy dos instrucciones mas alla if verdadero (AC<0)");
							UtGen.emitirRM("LDC", UtGen.AC, 0, UtGen.AC, "caso de falso (AC=0)");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "Salto incodicional a direccion: PC+1 (es falso evito colocarlo verdadero)");
							UtGen.emitirRM("LDC", UtGen.AC, 1, UtGen.AC, "caso de verdadero (AC=1)");
							break;
			case	menorigual:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: <=");
							UtGen.emitirRM("JLE", UtGen.AC, 2, UtGen.PC, "saltar si AC<=0");
							UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "caso falso");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "saltar caso verdadero");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "caso verdadero");
							break;
			case	mayor:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: >");
							UtGen.emitirRM("JGT", UtGen.AC, 2, UtGen.PC, "saltar si AC>0");
							UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "caso falso");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "saltar caso verdadero");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "caso verdadero");
							break;
			case	mayorigual:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: >=");
							UtGen.emitirRM("JGE", UtGen.AC, 2, UtGen.PC, "saltar si AC>=0");
							UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "caso falso");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "saltar caso verdadero");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "caso verdadero");
							break;
			case	igual:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: ==");
							UtGen.emitirRM("JEQ", UtGen.AC, 2, UtGen.PC, "voy dos instrucciones mas alla if verdadero (AC==0)");
							UtGen.emitirRM("LDC", UtGen.AC, 0, UtGen.AC, "caso de falso (AC=0)");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "Salto incodicional a direccion: PC+1 (es falso evito colocarlo verdadero)");
							UtGen.emitirRM("LDC", UtGen.AC, 1, UtGen.AC, "caso de verdadero (AC=1)");
							break;
			case	diferente:	UtGen.emitirRO("SUB", UtGen.AC, UtGen.AC1, UtGen.AC, "op: !=");
							UtGen.emitirRM("JNE", UtGen.AC, 2, UtGen.PC, "saltar si AC!=0");
							UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "caso falso");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "saltar caso verdadero");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "caso verdadero");
							break;
			case	and:	// Evaluación de cortocircuito
							UtGen.emitirRM("JEQ", UtGen.AC1, 3, UtGen.PC, "and: si izquierdo es falso, resultado es falso");
							UtGen.emitirRM("JEQ", UtGen.AC, 2, UtGen.PC, "and: si derecho es falso, resultado es falso");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "and: ambos verdaderos");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "and: saltar caso falso");
							UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "and: resultado falso");
							break;
			case	or:		// Evaluación de cortocircuito
							UtGen.emitirRM("JNE", UtGen.AC1, 3, UtGen.PC, "or: si izquierdo es verdadero, resultado es verdadero");
							UtGen.emitirRM("JNE", UtGen.AC, 2, UtGen.PC, "or: si derecho es verdadero, resultado es verdadero");
							UtGen.emitirRM("LDC", UtGen.AC, 0, 0, "or: ambos falsos");
							UtGen.emitirRM("LDA", UtGen.PC, 1, UtGen.PC, "or: saltar caso verdadero");
							UtGen.emitirRM("LDC", UtGen.AC, 1, 0, "or: resultado verdadero");
							break;
			default:
							UtGen.emitirComentario("BUG: tipo de operacion desconocida: " + n.getOperacion());
		}
		if(UtGen.debug)	UtGen.emitirComentario("<- Operacion: " + n.getOperacion());
	}
	
	private static void generarPreludioEstandar(){
		UtGen.emitirComentario("* Compilacion TINY para la maquina TM");
		UtGen.emitirComentario("* Prefacio estandar");
		// Inicializar punteros
		UtGen.emitirRM("LDC", UtGen.GP, 0, 0, "init: GP = 0");
		UtGen.emitirRM("LDC", UtGen.MP, 1023, 0, "init: MP = 1023 (tope de memoria)");
		UtGen.emitirComentario("* Fin del prefacio estandar");
	}
}