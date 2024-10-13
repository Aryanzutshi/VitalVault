// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Identity {
    string private name;
    uint private age;

    constructor() public {
        name = "Laljan";
        age = 24;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function getAge() public view returns (uint) {
        return age;
    }

    function setAge(uint _age) public {
        age = _age;
    }
}
