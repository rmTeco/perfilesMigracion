global class g_AccountWrapper implements Comparable {
    public SObject c;
    
    // Constructor
    public g_AccountWrapper(sObject cc) {
        c = cc;
    }

	public Account getAccount() {
		return (Account) c;
	}
    
    global Integer compareTo(Object compareTo) {
        SObject other = ((g_AccountWrapper) compareTo).c;
        
        Integer returnValue = 0;
		Account a;
		String accName;
		a = (Account) c;
		if (null == a) {
			accName = '';
		} else {
			accName = a.Name;
		}
		String otherAccName;
		a = (Account) other;
		if (null == a) {
			otherAccName = '';
		} else {
			otherAccName = a.Name;
		}
		returnValue = compare(accName, otherAccName); 
        
        if (returnValue != 0) {
            return returnValue;
        }
		returnValue = compareStr(c.get('Name'), other.get('Name'));
        return returnValue;
    }
    
    private Integer compareStr(Object a, Object b) {
    	String sa = (String) a;
    	String sb = (String) b;
    	
    	if (sa > sb) {
    		return 1;
    	}
    	if (sa < sb) {
    		return -1;
    	}
    	return 0;
    }

    private Integer compare(String a, String b) {
    	if (a > b) {
    		return 1;
    	}
    	if (a < b) {
    		return -1;
    	}
    	return 0;
    }
}