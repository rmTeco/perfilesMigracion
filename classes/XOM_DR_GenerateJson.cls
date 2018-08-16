global class XOM_DR_GenerateJson implements vlocity_cmt.VlocityOpenInterface2{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        try{
            Map<string, Object> jsonRecived;
            List<Map<string, Object>> jsonNodesToCreate = new List<Map<string, Object>>();
            List<Map<string, Object>> jsonToReturn = new List<Map<string, Object>>();
            List<Object> listOfMapElementsRecived = new List<Object>();
            Boolean nodeFound = false;
            //string strings;
            //List<string> listStrings = new List<string>();

            Map<string, object> mapFromRecivedJson = new Map<string, object>();
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            system.debug(arguments);
            jsonRecived = (Map<string, Object>)arguments[0];
            
            /*
            for(integer i = 1 ; i < arguments.size(); i++){
                strings += arguments[i];
            }

            for(string s : strings.split('|')){
                Map<string, object> mapa = new Map<string, object>();
                List<string>
                for(string str : s.split(',')){
                    mapa.put(str);
                }
                jsonNodesToCreate.add(mapa);
            }*/

            Map<string, Object> mapNodesToCreate = new Map<string, Object>();
            for(integer i = 1 ; i < arguments.size(); i++){       
                mapNodesToCreate.put( (((string)(arguments[i])).split(',')[0]) , (((string)(arguments[i])).split(',')[1]));
                if(arguments[i] == '|' && (i == arguments.size() -1) ){
                    jsonNodesToCreate.add(mapNodesToCreate);
                    mapNodesToCreate = new Map<string, Object>();
                }
                else if(i == arguments.size() -1){
                    jsonNodesToCreate.add(mapNodesToCreate);
                }
            }

            system.debug('mapNodesToCreate ' + jsonNodesToCreate);

            for(string obj : jsonRecived.keySet()){ //nodes from recived json
                for(object objElementFromJsonNodesToCreate : jsonNodesToCreate){ //List of map recived to be replaced
                    for(string objNodesToCreate: ((Map<string, object>)objElementFromJsonNodesToCreate).keySet()){  //nodes to replace
                        system.debug('obj '+ obj);
                        system.debug('jsonRecived '+ jsonRecived.get(obj));
                        system.debug('objNodesToCreate' + objNodesToCreate);
                        system.debug('jsonNodesToCreate' + jsonNodesToCreate);


                        if(jsonRecived.get(obj) != null && (obj == 'orderItemsWithAttrs' || obj == 'attrs')){ //the only places where attrs lives
                            try{
                                listOfMapElementsRecived = (List<object>)jsonRecived.get(obj); //orderItemWithAttrs:orderItemWithAttrs, if it has more than one son Map.get will return a List of objects
                            }
                            catch(System.TypeException texp){
                                system.debug('exp');
                                mapFromRecivedJson = (Map<string, object>)jsonRecived.get(obj); //attrs are inside some orderItemWithAttrs and its a Map
                                listOfMapElementsRecived = new List<Map<string, object>>();
                            }

                            if(listOfMapElementsRecived != null){ 
                                for(object mapOfElementRecived : listOfMapElementsRecived){
                                        string aux = (string)((Map<string, object>)objElementFromJsonNodesToCreate).get(objNodesToCreate);//whats the node value u want to replace
                                        string value  = findTheNode((Map<string, object>)mapOfElementRecived,aux); //whats the value you found according to the node u passed?
                                        system.debug('value ' + value );
                                        system.debug('aux ' + aux );
                                        if(value != aux){ //if its different then you found something
                                            ((Map<string, object>)objElementFromJsonNodesToCreate).put(objNodesToCreate, value); //you will insert it on that specific node
                                            nodeFound = true;
                                            break; //stop looking for that node
                                        }
                                    }
                            }
                            else if(mapFromRecivedJson != null){ //you are on attrs, only a map
                                string aux = (string)((Map<string, object>)objElementFromJsonNodesToCreate).get(objNodesToCreate); 
                                string value  = findTheNode(mapFromRecivedJson,aux);
                                system.debug('value ' + value );
                                system.debug('aux ' + aux );
                                if( aux != value){
                                    ((Map<string, object>)objElementFromJsonNodesToCreate).put(objNodesToCreate, value);
                                    nodeFound = true;
                                }

                            }
                            listOfMapElementsRecived = new List<Map<string, object>>();
                            mapFromRecivedJson = new Map<string, object>();

                            if(nodeFound){
                                //nodeFound=false;
                                break;
                            }
                                /*if(obj == 'orderItemsWithAttrs'){ //this means you are iterating inside a cfs with childs. Maybe if he has 1 son this wont work, ups.. gotta check that latter
                                    for(object objFromRecivedJson : (List<object>)jsonRecived.get(obj)){
                                        Map<string, object> mapFromRecivedJson = (Map<string, object> )objFromRecivedJson;
                                        objNodesToCreate = findTheNode(mapFromRecivedJson,(string)((Map<string, object>)objElementFromJsonNodesToCreate).get(objNodesToCreate));
                                    }
                                }
                                else{
                                    objNodesToCreate = findTheNode((Map<string,object>)jsonRecived.get(obj),(string)((Map<string, object>)objElementFromJsonNodesToCreate).get(objNodesToCreate));
                                
                                }*/

                        }
                        /*if(mapFromRecivedJson.get('attrs') != null){
                            if((mapFromRecivedJson.get('attrs')).get(mapFromRecivedJson) != null){
                                (mapFromRecivedJson.get('attrs')).get(mapFromRecivedJson);
                            }
                        }
                        if(mapFromRecivedJson.get('orderItemsWithAttrs') != null){
                            if((mapFromRecivedJson.get('orderItemsWithAttrs')).get('attrs') != null )
                                ((mapFromRecivedJson.get('orderItemsWithAttrs')).get('attrs')).get(mapFromRecivedJson);
                        }*/ 
                    }
                }
            }


            system.debug('jsonNodesToCreate before out' + jsonNodesToCreate);
            output.put('result', jsonNodesToCreate);

            return true;
        }
        catch(exception ex){
            system.debug(ex);
            output.put('result', 'unexpected error on line ' + ex.getLineNumber());
            return false;
        }
    }

    string findTheNode(Map<string, object> jsonToSearch, string node){
        try{
            system.debug('jsonToSearch' + jsonToSearch);
            if(node != null || node != '')
            {
                List<object> listOfMapToSearch = new List<object>();
                Map<string,object> mapFromJsonToSearch = new Map<string, object>();

                for(object obj : jsonToSearch.keyset()){
                    if((string)obj == 'attrs' || (string)obj == 'orderItemsWithAttrs'){

                        if((string)obj == 'orderItemsWithAttrs'){
                            listOfMapToSearch = (List<object>)jsonToSearch.get((string)obj);
                            for(object mapToSearch : listOfMapToSearch){
                                string aux = findTheNode((Map<string,object>)mapToSearch, node);
                                if(aux != node && aux != null)
                                    return aux;
                            }
                        }
                        else if((string)obj == 'attrs'){
                            mapFromJsonToSearch = (Map<string, object>)jsonToSearch.get((string)obj);
                            string aux = (string)(mapFromJsonToSearch.get(node));
                            if(aux != node && aux != null)
                                return aux;
                        }



                        /*try{
                            listOfMapToSearch = (List<object>)jsonToSearch.get((string)obj);
                        }
                        catch(System.TypeException texp){
                            system.debug('exp');
                            mapFromJsonToSearch = (Map<string, object>)jsonToSearch.get((string)obj);
                            listOfMapToSearch = new List<object>();
                        }*/

                        /*Map<string, object> mapFromJsonToSearch = (Map<string, object>)jsonToSearch.get((string)obj);

                        if(mapFromJsonToSearch.get('attrs') != null){
                            if(((Map<string, object>)mapFromJsonToSearch.get('attrs')).get(node) != null){
                                return (string)((Map<string, object>)(mapFromJsonToSearch.get('attrs'))).get(node);
                            }
                        }
                        if(mapFromJsonToSearch.get('orderItemsWithAttrs') != null)
                            return findTheNode(mapFromJsonToSearch, node);*/
                    }
                }
            }
            return node;
        }
        catch(exception ex){
            system.debug('err '+ ex + 'on ' + ex.getLineNumber());
            return 'unexpected error on line ' + ex.getLineNumber();
        }
    }
}