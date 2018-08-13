@isTest
global class IFS_S271_prefeseabiltyMock implements HttpCalloutMock {
     public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"tecnologiasAcceso":{"TecnologiaAcceso":{"tecnologia":"test","ebos":"test","armario":"test","autoconmutador":"test","cdo":{"categoria":"test","estado":"test","modalidad":"test"},"terminal":{"codigoTerminal":"test","paresDisponibles":8,"paresDefectuosos":8,"categoriaTerminal":"test","Topologia":"test"},"servicios":{"servicio":{"servicio":"test","standardsTecnico":{"standardTecnico":{"standardTecnico":"test","medicionDeBajada":8}},"disponibilidad":"test","codigoMensaje":"test","descMensaje":"test"}},"centrales":{"centralAtendida":"test","centralGSMF":"test","centralGirafe":"test","centralVoz":"test","centralInternet":"test"}}},"Servicios" : {"servicio":{"ebos":"test","idServicio":"test","Tipo":"test","Tecnologia":"test","centralAtendida":"test","Autoconmutador":"test","Armario":"test","Terminal":{"codigoTerminal":"test","Categoria":"test","Topologia":"test","medicionDeBajada":"test"}}}}';
             
             //String jsonString='{"tecnologiasAcceso":{"TecnologiaAcceso":[{"tecnologia":"test","ebos":"test","armario":"test","autoconmutador":"test","cdo":[{"categoria":"test","estado":"test","modalidad":"test"}],"terminal":[{"codigoTerminal":"test","paresDisponibles":8,"paresDefectuosos":8,"categoriaTerminal":"test","topologia":"test"}],"servicios":[{"servicio":[{"servicio":"test","standardsTecnico":[{"standardTecnico":[{"standardTecnico":"test","medicionDeBajada":8}]}],"disponibilidad":"test","codigoMensaje":"test","descMensaje":"test"}]}],"centrales":[{"centralAtendida":"test","centralGSMF":"test","centralGirafe":"test","centralVoz":"test","centralInternet":"test"}]}]},"Servicios" : {"servicio":[{"ebos":"e1","idServicio":"test","Tipo":"test","Tecnologia":"test","centralAtendida":"test","Autoconmutador":"test","Armario":"test","Terminal":[{"codigoTerminal":"test","Categoria":"test","Topologia":"test","medicionDeBajada":"test"}]}]}}';     
             
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}