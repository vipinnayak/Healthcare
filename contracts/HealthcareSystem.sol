// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthcareSystem {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // --- Hospital ---
    struct Hospital {
        string hospitalName;
        address hospitalAddress;
        string hospitalSpec;
    }

    mapping(uint => Hospital) public hospitals;
    uint public hospitalCount;

    function addHospital(string memory name, address addr, string memory spec) public onlyOwner {
        hospitalCount++;
        hospitals[hospitalCount] = Hospital(name, addr, spec);
    }

    // --- Insurance ---
    struct Insurance {
        uint policyNo;
        string insurerName;
        address insurerAddress;
        string description;
        uint policyLimit;
        address insuranceAddress;
        address patientAddress;
    }

    mapping(uint => Insurance) public insurances;
    uint public insuranceCount;

    event InsuranceAdded(uint indexed insuranceId, uint policyNo, address patientAddress);

    function generateRandomPolicyNumber(address patientAddr) private view returns (uint) {
        uint policyNo = uint(
            keccak256(
                abi.encodePacked(block.timestamp, patientAddr, msg.sender, block.difficulty, insuranceCount)
            )
        ) % 1000000;

        return policyNo == 0 ? 1 : policyNo;
    }

    function addInsurance(
        string memory name,
        address addr,
        string memory desc,
        uint limit,
        address insuranceAddr,
        address patientAddr
    ) public onlyOwner {
        for (uint i = 1; i <= insuranceCount; i++) {
            if (insurances[i].patientAddress == patientAddr) {
                revert("This patient already has an insurance policy.");
            }
        }

        uint policyNo = generateRandomPolicyNumber(patientAddr);
        insuranceCount++;
        insurances[insuranceCount] = Insurance(policyNo, name, addr, desc, limit, insuranceAddr, patientAddr);

        emit InsuranceAdded(insuranceCount, policyNo, patientAddr);
    }

    // --- Patient ---
    struct Patient {
        string name;
        uint patientId;
        uint age;
        string gender;
        string height;
        string weight;
        address patientAddress;
        uint phone;
        string email;
        uint hospitalId;
        uint doctorId;
        uint policyNo;
    }

    mapping(uint => Patient) public patients;
    uint public patientCount;

    function addPatient(
        string memory name,
        uint age,
        string memory gender,
        string memory height,
        string memory weight,
        address addr,
        uint phone,
        string memory email,
        uint hospitalId,
        uint doctorId,
        uint policyNo
    ) public onlyOwner {
        bool validPolicy = false;
        for (uint i = 1; i <= insuranceCount; i++) {
            if (insurances[i].patientAddress == addr && insurances[i].policyNo == policyNo) {
                validPolicy = true;
                break;
            }
        }
        require(validPolicy, "Invalid or non-existent policy number for this patient.");

        patientCount++;
        patients[patientCount] = Patient(name, patientCount, age, gender, height, weight, addr, phone, email, hospitalId, doctorId, policyNo);
    }

    // --- Doctor ---
    struct Doctor {
        string name;
        uint doctorId;
        string specialization;
        uint phone;
        address doctorAddress;
    }

    mapping(uint => Doctor) public doctors;
    uint public doctorCount;

    function addDoctor(
        string memory name,
        string memory specialization,
        uint phone,
        address addr
    ) public onlyOwner {
        doctorCount++;
        doctors[doctorCount] = Doctor(name, doctorCount, specialization, phone, addr);
    }

    // --- Bill ---
    struct Bill {
        uint billId;
        string drugName;
        uint drugCount;
        uint cost;
        address patientAddress;
        address pharmacyAddress;
    }

    mapping(uint => Bill) public bills;
    uint public billCount;

    function addBill(
        string memory drugName,
        uint drugCount,
        uint cost,
        address patientAddr,
        address pharmacyAddr
    ) public onlyOwner {
        billCount++;
        bills[billCount] = Bill(billCount, drugName, drugCount, cost, patientAddr, pharmacyAddr);
    }

    // --- Report ---
    struct Report {
        uint reportId;
        string diagnosis;
        string drugName;
        uint drugCount;
        address patientAddress;
        address doctorAddress;
    }

    mapping(uint => Report) public reports;
    uint public reportCount;

    function addReport(
        string memory diagnosis,
        string memory drugName,
        uint drugCount,
        address patientAddr,
        address doctorAddr
    ) public onlyOwner {
        reportCount++;
        reports[reportCount] = Report(reportCount, diagnosis, drugName, drugCount, patientAddr, doctorAddr);
    }

    // --- Applied Insurance ---
    struct AppliedInsurance {
        uint appliedId;
        uint policyNo;
        address patientAddr;
        address doctorAddr;
        address pharmacyAddr;
        address hospitalAddr;
        bool hospitalApproval;
        bool pharmacyApproval;
        bool isClaimed;
    }

    mapping(uint => AppliedInsurance) public appliedInsurances;
    uint public appliedInsuranceCount;

   function applyForInsurance(
    uint policyNo,
    address patientAddr,
    address doctorAddr,
    address pharmacyAddr,
    address hospitalAddr
) public {
    require(msg.sender == patientAddr, "Only the patient can apply for insurance.");

    bool isValidPolicy = false;
    for (uint i = 1; i <= patientCount; i++) {
        if (patients[i].patientAddress == patientAddr && patients[i].policyNo == policyNo) {
            isValidPolicy = true;
            break;
        }
    }
    require(isValidPolicy, "Patient policy number does not match.");

    appliedInsuranceCount++;
    appliedInsurances[appliedInsuranceCount] = AppliedInsurance(
        appliedInsuranceCount,
        policyNo,
        patientAddr,
        doctorAddr,
        pharmacyAddr,
        hospitalAddr,
        false,
        false,
        false
    );
}

    function approveInsuranceByHospital(uint appliedId) public {
        AppliedInsurance storage applied = appliedInsurances[appliedId];
        require(applied.hospitalAddr == msg.sender, "Only the hospital can approve.");
        applied.hospitalApproval = true;
    }

    function approveInsuranceByPharmacy(uint appliedId) public {
        AppliedInsurance storage applied = appliedInsurances[appliedId];
        require(applied.pharmacyAddr == msg.sender, "Only the pharmacy can approve.");
        applied.pharmacyApproval = true;
    }

    function claimInsurance(uint appliedId) public {
        AppliedInsurance storage applied = appliedInsurances[appliedId];
        require(applied.hospitalApproval && applied.pharmacyApproval, "Insurance must be approved by both hospital and pharmacy.");
        require(!applied.isClaimed, "Insurance is already claimed.");
        require(applied.policyNo > 0, "Invalid policy number.");
        applied.isClaimed = true;
    }
}