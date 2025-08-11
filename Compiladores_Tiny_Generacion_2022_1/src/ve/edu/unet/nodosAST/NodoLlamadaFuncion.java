package ve.edu.unet.nodosAST;

public class NodoLlamadaFuncion extends NodoBase {
    private String nombreFuncion;
    private NodoBase argumentos;

    public NodoLlamadaFuncion(String nombreFuncion, NodoBase argumentos) {
        super();
        this.nombreFuncion = nombreFuncion;
        this.argumentos = argumentos;
    }

    public NodoLlamadaFuncion(String nombreFuncion) {
        super();
        this.nombreFuncion = nombreFuncion;
        this.argumentos = null;
    }

    public String getNombreFuncion() {
        return nombreFuncion;
    }

    public void setNombreFuncion(String nombreFuncion) {
        this.nombreFuncion = nombreFuncion;
    }

    public NodoBase getArgumentos() {
        return argumentos;
    }

    public void setArgumentos(NodoBase argumentos) {
        this.argumentos = argumentos;
    }
}