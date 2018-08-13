@isTest
private class xOMReproPostImportReportControllerTest {
    
    @isTest static void test_method_one() {
        Test.startTest();
        xOMReproPostImportReportController controller = new xOMReproPostImportReportController();
        Date d1 = controller.startDate;
        Date d2 = controller.endDate;
        xOMReproPostImportReportController.xOMReproJobLoteResults reproLinesLoteDetail = controller.reproLinesLoteDetail;
        List<SelectOption> wholesaleAccounts = controller.getWholesaleAccounts();
        List<xOMReproPostImportReportController.xOMReproJobLoteResults> reproLines = controller.reproLines;
        for(xOMReproPostImportReportController.xOMReproJobLoteResults reproLine : reproLines) {
            String s1 = reproLine.wholesaleAccount;
            String s2 = reproLine.wholesaleName;
            String s3 = reproLine.loteId;
            Integer i1 = reproLine.totalLineas;
            Integer i2 = reproLine.ordenesFallidas;
            Integer i3 = reproLine.ordenesCreadas;
            Integer i4 = reproLine.ordenesConProductos;
            Integer i5 = reproLine.ordenesDescompuestas;
            Integer i6 = reproLine.ordenesActivadas;
            String s4 = reproLine.initTimestamp;
            String s5 = reproLine.endTimestamp;
            controller.selectedLoteId = reproLine.loteId;
            controller.getLoteDetail();
            List<xOMReproPostImportReportController.xOMReproJobLoteResultsDetail> listOfLines = reproLine.listOfLines;
            for(xOMReproPostImportReportController.xOMReproJobLoteResultsDetail line : listOfLines) {
                String sl1 = line.statusOrden;
                String sl2 = line.ordenCreada;
                String sl3 = line.productosAdded;
                String sl4 = line.ordenDescompuesta;
                String sl5 = line.ordenActivada;
                String sl6 = line.ordenFallida;
                String sl7 = line.mensaje;
                String sl8 = line.registro;
                String sl9 = line.orden;
                String sl10 = line.orchPlanId;
            }
            
        }

        Test.stopTest();
    }
    
    @isTest static void test_method_two() {
        // Implement test code
    }
    
}