function dasdasdas(){
alert('jelou');
}



function togle2(element){
alert(element.getAttribute('aria-expanded'));
if (element.getAttribute('aria-expanded'))
   element.setAttribute('aria-expanded', false);
else
 element.setAttribute('aria-expanded', true);
}

function togle4(element){
alert('togleeeeee');


alert(element.className);
if (element.className.indexOf('slds-is-collapsed') == -1)
   element.className += ' slds-is-collapsed';
else
   element.className = element.className.replace('slds-is-collapsed', '');

if (element.className.indexOf('slds-is-expanded') == -1)
   element.className += ' slds-is-expanded';
else
   element.className = element.className.replace('slds-is-expanded', '');

alert(element.className);
}


function togle(element){

if (element.nextElementSibling.className.indexOf('slds-is-collapsed') == -1)
   element.nextElementSibling.className += ' slds-is-collapsed';
else
   element.nextElementSibling.className = element.nextElementSibling.className.replace('slds-is-collapsed', '');

if (element.nextElementSibling.className.indexOf('slds-is-expanded') == -1)
   element.nextElementSibling.className += ' slds-is-expanded';
else
   element.nextElementSibling.className = element.nextElementSibling.className.replace('slds-is-expanded', '');


}