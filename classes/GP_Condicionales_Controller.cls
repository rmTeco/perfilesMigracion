public with sharing class GP_Condicionales_Controller {

    public GP_Condicional_logico__c GP_Condicional_logico{get;set;}
    public GP_Condicional_logico__c condAUX{get;set;}
    public GP_Atributo_de_evento__c atributoDeEvento{get;set;}
    public List<GP_Condicional_logico__c> listaCondiciones{get;set;}
    public GP_Regla__c regla{get;set;}
    public Id IdCond{get;set;}
    public String calculoDePuntos{get;set;}
    public String calculoVTO{get;set;}
    public String tipoAtributoAux{get;set;}
    public Boolean esEventoGeneral{get;set;}
    public String JSONesAtributoEvento{get;set;}
    
    //Picklists
    public List<SelectOption> fechaVTOList{get;set;}
    public List<SelectOption> varACompararList{get;set;}
    public List<SelectOption> fijoVariableList{get;set;}
    public List<SelectOption> varResult{get;set;}
    public List<SelectOption> listTipoEvento{get;set;}
    public List<SelectOption> pickOperadorGeneral{get;set;}
    public String tipoEventoVar{get;set;}
    public String selectedVar{get;set;}
    public String tipoCalculo{get;set;}
    public String tipoVTO{get;set;}
    public String selOperadorGeneral{get;set;}

    private String IdRegla = '';
    private Set<String> eventosGenerales = new Set<String>();
    private Map<String, GP_Atributo_de_evento__c> atributosEvGeneral = new Map<String, GP_Atributo_de_evento__c>();
    private List<GP_Atributo_de_evento__c> atributosEventoGeneral;
    private Map<String, Object> atributoEvento;

    public GP_Condicionales_Controller() {
        IdCond = null;
        listaCondiciones = new List<GP_Condicional_logico__c>();
        varACompararList = new List<SelectOption>();
        condAUX = new GP_Condicional_logico__c();
        inicializarVariables();
        popularPicklistVTO();
        popularPicklistFijoVar();
        picklistResultado();

        IdRegla = ApexPages.currentPage().getParameters().get('id');
        if (IdRegla != null) {
            regla = 
                [SELECT Id, Name, Descripcion_regla__c, Metodo_a_ejecutar__c, SeComparaContraElValorFijo__c,
                    Tipo_de_evento__c, Valor_resultado_fijo__c, Valor_resultado_variable__c, Fecha_vencimiento__c,
                    Dias_vencimiento__c, Vencimiento_fecha_fija__c, Variable_calculo__c, Operador_calculo__c,
                    Valor_calculo__c, Vigencia_desde__c, Vigencia_hasta__c, Evento_general__c, Evento_general__r.Name, Activa__c
                FROM GP_Regla__c
                WHERE Id = :IdRegla];
            if(regla.SeComparaContraElValorFijo__c == true && tipoCalculo == null) {
                tipoCalculo = 'fijo';
            } else {
                tipoCalculo = 'variable';
            }
            if(regla.Vencimiento_fecha_fija__c == true && tipoVTO == null) {
                tipoVTO = 'fija';
            } else {
                tipoVTO = 'dias';
            }
            calculoDePuntosText();
            fechaVTOText();
            getPicklists();
            conseguirCondiciones();
            if(regla.Evento_general__c != null) {
                tipoEventoVar = regla.Evento_general__r.Name;
                esEventoGeneral = true;
            } else {
                tipoEventoVar = regla.Tipo_de_evento__c;
                esEventoGeneral = false;
            }
        } else {
            regla = new GP_Regla__c();
        }
        conseguirTiposDeEvento();
        initCondicion();
    }
    public void conseguirCondiciones(){
        listaCondiciones = 
            [SELECT Id, Name, Operador__c, SeComparaContraElValorFijo__c, Valor_contra_el_que_se_compara__c, Atributo_de_evento__c, Atributo_de_evento__r.Name, Atributo_de_evento__r.Tipo_de_atributo__c,
                Variable_a_comparar__c, Variable_contra_la_que_se_compara__c, Valor_entero__c, Valor_booleano__c, Valor_string__c, Regla__c
            FROM GP_Condicional_logico__c 
            WHERE Regla__c = :regla.Id];
    }
    public void getCondicional() {
        GP_Condicional_logico = 
            [SELECT Id, Name, Operador__c, SeComparaContraElValorFijo__c, Valor_contra_el_que_se_compara__c, Atributo_de_evento__c, Atributo_de_evento__r.Name, Atributo_de_evento__r.Tipo_de_atributo__c,
                Variable_a_comparar__c, Variable_contra_la_que_se_compara__c, Valor_entero__c, Valor_booleano__c, Valor_string__c, Regla__c, Regla__r.Evento_general__c
            FROM GP_Condicional_logico__c
            WHERE Id = :IdCond];
        selectedVar = GP_Condicional_logico.Variable_a_comparar__c;
        if(GP_Condicional_logico.Atributo_de_evento__c != null) {
            tipoAtributoAux = GP_Condicional_logico.Atributo_de_evento__r.Tipo_de_atributo__c;
        } else {
            tipoAtributoAux = '';
        }
        selOperadorGeneral = GP_Condicional_logico.Operador__c;
        getPicklists();
    }
    public void saveCondicional() {
        if(atributosEvGeneral.containsKey( selectedVar.toLowerCase() )) {
            GP_Atributo_de_evento__c attr = atributosEvGeneral.get( selectedVar.toLowerCase() );
            GP_Condicional_logico.Atributo_de_evento__c = attr.Id;
            GP_Condicional_logico.Operador__c = selOperadorGeneral;
        }
        GP_Condicional_logico.Variable_a_comparar__c = selectedVar;
        update GP_Condicional_logico;
        conseguirCondiciones();
        GP_Condicional_logico = new GP_Condicional_logico__c(Regla__c = regla.Id);
        inicializarVariables();
    }
    public void insertarCondicion(){
        if (GP_Condicional_logico.Regla__c == null) {
            validarTipoEvento();
            upsert regla;
            GP_Condicional_logico.Regla__c = regla.Id;
        }
        if(atributosEvGeneral.containsKey( selectedVar.toLowerCase() )) {
            GP_Atributo_de_evento__c attr = atributosEvGeneral.get( selectedVar.toLowerCase() );
            GP_Condicional_logico.Atributo_de_evento__c = attr.Id;
            GP_Condicional_logico.Operador__c = selOperadorGeneral;
        }
        GP_Condicional_logico.Variable_a_comparar__c = selectedVar;
        GP_Condicional_logico__c cond_aux = GP_Condicional_logico;
        insert cond_aux;
        conseguirCondiciones();
        initCondicion();
    }
    public void initCondicion() {
        GP_Condicional_logico = new GP_Condicional_logico__c();
        inicializarVariables();
    }
    public void deleteCond() {
        try {
            GP_Condicional_logico = 
                [SELECT Id
                FROM GP_Condicional_logico__c
                WHERE Id = :IdCond];
            delete GP_Condicional_logico;
            initCondicion();
            conseguirCondiciones();
        } catch (Exception ex) {
            throw ex;
        }
    }
    public PageReference saveAndReturnToList() {
        try {
            validarTipoEvento();
            upsert regla;
            PageReference listPage = new PageReference('/apex/GP_Gestor_Reglas');
            listPage.setRedirect(true);
            return listPage;
        } catch (Exception ex) {
            throw ex;
        }
    }
    public void getPicklists() {
        getAtributosEventoGeneral();
        getVarAComparar();
    }
    public void getAtributosEventoGeneral() {
        atributosEventoGeneral = new List<GP_Atributo_de_evento__c>();
        atributoEvento = new Map<String, Object>();
        if(regla.Evento_general__c != null) {
            atributosEventoGeneral = [  Select Id,Name,GP_Evento_General__c,Nombre_API__c,Tipo_de_atributo__c, Valores_Posibles__c
                                        From GP_Atributo_de_evento__c
                                        Where GP_Evento_General__c = :regla.Evento_general__c];
        }
    }
    public void getVarAComparar () {
        Boolean isActive;
        String value;
        String label;

        Map<String, Object> mapAux = new Map<String, Object>();
        atributoEvento = new Map<String, Object>();
        JSONesAtributoEvento = '';

        varACompararList = new List<SelectOption>();
        varACompararList.add(new SelectOption('','--Vacio--'));
        pickOperadorGeneral = new List<SelectOption>();
        pickOperadorGeneral.add(new SelectOption('','--Vacio--'));
        pickOperadorGeneral.add(new SelectOption('=','='));
        pickOperadorGeneral.add(new SelectOption('!=','!='));

        if(atributosEventoGeneral.size() > 0) {
            //Evento General
            for(GP_Atributo_de_evento__c attr : atributosEventoGeneral) {
                varACompararList.add(new SelectOption(attr.Name, attr.Name));
                mapAux = new Map<String, Object>();
                mapAux.put('tipo', attr.Tipo_de_atributo__c);
                if(attr.Tipo_de_atributo__c == 'String' && attr.Valores_Posibles__c != null) {
                    List<String> valoresAux = attr.Valores_Posibles__c.split(';');
                    mapAux.put('valoresPosibles', valoresAux);
                }
                atributoEvento.put( attr.Name , mapAux);
                atributosEvGeneral.put( attr.Name.toLowerCase() , attr);
            }
            JSONesAtributoEvento = JSON.serialize(atributoEvento);
            if(atributosEvGeneral.containsKey( selectedVar.toLowerCase() )) {
                GP_Atributo_de_evento__c attrAux = atributosEvGeneral.get( selectedVar.toLowerCase() );
                if(attrAux.Tipo_de_atributo__c == 'Number') {
                    pickOperadorGeneral.add(new SelectOption('>','>'));
                    pickOperadorGeneral.add(new SelectOption('<','<'));
                } else if(attrAux.Tipo_de_atributo__c == 'Boolean') {
                    pickOperadorGeneral = new List<SelectOption>();
                    pickOperadorGeneral.add(new SelectOption('=','='));
                }
            }
        } else {
            //Variable a comparar
            Schema.DescribeFieldResult Field = GP_Condicional_logico__c.Variable_a_comparar__c.getDescribe();
            List<Schema.PicklistEntry> P = Field.getPicklistValues();
            for (Schema.PicklistEntry item : P) { 
                isActive = item.isActive();
                value = item.getValue();
                label = item.getLabel();
                if (isActive) {
                    if (value == 'Categoria De Socio' || value == 'Tipo De Cliente' || value == 'Tipo De Servicio') {
                        varACompararList.add(new SelectOption(value, label));
                    }
                    else if (value == 'Tipo De Upselling' && regla.Tipo_de_evento__c == 'Upselling') {
                        varACompararList.add(new SelectOption(value, label));
                    }
                    else if (value == 'Equipo Categoria' && regla.Tipo_de_evento__c == 'Cater') {
                        varACompararList.add(new SelectOption(value, label));
                    }
                    else if (value == 'Monto' && regla.Tipo_de_evento__c == 'Recarga por Monto') {
                        varACompararList.add(new SelectOption(value, label));
                    }
                }
            }
        }
    }
    public void inicializarVariables() {
        selectedVar = '';
        selOperadorGeneral = '';
        tipoAtributoAux = '';
    }
    public void doNothing() {
        return;
    }
    //Manejo de resultado fijo/variable
    public void popularPicklistFijoVar() {
        fijoVariableList = new List<SelectOption>();
        fijoVariableList.add(new SelectOption('fijo','Fijo'));
        fijoVariableList.add(new SelectOption('variable','Variable'));
    }
    public void calculoDePuntosText() {
        String text = '';
        if (tipoCalculo == 'fijo') {
            calculoDePuntos = String.valueOf(regla.Valor_resultado_fijo__c);
            regla.SeComparaContraElValorFijo__c = true;
        } else if (tipoCalculo == 'variable') {

            if (regla.Variable_calculo__c != null) {
                text = regla.Variable_calculo__c;
            }
            if (regla.Operador_calculo__c != null) {
                text += ' ' + regla.Operador_calculo__c;
            }
            if (regla.Valor_calculo__c != null) {
                text += ' ' + regla.Valor_calculo__c;
            }
            calculoDePuntos = text;
            regla.SeComparaContraElValorFijo__c = false;
        }
    }
    //Manejo de fecha VTO
    public void popularPicklistVTO() {
        fechaVTOList = new List<SelectOption>();
        fechaVTOList.add(new SelectOption('fija','Fecha fija'));
        fechaVTOList.add(new SelectOption('dias','Cálculo por días'));
    }

    public void fechaVTOText() {
        String text = '';
        if (tipoVTO == 'fija') {
            calculoVTO = String.valueOf(regla.Fecha_vencimiento__c);
            regla.Vencimiento_fecha_fija__c = true;
        } else {
            if (regla.Dias_vencimiento__c != null) {
                text = 'Luego de ' + String.valueOf(regla.Dias_vencimiento__c) + ' días.';
            }
            calculoVTO = text;
            regla.Vencimiento_fecha_fija__c = false;
        }
    }
    public void picklistResultado() {
        String value = '';
        String label = '';
        Boolean isActive;
        String language = UserInfo.getLanguage();

        varResult = new List<SelectOption>();
        
        Schema.DescribeFieldResult picklistField = GP_Condicional_logico__c.Variable_a_comparar__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = picklistField.getPicklistValues();

        Schema.SObjectField field = GP_Condicional_logico__c.valor_contra_el_que_se_compara__c.getDescribe().getSObjectField();
        Schema.SObjectField ctrlField = picklistField.getSObjectField();
        Map<String, List<String>> result = HL_FieldDescribeUtil.getDependentOptionsImpl(field,ctrlField);

        if(language.substringBefore('_') == 'en') {
            varResult.add(new SelectOption('','--None--'));
        } else {
            varResult.add(new SelectOption('','--Vacio--'));
        }

        for(Schema.PicklistEntry option : picklistValues) {
            value = option.getValue();
            label = option.getLabel();
            isActive = option.isActive();
            List<String> valoresDependientes = result.get(value);
            for(String valor : valoresDependientes) {
                if(valor == 'integer' && isActive == true) {
                    varResult.add(new SelectOption(value,label));
                }
            }
        }
    }
    public void conseguirTiposDeEvento() {
        String value = '';
        String label = '';
        Boolean isActive;

        Schema.DescribeFieldResult Field = GP_Regla__c.Tipo_de_evento__c.getDescribe();
        List<Schema.PicklistEntry> P = Field.getPicklistValues();
        listTipoEvento = new List<SelectOption>();
        listTipoEvento.add(new SelectOption('','--Vacio--'));

        for(Schema.PicklistEntry option : p) {
            value = option.getValue();
            label = option.getLabel();
            isActive = option.isActive();
            if(isActive) {
                listTipoEvento.add(new SelectOption(value,label));
            }
        }

        List<GP_Evento_General__c> evGral = [Select Id, Name, Descripcion_del_evento__c, Activo__c
                                             From GP_Evento_General__c
                                             Where Activo__c = true];
        if(evGral.size() > 0) {
            for(GP_Evento_General__c ev : evGral) {
                listTipoEvento.add(new SelectOption(ev.Name, ev.Name));
                if(!eventosGenerales.contains(String.valueOf(ev.Name))){
                    eventosGenerales.add(String.valueOf(ev.Name));
                }
            }
        }
    }
    public void validarTipoEvento() {
        if(eventosGenerales.contains(tipoEventoVar)) {
            regla.Evento_general__c = [Select Id From GP_Evento_General__c Where Name = :tipoEventoVar Limit 1].Id;
            regla.Tipo_de_evento__c = tipoEventoVar;
            esEventoGeneral = true;
        } else {
            regla.Evento_general__c = null;
            regla.Tipo_de_evento__c = tipoEventoVar;
            esEventoGeneral = false;
        }
    }

}