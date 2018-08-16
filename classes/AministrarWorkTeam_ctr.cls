/**
* 
* @author       Helman Reyes href=<hreyesq@aconcaguabs.com>
* Project:      Telecom
* Description:    Controlador de página
*
* Changes (Version)
* -------------------------------------
*      No.    Date      Author                 Description
*      -----  ----------    --------------------         ---------------
* @version  1.0    2018-02-02    Helman Reyes    Creación clase.
*************************************************************************************************************/

public class AministrarWorkTeam_ctr {

  public Boolean blnEquipo {get;set;} 
  public String strResultados {get;set;} 

  public List<WorkTeam__c> listaEquipos {get;set;}
  public List<WorkTeam__c> equiposToShow {get;set;}

//variables tabla:
    Integer counter = 0;
    Integer limitSize = 10;
    Integer totalSize =0;


  public AministrarWorkTeam_ctr() {
    strResultados     = '';
    blnEquipo= true;    
    listaEquipos= new List<WorkTeam__c>();
    listaEquipos=[select id, name, Work_Team_Number__c , Manager__r.name, Manager_Profile__c  from WorkTeam__c order by Work_Team_Number__c desc];
    equiposToShow= new List<WorkTeam__c>();


    System.debug('cantidad de equipos:'+listaEquipos.size());


    totalSize = listaEquipos.size();
        
    //muestra primeros elementos en la tabla
    if((counter+limitSize) <= totalSize){
      for(Integer i=0;i<limitSize;i++){
        equiposToShow.add(listaEquipos.get(i));
      }
    }else{
      for(Integer i=0;i<totalSize;i++){
        equiposToShow.add(listaEquipos.get(i));
        }
    }
       
  }
    
}