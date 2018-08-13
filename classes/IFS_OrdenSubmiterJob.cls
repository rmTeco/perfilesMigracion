/**
 * Esta clase es un batch job que debera esta agendado para
 * correr cada n minutos, por cada ejecucion realiza una
 * corrida batch del IFS_OrderSubmiter.
 * 
 * @Author: Alejandro Salord (Certa Consulting)
 * @Version: 1.0
 */
global with sharing class IFS_OrdenSubmiterJob implements Schedulable  {
    private boolean K_DEBUG_ON = false;

    public IFS_OrdenSubmiterJob() {
    }

    public IFS_OrdenSubmiterJob(Boolean pDebug) {
        K_DEBUG_ON = pDebug;

    }

    global void execute(SchedulableContext context){
         IFS_OrderSubmiter os = new IFS_OrderSubmiter(K_DEBUG_ON);
         Database.executebatch(os);
    }
}