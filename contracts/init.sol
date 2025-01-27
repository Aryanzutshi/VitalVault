// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HospitalRecords {
    // Owner of the contract
    address public owner;

    // Struct for patient details
    struct Patient {
        uint id;
        string name;
        uint age;
        string gender;
        address walletAddress;
    }

    // Struct for medical records
    struct MedicalRecord {
        uint id;
        string description;
        string diagnosis;
        uint timestamp;
    }

    // Mappings for patients and their records
    mapping(address => Patient) public patients;
    mapping(address => MedicalRecord[]) public medicalRecords;

    // Authorized hospitals
    mapping(address => bool) public authorizedHospitals;

    // Events
    event PatientRegistered(address patientAddress, uint id, string name);
    event MedicalRecordAdded(address patientAddress, uint recordId, string description);
    event HospitalAuthorized(address hospitalAddress);
    event HospitalRevoked(address hospitalAddress);

    constructor() {
        owner = msg.sender; // Set the contract owner
    }

    // Modifier for contract owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // Modifier for authorized hospitals
    modifier onlyAuthorizedHospital() {
        require(authorizedHospitals[msg.sender], "Not an authorized hospital");
        _;
    }

    // Register a new patient
    function registerPatient(
        uint _id,
        string memory _name,
        uint _age,
        string memory _gender,
        address _walletAddress
    ) public onlyAuthorizedHospital {
        require(patients[_walletAddress].id == 0, "Patient already registered");
        patients[_walletAddress] = Patient(_id, _name, _age, _gender, _walletAddress);
        emit PatientRegistered(_walletAddress, _id, _name);
    }

    // Add a medical record for a patient
    function addMedicalRecord(
        address _patientAddress,
        uint _recordId,
        string memory _description,
        string memory _diagnosis
    ) public onlyAuthorizedHospital {
        require(patients[_patientAddress].id != 0, "Patient not registered");
        medicalRecords[_patientAddress].push(MedicalRecord(_recordId, _description, _diagnosis, block.timestamp));
        emit MedicalRecordAdded(_patientAddress, _recordId, _description);
    }

    // Get all medical records of a patient
    function getMedicalRecords(address _patientAddress) public view returns (MedicalRecord[] memory) {
        require(msg.sender == _patientAddress || authorizedHospitals[msg.sender], "Access denied");
        return medicalRecords[_patientAddress];
    }

    // Authorize a hospital
    function authorizeHospital(address _hospitalAddress) public onlyOwner {
        authorizedHospitals[_hospitalAddress] = true;
        emit HospitalAuthorized(_hospitalAddress);
    }

    // Revoke hospital authorization
    function revokeHospital(address _hospitalAddress) public onlyOwner {
        authorizedHospitals[_hospitalAddress] = false;
        emit HospitalRevoked(_hospitalAddress);
    }
}
