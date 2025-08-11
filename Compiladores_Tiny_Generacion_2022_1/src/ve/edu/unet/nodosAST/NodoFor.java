package ve.edu.unet.nodosAST;

public class NodoFor extends NodoBase {
    private String variable;
    private NodoBase valorInicial;
    private NodoBase valorFinal;
    private NodoBase incremento;
    private NodoBase cuerpo;

    public NodoFor(String variable, NodoBase valorInicial, NodoBase valorFinal, NodoBase incremento, NodoBase cuerpo) {
        super();
        this.variable = variable;
        this.valorInicial = valorInicial;
        this.valorFinal = valorFinal;
        this.incremento = incremento;
        this.cuerpo = cuerpo;
    }

    public String getVariable() {
        return variable;
    }

    public void setVariable(String variable) {
        this.variable = variable;
    }

    public NodoBase getValorInicial() {
        return valorInicial;
    }

    public void setValorInicial(NodoBase valorInicial) {
        this.valorInicial = valorInicial;
    }

    public NodoBase getValorFinal() {
        return valorFinal;
    }

    public void setValorFinal(NodoBase valorFinal) {
        this.valorFinal = valorFinal;
    }

    public NodoBase getIncremento() {
        return incremento;
    }

    public void setIncremento(NodoBase incremento) {
        this.incremento = incremento;
    }

    public NodoBase getCuerpo() {
        return cuerpo;
    }

    public void setCuerpo(NodoBase cuerpo) {
        this.cuerpo = cuerpo;
    }
}