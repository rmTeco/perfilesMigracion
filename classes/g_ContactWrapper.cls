global class g_ContactWrapper implements Comparable {
    public SObject c;
    
    // Constructor
    public g_ContactWrapper(sObject cc) {
        c = cc;
    }

	public Contact getContact() {
		return (Contact) c;
	}
    
    // Compare contacts based on account name and contact name.
    global Integer compareTo(Object compareTo) {
        SObject other = ((g_ContactWrapper) compareTo).c;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;

		Account a;
		String accName;
		a = (Account) c.getSObject('Account');
		if (null == a) {
			accName = '';
		} else {
			accName = a.Name;
		}

		String otherAccName;
		a = (Account) other.getSObject('Account');
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