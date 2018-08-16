({
    doInit: function (cmp, event, helper) {
        cmp.set('v.gridColumns', [
            {label: 'Equipo a Seleccionar', fieldName: 'teamName', type: 'text'},
            ]);
        helper.getHierarchyWorkTeam(cmp);
    },
    handleSave: function (cmp, event, helper) {
        helper.saveHierarchyPermission(cmp);
    },
    getSelectedRow: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
            //LLENAR UN ARRAY PARA CONTROLAR EL CAMBIO DE ESTADO DE CADA ROW
        }
    }          
})