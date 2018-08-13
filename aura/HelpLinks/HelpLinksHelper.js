({
    setJSON : function () {

		return {
                "title"        : $A.get("$Label.et4ae5.hlpLnks"),
                "description"  : $A.get("$Label.et4ae5.description"),
                "entries" : [
                    {
                        "url" : "#",
                        "title" : $A.get("$Label.et4ae5.forgotJSON"),
                        "description" : $A.get("$Label.et4ae5.diffJSON")
                    },
                ]
            };
    }
})