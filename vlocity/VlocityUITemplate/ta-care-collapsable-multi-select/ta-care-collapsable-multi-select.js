vlocity.cardframework.registerModule.controller('collapsableMultiSelectController', ['$scope', function ($scope) {
    
    baseCtrl.prototype.assetItems = [];
    baseCtrl.prototype.allChk = {};
    baseCtrl.prototype.selectedAssets = [];
    baseCtrl.prototype.prod = {};
    baseCtrl.prototype.items = [];

    //handles the select checkbox
    baseCtrl.prototype.changeAssetSelection = function (item, items, onselect) {
        if (item.length > 1) {
            angular.forEach(item, function (value, key) {
                baseCtrl.prototype.allCheckChange(value);
            });
        } else {
            baseCtrl.prototype.prod.vlcSelected = item.vlcSelected;

            var lineNum = [];
            var selItem = {};
            if (item.LineNumber) {
                lineNum = item.LineNumber.split('.');
                angular.forEach(items, function (value, key) {
                    if (value.LineNumber !== undefined && value.LineNumber === lineNum[0]) {
                        value.vlcSelected = baseCtrl.prototype.prod.vlcSelected;
                        if (value.children) {
                            baseCtrl.prototype.parentCheckChange(value);
                        }
                        // We're handling the toggling of all of the children here
                        else {
                            if (value.vlcSelected === undefined)
                                value.vlcSelected = baseCtrl.prototype.allChk.vlcSelected;
                        }
                    }
                });
            }
        }

        var isAllSelected = true;
        for (var i = 0; i < items.length; i++) {
            if (!items[i].vlcSelected) {
                isAllSelected = false;
                break;
            }
        }
        if (isAllSelected) {
            baseCtrl.prototype.allChk.vlcSelected = true;
        } else {
            baseCtrl.prototype.allChk.vlcSelected = false;
        }
    };

    baseCtrl.prototype.changeAllAssetSelection = function (item, items) {
        // We're handling the ALL checkbox here
        if (item.length > 0) {
            angular.forEach(item, function (value, key) {
                baseCtrl.prototype.allCheckChange(value);
            });
        }
    };

    baseCtrl.prototype.allCheckChange = function (item) {
        if (item['Availability'] !== 'Not Available') {
            item.vlcSelected = baseCtrl.prototype.allChk.vlcSelected;
            if (item.children) {
                for (var i in item.children) {
                    item.children[i].vlcSelected = baseCtrl.prototype.allChk.vlcSelected;
                    if (item.children[i].children) {
                        baseCtrl.prototype.parentAllCheckChange(item.children[i]);
                    }
                }
            }
        }
    };

    baseCtrl.prototype.parentAllCheckChange = function (item) {
        if (item['Availability'] !== 'Not Available') {
            for (var i in item.children) {
                item.children[i].vlcSelected = baseCtrl.prototype.allChk.vlcSelected;
                if (item.children[i].children) {
                    baseCtrl.prototype.parentAllCheckChange(item.children[i]);
                }
            }
        }
    };

    baseCtrl.prototype.parentCheckChange = function (item) {
        if (item['Availability'] !== 'Not Available') {
            for (var i in item.children) {
                item.children[i].vlcSelected = baseCtrl.prototype.prod.vlcSelected;
                if (item.children[i].children) {
                    baseCtrl.prototype.parentCheckChange(item.children[i]);
                }
            }
        }
    };

    /* render the asset items */
    baseCtrl.prototype.renderAssetItems = function (items, expandType) {
        baseCtrl.prototype.assetItems = [];
        baseCtrl.prototype.items = [];
        var indent;
        prevIdx = 0;
        angular.forEach(items, function (prod, idx) {
            if (prod.LineNumber !== undefined) {
                indent = prod.LineNumber.split('.');
                if (indent.length === 1 && idx > 0) {
                    var tempProdList = items.slice(prevIdx, idx);
                    var tempProdHierarchy = baseCtrl.prototype.createAssetHierarchy(tempProdList, expandType);
                    baseCtrl.prototype.assetItems.push(tempProdHierarchy[0]);
                    prevIdx = idx;
                }
            } else {
                baseCtrl.prototype.assetItems.push(prod);
            }

            if (indent.length === 1) {
                expandType = 'expandNone';
            }

        });
        if (prevIdx < items.length) {
            var tempProdList = items.slice(prevIdx, items.length);
            var tempProdHierarchy = baseCtrl.prototype.createAssetHierarchy(tempProdList, expandType);
            baseCtrl.prototype.assetItems.push(tempProdHierarchy[0]);
        }
        baseCtrl.prototype.items = items;
        return items;
    };

    /* convert the product list into a tree hierarchy */
    baseCtrl.prototype.createAssetHierarchy = function (productList, expandNode) {
        var productHierarchy = [];

        var rootProduct = productList[0];
        rootProduct.isRoot = true;
        rootProduct.level = 1;
        if (expandNode !== undefined)
            rootProduct.isExpanded = (expandNode === 'expandAll' || expandNode === 'expandRoot');

        for (var idx = 1; idx < productList.length; idx++) {
            var prod = productList[idx];
            var levels;
            if (prod.LineNumber !== undefined) {
                levels = prod.LineNumber.split('.');
                prod.level = levels.length;
            }
            if (expandNode !== undefined)
                prod.isExpanded = (expandNode === 'expandAll');
            prod.rootProductId = rootProduct.productId;
            if (levels !== undefined)

                baseCtrl.prototype.setProductChildren(rootProduct, levels.slice(1), prod);
        }
        baseCtrl.prototype.filterProductHierarchy(rootProduct);
        productHierarchy.push(rootProduct);

        return productHierarchy;
    };

    /* set the product children as part of building the tree hierarchy */
    baseCtrl.prototype.setProductChildren = function (product, levels, p) {
        if (levels.length === 1) {
            if (product.children === undefined)
                product.children = [];

            product.children[levels[0] - 1] = p;
        } else {
            baseCtrl.prototype.setProductChildren(product.children[levels[0] - 1], levels.slice(1), p);
        }
    };

    /* filter the tree hierarchy to remove undefined array elements */
    baseCtrl.prototype.filterProductHierarchy = function (product) {
        if (product.children) {
            product.children = product.children.filter(function (n) { return n !== undefined; });
            angular.forEach(product.children, function (prod) {
                baseCtrl.prototype.filterProductHierarchy(prod);
            });
        }
    };
}]);