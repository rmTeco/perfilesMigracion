global with sharing class RefillHistoryHandler implements vlocity_cmt.VlocityOpenInterface{

    global RefillHistoryHandler(){}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
    {
        Boolean result = true;
        try {
            if (methodName.equals('filterDataByChannel'))
                filterDataByChannel(methodName, input, outMap, options);

            return result;
        }
        catch(Exception e) {
            System.debug('RefillHistoryHandler: invokeMethod -> exception: ' + e);
            return false;
        }
        
    }

    static Integer randomWithLimit(Integer upperLimit)
    {
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }

    global static void filterDataByChannel(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {    
        String startDateScope = (String) input.get('startDateFilter');
        String endDateScope = (String) input.get('endDateFilter');
        String channelScope = (String) input.get('channelFilter');
        String benefitScope = (String) input.get('benefitFilter');
        decimal totalAmount = 0;

        system.debug('startDateScope: ' + startDateScope);
        system.debug('endDateScope: ' + endDateScope);
        system.debug('channelScope: ' + channelScope);
        system.debug('benefitScope: ' + benefitScope);

        Map<String, Object> refillsInfo = new Map<String, Object>();
        List<Map<String, String>> refillsNodeList = new List<Map<String, String>>();
        Map<String, String> node;

        String [] arrayListChannels = new List<String>();
        arrayListChannels.add('SMS');
        arrayListChannels.add('Web');
        arrayListChannels.add('ROL');
        arrayListChannels.add('IVR');

        String [] arrayListBenefitTypes = new List<String>();
        arrayListBenefitTypes.add('De Unidades');
        arrayListBenefitTypes.add('De Crédito');

        String [] arrayListAmounts = new List<String>();
        arrayListAmounts.add('129');
        arrayListAmounts.add('901');
        arrayListAmounts.add('457');
        arrayListAmounts.add('986');
        arrayListAmounts.add('726');
        arrayListAmounts.add('424');
        arrayListAmounts.add('175');
        arrayListAmounts.add('547');
        arrayListAmounts.add('118');
        arrayListAmounts.add('575');
        arrayListAmounts.add('888');
        arrayListAmounts.add('996');
        arrayListAmounts.add('892');
        arrayListAmounts.add('162');

        String [] arrayListBenefitAmounts = new List<String>();
        arrayListBenefitAmounts.add('300');
        arrayListBenefitAmounts.add('350');
        arrayListBenefitAmounts.add('400');
        
        if(channelScope == 'ROL')
        {
            if(String.isNotBlank(startDateScope) && String.isNotBlank(endDateScope))
            {
                for(Integer i = 0; i < 30; i++)
                {
                    if(((system.today()-i) >= date.valueOf(startDateScope)) && (system.today()-i) <= date.valueOf(endDateScope))
                    {
                        String inicio = String.valueOf((system.now()-i).format());
                        String fin = String.valueOf((system.now()-i+7).format());
                        node = new Map<String, String>();
                        node.put('Channel', 'ROL');
                        node.put('StartDate', inicio);
                        node.put('EndDate', fin);
                        node.put('Description', 'Saldo virtual');
                        Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                        node.put('Amount', String.valueOf(amount));

                        if(benefitScope == 'Con Beneficio')
                        {
                            node.put('Benefit', 'Con Beneficio');
                            node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                            node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                            node.put('CreditUnitBenefits', 'Valor número uno');
                            node.put('BenefitStartDate', ((system.today()-i).format()));
                            node.put('BenefitEndDate', (system.today()+i).format());
                        }
                        else if(benefitScope == 'Sin Beneficio')
                            node.put('Benefit', 'Sin Beneficio');
                        else
                        {
                            if(Math.Mod(i, 2) == 0)
                                node.put('Benefit', 'Sin Beneficio');
                            else
                            {
                                node.put('Benefit', 'Con Beneficio');
                                node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                                node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                                node.put('CreditUnitBenefits', 'Valor número uno');
                                node.put('BenefitStartDate', ((system.today()-i).format()));
                                node.put('BenefitEndDate', (system.today()+i).format());
                            }
                        }
                        
                        totalAmount += amount;
                        refillsNodeList.add(node);
                    }
                }
            }
            else
            {
                if(String.isNotBlank(benefitScope))
                {
                    for(Integer i = 0; i < 25 ; i++)
                    {
                        String inicio = String.valueOf((system.now()-i).format());
                        String fin = String.valueOf((system.now()-i+7).format());
                        node = new Map<String, String>();
                        node.put('Channel', 'ROL');
                        node.put('StartDate', inicio);
                        node.put('EndDate', fin);
                        node.put('Description', 'Saldo virtual');
                        Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                        node.put('Amount', String.valueOf(amount));
                        
                        if(benefitScope == 'Con Beneficio')
                        {
                            node.put('Benefit', 'Con Beneficio');
                            node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                            node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                            node.put('CreditUnitBenefits', 'Valor número dos');
                            node.put('BenefitStartDate', ((system.today()-3).format()));
                            node.put('BenefitEndDate', (system.today()+4).format());
                        }
                        else if(benefitScope == 'Sin Beneficio')
                            node.put('Benefit', 'Sin Beneficio');
                        else
                        {
                            if(Math.Mod(i, 2) == 0)
                                node.put('Benefit', 'Sin Beneficio');
                            else
                            {
                                node.put('Benefit', 'Con Beneficio');
                                node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                                node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                                node.put('CreditUnitBenefits', 'Valor número tres');
                                node.put('BenefitStartDate', ((system.today()-3).format()));
                                node.put('BenefitEndDate', (system.today()+4).format());
                            }
                        }

                        totalAmount += amount;
                        refillsNodeList.add(node);
                    }
                }
                else
                {
                    for(Integer i = 0; i < 28; i++)
                    {
                        String inicio = String.valueOf((system.now()-i).format());
                        String fin = String.valueOf((system.now()-i+7).format());
                        node = new Map<String, String>();
                        node.put('Channel', 'ROL');
                        node.put('StartDate', inicio);
                        node.put('EndDate', fin);
                        node.put('Description', 'Saldo virtual');
                        Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                        node.put('Amount', String.valueOf(amount));
                        
                        if(Math.Mod(i, 2) == 0)
                            node.put('Benefit', 'Sin Beneficio');
                        else
                        {
                            node.put('Benefit', 'Con Beneficio');
                            node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                            node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                            node.put('CreditUnitBenefits', 'Valor número cuatro');
                            node.put('BenefitStartDate', ((system.today()-3).format()));
                            node.put('BenefitEndDate', (system.today()+4).format());
                        }

                        totalAmount += amount;
                        refillsNodeList.add(node);
                    }
                }
            }
        }
        else if(channelScope == 'Web')
        {
            for(Integer i = 0; i < 50; i++)
            {
                String inicio = String.valueOf((system.now()-i).format());
                String fin = String.valueOf((system.now()-i+7).format());
                node = new Map<String, String>();
                node.put('Channel', 'Web');
                node.put('StartDate', inicio);
                node.put('EndDate', fin);
                node.put('Description', 'Saldo virtual');
                Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                node.put('Amount', String.valueOf(amount));

                if(benefitScope == 'Con Beneficio')
                {
                    node.put('Benefit', 'Con Beneficio');
                    node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                    node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                    node.put('CreditUnitBenefits', 'Valor número cinco');
                    node.put('BenefitStartDate', ((system.today()-1).format()));
                    node.put('BenefitEndDate', (system.today()+6).format());
                }
                else if(benefitScope == 'Sin Beneficio')
                    node.put('Benefit', 'Sin Beneficio');
                else
                {
                    if(Math.Mod(i, 2) == 0)
                        node.put('Benefit', 'Sin Beneficio');
                    else
                    {
                        node.put('Benefit', 'Con Beneficio');
                        node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                        node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                        node.put('CreditUnitBenefits', 'Valor número cinco');
                        node.put('BenefitStartDate', ((system.today()-1).format()));
                        node.put('BenefitEndDate', (system.today()+6).format());
                    }
                }

                totalAmount += amount;
                refillsNodeList.add(node);
            }
        }
        else if(channelScope == 'SMS')
        {
            for(Integer i = 0; i < 115; i++)
            {
                if(((system.today()-i) >= date.valueOf(startDateScope)) && (system.today()) <= date.valueOf(endDateScope))
                {
                    String inicio = String.valueOf((system.now()-i).format());
                    String fin = String.valueOf((system.now()-i+7).format());
                    node = new Map<String, String>();
                    node.put('Channel', 'SMS');
                    node.put('StartDate', inicio);
                    node.put('EndDate', fin);
                    node.put('Description', 'Saldo virtual');
                    Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                    node.put('Amount', String.valueOf(amount));

                    if(benefitScope == 'Con Beneficio')
                    {
                        node.put('Benefit', 'Con Beneficio');
                        node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                        node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                        node.put('CreditUnitBenefits', 'Valor número seis');
                        node.put('BenefitStartDate', ((system.today()-8).format()));
                        node.put('BenefitEndDate', (system.today()-1).format());
                    }
                    else if(benefitScope == 'Sin Beneficio')
                        node.put('Benefit', 'Sin Beneficio');
                    else
                    {
                        if(Math.Mod(i, 2) == 0)
                            node.put('Benefit', 'Sin Beneficio');
                        else
                        {
                            node.put('Benefit', 'Con Beneficio');
                            node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                            node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                            node.put('CreditUnitBenefits', 'Valor número seis');
                            node.put('BenefitStartDate', ((system.today()-8).format()));
                            node.put('BenefitEndDate', (system.today()-1).format());
                        }
                    }

                    totalAmount += amount;
                    refillsNodeList.add(node);
                }
            }
        }
        else if(channelScope == 'IVR')
        {
            for(Integer i = 0; i < 40; i++)
            {
                String inicio = String.valueOf((system.now()-i).format());
                String fin = String.valueOf((system.now()-i+7).format());
                node = new Map<String, String>();
                node.put('Channel', 'IVR');
                node.put('StartDate', inicio);
                node.put('EndDate', fin);
                node.put('Description', 'Saldo virtual');
                Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                node.put('Amount', String.valueOf(amount));

                if(benefitScope == 'Con Beneficio')
                {
                    node.put('Benefit', 'Con Beneficio');
                    node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                    node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                    node.put('CreditUnitBenefits', 'Valor número siete');
                    node.put('BenefitStartDate', ((system.today()-9).format()));
                    node.put('BenefitEndDate', (system.today()+2).format());
                }
                else if(benefitScope == 'Sin Beneficio')
                    node.put('Benefit', 'Sin Beneficio');
                else
                {
                    if(Math.Mod(i, 2) == 0)
                        node.put('Benefit', 'Sin Beneficio');
                    else
                    {
                        node.put('Benefit', 'Con Beneficio');
                        node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                        node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                        node.put('CreditUnitBenefits', 'Valor número siete');
                        node.put('BenefitStartDate', ((system.today()-9).format()));
                        node.put('BenefitEndDate', (system.today()+2).format());
                    }
                }

                totalAmount += amount;
                refillsNodeList.add(node);
            } 
        }
        else
        {
            for(Integer i = 0; i < 64; i++)
            {
                String inicio = String.valueOf((system.now()-i).format());
                String fin = String.valueOf((system.now()-i+7).format());
                node = new Map<String, String>();
                node.put('Channel', arrayListChannels[randomWithLimit(3)]);
                node.put('StartDate', inicio);
                node.put('EndDate', fin);
                node.put('Description', 'Saldo virtual');
                Decimal amount = Decimal.valueOf(arrayListAmounts[randomWithLimit(13)]);
                node.put('Amount', String.valueOf(amount));
                
                if(benefitScope == 'Con Beneficio')
                {
                    node.put('Benefit', 'Con Beneficio');
                    node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                    node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                    node.put('CreditUnitBenefits', 'Valor número ocho');
                    node.put('BenefitStartDate', ((system.today()-4).format()));
                    node.put('BenefitEndDate', (system.today()+3).format());
                }
                else if(benefitScope == 'Sin Beneficio')
                    node.put('Benefit', 'Sin Beneficio');
                else
                {
                    if(Math.Mod(i, 2) == 0)
                        node.put('Benefit', 'Sin Beneficio');
                    else
                    {
                        node.put('Benefit', 'Con Beneficio');
                        node.put('BenefitType', arrayListBenefitTypes[randomWithLimit(2)]);
                        node.put('BenefitAmountUnit', arrayListBenefitAmounts[randomWithLimit(2)]);
                        node.put('CreditUnitBenefits', 'Valor número ocho');
                        node.put('BenefitStartDate', ((system.today()-4).format()));
                        node.put('BenefitEndDate', (system.today()+3).format());
                    }
                }
                
                totalAmount += amount;
                refillsNodeList.add(node);
            }
        }
        
        refillsInfo.put('RefillsList', refillsNodeList);
        refillsInfo.put('TotalAmount', totalAmount);
        outMap.put('Result', refillsInfo);
    }
}