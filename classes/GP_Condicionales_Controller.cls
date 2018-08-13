public with sharing class GP_Condicionales_Controller {

    public GP_Condicional_logico__c GP_Condicional_logico{get;set;}
    public GP_Condicional_logico__c condAUX{get;set;}
    public List<GP_Condicional_logico__c> listaCondiciones{get;set;}
    public GP_Regla__c regla{get;set;}
    public Id IdCond{get;set;}
    public String calculoDePuntos{get;set;}
    public String calculoVTO{get;set;}
    
    //Picklists
    public List<SelectOption> fechaVTOList{get;set;}
    public List<SelectOption> varACompararList{get;set;}
    public List<SelectOption> fijoVariableList{get;set;}
    public List<SelectOption> varResult{get;set;}
    public String selectedVar{get;set;}
    public String tipoCalculo{get;set;}
    public String tipoVTO{get;set;}

    private String IdRegla = '';

    public GP_Condicionales_Controller() {
        IdCond = null;
        listaCondiciones = new List<GP_Condicional_logico__c>();
        varACompararList = new List<SelectOption>();
        condAUX = new GP_Condicional_logico__c();
        popularPicklistFijoVar();
        popularPicklistVTO();
        inicializarVariables();
        picklistResultado();

        IdRegla = ApexPages.currentPage().getParameters().get('id');
        if (IdRegla != null) {
            regla = 
                [SELECT Id,Name,Descripcion_regla__c,Metodo_a_ejecutar__c,SeComparaContraElValorFijo__c,Tipo_de_evento__c,Valor_resultado_fijo__c,Valor_resultado_variable__c,Fecha_vencimiento__c,Dias_vencimiento__c,Vencimiento_fecha_fija__c,Variable_calculo__c,Operador_calculo__c,Valor_calculo__c,Vigencia_desde__c,Vigencia_hasta__c,Activa__c
                FROM GP_Regla__c 
                WHERE Id = :IdRegla];
            if (regla.SeComparaContraElValorFijo__c == true && tipoCalculo == null) {
                tipoCalculo = 'fijo';
            } else {
                tipoCalculo = 'variable';
            }
            if (regla.Vencimiento_fecha_fija__c == true && tipoVTO == null) {
                tipoVTO = 'fija';
            } else {
                tipoVTO = 'dias';
            }
            calculoDePuntosText();
            fechaVTOText();
            getPicklists();
            conseguirCondiciones();
        } else {
            regla = new GP_Regla__c();
        }
        initCondicion();
    }

    public void conseguirCondiciones(){
        listaCondiciones = 
            [SELECT Id,Name,Operador__c,SeComparaContraElValorFijo__c,Valor_contra_el_que_se_compara__c,Variable_a_comparar__c,Variable_contra_la_que_se_compara__c,Valor_entero__c,Valor_booleano__c,Regla__c
            FROM GP_Condicional_logico__c 
            WHERE Regla__c = :regla.Id];
    }

    public void getCondicional() {
        GP_Condicional_logico = 
            [SELECT Id,Name,Operador__c,SeComparaContraElValorFijo__c,Valor_contra_el_que_se_compara__c,Variable_a_comparar__c,Variable_contra_la_que_se_compara__c,Valor_entero__c,Valor_booleano__c,Regla__c
            FROM GP_Condicional_logico__c
            WHERE Id = :IdCond];
        selectedVar = GP_Condicional_logico.Variable_a_comparar__c;
        getPicklists();
    }
    
    public void saveCondicional() {
        GP_Condicional_logico.Variable_a_comparar__c = selectedVar;
        update GP_Condicional_logico;
        conseguirCondiciones();
        GP_Condicional_logico = new GP_Condicional_logico__c(Regla__c = regla.Id);
        inicializarVariables();
    }

    public void insertarCondicion(){
        if (GP_Condicional_logico.Regla__c == null) {
            upsert regla;
            GP_Condicional_logico.Regla__c = regla.Id;
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
                [SELECT Id,Name,Operador__c,SeComparaContraElValorFijo__c,Valor_contra_el_que_se_compara__c,Variable_a_comparar__c,Variable_contra_la_que_se_compara__c,Valor_entero__c,Valor_booleano__c,Regla__c
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
            upsert regla;
            PageReference listPage = new PageReference('/apex/GP_Gestor_Reglas');
            listPage.setRedirect(true);
            return listPage;
        } catch (Exception ex) {
            throw ex;
        }
    }

    public void getPicklists() {
        getVarAComparar();
    }

    public void getVarAComparar () {
        Boolean isActive;
        String value;
        String label;

        //Variable a comparar
        Schema.DescribeFieldResult Field = GP_Condicional_logico__c.Variable_a_comparar__c.getDescribe();
        List<Schema.PicklistEntry> P = Field.getPicklistValues();
        varACompararList = new List<SelectOption>();
        varACompararList.add(new SelectOption('','--Vacio--'));
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

    public void inicializarVariables() {
        selectedVar = '';
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

}