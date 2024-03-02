//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientRecords {
    uint256 patientCount;
    address[] doctorsList;

    struct Doctor {
        uint256 id;
        string name;
        string qualification;
        string workPlace;
        mapping(uint256 => address) patients;
        uint256 patientCount;
    }

    struct Patient {
        uint256 id;
        string name;
        uint256 age;
        address patientAddress;
        string[] diseases;
        uint256[] prescribedMedicines;
    }

    struct Medicine {
        uint256 id;
        string name;
        string expiryDate;
        string dose;
        uint256 price;
    }

    mapping(address => Doctor)doctors;
    mapping(address => Patient)patients;
    mapping(uint256 => Medicine)medicines;

    function addMedicine(uint256 _id, string memory _name, string memory _expiryDate, string memory _dose, uint256 _price) external {
        Medicine storage medicine = medicines[_id];
        medicine.id = _id;
        medicine.name = _name;
        medicine.expiryDate = _expiryDate;
        medicine.dose = _dose;
        medicine.price = _price;
    }
     function addNewDisease(string memory _disease) external {
        patients[msg.sender].diseases.push(_disease);
    }
    function prescribeMedicine(uint256 _medicineId, address _patient) external {
        require(doctors[msg.sender].id > 0, "Only registered doctors can prescribe medicine");
        
        Medicine storage medicine = medicines[_medicineId];
        require(medicine.id > 0, "Invalid medicine ID");

        patients[_patient].prescribedMedicines.push(_medicineId);
        patients[_patient].diseases.push(medicine.name);
    }
    function registerDoctor(uint256 _id, string memory _name, string memory _qualification, string memory _workPlace) external {
        require(_id > 0, "Invalid doctor ID");
        require(doctors[msg.sender].id == 0, "Doctor is already registered");
        Doctor storage doctor = doctors[msg.sender];
        doctor.id = _id;
        doctor.name = _name;
        doctor.qualification = _qualification;
        doctor.workPlace = _workPlace;
    }
    function registerPatient(uint256 _id, string memory _name, uint256 _age) external {
        require(_id > 0, "Invalid patient ID");
        require(patients[msg.sender].id == 0, "Patient is already registered");
        Patient storage patient = patients[msg.sender];
        patient.id = _id;
        patient.name = _name;
        patient.age = _age;
        patient.patientAddress = msg.sender;
        patientCount++;
    }
    function updateAge(uint256 _age) external {
        patients[msg.sender].age = _age;
    }
    function viewDoctorById(uint256 _doctorId) external view returns (uint256, string memory, string memory, string memory) {
    require(_doctorId > 0, "Doctor not found");
    Doctor storage doctor = doctors[msg.sender];
    return (doctor.id, doctor.name, doctor.qualification, doctor.workPlace);
}

    function viewMedicine(uint256 _Id) external view returns (uint256, string memory, string memory, string memory, uint256) {
        Medicine storage medicine = medicines[_Id];
        return (medicine.id, medicine.name, medicine.expiryDate, medicine.dose, medicine.price);
    }
    function viewPatientById(uint256 _patientId) external view returns (uint256, string memory, uint256, address, string[] memory, uint256[] memory) {
        require(_patientId > 0, "Invalid patient ID");
        Patient storage patient = patients[msg.sender];
        return (patient.id, patient.name, patient.age, patient.patientAddress, patient.diseases, patient.prescribedMedicines);
    }
    function viewPrescribedMedicine(address _patientAddress) external view returns (uint256[] memory) {
        require(_patientAddress != address(0), "Invalid patient address");
        return patients[_patientAddress].prescribedMedicines;
    }
    
    function viewPatientDetailsByDoctorId(uint256 _doctorId) external view returns (uint256, string memory, uint256, string[] memory) {
        require(doctors[msg.sender].id > 0, "Only registered doctors can view patients");
        require(_doctorId == doctors[msg.sender].id, "Invalid doctor ID");        
        Patient storage patient = patients[msg.sender];
        return (patient.id, patient.name, patient.age, patient.diseases);
    }
    function viewRecord() external view returns (uint256, string memory, uint256, string[] memory) {
        require(patients[msg.sender].id > 0, "Only registered patients can view their records");
        Patient storage patient = patients[msg.sender];
        return (patient.id, patient.name, patient.age, patient.diseases);
    }
}
