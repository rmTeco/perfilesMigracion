public with sharing class ProcessWrapper {
	public Boolean checked{ get; set; }
	public Account acc { get; set;}

    public ProcessWrapper(){
        acc = new Account();
        checked = false;
    }

    public ProcessWrapper(Account a){
        acc = a;
        checked = false;
    }
}