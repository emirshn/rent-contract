// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract rentContract {
    enum RentalType {house, shop}

    //tenant
    struct Tenant {
        string name;
        string tenantAddress;
        address owner;
    }

    //rent
    //rental type should be 0 or 1 and dates are years like 2022, 2023 etc.
    struct RentalContract{
        RentalType rentalType;
        uint256 startDate;
        uint256 endDate;
    }

    //rent properties
    struct RentalProperty{
        Tenant tenant;
        RentalContract contractInfo;
        bool active;
    }

    RentalProperty[] public rentalProperties;

    mapping(address => Tenant) public tenants;

    function addNewTenant(string memory _name, string memory _address) public {
        Tenant storage newTenant = tenants[msg.sender];
        newTenant.name = _name;
        newTenant.tenantAddress = _address;
        newTenant.owner = msg.sender;
    }

    function addNewRentalProperty(RentalType _rentalType, uint256 _startDate, uint256 _endDate) public {
        RentalContract memory newContract = RentalContract({
            rentalType: _rentalType,
            startDate: _startDate,
            endDate: _endDate
        });

        RentalProperty memory newRentalProperty = RentalProperty({
            tenant: tenants[msg.sender],
            contractInfo: newContract,
            active: false
        });

        rentalProperties.push(newRentalProperty);
    }

    function startRental(uint256 _propertyIndex) public {
        require(_propertyIndex < rentalProperties.length, "Invalid property index");

        RentalProperty storage rentalProperty = rentalProperties[_propertyIndex];
        require(rentalProperty.tenant.owner == msg.sender, "You do not own this property");
        require(!rentalProperty.active, "Property is already rented");

        rentalProperty.active = true;
    }

    function terminateRental(uint256 _propertyIndex) public {
        require(_propertyIndex < rentalProperties.length, "Invalid property index");

        RentalProperty storage rentalProperty = rentalProperties[_propertyIndex];
        require(rentalProperty.tenant.owner == msg.sender, "You do not own this property");
        require(rentalProperty.active, "Property is not rented");

        rentalProperty.active = false;

    }

    mapping(uint256 => string[]) public propertyErrorMessages;

    function reportIssue(uint256 _propertyIndex, string memory _errorMessage) public {
        require(_propertyIndex < rentalProperties.length, "Invalid property index");

        RentalProperty storage rentalProperty = rentalProperties[_propertyIndex];
        require(rentalProperty.tenant.owner == msg.sender, "You do not own this property");
        
        propertyErrorMessages[_propertyIndex].push(_errorMessage);
    }
}