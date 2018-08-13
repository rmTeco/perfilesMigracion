public with sharing class IntegrationUtils {

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the body that will be passed to the request for the customer creation.
     */
    public static String createBodyCustomerCreation(Account account) {
        Map<String, Object> bodyMap = new Map<String, Object>();
        Map<String, Object> accountMap = new Map<String, Object>();

        String codCliente = String.valueOf(account.CustomerIntegrationId__c);

        Map<String, Object> clientMap = customerCreationClientNode(account);

        Map<String, Object> cuentaMap = customerCreationAccountNode(account);

        List<Map<String, Object>> direccionList = customerCreationAddressNode(account);

        bodyMap.put('codCliente', codCliente);
        bodyMap.put('cliente', clientMap);
        bodyMap.put('cuenta', cuentaMap);
        bodyMap.put('direccion', direccionList);

        return JSON.serialize(bodyMap);
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the body that will be passed to the request for the Billing Account creation.
     */
    public static String createBodyBillingAccountCreation(Account account) {
        Map<String, Object> bodyMap = new Map<String, Object>();
        Map<String, Object> accountMap = new Map<String, Object>();

        Map<String, Object> cuentaMap = billingAccountCreationAccountNode(account);

        Map<String, Object> direccionMap = billingAccountCreationAddressNode(account);

        bodyMap.put('cuenta', cuentaMap);
        bodyMap.put('direccion', direccionMap);

        return JSON.serialize(bodyMap);
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the Client Node of the Body for the Customer Creation.
     */
    private static Map<String, Object> customerCreationClientNode(Account account) {
        Map<String, Object> clientMap = new Map<String, Object>();
        Map<String, Object> infoClientMap = new Map<String, Object>();
        String idCliente = account.Id;
        String tipoCliente = account.Type;
        String tipoNodoCliente;
        String codCliente = String.valueOf(account.CustomerIntegrationId__c);
        infoClientMap.put('idCliente', idCliente);
        infoClientMap.put('tipoCliente', tipoCliente);
        infoClientMap.put('tipoNodoCliente', tipoNodoCliente);
        infoClientMap.put('codCliente', codCliente);

        Map<String, Object> infoClientPadreMap = new Map<String, Object>();
        String idClientePadre = account.ParentId;
        infoClientPadreMap.put('idCliente', idClientePadre);
        infoClientMap.put('infoClientepadre', infoClientPadreMap);

        Map<String, Object> infoBasicaClienteMap = new Map<String, Object>();
        String tipoCicloFacturacion;
        String codAccionMoroATomar;
        infoBasicaClienteMap.put('tipoCicloFacturacion', tipoCicloFacturacion);
        infoBasicaClienteMap.put('codAccionarMoroATomar', codAccionMoroATomar);
        List<Map<String, Object>> listaDatosAdicionales = new List<Map<String, Object>>();
        Map<String, Object> mapDatosAdicionales = new Map<String, Object>();
        String nombreParametro;
        String valorParametro;
        mapDatosAdicionales.put('nombreParametro', nombreParametro);
        mapDatosAdicionales.put('valorParametro', valorParametro);
        listaDatosAdicionales.add(mapDatosAdicionales);
        infoBasicaClienteMap.put('listaDatosAdicionales', listaDatosAdicionales);

        infoClientMap.put('infoBasicaCliente', infoBasicaClienteMap);
        clientMap.put('infoCliente', infoClientMap);


        Map<String, Object> infoIndividuoMap = new Map<String, Object>();
        String tipoDocumento = account.DocumentType__c;
        String numeroDocumento = account.DocumentNumber__c;
        String fechaValidezDocumento;
        String tituloCortesia = account.vlocity_cmt__PrimaryContactId__r.Title;
        String nombre = account.vlocity_cmt__PrimaryContactId__r.FirstName;
        String segundoNombre;
        String apellido = account.vlocity_cmt__PrimaryContactId__r.LastName;
        String idDireccion;
        String genero = account.vlocity_cmt__PrimaryContactId__r.Gender__c;
        String codPais;
        String profesion;
        String fechaNacimiento = String.valueOf(account.vlocity_cmt__PrimaryContactId__r.Birthdate);

        Map<String, Object> lugarDeNacimientoMap = new Map<String, Object>();
        String codPaisLugarNac;
        lugarDeNacimientoMap.put('codPais', codPaisLugarNac);

        String estadoCivil;
        String nivelEducacion;
        String numeroTelefono = account.vlocity_cmt__PrimaryContactId__r.Phone;

        Map<String, Object> numeroContacto = new Map<String, Object>();
        String numeroTelefonoContacto;
        numeroContacto.put('numeroTelefono', numeroTelefonoContacto);

        String numeroTelefonoAlternativo = account.vlocity_cmt__PrimaryContactId__r.MobilePhone;
        String numeroFax = account.vlocity_cmt__PrimaryContactId__r.Fax;
        String direccionEmail = account.vlocity_cmt__PrimaryContactId__r.Email;
        infoIndividuoMap.put('tipoDocumento', tipoDocumento);
        infoIndividuoMap.put('numeroDocumento', numeroDocumento);
        infoIndividuoMap.put('fechaValidezDocumento', fechaValidezDocumento);
        infoIndividuoMap.put('tituloCortesia', tituloCortesia);
        infoIndividuoMap.put('nombre', nombre);
        infoIndividuoMap.put('segundoNombre', segundoNombre);
        infoIndividuoMap.put('apellido', apellido);
        infoIndividuoMap.put('idDireccion', idDireccion);
        infoIndividuoMap.put('genero', genero);
        infoIndividuoMap.put('codPais', codPais);
        infoIndividuoMap.put('profesion', profesion);
        infoIndividuoMap.put('fechaNacimiento', fechaNacimiento);
        infoIndividuoMap.put('lugarDeNacimiento', lugarDeNacimientoMap);
        infoIndividuoMap.put('estadoCivil', estadoCivil);
        infoIndividuoMap.put('nivelEducacion', nivelEducacion);
        infoIndividuoMap.put('numeroTelefono', numeroTelefono);
        infoIndividuoMap.put('numeroContacto', numeroContacto);
        infoIndividuoMap.put('numeroTelefonoAlternativo', numeroTelefonoAlternativo);
        infoIndividuoMap.put('numeroFax', numeroFax);
        infoIndividuoMap.put('direccionEmail', direccionEmail);

        clientMap.put('infoIndividuo', infoIndividuoMap);


        Map<String, Object> infoEmpresaMap = new Map<String, Object>();
        String razonSocial;
        String nombreFantasia;
        String idDireccionEmpresa;
        String tipoOrganizacion;
        String sectorActividad;
        String numeroTelefonoEmpresa = account.Phone;
        String numeroFaxEmpresa = account.Fax;
        String direccionEmailEmpresa;
        String web;
        infoEmpresaMap.put('razonSocial', razonSocial);
        infoEmpresaMap.put('nombreFantasia', nombreFantasia);
        infoEmpresaMap.put('idDireccion', idDireccionEmpresa);
        infoEmpresaMap.put('tipoOrganizacion', tipoOrganizacion);
        infoEmpresaMap.put('sectorActividad', sectorActividad);
        infoEmpresaMap.put('numeroTelefono', numeroTelefonoEmpresa);
        infoEmpresaMap.put('numeroFax', numeroFaxEmpresa);
        infoEmpresaMap.put('direccionEmail', direccionEmailEmpresa);
        infoEmpresaMap.put('web', web);

        clientMap.put('infoEmpresa', infoEmpresaMap);

        return clientMap;
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the Account Node of the Body for the Customer Creation.
     */
    private static Map<String, Object> customerCreationAccountNode(Account account) {
        Map<String, Object> cuentaMap = new Map<String, Object>();
        String idRelacionPago;
        String idCuenta = account.Id;

        Map<String, Object> infoCuentaMap = new Map<String, Object>();
        String codCuenta = String.valueOf(account.CustomerIntegrationId__c);
        String idCliente = account.Id;

        Map<String, Object> infoBasicaCuenta = new Map<String, Object>();
        String codAccionMoroATomar;
        String marcaCargoTardio;
        String marcaControlLimite;

        Map<String, Object> datosDeContacto = new Map<String, Object>();
        String tituloCortesia = account.vlocity_cmt__PrimaryContactId__r.Title;
        String nombre = account.vlocity_cmt__PrimaryContactId__r.FirstName;
        String segundoNombre;
        String apellido = account.vlocity_cmt__PrimaryContactId__r.LastName;
        String idDireccion;
        String numeroTelefono = account.vlocity_cmt__PrimaryContactId__r.Phone;

        Map<String, Object> numeroContacto = new Map<String, Object>();
        String numeroTelefonoContacto;
        numeroContacto.put('numeroTelefono', numeroTelefonoContacto);

        String numeroTelefonoAlternativo = account.vlocity_cmt__PrimaryContactId__r.MobilePhone;
        String direccionEmail = account.vlocity_cmt__PrimaryContactId__r.Email;
        String numeroFax = account.vlocity_cmt__PrimaryContactId__r.Fax;
        datosDeContacto.put('tituloCortesia', tituloCortesia);
        datosDeContacto.put('nombre', nombre);
        datosDeContacto.put('segundoNombre', segundoNombre);
        datosDeContacto.put('apellido', apellido);
        datosDeContacto.put('idDireccion', idDireccion);
        datosDeContacto.put('numeroTelefono', numeroTelefono);
        datosDeContacto.put('numeroContacto', numeroContacto);
        datosDeContacto.put('numeroTelefonoAlternativo', numeroTelefonoAlternativo);
        datosDeContacto.put('direccionEmail', direccionEmail);
        datosDeContacto.put('numeroFax', numeroFax);

        Map<String, Object> tipoFactura = new Map<String, Object>();
        String tipoNotioficacion;
        String marcaCargoInteraccionNegocio;
        tipoFactura.put('tipoNotificacion', tipoNotioficacion);
        tipoFactura.put('marcaCargoInteraccionNegocio', marcaCargoInteraccionNegocio);

        List<Map<String, Object>> listaDatosAdicionales = new List<Map<String, Object>>();
        Map<String, Object> mapDatosAdicionales = new Map<String, Object>();
        String nombreParametro;
        String valorParametro;
        mapDatosAdicionales.put('nombreParametro', nombreParametro);
        mapDatosAdicionales.put('valorParametro', valorParametro);
        listaDatosAdicionales.add(mapDatosAdicionales);

        infoBasicaCuenta.put('codAccionMoroATomar', codAccionMoroATomar);
        infoBasicaCuenta.put('marcaCargoTardio', marcaCargoTardio);
        infoBasicaCuenta.put('marcaControlLimite', marcaControlLimite);
        infoBasicaCuenta.put('datosDeContacto', datosDeContacto);
        infoBasicaCuenta.put('tipoFactura', tipoFactura);
        infoBasicaCuenta.put('listaDatosAdicionales', listaDatosAdicionales);

        String tipoCicloFacturacion;
        String claseCuenta;
        String condicionPago;
        String saldoBalance;

        Map<String, Object> listaLimiteDeCreditoMap = new Map<String, Object>();
        List<Map<String, Object>> listaLimiteDeCredito = new List<Map<String, Object>>();
        Map<String, Object> mapaLimiteDeCredito = new Map<String, Object>();
        String tipoPerfilCrediticio;
        String limiteCreditoOriginal;
        mapaLimiteDeCredito.put('tipoPerfilCrediticio', tipoPerfilCrediticio);
        mapaLimiteDeCredito.put('limiteCreditoOriginal', limiteCreditoOriginal);
        listaLimiteDeCredito.add(mapaLimiteDeCredito);
        listaLimiteDeCreditoMap.put('listaLimiteDeCredito', listaLimiteDeCredito);

        Map<String, Object> pagoMap = new Map<String, Object>();
        String codPago;

        Map<String, Object> infoCanalDePago = new Map<String, Object>();
        String codEntidadFinanciera;
        String codSucursalEntidad;
        String codMedioPago;
        String codEntidadTC;
        String ultimosDigitosTarjeta;
        String nombreEntidadFinanciera;
        String codSeguridadTarjeta;
        String fechaVencimientoTarjeta;
        String prioridad;

        List<Map<String, Object>> listaCodigosCargo = new List<Map<String, Object>>();
        Map<String, Object> mapaCodigosCargo = new Map<String, Object>();
        String codCargo;
        mapaCodigosCargo.put('codCargo', codCargo);
        listaCodigosCargo.add(mapaCodigosCargo);

        Map<String, Object> listaPlanesDePagoMap = new Map<String, Object>();
        List<Map<String, Object>> planDePagoList = new List<Map<String, Object>>();
        Map<String, Object> mapPlanDePago = new Map<String, Object>();
        String tipoPago;
        mapPlanDePago.put('tipoPago', tipoPago);
        planDePagoList.add(mapPlanDePago);
        listaPlanesDePagoMap.put('PlanDePago', planDePagoList);

        infoCanalDePago.put('codEntidadFinanciera', codEntidadFinanciera);
        infoCanalDePago.put('codSucursalEntidad', codSucursalEntidad);
        infoCanalDePago.put('codMedioPago', codMedioPago);
        infoCanalDePago.put('codEntidadTC', codEntidadTC);
        infoCanalDePago.put('ultimosDigitosTarjeta', ultimosDigitosTarjeta);
        infoCanalDePago.put('nombreEntidadFinanciera', nombreEntidadFinanciera);
        infoCanalDePago.put('codSeguridadTarjeta', codSeguridadTarjeta);
        infoCanalDePago.put('fechaVencimientoTarjeta', fechaVencimientoTarjeta);
        infoCanalDePago.put('prioridad', prioridad);
        infoCanalDePago.put('listaCodigosCargo', listaCodigosCargo);
        infoCanalDePago.put('listaPlanesDePago', listaPlanesDePagoMap);

        pagoMap.put('codPago', codPago);
        pagoMap.put('infoCanalDePago', infoCanalDePago);

        infoCuentaMap.put('codCuenta', codCuenta);
        infoCuentaMap.put('idCliente', idCliente);
        infoCuentaMap.put('idCuenta', idCuenta);
        infoCuentaMap.put('infoBasicaCuenta', infoBasicaCuenta);
        infoCuentaMap.put('tipoCicloFacturacion', tipoCicloFacturacion);
        infoCuentaMap.put('claseCuenta', claseCuenta);
        infoCuentaMap.put('condicionPago', condicionPago);
        infoCuentaMap.put('saldoBalance', saldoBalance);
        infoCuentaMap.put('listaLimiteDeCredito', listaLimiteDeCreditoMap);
        infoCuentaMap.put('pago', pagoMap);

        cuentaMap.put('idRelacionPago', idRelacionPago);
        cuentaMap.put('idCuenta', idCuenta);
        cuentaMap.put('infoCuenta', infoCuentaMap);

        return cuentaMap;
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the Address Node of the Body for the Customer Creation.
     */
    private static List<Map<String, Object>> customerCreationAddressNode(Account account) {
        List<Map<String, Object>> direccionList = new List<Map<String, Object>>();
        Map<String, Object> mapDireccion = new Map<String, Object>();
        String idDireccion;
        String provincia;
        String localidad;
        String municipio;
        String barrio;
        String calle;
        String descipcionTipo;
        String sector;
        String descripcion;
        String comentario;
        String sucursalCasilla;
        String codigoPostal;
        mapDireccion.put('idDireccion', idDireccion);
        mapDireccion.put('provincia', provincia);
        mapDireccion.put('localidad', localidad);
        mapDireccion.put('municipio', municipio);
        mapDireccion.put('barrio', barrio);
        mapDireccion.put('calle', calle);
        mapDireccion.put('descipcionTipo', descipcionTipo);
        mapDireccion.put('sector', sector);
        mapDireccion.put('descripcion', descripcion);
        mapDireccion.put('comentario', comentario);
        mapDireccion.put('sucursalCasilla', sucursalCasilla);
        mapDireccion.put('codigoPostal', codigoPostal);
        direccionList.add(mapDireccion);

        return direccionList;
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the Account Node of the Body for the Billing Account Creation.
     */
    private static Map<String, Object> billingAccountCreationAccountNode(Account account) {
        Map<String, Object> cuentaMap = new Map<String, Object>();
        String idCuenta = account.Id;

        Map<String, Object> infoCuentaMap = new Map<String, Object>();
        String codCuenta = account.AccountIntegrationId__c;
        String idCliente = account.Id;
        String idCuentaInfoCuenta = account.Id;

        Map<String, Object> infoBasicaCuenta = new Map<String, Object>();
        String codAccionMoroATomar;
        String marcaCargoTardio;
        String marcaControlLimite;

        Map<String, Object> datosDeContacto = new Map<String, Object>();
        String tituloCortesia = account.vlocity_cmt__PrimaryContactId__r.Title;
        String nombre = account.vlocity_cmt__PrimaryContactId__r.FirstName;
        String segundoNombre;
        String apellido = account.vlocity_cmt__PrimaryContactId__r.LastName;
        String idDireccion;
        String numeroTelefono = account.vlocity_cmt__PrimaryContactId__r.Phone;

        Map<String, Object> numeroContacto = new Map<String, Object>();
        String numeroTelefonoContacto;
        numeroContacto.put('numeroTelefono', numeroTelefonoContacto);

        String numeroTelefonoAlternativo = account.vlocity_cmt__PrimaryContactId__r.MobilePhone;
        String direccionEmail = account.vlocity_cmt__PrimaryContactId__r.Email;
        String numeroFax = account.vlocity_cmt__PrimaryContactId__r.Fax;
        datosDeContacto.put('tituloCortesia', tituloCortesia);
        datosDeContacto.put('nombre', nombre);
        datosDeContacto.put('segundoNombre', segundoNombre);
        datosDeContacto.put('apellido', apellido);
        datosDeContacto.put('idDireccion', idDireccion);
        datosDeContacto.put('numeroTelefono', numeroTelefono);
        datosDeContacto.put('numeroContacto', numeroContacto);
        datosDeContacto.put('numeroTelefonoAlternativo', numeroTelefonoAlternativo);
        datosDeContacto.put('direccionEmail', direccionEmail);
        datosDeContacto.put('numeroFax', numeroFax);

        Map<String, Object> tipoFactura = new Map<String, Object>();
        String tipoNotioficacion;
        String marcaCargoInteraccionNegocio;
        tipoFactura.put('tipoNotificacion', tipoNotioficacion);
        tipoFactura.put('marcaCargoInteraccionNegocio', marcaCargoInteraccionNegocio);

        List<Map<String, Object>> listaDatosAdicionales = new List<Map<String, Object>>();
        Map<String, Object> mapDatosAdicionales = new Map<String, Object>();
        String nombreParametro;
        String valorParametro;
        mapDatosAdicionales.put('nombreParametro', nombreParametro);
        mapDatosAdicionales.put('valorParametro', valorParametro);
        listaDatosAdicionales.add(mapDatosAdicionales);

        infoBasicaCuenta.put('codAccionMoroATomar', codAccionMoroATomar);
        infoBasicaCuenta.put('marcaCargoTardio', marcaCargoTardio);
        infoBasicaCuenta.put('marcaControlLimite', marcaControlLimite);
        infoBasicaCuenta.put('datosDeContacto', datosDeContacto);
        infoBasicaCuenta.put('tipoFactura', tipoFactura);
        infoBasicaCuenta.put('datosAdicionales', listaDatosAdicionales);

        String tipoCicloFacturacion;
        String claseCuenta;
        String condicionPago;
        String saldoBalance;

        Map<String, Object> listaLimiteDeCreditoMap = new Map<String, Object>();
        List<Map<String, Object>> listaLimiteDeCredito = new List<Map<String, Object>>();
        Map<String, Object> mapaLimiteDeCredito = new Map<String, Object>();
        String tipoPerfilCrediticio;
        String limiteCreditoOriginal;
        mapaLimiteDeCredito.put('tipoPerfilCrediticio', tipoPerfilCrediticio);
        mapaLimiteDeCredito.put('limiteCreditoOriginal', limiteCreditoOriginal);
        listaLimiteDeCredito.add(mapaLimiteDeCredito);
        listaLimiteDeCreditoMap.put('limiteDeCredito', listaLimiteDeCredito);

        Map<String, Object> pagoMap = new Map<String, Object>();
        String codFormaPago;

        List<Map<String, Object>> listaCanalesDePago = new List<Map<String, Object>>();
        Map<String, Object> mapCanalesDePago = new Map<String, Object>();
        String codPago;

        Map<String, Object> infoCanalDePago = new Map<String, Object>();
        String codEntidadFinanciera;
        String codSucursalEntidad;
        String codMedioPago;
        String codEntidadTC;
        String ultimosDigitosTarjeta;
        String nombreEntidadFinanciera;
        String codSeguridadTarjeta;
        String fechaVencimientoTarjeta;
        String prioridad;

        List<Map<String, Object>> listaCodigosCargo = new List<Map<String, Object>>();
        Map<String, Object> mapaCodigosCargo = new Map<String, Object>();
        String codCargo;
        mapaCodigosCargo.put('codCargo', codCargo);
        listaCodigosCargo.add(mapaCodigosCargo);

        List<Map<String, Object>> listaPlanesDePagoList = new List<Map<String, Object>>();
        Map<String, Object> mapPlanDePago = new Map<String, Object>();
        String tipoPago;
        mapPlanDePago.put('tipoPago', tipoPago);

        List<Map<String, Object>> listaEsquemas = new List<Map<String, Object>>();
        Map<String, Object> mapEsquemas = new Map<String, Object>();
        Map<String, Object> esquemaBasadoEnCicloDeFacturacion = new Map<String, Object>();
        String diaImputacionPago;
        String montoMaximoDebito;
        esquemaBasadoEnCicloDeFacturacion.put('diaImputacionPago', diaImputacionPago);
        esquemaBasadoEnCicloDeFacturacion.put('montoMaximoDebito', montoMaximoDebito);
        Map<String, Object> esquemaBasadoEnTiempo = new Map<String, Object>();
        String periodoTiempo;
        String diaImputacionPagoTiempo;
        String montoRecarga;
        esquemaBasadoEnTiempo.put('periodoTiempo', periodoTiempo);
        esquemaBasadoEnTiempo.put('diaImputacionPago', diaImputacionPagoTiempo);
        esquemaBasadoEnTiempo.put('montoRecarga', montoRecarga);
        Map<String, Object> esquemaBasadoEnBlance = new Map<String, Object>();
        String montoRecargaMin;
        String montoRecargaBlance;
        String periodoTiempoBlance;
        String numeroDeRecarga;
        esquemaBasadoEnBlance.put('montoRecargaMin', montoRecargaMin);
        esquemaBasadoEnBlance.put('montoRecarga', montoRecargaBlance);
        esquemaBasadoEnBlance.put('periodoTiempo', periodoTiempoBlance);
        esquemaBasadoEnBlance.put('numeroDeRecarga', numeroDeRecarga);

        mapEsquemas.put('esquemaBasadoEnCicloDeFacturacion', esquemaBasadoEnCicloDeFacturacion);
        mapEsquemas.put('esquemaBasadoEnTiempo', esquemaBasadoEnTiempo);
        mapEsquemas.put('esquemaBasadoEnBlance', esquemaBasadoEnBlance);
        listaEsquemas.add(mapEsquemas);
        mapPlanDePago.put('listaEsquemas', listaEsquemas);
        listaPlanesDePagoList.add(mapPlanDePago);

        infoCanalDePago.put('codEntidadFinanciera', codEntidadFinanciera);
        infoCanalDePago.put('codSucursalEntidad', codSucursalEntidad);
        infoCanalDePago.put('codMedioPago', codMedioPago);
        infoCanalDePago.put('codEntidadTC', codEntidadTC);
        infoCanalDePago.put('ultimosDigitosTarjeta', ultimosDigitosTarjeta);
        infoCanalDePago.put('nombreEntidadFinanciera', nombreEntidadFinanciera);
        infoCanalDePago.put('codSeguridadTarjeta', codSeguridadTarjeta);
        infoCanalDePago.put('fechaVencimientoTarjeta', fechaVencimientoTarjeta);
        infoCanalDePago.put('prioridad', prioridad);
        infoCanalDePago.put('listaCodigosCargo', listaCodigosCargo);
        infoCanalDePago.put('listaPlanesDePago', listaPlanesDePagoList);

        mapCanalesDePago.put('infoCanalDePago', infoCanalDePago);
        mapCanalesDePago.put('codPago', codPago);
        listaCanalesDePago.add(mapCanalesDePago);

        pagoMap.put('codFormaPago', codFormaPago);
        pagoMap.put('listaCanalesDePago', listaCanalesDePago);

        infoCuentaMap.put('codCuenta', codCuenta);
        infoCuentaMap.put('idCliente', idCliente);
        infoCuentaMap.put('idCuenta', idCuentaInfoCuenta);
        infoCuentaMap.put('infoBasicaCuenta', infoBasicaCuenta);
        infoCuentaMap.put('tipoCicloFacturacion', tipoCicloFacturacion);
        infoCuentaMap.put('claseCuenta', claseCuenta);
        infoCuentaMap.put('condicionPago', condicionPago);
        infoCuentaMap.put('saldoBalance', saldoBalance);
        infoCuentaMap.put('limiteDeCredito', listaLimiteDeCreditoMap);
        infoCuentaMap.put('pago', pagoMap);

        cuentaMap.put('idCuenta', idCuenta);
        cuentaMap.put('infoCuenta', infoCuentaMap);

        return cuentaMap;
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to create the Address Node of the Body for the Billing Account Creation.
     */
    private static Map<String, Object> billingAccountCreationAddressNode(Account account) {
        Map<String, Object> direccionMap = new Map<String, Object>();
        String idDireccion;
        String provincia;
        String localidad;
        String municipio;
        String barrio;
        String calle;
        String descripcionTipo;
        String sector;
        String descripcion;
        String comentario;
        String sucursalCasilla;
        String codigoPostal;
        direccionMap.put('idDireccion', idDireccion);
        direccionMap.put('provincia', provincia);
        direccionMap.put('localidad', localidad);
        direccionMap.put('municipio', municipio);
        direccionMap.put('barrio', barrio);
        direccionMap.put('calle', calle);
        direccionMap.put('descripcionTipo', descripcionTipo);
        direccionMap.put('sector', sector);
        direccionMap.put('descripcion', descripcion);
        direccionMap.put('comentario', comentario);
        direccionMap.put('sucursalCasilla', sucursalCasilla);
        direccionMap.put('codigoPostal', codigoPostal);

        return direccionMap;
    }

    public static String ParseSalutation(String salesforceSalutation){
        String huaweiSalutation;

        if(salesforceSalutation == 'Mrs'){
            huaweiSalutation = '2';
        }  
        else if (salesforceSalutation == 'Ms') {
            huaweiSalutation = '3';
        } else {
            huaweiSalutation = '1';
        }

        return huaweiSalutation;
    }
    
    public static String ParseGender(String salesforceGender){
        String ret = null;
        if(salesforceGender != null){
            ret = salesforceGender.substring(0,1);
        }
        return ret;
    }

    public static String ParseDocumentType(String salesforceDocumentType){
        // SF > HW
        // DNI > DNI
        // CUIL > CUIL
        // Libreta de Enrolamiento  LEN > LE
        // Libreta Civica   LCV > LC
        // Pasaporte    PAS > PASAPORTE
        // Cedula de Identidad  CID > CI

        String huaweiDocumentType;

        if(salesforceDocumentType == 'CID'){
            huaweiDocumentType = 'CI';
        }  
        else if (salesforceDocumentType == 'PAS') {
            huaweiDocumentType = 'PASAPORTE';
        }  
        else if (salesforceDocumentType == 'LCV') {
            huaweiDocumentType = 'LC';
        }  
        else if (salesforceDocumentType == 'LEN') {
            huaweiDocumentType = 'LE';
        } else {
            huaweiDocumentType = salesforceDocumentType;
        }
        

        return huaweiDocumentType;
    }

    public static String ParseAmount(Decimal amount){
        String ret = '0.0000';
        // 4 decimales
        if(amount != null){
            ret = String.valueOf(amount.setScale(4));
        }
        
        return ret;
    }

    public static String ParseInvoiceType(String invoiceType){
        InvoiceTypeHuawei__c customSetting = InvoiceTypeHuawei__c.getInstance('InvoiceTypeHuawei');
        return String.valueOf(customSetting.get(invoiceType + '__c'));
    }

    public static String ParseDateTime(Datetime fecha){
        String ret = '';
        if(fecha != null){
            ret = fecha.format('YYYY-MM-dd hh:mm:ss');
        }
        return ret;
    }

    //Parameteres
    //linesToUpdate: Map<Linea,Accion>
    public static String GenerateBodyS326(Map<String, String> linesToUpdate){
        Integer cantLineasCargadas = 0;
        String idUnicoTransaccion = GuidUtil.NewGuid();
        System.debug('IntegrationUtils:idUnicoTransaccion: ' + idUnicoTransaccion);
        String body = '{"params":{ "X-Consumer-Transaction-ID": "'+idUnicoTransaccion+'"}, "body" :{"ListaNumeros": [';
        for(String linea : linesToUpdate.KeySet())
        {
            if (cantLineasCargadas > 0) body += ',';
            body += '{"nroLinea":"' + linea + '", "Accion":"' + linesToUpdate.get(linea) + '"}';
            cantLineasCargadas++;
        }
        body += ']}}';
        System.debug('GenerateBodyS326:body: ' + body);
        return body;
    }

    public static String ParseFabricacion(String epcFabricacion){
        // Nacional > NAC
        // IMPORTADO > IMP
        // Tierra del Fuego > TDF
        
        String huaweiFabricacion;

        if(epcFabricacion == 'Nacional'){
            huaweiFabricacion = 'NAC';
        }  
        else if (epcFabricacion == 'Internacional') {
            huaweiFabricacion = 'IMP';
        }  
        else if (epcFabricacion == 'Tierra del Fuego') {
            huaweiFabricacion = 'TDF';
        } else {
            huaweiFabricacion = epcFabricacion;
        }

        return huaweiFabricacion;
    }

    public static String ParseCodMedioPago(String codMedioPago){
        //Código Velocity	Código Legado	Descripción
        //TAR	            C	            Tarjeta de crédito
        //DEB	            D	            Tarjeta de débito
        String codVlocity; 

        if(codMedioPago == '2001'){
            codVlocity = 'TAR';
        }  
        else if (codMedioPago == '4001') {
            codVlocity = 'DEB';
        }  
        else if (codMedioPago == '4002') {
            codVlocity = 'DEB';
        }

        return codVlocity;
    }
}