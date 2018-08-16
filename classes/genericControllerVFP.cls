public class genericControllerVFP {
    public String valor;
    
    public genericControllerVFP(ApexPages.StandardController controller) {
        if (Cache.Session.contains('local.myPartition.valor')) {
            valor = (String) Cache.Session.get('local.myPartition.valor');
        } else {
            valor = 'nop';
        }

    }
    
    public String palabra;

    public genericControllerVFP(){
        palabra = 'Constructor';
    }

    public String getValor(){
        return valor;
    }

    public void traerValor(){
        if (Cache.Session.contains('local.myPartition.valor')) {
            valor = (String) Cache.Session.get('local.myPartition.valor');
        } else {
            valor = 'nop';
        }
    }

    public void setearValor(){
        Cache.Session.put('local.myPartition.valor', 'algo');
    }
    
    public String getPalabra(){
        return palabra;
    }
    
    public void setPalabra(String pal){
        palabra = pal;
    }

}