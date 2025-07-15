 ## Blockchain-based Healthcare Insurance System


This project is a smart contract–based Healthcare Insurance System developed using Solidity. It manages hospitals, doctors, patients, insurance policies, bills, reports, and the insurance claim process on the Ethereum blockchain.

## Tech Stack
- **Smart Contracts:** Solidity (v0.8.0)
- **Framework:** Truffle
- **Blockchain Simulator:** Ganache (CLI/GUI)
- **Testing:** Truffle Console (manual input)

## Project Structure
build\contracts
└── HealthcareSystem.json
contracts/
└── HealthcareSystem.sol
migrations/
└── 1_deploy_contracts.js
test/
└── (optional)
scripts/
└── (optional console scripts)
README.md
truffle-config.js

## Setup Instructions

### 1.Prerequisites

- Node.js (recommended v18.x)
- Truffle (`npm install -g truffle`)
- Ganache (GUI or CLI)

---

### 2. Compile & Migrate

Start Ganache first (port: `7545`).


truffle compile
truffle migrate --reset
truffle console

## Manual Testing Using Truffle Console
You can interact with the deployed contract using Truffle Console and the commands below.

 1. Load Contract
const healthcare = await HealthcareSystem.deployed();
________________________________________
 2. Add Hospital
await healthcare.addHospital(
  "Apollo Hospital",
  "0x077AEcE1b733f1976FA7e9626b171b32C5d1Fd62",  // Hospital Address
  "Cardiology",
  { from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" } // Owner Address
);
________________________________________
 3. Add Doctor
await healthcare.addDoctor(
  "Dr. Vikas Nayak",
  "Neurology",
  9876543210,
  "0x185D6eFa99fB719624EA31Aa4112b675b0065116", // Doctor Address
  { from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" } // Owner Address
);
________________________________________
 4. Add Insurance
await healthcare.addInsurance(
  "LIC Insurance",
  "0x9cdC154263398346A1CE29C4e20D761d19dCb2A9", // Insurance Company Address
  "Full Coverage",
  50000,
  "0x9cdC154263398346A1CE29C4e20D761d19dCb2A9", // Insurance Address again
  "0x297e668144Be4688a5F04cBfBa881fA52f7c694A", // Patient Address
  { from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" } // Owner Address
);
________________________________________
 5. Add Bill
await healthcare.addBill(
  "Paracetamol",
  2,
  500,
  "0x297e668144Be4688a5F04cBfBa881fA52f7c694A", // Patient Address
  "0x21AF00c8B12746f08E7c789a7Ede3C41e15A86Cb", // Pharmacy Address
  { from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" } // Owner Address
);
________________________________________
 6. Add Report
await healthcare.addReport(
  "Fever",
  "Paracetamol",
  2,
  "0x297e668144Be4688a5F04cBfBa881fA52f7c694A", // Patient Address
  "0x185D6eFa99fB719624EA31Aa4112b675b0065116", // Doctor Address
  { from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" } // Owner Address
);
________________________________________
 7. Get Policy Number
const policy = await healthcare.insurances(1); // Assuming Insurance ID = 1
console.log(policy.policyNo.toString());
(Let’s say it prints 661189)
________________________________________
 8. Add Patient
await healthcare.addPatient(
  "Rahul Sharma",
  30,
  "Male",
  "5ft 9in",
  "70kg",
  "0x297e668144Be4688a5F04cBfBa881fA52f7c694A", // Patient Address
  9876543210,
  "rahul@example.com",
  101, // Hospital ID (you can update this)
  202, // Doctor ID (you can update this)
  661189, // Policy Number
  { from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" } // Owner Address
);
________________________________________
 9. Apply for Insurance
await healthcare.applyForInsurance(
  661189, // Policy Number
  "0x297e668144Be4688a5F04cBfBa881fA52f7c694A", // Patient Address
  "0x185D6eFa99fB719624EA31Aa4112b675b0065116", // Doctor Address
  "0x21AF00c8B12746f08E7c789a7Ede3C41e15A86Cb", // Pharmacy Address
  "0x077AEcE1b733f1976FA7e9626b171b32C5d1Fd62", // Hospital Address
  { from: "0x297e668144Be4688a5F04cBfBa881fA52f7c694A" } // Patient (caller)
);
________________________________________
 10. Approve by Pharmacy
await healthcare.approveInsuranceByPharmacy(1, {
  from: "0x21AF00c8B12746f08E7c789a7Ede3C41e15A86Cb" // Pharmacy
});
________________________________________
 11. Approve by Hospital
await healthcare.approveInsuranceByHospital(1, {
  from: "0x077AEcE1b733f1976FA7e9626b171b32C5d1Fd62" // Hospital
});
________________________________________
 12. Claim Insurance
await healthcare.claimInsurance(1, {
  from: "0x06BE85Ab6A23795571e5411B09C90F4ada49a225" // Owner or any approver
});
________________________________________
 13. View Applied Insurance
await healthcare.appliedInsurances(1);

•  All address values are from Ganache accounts.
•  The full insurance claim process has been tested manually via Truffle Console.
