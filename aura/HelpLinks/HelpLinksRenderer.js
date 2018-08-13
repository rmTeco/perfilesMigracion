({
		afterRender : function(component, event, helper) {
            var value = this.superAfterRender();
            var values = component.get("v.json");
            var entries = values.entries;
            var help_links = "";
            for (var obj in entries) {
                if(entries[obj].url !== undefined) {
                help_links += 
                        "<div class='help_link'>\
                            <a target='_blank' href=" + entries[obj].url + ">" + 
                            entries[obj].title + "</a>\
                            <p>" + entries[obj].description + "</p>\
                        </div>";                    
                }
            }
            var oLinks = component.find("oLinks");
            oLinks.set("v.value","");
            oLinks.set("v.value", help_links);
            return value;
        }
})