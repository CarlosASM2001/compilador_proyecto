package ve.edu.unet.nodosAST;

public class NodoIdentificador extends NodoBase {
	private String nombre;
	private NodoBase desplazamiento;

	public NodoIdentificador(String nombre) {
		super();
		this.nombre = nombre;
		this.desplazamiento = null;
	}

	public NodoIdentificador(String nombre, NodoBase desplazamiento) {
		super();
		this.nombre = nombre;
		this.desplazamiento = desplazamiento;
	}

	public NodoIdentificador() {
		super();
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public NodoBase getDesplazamiento() {
		return desplazamiento;
	}
	
	public void setDesplazamiento(NodoBase desplazamiento) {
		this.desplazamiento = desplazamiento;
	}

}
