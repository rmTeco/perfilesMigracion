public class GP_AtributoBatchJson {

    public List<gp_atributos> listaDeAtributos {get;set;}
    
    public class gp_atributos{
      public String NombreDelAtributo {get;set;}
	  public String TipoDeAtributo {get;set;}
	  public String Valor {get;set;}  
    }
}