package ve.edu.unet.nodosAST;

public class NodoValor extends NodoBase {
	private Object valor; // Puede ser Integer o Double
	private boolean esReal;

	public NodoValor(Integer valor) {
		super();
		this.valor = valor;
		this.esReal = false;
	}

	public NodoValor(Double valor) {
		super();
		this.valor = valor;
		this.esReal = true;
	}

	public NodoValor() {
		super();
		this.valor = 0;
		this.esReal = false;
	}
	
	public Object getValor() {
		return valor;
	}

	public Integer getValorEntero() {
		if (!esReal && valor instanceof Integer) {
			return (Integer) valor;
		}
		return null;
	}

	public Double getValorReal() {
		if (esReal && valor instanceof Double) {
			return (Double) valor;
		}
		return null;
	}

	public boolean esReal() {
		return esReal;
	}

	public void setValor(Object valor) {
		this.valor = valor;
		this.esReal = valor instanceof Double;
	}
}
