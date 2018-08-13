/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IFS_S419_getOpportunities {
    global IFS_S419_getOpportunities() {

    }
    webService static SCP_Certa_GC.IFS_S419_getOpportunities.wrapperResponse getOpportunities(String cuit_Req, String idClienteLegado) {
        return null;
    }
global class wrapperOportunidades {
    @WebService
    webService String Description_op;
    @WebService
    webService String estado_oportunidad;
    @WebService
    webService String Id_op;
    global wrapperOportunidades() {

    }
}
global class wrapperResponse {
    @WebService
    webService String codError;
    @WebService
    webService String descError;
    @WebService
    webService List<SCP_Certa_GC.IFS_S419_getOpportunities.wrapperOportunidades> listaOportunidades;
}
}
