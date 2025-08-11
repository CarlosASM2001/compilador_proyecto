package ve.edu.unet.nodosAST;

public class NodoAsignacion extends NodoBase {
	private String identificador;
	private NodoBase expresion;
	private NodoBase indice; // Para asignaciones a arrays
	
	public NodoAsignacion(String identificador) {
		super();
		this.identificador = identificador;
		this.expresion = null;
		this.indice = null;
	}
	
	public NodoAsignacion(String identificador, NodoBase expresion) {
		super();
		this.identificador = identificador;
		this.expresion = expresion;
		this.indice = null;
	}

	// Constructor para asignaciones a arrays
	public NodoAsignacion(String identificador, NodoBase expresion, NodoBase indice) {
		super();
		this.identificador = identificador;
		this.expresion = expresion;
		this.indice = indice;
	}

	public String getIdentificador() {
		return identificador;
	}

	public void setIdentificador(String identificador) {
		this.identificador = identificador;
	}

	public NodoBase getExpresion() {
		return expresion;
	}

	public void setExpresion(NodoBase expresion) {
		this.expresion = expresion;
	}
	
	public NodoBase getIndice() {
		return indice;
	}

	public void setIndice(NodoBase indice) {
		this.indice = indice;
	}

	public boolean esAsignacionArray() {
		return indice != null;
	}
}
