public class apexResponsWrapper{

    public ListaInfoPagos listaInfoPagos;
    public Integer cantidadItemsConsulta;
    public Integer referenciaItemPaginado;
    public Integer cantidadMaxConsulta;

    public class Impuestos {
        public String codImpuesto;
        public String importeImpuestoAplicado;
    }

    public class ListaDatosAdicionales {
        public List<DatosAdicionales> datosAdicionales;
    }

    public class UserReversa {
        public String codUsuario;
        public String codGerencia;
    }

    public class ElementoInfoCambioBalance {
        public String codTipoBalance;
        public String codBalance;
        public String nombreBalance;
        public String saldoBalance;
        public NuevoBal nuevoBal;
        public String codMoneda;
    }

    public class InfoVoucher {
        public String numeroSerie;
    }

    public class CicloVida {
        public List<ListaStatusCicloVidaAnt> listaStatusCicloVidaAnt;
        public List<ListaStatusCicloVidaAnt> ListaStatusCicloVida;
    }

    public class ListaDetallesPagos {
        public List<DetallePago> detallePago;
    }

    public class ListaBalances {
        public List<ListaUnidadLibre_Z> listaUnidadLibre;
    }

    public class ListaStatusCicloVidaAnt {
        public String descripcionEstadoSuscripcion;
        public String fechaExpiracionSuscripcion;
        public String estadoSuscripcion;
    }

    public class ListaUnidadesLibres {
        public List<ListaUnidadLibre> listaUnidadLibre;
    }

    public class DatosAdicionales {
        public String nombreParametro;
        public String valorParametro;
    }

    public class InfoCambioBalance {
        public List<ElementoInfoCambioBalance> elementoInfoCambioBalance;
    }

    public class InfoPago {
        public String idCuenta;
        public String idCliente;
        public String codSuscripcion;
        public String identificadorRecurso;
        public String txId;
        public String tipoTransaccionPago;
        public String fechaAplicacionPago;
        public String importePago;
        public String codMoneda;
        public MonedaExtranjera monedaExtranjera;
        public String tasaDeCambio;
        public ListaDetallesPagos listaDetallesPagos;
        public String codMedioPago;
        public String codMotivoRecarga;
        public InfoVoucher infoVoucher;
        public InfoBanco infoBanco;
        public String codCanal;
        public String modoAcceso;
        public String estadoPago;
        public String codRespuesta;
        public String codUsuario;
        public String codGerencia;
        public UserReversa userReversa;
        public String periodoTiempo;
        public CicloVida cicloVida;
        public InfoCambioBalance infoCambioBalance;
        public InfoRecargaBonus infoRecargaBonus;
        public ListaDatosAdicionales listaDatosAdicionales;
        public String montoValidadoPago;
        public String saldoBalance;
        public String importeImpuestoAplicado;
        public String codPuntoDeVenta;
    }

    public class NuevoBal {
        public String saldoBalance;
    }

    public class ListaUnidadLibre_Z {
        public String codTipoBalance;
        public String codBalance;
        public String nombreBalance;
        public String cantUnidadesLibres;
        public String codMoneda;
        public String fechaVigenciaDesdeProdAdq;
        public String fechaVigenciaHastaProdAdq;
    }

    public class InfoBanco {
        public String codEntidadFinanciera;
        public String codSucursalEntidad;
        public String codMedioPago;
        public String ultimosDigitosTarjeta;
        public String codEntidadTC;
        public String nombreEntidadFinanciera;
        public String fechaVencimientoTarjeta;
        public String codSeguridadTarjeta;
        public String nroCheque;
        public String fechaEmisionCheque;
        public Integer cantidadCuotasTarjeta;
    }

    public class InfoRecargaBonus {
        public ListaUnidadesLibres listaUnidadesLibres;
        public ListaBalances listaBalances;
    }

    public class ListaUnidadLibre {
        public String codPaqueteUnidadesLibres;
        public String codUsoUnidadesLibres;
        public String descUsoUnidadesLibres;
        public String codUnidadDeMedida;
        public String descUnidadMedida;
        public String cantUnidadesLibres;
        public String fechaVigenciaDesdeProdAdq;
        public String fechaVigenciaHastaProdAdq;
    }

    public class DetallePago {
        public String tipoPago;
        public String montoCuotaConvenioCta;
        public String numeroComprobante;
        public String codComprobante;
        public String tipoItemComprobante;
        public String codCargo;
        public String importeComprobante;
        public ListaImpuestos listaImpuestos;
        public String montoDescuentoPrecioProducto;
    }

    public class ListaInfoPagos {
        public List<InfoPago> infoPago;
    }

    public class MonedaExtranjera {
        public String importePago;
        public String codMoneda;
    }

    public class ListaImpuestos {
        public List<Impuestos> impuestos;
    }

    
    public static apexResponsWrapper parse(String json) {
        return (apexResponsWrapper) System.JSON.deserialize(json, apexResponsWrapper.class);
    }
     public static list<apexResponsWrapper.ListaInfoPagos>  parse2(String json) {
        return (list<apexResponsWrapper.ListaInfoPagos> ) System.JSON.deserialize(json,apexResponsWrapper.ListaInfoPagos.class);
    }
}