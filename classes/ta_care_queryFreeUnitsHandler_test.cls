/**
 * Created by bodie2003 on 23/11/17.
 */

@IsTest
private class ta_care_queryFreeUnitsHandler_test {

    @IsTest static void invoke_GetProductsFreeUnits_correct(){
        String methodName = 'GetProductsFreeUnits';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Object argsOK = (Object)'{"objConsulta":{"codigoAccesoCliente":{"identificadorRecurso":"1234","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        input.put('body',argsOK);

        ta_care_queryFreeUnitsHandler testedClass = new ta_care_queryFreeUnitsHandler();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        System.debug('Correct output: '+ outMap);

        System.assertNotEquals(empty, outMap);
    }

    @IsTest static void invoke_GetProductsFreeUnits_error(){
        String methodName = 'GetProductsFreeUnits';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Object argsERROR = (Object)'{"objConsulta":{"codigoAccesoCliente":{"identificadorRecurso":"0000","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        input.put('body',argsERROR);

        ta_care_queryFreeUnitsHandler testedClass = new ta_care_queryFreeUnitsHandler();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        System.debug('Error output: '+ outMap);

        System.assertNotEquals(empty, outMap);
    }


    /*public void queryFreeUnitsCallTester(String event){
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();

        Object arg1 = (Object)'{"codigoAccesoCliente":{"identificadorRecurso":"1234","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}}';
        Object arg2 = (Object)'{"codProducto":"string","secuenciaProductoAdquirido":"string"}';
        Object argsOK = (Object)'{"objConsulta":{"codigoAccesoCliente":{"identificadorRecurso":"1234","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';
        Object argsERROR = (Object)'{"objConsulta":{"codigoAccesoCliente":{"identificadorRecurso":"0000","idCliente":"string","codCliente":"string"},"codigoAcceso":{"identificadorRecurso":"string","codSuscripcion":"string"},"codigoAccesoGrupo":{"codGrupoSuscripcion":"string","grupoSuscripcion":"string"}},"codigoDeProducto":{"codProducto":"string","secuenciaProductoAdquirido":"string"}}';


        //inputMap.put('codigoDeProducto',arg2);
        if(event=='OK'){
            inputMap.put('body',argsOK);
        } else if(event=='ERROR'){
            inputMap.put('body',argsERROR);
        }

        System.debug('Inputmap: ' + inputMap);

        GetProductsFreeUnits(inputMap, outMap, options);
    }*/
}