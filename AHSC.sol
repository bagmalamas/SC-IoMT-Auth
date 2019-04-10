pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract AHSC {

uint _userId;
string _userRole;
uint _deviceId;
address _userAddress = msg.sender;


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


// First the user must run the isVerified function in order to retrieve his userId and the role attribute

function isVerified (address _userAddress) returns (uint _userId, string _userRole) {

	getUserRole(_userAddress); 

    return (uint, string);
}


function getUserDetails (uint _userId) constant returns (string _hashIPFSmed) private{

	return (user[_userId].hashIPFSmed);

}

function getDeviceDetails(uint _deviceId) constant returns (string _hashIPFStech) private{
	
	return (device[_deviceId].hsashIPFStech,);
}


  



//<...........................Functions for the patient role..............................>

//       We use the onlyPatient modifier to restrict the access to anauthorized users
//     Two example functions are given, of course more can be added depending on the needs


function ViewPHI(uint _userId) onlyPatient(_userId) returns (string _hashIPFSmed){
        getUserDetails(_userId);

        return(_hashIPFSmed); // The function returns the links to the IPFS were the informations are stored

}

function ChangeDoctor(uint _userId, uint _doctorId) onlyPatient(_userId) returns(bool) {

    User[_userId].doctor = _doctorId;

    return true;

}






//<..........................Functions for the Doctor role................................>

//       We use the onlyDoctor modifier to restrict the access to anauthorized users

//      The require clause will check if the doctor is assigned to the specific patient

function ViewPatientData(uint _userId, uint _patientId) onlyDoctor(uint _userId) returns (string _hashIPFSmed){
    require(User[_patientId].doctor.address == msg.sender);
    getUserDetails(_patientId);
    return(_hashIPFSmed);
} 


function ChangeTreatment(uint _userId, uint _patientId) onlyDoctor(_userId) returns(bool){
    
    require(User[_patientId].doctor.address == msg.sender); 

// ....here we can add some code for changing the treatment plan of a patient..

return true;

}






//<.....................Functions for the Medical Peronnel role...........................>

//       We use the onlyMedical modifier to restrict the access to anauthorized users
//       we can also add a variable for determing the Health provider in order 
//       to restrict the access only to the health providers the patient is assigned


function changeDeviceOwnership(uint _deviceId, address _newOwner) onlyMedical(uint _devId) returns (bool) {
    require(device[_deviceId].currOwner != _newOwner);
    device[_devId].currOwner = _newOwner;
    
    return true;
    }

function ChangeDoctor(uint _userId, uint _patientId ,uint _doctorId) onlyPatient(_userId) returns(bool) {

    User[_patientId].doctor = _doctorId;

    return true;

}


//<.......................Functions for the Manufacturer role..............................>


//       We use the onlyDoctor modifier to restrict the access to anauthorized users

//      The require clause will check if the Manufacturer is linked with the specific device 

function ViewDeviceTech(uint _userId) onlyManufacturer(_userId) returns(string _hashIPFStech) {
    for (uint i=1; i<device.length;i++){
        if (Device[i].manufacturer.address == msg.sender){
            getDeviceDetails(_deviceId);
            return (string _hashIPFStech);
        }
        else
            return ('no device found');
    }

}
function UpdateFirmware(uint _userId, uint _deviceId) onlyManufacturer(_userId) returns(bool){
    
    require(Device[_deviceId].manufacturer.address == msg.sender); 

// ....here we can add some code for updating the firmware of the device..

return true;

}

    
}







