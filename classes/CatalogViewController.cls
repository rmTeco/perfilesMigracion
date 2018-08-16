public class CatalogViewController {
    
    private static String graph = 'strict digraph ProductCatalogue {\n ' +
        'graph [fontname = "helvetica", fontsize = "10.0"];\n ' +
        'node [fontname = "helvetica", style="invis", fontsize = "10.0"];  ' +
        'edge [fontname = "helvetica", fontsize = "10.0"];\n';
    private static Map<String, String> shapeStyles = new Map<String, String>
    {
        'Resource' => ' [shape=box, style=filled, color="#000000", fillcolor="#D95F70", href="$HREF$"]',
            'Service' => ' [shape=box, style=filled, color="#000000", fillcolor="#8DF045", href="$HREF$"]',
            'Product' => ' [shape=box, style=filled, color="#000000", fillcolor="#FAA105", href="$HREF$"]',
            'Offer' => ' [shape=box, style=filled, color="#000000", fillcolor="#AC9ACB", href="$HREF$"]',
            'Promotion' => ' [shape=box, style=filled, color="#000000", fillcolor="#22DCD9", href="$HREF$"]',
            'Grant' => ' [shape=box, style=filled, color="#000000", fillcolor="#2252DC", href="$HREF$"]',
            'Repair Service' => ' [shape=box, style=filled, color="#000000", fillcolor="#838188", href="$HREF$"]',
            'Group' => ' [shape=box, style=filled, color="#000000", fillcolor="#E3F9F9", href="$HREF$"]'
            };
                
                
                private static String classShapeStyle = ' [shape=box, style=dashed, color="#000000", fillcolor="#000000", href="$HREF$", tooltip="Class"]';
    private static String errorShapeStyle = ' [shape=box, style=filled, color="#000000", fillcolor="#ff0000"]';
    
    private static String pciLinkStyle = ' [color="#515252", tooltip="PCI"]';
    private static String decompLinkStyle = ' [style=dashed, color="#039CD6", tooltip="Decomposition relationship"]';
    private static String classLinkStyle = ' [style=dashed, arrowhead="empty", arrowtail="empty", color="#2f5da8", tooltip="Parent class"]';
    
    public String productId {get; set;}
    
    public static Map<Id,GraphNode> products;
    
    public class GraphNode
    {
        public Id productId;
        public String productName;
        public boolean erroneous = false;
        public String specType = 'Product';
        public boolean isClass;
        public Id parentClass;
        
        public Map<Id,GraphNode> pciNodes = null; 
        public Map<Id,GraphNode> decompNodes = null;
        
        GraphNode(Id productId, String productName, String specType)
        {
            this.productId = productId;
            this.productName = productName;
            if (specType != null) this.specType = specType;
            erroneous = false;
            isClass = false;
            parentClass = null;
        }
        
        GraphNode(boolean erroneous)
        {
            this.erroneous = erroneous;
        }
        
        public void addPCI(GraphNode pciNode)
        {
            if (pciNodes == null) pciNodes = new Map<Id,GraphNode>();
            if (pciNodes.get(pciNode.productId) == null)
            {
                pciNodes.put(pciNode.productId, pciNode);
            }
        }
        
        public void addDecomp(GraphNode decompNode)
        {
            if (decompNodes == null) decompNodes = new Map<Id,GraphNode>();
            if (decompNodes.get(decompNode.productId) == null)
            {
                decompNodes.put(decompNode.productId, decompNode);
            }
        }
        
    }
    
    @remoteAction
    public static String getFullGraph()
    {
        generateFullGraph();
        return graph+='}';
    }
    
    private static void generateFullGraph()
    {
        generateGraphForProducts('ALL');
    }
    
    @remoteAction
    public static String getGraphForProduct(String productId)
    {
        generateGraphForProducts(productId);
        return graph+='}';
    }
    
    private static void generateGraphForProducts(String productId)
    {
        getAllProducts();
        
        if ('ALL'.equals(productId)) 
        {
            List<GraphNode> graphNodes = products.values();
            Iterator<GraphNode> itr = graphNodes.iterator();
            while (itr.hasNext())
            {
                GraphNode graphNode = itr.next();
                generateGraphForProduct(Id.valueOf(graphNode.productId), true);
            }   
        }
        else
        {
            generateGraphForProduct(Id.valueOf(productId), false);
        }
    }
    
    private static void generateGraphForProduct(Id productId, boolean isFull)
    {
        System.debug('generateGraphForProduct, where productId: '+productId+' and isFull:'+isFull);
        GraphNode mainNode = products.get(productId);
        
        String style = shapeStyles.get(mainNode.specType);
        if (style==null) style = ' [shape=box, style=filled, color="#000000", fillcolor="#FAA105", href="$HREF$"]';
        
        if (mainNode.isClass) style = classShapeStyle;
        
        style = style.replace('$HREF$', '/'+mainNode.productId);
        graph+='"' + mainNode.specType + ': ' + mainNode.productName + '"' + style + ';\n';
        
        System.debug('generateGraphForProduct, graph before PCI is '+graph);
        
        Map<Id,GraphNode> pcItems = mainNode.pciNodes;
        if (pcItems != null)
        {
            Iterator<GraphNode> pciItr = pcItems.values().iterator();
            while(pciItr.hasNext()) 
            {
                GraphNode pciNode = pciItr.next();
                if (!pciNode.erroneous) 
                { 
                    graph+='"' + mainNode.specType + ': ' + mainNode.productName + '" -> "' + pciNode.specType + ': ' + pciNode.productName + '"'+pciLinkStyle+';\n';
                    
                    //if we are generating the graph for a specific product then we need to go deeper and 
                    //repeat the process for each PCI
                    if (!isFull) generateGraphForProduct(pciNode.productId, false);
                }
                else
                {
                    graph+='"ERROR"' + errorShapeStyle + ';\n';
                    graph+='"' + mainNode.specType + ': ' + mainNode.productName + '" -> "ERROR"'+pciLinkStyle+';\n';
                }
                
            }    
        }
        System.debug('generateGraphForProduct, graph after PCI is '+graph);
        
        Map<Id,GraphNode> decompItems = mainNode.decompNodes;
        if (decompItems != null)
        {
            Iterator<GraphNode> decompItr = decompItems.values().iterator();
            while(decompItr.hasNext()) 
            {
                GraphNode decompNode = decompItr.next();
                if (!decompNode.erroneous) 
                { 
                    graph+='"' + mainNode.specType + ': ' + mainNode.productName + '" -> "' + decompNode.specType + ': ' + decompNode.productName + '"'+decompLinkStyle+';\n';
                    
                    //if we are generating the graph for a specific product then we need to go deeper and 
                    //repeat the process for each decomp
                    if (!isFull) generateGraphForProduct(decompNode.productId, false);
                }
                else
                {
                    graph+='"ERROR"' + errorShapeStyle + ';\n';
                    graph+='"' + mainNode.specType + ': ' + mainNode.productName + '" -> "ERROR"'+decompLinkStyle+';\n';
                }
            }    
        }
        System.debug('generateGraphForProduct, graph after DR processing is '+graph);
        
        if (mainNode.parentClass != null)
        {
            GraphNode classNode = products.get(mainNode.parentClass);
            if (classNode!=null)
            {
                graph+='"' + mainNode.specType + ': ' + mainNode.productName + '" -> "' + classNode.specType + ': ' + classNode.productName + '"'+classLinkStyle+';\n';
                
                if (!isFull) generateGraphForProduct(classNode.productId, false);
            }
        }
    }
    
    private static void getAllProducts()
    {
        products = new Map<Id, GraphNode>();
        
        List<Product2> productsRS;
        productsRS = [select Id, Name, vlocity_cmt__SpecificationType__c, RecordType.Name, vlocity_cmt__ParentClassId__r.Id,
                      (select Name, vlocity_cmt__ChildProductId__r.Name, vlocity_cmt__ChildProductId__r.vlocity_cmt__SpecificationType__c, vlocity_cmt__ChildProductId__r.vlocity_cmt__ParentClassId__r.Id 
                       from vlocity_cmt__ProductChildItems__r where not (name like 'Root%')
                      ), 
                      (select Name, vlocity_cmt__DestinationProductId__r.Name, vlocity_cmt__DestinationProductId__r.vlocity_cmt__SpecificationType__c, vlocity_cmt__DestinationProductId__r.vlocity_cmt__ParentClassId__r.Id 
                       from vlocity_cmt__DestinationDecompositionRelationships__r
                      ) from Product2];
        
        Iterator<Product2> productsItr = productsRS.iterator();
        while (productsItr.hasNext())
        {
            Product2 product = productsItr.next();
            
            GraphNode mainNode = products.get(product.Id);
            if (mainNode == null)
            {
                mainNode = new GraphNode(product.Id, product.Name, product.vlocity_cmt__SpecificationType__c);
                if (product.RecordType.Name == 'Class') mainNode.isClass = true;
                if (product.vlocity_cmt__ParentClassId__c != null && !''.equals(product.vlocity_cmt__ParentClassId__c))
                {
                    mainNode.parentClass = product.vlocity_cmt__ParentClassId__c;
                }
                products.put(product.Id, mainNode);
            }
            
            List<vlocity_cmt__ProductChildItem__c> pcItems = product.vlocity_cmt__ProductChildItems__r;
            Iterator<vlocity_cmt__ProductChildItem__c> pciItr = pcItems.iterator();
            while(pciItr.hasNext()) 
            {
                vlocity_cmt__ProductChildItem__c pci = pciItr.next();
                if (pci.vlocity_cmt__ChildProductId__r!=null) 
                { 
                    GraphNode pciNode = products.get(pci.vlocity_cmt__ChildProductId__r.Id);
                    if (pciNode == null)
                    {
                        pciNode = new GraphNode(pci.vlocity_cmt__ChildProductId__r.Id, 
                                                pci.vlocity_cmt__ChildProductId__r.Name, 
                                                pci.vlocity_cmt__ChildProductId__r.vlocity_cmt__SpecificationType__c);
                        if (pci.vlocity_cmt__ChildProductId__r.vlocity_cmt__ParentClassId__c != null && !''.equals(pci.vlocity_cmt__ChildProductId__r.vlocity_cmt__ParentClassId__c))
                        {
                            pciNode.parentClass = pci.vlocity_cmt__ChildProductId__r.vlocity_cmt__ParentClassId__c;
                        }
                        
                        products.put(pciNode.productId, pciNode);
                    }
                    
                    mainNode.addPCI(pciNode);
                }
                else
                {
                    mainNode.addPCI(new GraphNode(true));
                }
                
            }    
            
            List<vlocity_cmt__DecompositionRelationship__c> decompItems = product.vlocity_cmt__DestinationDecompositionRelationships__r;
            Iterator<vlocity_cmt__DecompositionRelationship__c> decompItr = decompItems.iterator();
            while(decompItr.hasNext()) 
            {
                vlocity_cmt__DecompositionRelationship__c decomp = decompItr.next();
                if (decomp.vlocity_cmt__DestinationProductId__r!=null) 
                { 
                    GraphNode decompNode = products.get(decomp.vlocity_cmt__DestinationProductId__r.Id);
                    if (decompNode == null)
                    {
                        decompNode = new GraphNode(decomp.vlocity_cmt__DestinationProductId__r.Id, 
                                                   decomp.vlocity_cmt__DestinationProductId__r.Name, 
                                                   decomp.vlocity_cmt__DestinationProductId__r.vlocity_cmt__SpecificationType__c);
                        if (decomp.vlocity_cmt__DestinationProductId__r.vlocity_cmt__ParentClassId__c != null && !''.equals(decomp.vlocity_cmt__DestinationProductId__r.vlocity_cmt__ParentClassId__c))
                        {
                            decompNode.parentClass = decomp.vlocity_cmt__DestinationProductId__r.vlocity_cmt__ParentClassId__c;
                        }

                        products.put(decompNode.productId, decompNode);
                    }
                    
                    mainNode.addDecomp(decompNode);
                }
                else
                {
                    mainNode.addDecomp(new GraphNode(true));
                }
            }    
        }
    }
    
    public List<SelectOption> getProducts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('ALL', 'Show All'));
        
        List<Product2> products = [select Id, Name from Product2 order by Name limit 998];
        Iterator<Product2> productsItr = products.iterator();
        while (productsItr.hasNext())
        {
            Product2 product = productsItr.next();
            options.add(new SelectOption(product.Id, product.Name));
        }
        
        options.add(new SelectOption('...', '>>Too many products to display. Call the page from the required product'));
        
        return options;
    }
    
}