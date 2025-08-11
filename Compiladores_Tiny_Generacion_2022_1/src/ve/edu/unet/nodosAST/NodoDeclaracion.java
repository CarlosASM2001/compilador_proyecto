package ve.edu.unet.nodosAST;

public class NodoDeclaracion extends NodoBase {
    private String nombreVariable;
    private String tipo;
    private NodoBase tamaño; // Para arrays
    private boolean esGlobal;
    private boolean esArray;

    public NodoDeclaracion(String nombreVariable, boolean esGlobal) {
        super();
        this.nombreVariable = nombreVariable;
        this.esGlobal = esGlobal;
        this.esArray = false;
        this.tipo = "int";
        this.tamaño = null;
    }

    public NodoDeclaracion(String nombreVariable, boolean esGlobal, NodoBase tamaño) {
        super();
        this.nombreVariable = nombreVariable;
        this.esGlobal = esGlobal;
        this.esArray = true;
        this.tipo = "array";
        this.tamaño = tamaño;
    }

    public String getNombreVariable() {
        return nombreVariable;
    }

    public void setNombreVariable(String nombreVariable) {
        this.nombreVariable = nombreVariable;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public NodoBase getTamaño() {
        return tamaño;
    }

    public void setTamaño(NodoBase tamaño) {
        this.tamaño = tamaño;
    }

    public boolean isEsGlobal() {
        return esGlobal;
    }

    public void setEsGlobal(boolean esGlobal) {
        this.esGlobal = esGlobal;
    }

    public boolean isEsArray() {
        return esArray;
    }

    public void setEsArray(boolean esArray) {
        this.esArray = esArray;
    }
}