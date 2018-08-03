pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

interface EmbassyCustom{
    function customCheck();
}

contract EasyVisa is EmbassyCustom{

    //Display Events  
    event displayString(string _text);
    event displayAddress(address _address);
    event displayUint(uint _num);
    
    //Applicant Struct
    struct Applicant{
        address applicantAddress;
        
        string name;
        string origin;
       // string passportID;
        string[] documents; //specific documents include language proficiency etc.    

        uint fund;
        uint age;
        bool isApplied;
        //bool[] prevAppResults;
    }

    //Embassy Struct     
    struct Embassy{
        address embassyAddress;
        string country;
        string loc;//Not certain
        string[] countryBlackList;
        uint fundRequired;
    }
    
    /*Applicant[] applicants;
    Embassy[] embassies;*/
    
    //Data Mappings
    mapping(address => Applicant) applicants;
    mapping(address => Embassy) embassies;
    
    //String Comparison
    function strcmp(string a, string b) view returns(bool){
        return keccak256(a) == keccak256(b);
    }
    
    //Embassy-specific application check
    function customCheck(Embassy emb, string[] _applicantDocuments) returns(bool){
        //More detail to be specified
        return true; //Temporary condition
    }
    
    //Applicant Information Display
    function displayApplicantInfo(Applicant app){
        displayString("Name: ");
        displayString(app.name);
        
        displayString("Address: ");
        displayAddress(app.applicantAddress);
    }
    
    //Embassy Information Display
    function displayEmbassyInfo(Embassy emb){
        displayString("Embassy: ");
        displayString(emb.country);
        displayString(emb.loc);
        
        displayString("Address:");
        displayAddress(emb.embassyAddress);
    }

    //Application Approve   
    function Approve(Applicant app, Embassy emb){
        displayString("Your application has been approved by ");
        displayEmbassyInfo(emb);
        displayString("\n Constitution to ");
        displayApplicantInfo(app);
    }
    
    //Application Reject
    function Reject(Applicant app){
        displayString("Your application has been rejected.");
        displayApplicantInfo(app);
    }
    
    //Processing Application
    function processApplication(address _applicantAddress, address _embassyAddress){
        
        Applicant storage applicant = applicants[_applicantAddress];
        Embassy storage embassy = embassies[_embassyAddress];
        
        uint x = 0;
        
        //Nationality check
        while(x < embassy.countryBlackList.length && strcmp(applicant.origin, embassy.countryBlackList[x])){ //string comparison
            x++;
            //x < embassy.countryBlackList.length && applicant.origin != embassy.countryBlackList[x]
        }
        
        //Age check
        require(applicant.age >= 19);
        
        //Monetary check
        require(applicant.fund > embassy.fundRequired);
        
        //Already applied check
        require(!applicant.isApplied);
        
        //Embassy custom check
        if(customCheck(embassy, applicant.documents))
            Approve(applicant, embassy); //Application approved
        else
            Reject(applicant); //Application rejected
    }
}


