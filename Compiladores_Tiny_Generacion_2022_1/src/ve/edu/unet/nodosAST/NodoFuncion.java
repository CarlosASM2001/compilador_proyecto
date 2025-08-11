package ve.edu.unet.nodosAST;

public class NodoFuncion extends NodoBase {
    private String nombre;
    private NodoBase parametros;
    private NodoBase cuerpo;
    private NodoBase retorno;

    public NodoFuncion(String nombre, NodoBase parametros, NodoBase cuerpo, NodoBase retorno) {
        super();
        this.nombre = nombre;
        this.parametros = parametros;
        this.cuerpo = cuerpo;
        this.retorno = retorno;
    }

    public NodoFuncion(NodoBase cuerpo, NodoBase retorno) {
        super();
        this.nombre = null;
        this.parametros = null;
        this.cuerpo = cuerpo;
        this.retorno = retorno;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public NodoBase getParametros() {
        return parametros;
    }

    public void setParametros(NodoBase parametros) {
        this.parametros = parametros;
    }

    public NodoBase getCuerpo() {
        return cuerpo;
    }

    public void setCuerpo(NodoBase cuerpo) {
        this.cuerpo = cuerpo;
    }

    public NodoBase getRetorno() {
        return retorno;
    }

    public void setRetorno(NodoBase retorno) {
        this.retorno = retorno;
    }
}