public with sharing class GP_Mantenimiento_EventosController {
    public String editModeRowId{get;set;}
    public GP_Evento_descriptor__c nuevoEvento{get;set;}
    public List<GP_Evento_descriptor__c> listaEventos{get;set;}

    public GP_Mantenimiento_EventosController() {
        editModeRowId = '';
        conseguirInitEventos();
    }

    public void insertRecord() {
        GP_Evento_descriptor__c eventoAUX = new GP_Evento_descriptor__c();
        eventoAUX.Tipo_de_evento__c = nuevoEvento.Tipo_de_evento__c;
        eventoAUX.Frecuencia_permitida__c = nuevoEvento.Frecuencia_permitida__c;
        eventoAUX.Descripcion__c = nuevoEvento.Descripcion__c;
        insert eventoAUX;
        conseguirInitEventos();
    }

    public void updateRecord() {
        update nuevoEvento;
        conseguirInitEventos();
    } 

    public void deleteRecord() {
        delete nuevoEvento;
        conseguirInitEventos();
    }

    public void conseguirInitEventos() {
        conseguirEventos();
        initNuevoEvento();
    }

    public void conseguirEventos() {
        listaEventos = new List<GP_Evento_descriptor__c>();
        listaEventos = [Select Id, Tipo_de_evento__c, Descripcion__c, Frecuencia_permitida__c From GP_Evento_descriptor__c];
        listaEventos.add(new GP_Evento_descriptor__c());
    }

    private void initNuevoEvento() {
        nuevoEvento = new GP_Evento_descriptor__c();
    }

    public void doNothing() {
        return;
    }
}