pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

// note that the onlySomeOwners function is based on the bitclave's implementation
// it si available on this github link https://github.com/bitclave/Multiownable

contract LSC {

uint cnt = 0;
Transactions[] public transactions;
address[] public owners;


    struct Transactions {
        uint userid;
		string functionName;
        string timestamp;

    }


mapping(uint => Transactions) private transaction;
mapping(address => uint) public ownersIndices;


modifier onlyAHSC(uint _AHSCaddress) {
    require(AHSCaddress=='0x45135b8ED5f52528175CCC6D7add2228779eDeE0');
        _;
    }

modifier onlySomeOwners(uint howMany) {
        require(howMany > 0, "onlySomeOwners: howMany argument is zero");
        require(howMany <= owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");
        
        if (checkHowManyOwners(howMany)) {
            bool update = (insideCallSender == address(0));
            if (update) {
                insideCallSender = msg.sender;
                insideCallCount = howMany;
            }
            _;
            if (update) {
                insideCallSender = address(0);
                insideCallCount = 0;
            }
        }
    }


function addTransaction (uint _userId, string _functionName) onlyAHSC(_AHSCaddress) returns(bool) {
		
		uint id = Transactions.length;
        if (id == 0) {
            Transactions[id] == Transactions.length;
            id = Transactions.length++;
        }
        User[id] = User({userid: userId, functionName: _functionName, timestamp: now });
        TransactionAdded(userId, functionName, timestamp);

}

function ownersCount() public constant returns(uint) {
        return owners.length;
    }


function checkHowManyOwners(uint howMany) internal returns(bool) {
        if (insideCallSender == msg.sender) {
            require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");
            return true;
        }

        uint ownerIndex = ownersIndices[msg.sender] - 1;
        require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");
        bytes32 operation = keccak256(msg.data, ownersGeneration);

        require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");
        votesMaskByOperation[operation] |= (2 ** ownerIndex);
        uint operationVotesCount = votesCountByOperation[operation] + 1;
        votesCountByOperation[operation] = operationVotesCount;
        if (operationVotesCount == 1) {
            allOperationsIndicies[operation] = allOperations.length;
            allOperations.push(operation);
            emit OperationCreated(operation, howMany, owners.length, msg.sender);
        }
        emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);

        // If enough owners confirmed the same operation
        if (votesCountByOperation[operation] == howMany) {
            deleteOperation(operation);
            emit OperationPerformed(operation, howMany, owners.length, msg.sender);
            return true;
        }

        return false;
    }



function deleteOperation(bytes32 operation) internal {
        uint index = allOperationsIndicies[operation];
        if (index < allOperations.length - 1) { // Not last
            allOperations[index] = allOperations[allOperations.length - 1];
            allOperationsIndicies[allOperations[index]] = index;
        }
        allOperations.length--;

        delete votesMaskByOperation[operation];
        delete votesCountByOperation[operation];
        delete allOperationsIndicies[operation];
    }


  constructor() public {
        owners.push(msg.sender);
        ownersIndices[msg.sender] = 1;
        howManyOwnersDecide = 1;
    }


function logRetrieve (uint _userId) onlySomeOwners(2) returns(transaction) {

	for (i=1;i<Transactions[].length;i++)
		if(Transactions[i].userid == _userId){

			return (Tranasctions[i].userid,Tranasctions[i].functionName,Tranasctions[i].timestamp);
		}


}


}