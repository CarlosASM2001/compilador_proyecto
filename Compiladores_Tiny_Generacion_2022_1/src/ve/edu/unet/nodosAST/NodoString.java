package ve.edu.unet.nodosAST;

public class NodoString extends NodoBase {
    private String valor;

    public NodoString(String valor) {
        super();
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public void setValor(String valor) {
        this.valor = valor;
    }
}