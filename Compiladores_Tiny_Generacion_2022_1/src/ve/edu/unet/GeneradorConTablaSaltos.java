package ve.edu.unet;

import ve.edu.unet.nodosAST.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;

public class GeneradorConTablaSaltos {
    // Variables existentes
    private static int desplazamientoTmp = 0;
    private static TablaSimbolos tablaSimbolos = null;
    private static int contadorEtiquetas = 0;
    private static java.util.Stack<Integer> pilaBreak = new java.util.Stack<Integer>();
    private static java.util.Stack<Integer> pilaContinue = new java.util.Stack<Integer>();

    // Variables para manejo de funciones con tabla de saltos
    private static final Map<String, NodoFuncion> funcionesRegistradas = new HashMap<>();
    private static final Map<String, Integer> inicioFuncion = new HashMap<>();
    private static final Set<String> funcionesEmitidas = new HashSet<>();
    
    // Nueva: Lista de saltos pendientes a resolver
    private static final List<SaltoPendiente> saltosPendientes = new ArrayList<>();
    
    // Clase interna para representar un salto pendiente
    static class SaltoPendiente {
        int direccion;      // Dirección donde está la instrucción de salto
        String funcion;     // Nombre de la función a la que debe saltar
        
        SaltoPendiente(int dir, String func) {
            this.direccion = dir;
            this.funcion = func;
        }
    }
    
    public static void setTablaSimbolos(TablaSimbolos tabla){
        tablaSimbolos = tabla;
    }
    
    public static void generarCodigoObjeto(NodoBase raiz){
        System.out.println();
        System.out.println();
        System.out.println("------ CODIGO OBJETO (CON TABLA DE SALTOS) ------");
        System.out.println();
        System.out.println();
        
        // Limpiar estructuras por si se usa múltiples veces
        saltosPendientes.clear();
        funcionesRegistradas.clear();
        inicioFuncion.clear();
        funcionesEmitidas.clear();
        
        generarPreludioEstandar();
        generar(raiz);
        
        // Resolver todos los saltos pendientes
        resolverSaltosPendientes();
        
        UtGen.emitirComentario("Fin de la ejecucion.");
        UtGen.emitirRO("HALT", 0, 0, 0, "");
        System.out.println();
        System.out.println();
        System.out.println("------ FIN DEL CODIGO OBJETO ------");
    }
    
    private static void generarPreludioEstandar(){
        UtGen.emitirComentario("Compilacion TINY para la TM");
        UtGen.emitirComentario("Preludio estandar:");
        UtGen.emitirRM("LD", UtGen.MP, 0, UtGen.AC, "cargar la maxima direccion desde la localidad 0");
        UtGen.emitirRM("ST", UtGen.AC, 0, UtGen.AC, "limpio el registro de la localidad 0");
    }
    
    private static void generar(NodoBase nodo){
        if(tablaSimbolos!=null){
            if (nodo instanceof NodoPrograma){
                generarPrograma(nodo);
            }else if (nodo instanceof NodoFuncion){
                generarFuncion((NodoFuncion) nodo);
            }else if (nodo instanceof NodoLlamadaFuncion){
                generarLlamadaFuncion(nodo);
            }
            // ... resto de los casos igual que el original
            
            if(nodo.TieneHermano())
                generar(nodo.getHermanoDerecha());
        }
    }
    
    private static void generarPrograma(NodoBase nodo){
        NodoPrograma n = (NodoPrograma)nodo;
        if(UtGen.debug) UtGen.emitirComentario("-> programa");
        
        // Generar todo secuencialmente
        if(n.getGlobal_block() != null){
            generar(n.getGlobal_block());
        }
        
        if(n.getFunction_block() != null){
            generar(n.getFunction_block());
        }
        
        if(n.getMain() != null){
            generar(n.getMain());
        }
        
        if(UtGen.debug) UtGen.emitirComentario("<- programa");
    }
    
    private static void generarFuncion(NodoFuncion n) {
        String nombreFuncion = n.getNombre();
        if(UtGen.debug) UtGen.emitirComentario("-> funcion " + nombreFuncion);
        
        // Registrar la función
        funcionesRegistradas.put(nombreFuncion, n);
        
        // Marcar el inicio de la función
        int direccionInicio = UtGen.emitSkip(0);
        inicioFuncion.put(nombreFuncion, direccionInicio);
        
        // Generar código de la función
        UtGen.emitirComentario("=== INICIO FUNCION " + nombreFuncion + " ===");
        
        // Procesar parámetros y cuerpo
        if(n.getCuerpo() != null){
            generar(n.getCuerpo());
        }
        
        // Return implícito si no hay return explícito
        UtGen.emitirRM("LDA", UtGen.PC, 0, 7, "return implicito");
        
        UtGen.emitirComentario("=== FIN FUNCION " + nombreFuncion + " ===");
        funcionesEmitidas.add(nombreFuncion);
        
        if(UtGen.debug) UtGen.emitirComentario("<- funcion " + nombreFuncion);
    }
    
    private static void generarLlamadaFuncion(NodoBase nodo){
        NodoLlamadaFuncion n = (NodoLlamadaFuncion)nodo;
        String nombreFuncion = n.getNombreFuncion();
        if(UtGen.debug) UtGen.emitirComentario("-> llamada funcion: " + nombreFuncion);
        
        // Procesar argumentos (simplificado)
        if(n.getArgumentos() != null){
            generar(n.getArgumentos());
        }
        
        // Guardar dirección de retorno
        UtGen.emitirRM("LDA", UtGen.AC1, 3, UtGen.PC, "guardar direccion de retorno");
        UtGen.emitirRM("ST", UtGen.AC1, desplazamientoTmp, UtGen.MP, "push return addr");
        desplazamientoTmp--;
        
        // Salto a la función
        if(inicioFuncion.containsKey(nombreFuncion)){
            // La función ya fue generada, podemos saltar directamente
            int direccion = inicioFuncion.get(nombreFuncion);
            UtGen.emitirRM_Abs("LDA", UtGen.PC, direccion, "salto a funcion " + nombreFuncion);
        } else {
            // La función aún no ha sido generada, crear salto pendiente
            int direccionActual = UtGen.emitSkip(0);
            saltosPendientes.add(new SaltoPendiente(direccionActual, nombreFuncion));
            // Emitir instrucción temporal que será reemplazada
            UtGen.emitirRM("LDA", UtGen.PC, 0, UtGen.PC, "PENDIENTE: salto a " + nombreFuncion);
        }
        
        // Después del retorno
        desplazamientoTmp++;
        
        if(UtGen.debug) UtGen.emitirComentario("<- llamada funcion: " + nombreFuncion);
    }
    
    // Resolver todos los saltos pendientes
    private static void resolverSaltosPendientes() {
        if(saltosPendientes.isEmpty()) return;
        
        UtGen.emitirComentario("=== RESOLVIENDO SALTOS PENDIENTES ===");
        
        for(SaltoPendiente salto : saltosPendientes) {
            String funcion = salto.funcion;
            int direccionSalto = salto.direccion;
            
            if(inicioFuncion.containsKey(funcion)) {
                int direccionFuncion = inicioFuncion.get(funcion);
                // Retroceder y corregir la instrucción de salto
                UtGen.emitBackup(direccionSalto);
                UtGen.emitirRM_Abs("LDA", UtGen.PC, direccionFuncion, 
                    "salto corregido a funcion " + funcion);
                UtGen.emitRestore();
            } else {
                System.err.println("ERROR: Funcion no encontrada: " + funcion);
            }
        }
        
        UtGen.emitirComentario("=== FIN RESOLUCION DE SALTOS ===");
    }
}