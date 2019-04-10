pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

//This is the Registration Smart Contract responsible for adding
//users along with their role and devices into the blockchain.
//It also stores the certificates in order to validate users and devices.
//An hashIPFS variable is included in order to connect users and devices to the medical and technical data accordingly

contract Registration {

bool status;
enum Role {Patient,Doctor,Medicalpers,Manufacturer}



// We create two index for storing users and devices 
// From the informations stored on those we validate users and devices

User[] public users;
Device[] public devices;

event UserAdded(address userAddress, string UserRole, string userCertificate);
event UserRemoved(address userAddress);

event DeviceAdded(address deviceAddress, string deviceCertificate, string deviceCurrowner);
event DeviceRemoved(address deviceAddress);

// Those are the informations stored for each user 
// The role can take any of the attributes defined at the start of the contract
// The hashIPFSmed variable is for storing the hash that links patient's medical data to the IPFS
struct User {

	uint id;
	address user;	
	Role role; 
	string certificate;
    Device device;
    User doctor;
	string hashIPFSmed;
}


// Those are the informations stored for each device added to the system 
// The currOwner variable indicates to which user is the device assigned 
// The hashIPFStech variable is for storing the hash that links devices's technical data to the IPFS


struct Device {

	address device;
	string certificate;
    User manufacturer;
	address currOwner;
	string hashIPFStech;
}

// We create a mapping for users and devices
	mapping (uint => Device) public devices;
	mapping (address => uint) public users;



//This is the function for adding a new user to the User index 

    function addUser(uint _userId, address userAddress, string userRole, string userCertificate, uint doctorId) public {
        require(status = true);
        require (userAddress == msg.sender);
        uint id = User.length;
        if (id == 0) {
            User[_userId] = User.length;
            id = User.length++;
        }
        User[id] = User({user: userAddress, role: userRole, certificate: userCertificate, doctor: doctorId });
        UserAdded(userAddress, userRole, userCertificate, doctorId);

    }

//This function is for removing a user from the User index 

    function removeUser(uint _userId) public {
        require(User[uint _userId].address == msg.sender);
        for (uint i = User[_userId]; i<users.length-1; i++){
            User[i] = User[i+1];
        }
        delete User[User.length-1];
        User.length--;
        UserRemoved(_userId);
       
    }


//This function is for adding a new device to the Device Index

    function addDevice(uint _deviceId, address deviceAddress, string deviceCertificate, string deviceCurrowner)  public {
        require(status = true);
        require(deviceAddress == msg.sender);
        uint id = devices.length;
        if (id == 0) {
            Device[_deviceId] = Device.length;
            id = Device.length++;
        }
        Device[id] = Device({device: deviceAddress, certificate: deviceCertificate, currOwner: deviceCurrowner});
        DeviceAdded(deviceAddress, deviceCertificate, currOwner);
        
    }

//This function is for removing a device from the Device Index 

    function removeDevice(uint _deviceId)  public {
        require(Device[_deviceId].address == msg.sender);
        for (uint i = Device[_deviceId]; i<Device.length-1; i++){
            Device[i] = Device[i+1];
        }
        delete Device[Device.length-1];
        Device.length--;
        DeviceRemoved(_deviceId);
       
    }


    function getUserRole (address _userAddress) returns (uint _userId, string _userRole)  private {
    	for (uint i=1; i<User.length; i++){
    		if (User[i].address == userAddress;){
    			uint _userId = i;
    			string _userRole = User[i].role; 
    		    return _userId, _userRole;
    		}
    		else 
    			return "the user is not registered";

    	} 

    	

    		
    }


}


