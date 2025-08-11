package ve.edu.unet.nodosAST;

public class NodoPrograma extends NodoBase {

    NodoBase global_block;
    NodoBase function_block;
    NodoBase main;

    public NodoPrograma(NodoBase global_block, NodoBase function_block, NodoBase main) {
        super();
        this.global_block = global_block;
        this.function_block = function_block;
        this.main = main;
    }

    public NodoPrograma(NodoBase global_block, NodoBase main) {
        super();
        this.global_block = global_block;
        this.function_block = null;
        this.main = main;
    }

    public NodoBase getGlobal_block() {
        return global_block;
    }

    public void setGlobal_block(NodoBase global_block) {
        this.global_block = global_block;
    }

    public NodoBase getFunction_block() {
        return function_block;
    }

    public void setFunction_block(NodoBase function_block) {
        this.function_block = function_block;
    }

    public NodoBase getMain() {
        return main;
    }

    public void setMain(NodoBase main) {
        this.main = main;
    }

}
