--No 1
CREATE TABLE MsCustomer 
(
    CustomerId CHAR(5) NOT NULL,
    CustomerName VARCHAR(50),
    CustomerGender VARCHAR(10),
    CustomerPhone VARCHAR(13),
    CustomerAddress VARCHAR(100),
    PRIMARY KEY(CustomerId),
    CONSTRAINT Check_CustId CHECK(CustomerId LIKE ('CU[0-9][0-9][0-9]')),
    CONSTRAINT Check_CustGen CHECK(CustomerGender IN ('Male', 'Female'))
);

CREATE TABLE MsStaff 
(
    StaffId CHAR(5) NOT NULL,
    StaffName VARCHAR(50),
    StaffGender VARCHAR(10),
    StaffPhone VARCHAR(13),
    StaffAddress VARCHAR(100),
    StaffSalary NUMERIC(11,2),
    StaffPosition VARCHAR(20),
    PRIMARY KEY(StaffId),
    CONSTRAINT Check_StaffId CHECK(StaffId LIKE ('SF[0-9][0-9][0-9]')),
	CONSTRAINT Check_StaffGen CHECK(StaffGender IN('Male', 'Female'))
);

CREATE TABLE MsTreatmentType 
(
    TreatmentTypeId CHAR(5) NOT NULL,
    TreatmentTypeName VARCHAR(50),
    PRIMARY KEY(TreatmentTypeId),
    CONSTRAINT Check_TreatTypeId CHECK(TreatmentTypeId LIKE ('TT[0-9][0-9][0-9]'))
);

CREATE TABLE MsTreatment 
(
    TreatmentId CHAR(5) NOT NULL,
    TreatmentTypeId CHAR(5) NOT NULL,
    TreatmentName VARCHAR(50),
    Price NUMERIC(11,2),
    PRIMARY KEY(TreatmentId),
	FOREIGN KEY(TreatmentTypeId) REFERENCES MsTreatmentType(TreatmentTypeId) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT Check_TreatId CHECK(TreatmentId LIKE ('TM[0-9][0-9][0-9]'))
);

CREATE TABLE HeaderSalonServices 
(
    TransactionId CHAR(5) NOT NULL,
    CustomerId CHAR(5) NOT NULL,
    StaffId CHAR(5) NOT NULL,
    TransactionDate DATE,
    PaymentType VARCHAR(20),
    PRIMARY KEY(TransactionId),
	FOREIGN KEY(CustomerId) REFERENCES MsCustomer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(StaffId) REFERENCES MsStaff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT Check_TransId CHECK(TransactionId LIKE ('TR[0-9][0-9][0-9]'))
);

CREATE TABLE DetailSalonServices 
(
    TransactionId CHAR(5) NOT NULL,
    TreatmentId CHAR(5) NOT NULL,
    PRIMARY KEY(TransactionId, TreatmentId),
	FOREIGN KEY(TransactionId) REFERENCES HeaderSalonServices(TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(TreatmentId) REFERENCES MsTreatment(TreatmentId) ON UPDATE CASCADE ON DELETE CASCADE
);

--No 2
DROP TABLE DetailSalonServices

--No 3
CREATE TABLE DetailSalonServices
(
	TransactionId CHAR(5) NOT NULL,
	TreatmentId CHAR(5) NOT NULL,
	FOREIGN KEY(TransactionId) REFERENCES HeaderSalonServices(TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(TreatmentId) REFERENCES MsTreatment(TreatmentId) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE DetailSalonServices
	ADD PRIMARY KEY(TransactionId, TreatmentId);

--No 4
ALTER TABLE MsStaff
	WITH NOCHECK
	ADD CONSTRAINT Check_Length CHECK(LEN(StaffName) <= 5 AND LEN(StaffName) >=20);

ALTER TABLE MsStaff
	DROP CONSTRAINT Check_Length;

--No 5
ALTER TABLE MsTreatment
	ADD Description VARCHAR(100);

ALTER TABLE MsTreatMent
	DROP Column Description;