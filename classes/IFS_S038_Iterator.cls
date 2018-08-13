public class IFS_S038_Iterator {
    
    public static List<Map<String,Object>> Iterate(List<String> requests){
        List<Map<String,Object>> respuestas = new List<Map<String,Object>>();
        for(String jsonEntrante: requests){ 
            Map<String,Object> mapa = (Map<String, Object>)JSON.deserializeUntyped(jsonEntrante);
            
            String identificador = (String)mapa.get('idCuenta');
            
            Map<String,Object> reply = new Map<String,Object>();
            reply=IFS_S038_updateCycle.updateCycle(jsonEntrante, identificador);
            respuestas.add(reply);
        }
        return respuestas;
    }
}