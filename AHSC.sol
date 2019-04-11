pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract AHSC {

uint _userId;
string _userRole;
uint _deviceId;
address _userAddress = msg.sender;


string Ip[] private ips;
string Mac[] private macs;

//..............................................................................
//  Here we must define ip and mac whitelist for checking the Trusted domains
//..............................................................................

Ip[1]="192.168.10.2";
Ip[2]="173.10.5.4";




Mac[1]="A3:B6:BC:12:34:F1";
Mac[2]="63:B4:6C:09:34:A3";






//.........................................................................
//      Here we define the modifiers for achieving access control
//.........................................................................

modifier onlyPatient(uint _userId) {
    require(User[_userId].address==msg.sender);
    require(user[_userId].role == 'Patient');
        _;
    }

modifier onlyDoctor (uint _userId){
    require(User[_userId].address==msg.sender);
	require(user[_userId].role == 'Doctor');
        _;
	}

modifier onlyMedical (uint _userId){
    require(User[_userId].address==msg.sender);
    require(user[_userId].role == 'Medicalpers');
        _;
    }

modifier onlyManufacturer (uint _userId){
    require(User[_userId].address==msg.sender);
    require(user[_userId].role == 'Manufacturer');
        _;
    }






//......................................................................................
//      This is the function that check if the user is accessing from a Trusted domain
//      defined in the whitelist
//.......................................................................................


function isTrusted(string _userip, string _usermac) returns (bool) {

   for (i=1;i<Ip[i].length;i++)
        if (Ip[i] == _userip){
            for (j=1;j<Mac[j].length;j++) 
                if (Mac[j] == _usermac){
                    return true;
                }
        }
        else 
            return false       
        
   }



            

        
   
    






//...............................................................................................
//      This is the first function a user must execute in order to gain access based on the role
//      (it acts as a login function)
//...............................................................................................


function isVerified (address _userAddress, string _userCertificate) returns (uint _userId, string _userRole) {

	getUserRole(_userAddress, _userCertificate); 
    string _functionName = "isVerified";
    addTransaction(uint _userId, string _functionName);
    return (uint, string);
}



//...............................................................................................
//This function is for retrieving the hashes that link IPFS medical records to a specific patient
//...............................................................................................



function getUserDetails (uint _userId) constant returns (string _hashIPFSmed) private{

	return (user[_userId].hashIPFSmed);

}



//...............................................................................................
//This function is for retrieving the hashes that link IPFS technical records to a specific device
//...............................................................................................



function getDeviceDetails(uint _deviceId) constant returns (string _hashIPFStech) private{
	
	return (device[_deviceId].hsashIPFStech,);
}


  


//...............................................................................................
//                                   Functions for the patient role
//...............................................................................................




//...............................................................................................
//       We use the onlyPatient modifier to restrict the access to anauthorized users
//     Two example functions are given, of course more can be added depending on the needs
//...............................................................................................


function ViewPHI(uint _userId) onlyPatient(_userId) returns (string _hashIPFSmed){
        getUserDetails(_userId);
        string _functionName = "ViewPHI";
        addTransaction(_userId,_functionName);

        return(_hashIPFSmed); // The function returns the links to the IPFS were the informations are stored

}


//          We want this function to be executable only inside a trusted domain

function ChangeDose(uint _userId, uint _doctorId) onlyPatient(_userId) isTrusted(_userip, _usermac) returns(bool) {

    User[_userId].doctor = _doctorId;
    string _functionName = "ChangeDose";
    addTransaction(_userId,_functionName);
    return true;

}





//...............................................................................................
//                                   Functions for the Doctor role
//...............................................................................................


//...............................................................................................
//               We use the onlyDoctor modifier to restrict the access to anauthorized users
//               The require clause will check if the doctor is assigned to the specific patient
//...............................................................................................


function ViewPatientData(uint _userId, uint _patientId) onlyDoctor(uint _userId) returns (string _hashIPFSmed){
    require(User[_patientId].doctor.address == msg.sender);
    getUserDetails(_patientId);
    string _functionName = "ViewPatientData";
    addTransaction(_userId,_functionName);
    return(_hashIPFSmed);
} 



//          We want this function to be executable only inside a trusted domain

function ChangeTreatment(uint _userId, uint _patientId) onlyDoctor(_userId) isTrusted(_userip, _usermac) returns(bool){
    
    require(User[_patientId].doctor.address == msg.sender); 
    string _functionName = "ChangeTreatment";
    addTransaction(_userId,_functionName);
// ....here we can add some code for changing the treatment plan of a patient..

return true;

}





//.................................................................................................
//                                  Functions for the Medical Peronnel role
//.................................................................................................


//..................................................................................................
//       We use the onlyMedical modifier to restrict the access to anauthorized users
// we can also add a variable for determing the Health provider in order to restrict the access only 
// to the health providers the patient is assigned
//...................................................................................................



function changeDeviceOwnership(uint _deviceId, address _newOwner) onlyMedical(uint _devId) isTrusted(_userip, _usermac) returns (bool) {
    require(device[_deviceId].currOwner != _newOwner);
    device[_devId].currOwner = _newOwner;
    string _functionName = "changeDeviceOwnership";
    addTransaction(_userId,_functionName);

    return true;
    }

function ChangeDoctor(uint _userId, uint _patientId ,uint _doctorId) onlyPatient(_userId) isTrusted(_userip, _usermac)returns(bool) {

    User[_patientId].doctor = _doctorId;
    string _functionName = "ChangeDoctor";
    addTransaction(_userId,_functionName);
    return true;

}



//...................................................................................................
//                                      Functions for the Manufacturer role
//...................................................................................................



//...................................................................................................
//       We use the onlyManufacturer modifier to restrict the access to anauthorized users
//      The require clause will check if the Manufacturer is linked with the specific device 
//...................................................................................................


function ViewDeviceTech(uint _userId) onlyManufacturer(_userId) returns(string _hashIPFStech) {
    for (uint i=1; i<device.length;i++){
        if (Device[i].manufacturer.address == msg.sender){
            getDeviceDetails(_deviceId);
            string _functionName = "ViewDeviceTech";
            addTransaction(_userId,_functionName);

            return (string _hashIPFStech);

        }
        else
            return ('no device found');
    }

}
function UpdateFirmware(uint _userId, uint _deviceId) onlyManufacturer(_userId) isTrusted(_userip, _usermac) returns(bool){
    
    require(Device[_deviceId].manufacturer.address == msg.sender); 
            string _functionName = "UpdateFirmware";
            addTransaction(_userId,_functionName);

            // ....here we can add some code for updating the firmware of the device..

return true;

}

    
}







