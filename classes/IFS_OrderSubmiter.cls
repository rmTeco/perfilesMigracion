/**
 * Esta clase es un batch job que debera esta agendado para
 * correr cada n minutos, en los cuales intentara procesar
 * las ordenes generadas por los procesos de F&F y Venta de Packs.
 * 
 * @Author: Alejandro Salord (Certa Consulting)
 * @Version: 1.0
 * @see: PFTA-????
 */
global with sharing class IFS_OrderSubmiter implements  Database.Batchable<sObject>, Database.AllowsCallouts  {
    private static final String K_TIPO_JOB = 'Job Request%';
    private static boolean K_DEBUG_ON = true;
    private List<Crossobject__c> lstJobsRequestToUpdate = null;
    private MyLimits limites = null;

     public IFS_OrderSubmiter() {
         limites = new MyLimits();
     }

     public IFS_OrderSubmiter(Boolean pDebug) {
         limites = new MyLimits();
        K_DEBUG_ON = pDebug;
     }
    

    global Database.QueryLocator start(Database.Batchablecontext BC){
        printDebug('Entre en start()');
        return Database.getQueryLocator(
            'SELECT order__c, Status__c, DateTime2__c, String2__c FROM Crossobject__c WHERE CrossObjectName__c LIKE \'Job Request%\' AND Status__c = \'Pendiente\'');
    }


    /**
     * @Objetivo: Secuencia principal.
     */
    global void execute(Database.BatchableContext BC, List<Crossobject__c> pLstJobsRequest) {
        try {
            printDebug('Start Process');
            printLimitAndUsedSize();
            if (pLstJobsRequest == null || pLstJobsRequest.isEmpty()) {
                printDebug('No hay Ordenes para procesar - Finalizo la ejecucion.');
                return;
            }
            printDebug('Cantidad de Ordenes a procesar --> ' + pLstJobsRequest.size());
            Boolean isLimit = false;
            for (Integer i=0; i < pLstJobsRequest.size() && !isLimit; i++) {
                Crossobject__c co = pLstJobsRequest.get(i);
                Id orderId = co.order__c;
                if (orderId == null) {
                    printDebug('El Id de la orden vino nulo');
                    co.Status__c = 'Cancelado';
                    co.DateTime2__c = DateTime.now();
                    co.String2__c = 'El Id de la orden vino nulo';
                    update co;
                    printLimitAndUsedSize();
                    continue;
                }
                printDebug('Inicio proceso [' + i + '] - OrderId --> ' + orderId);
                String result = vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(orderId, false);
                Map<String, Object> resultMap = (Map<String, Object>)JSON.deserializeUntyped(result);
                Boolean procStatus = true;
                String  procStatusDesc = 'Orden Submitida';
                if (resultMap != null) {
                    Boolean stat = (Boolean) resultMap.get('isOk');
                    if (!stat) {
                        printLimitAndUsedSize();
                        printDebug('--- Error al procesar la orden ' + resultMap.get('errorMsg'));
                        procStatus = false;
                        procStatusDesc = (String)resultMap.get('errorMsg');
                    }
                }
                else {
                    procStatus = false;
                    procStatusDesc = 'Fallo al verificar resultado de la API, el Mapa recibido es nulo';
                    printDebug('Fallo al verificar resultado de la API, el Mapa recibido es nulo');
                }

                co.Status__c = (procStatus ? 'Confirmado' : 'Cancelado');
                co.DateTime2__c = DateTime.now();
                co.String2__c = procStatusDesc;
                co.order__c = orderId;
                if (lstJobsRequestToUpdate == null) {
                    lstJobsRequestToUpdate = new List<Crossobject__c>();
                }
                printDebug('Fin proceso OrderId --> ' + orderId);
                printDebug('Agregando Cross Object para actualizarlos.');
                lstJobsRequestToUpdate.add(co);
                Integer qSoqlAcum = Limits.getQueries();
                Integer qHeapAcum = Limits.getHeapSize();
                if (i==0) {
                    limites.setQSoql1Shot();
                    limites.setQDml1Shot();
                    limites.setQHeap1Shot();
                    limites.setQCallout1Shot();
                }
                limites.printLimitsDebug();
                isLimit = !limites.canRunAgain();
            }

            if (lstJobsRequestToUpdate != null && !lstJobsRequestToUpdate.isEmpty()) {
                printDebug('Actualizo los Cross Object procesados.');
                update lstJobsRequestToUpdate;
                printDebug('Process End - Orders processed --> ' + lstJobsRequestToUpdate.size());
            }
            else {
                printDebug('Process End with no jobs to process');
            }    
            printLimitAndUsedSize();
        }
        catch (Exception e)     {
            printLimitAndUsedSize();
            printDebug('Process End With Errors - Error --> ' + e.getMessage());
            printDebug(e.getStackTraceString());
            throw e;
        }
    }

    global void finish(Database.BatchableContext BC){ }


    /**
     * @Objetivo: Muestra el consumo de recursos.
     */
    private void printLimitAndUsedSize() {
        if (limites != null) {
            limites.printLimitsDebug();
        }
    }

    /**
     * @Objetivo: Wrapper del System.debug que permite 
     *            activar o apagar con solo setear una variable.
     */
    public void printDebug(String pMensaje) {
        if (IFS_OrderSubmiter.K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {
    }

    private class MyLimits {
        private Integer qSoql1Shot = 0;
        private Integer qDml1Shot = 0;
        private Integer qHeap1Shot = 0;
        private Integer qCallout1Shot = 0;

        public void setQSoql1Shot(){qSoql1Shot=getQSoqlAcum();}
        public void setQDml1Shot(){qDml1Shot=getQDmlAcum();}
        public void setQHeap1Shot(){qHeap1Shot=getQHeapAcum();}
        public void setQCallout1Shot(){qCallout1Shot=getQCalloutAcum();}

        public Integer getQSoql1Shot(){return qSoql1Shot;}
        public Integer getQDml1Shot(){return qDml1Shot;}
        public Integer getQHeap1Shot(){return qHeap1Shot;}
        public Integer getQCallout1Shot(){return qCallout1Shot;}

        public Integer getQSoqlAcum(){return Limits.getQueries();}
        public Integer getQDmlAcum(){return Limits.getDMLStatements();}
        public Integer getQHeapAcum(){return Limits.getHeapSize();}
        public Integer getQCalloutAcum(){return Limits.getCallouts();}

        public Integer getQSoqlLimit(){return Limits.getLimitQueries();}
        public Integer getQDmlLimit(){return Limits.getLimitDMLStatements();}
        public Integer getQHeapLimit(){return Limits.getLimitHeapSize();}
        public Integer getQCalloutLimit(){return Limits.getLimitCallouts();}

        public void printLimitsDebug () {
            printDebug('SOQL Limit: ' + getQSoqlLimit() + ' - SOQL Acum: ' + getQSoqlAcum() + ' - SOQL 1 shot: ' +  getQSoql1Shot());
            printDebug('DML  Limit: ' + getQDmlLimit() + ' - DML  Acum: ' + getQDmlAcum() + ' - DML  1 shot: ' +  getQDml1Shot());
            printDebug('Heap Limit: ' + getQHeapLimit() + ' - Heap Acum: ' + getQHeapAcum() + ' - Heap 1 shot: ' +  getQHeap1Shot());
            printDebug('Call Limit: ' + getQCalloutLimit() + ' - Call Acum: ' + getQCalloutAcum() + ' - Call 1 shot: ' +  getQCallout1Shot());
        }

        private void printDebug(String pMensaje) {
            if (IFS_OrderSubmiter.K_DEBUG_ON) {
                System.debug(pMensaje);
            }
        }

        /**
         * @Objetivo: Si el limite menos el consumido menos lo que consume 1 ejecucion es mayor a lo que consume 1 ejecucion entoces puedo 
         *            ejecutar una vez mas sin pasar los limites.
         */
        public Boolean canRunAgain() {
            return 
                ((getQSoqlLimit()-getQSoqlAcum()-getQSoql1Shot())>getQSoql1Shot()) &&
                ((getQDmlLimit()-getQDmlAcum()-getQDml1Shot())>getQDml1Shot()) &&
                ((getQHeapLimit()-getQHeapAcum()-getQHeap1Shot())>getQHeap1Shot()) &&
                ((getQCalloutLimit()-getQCalloutAcum()-getQCallout1Shot())>getQCallout1Shot());
        }
    }
    
}