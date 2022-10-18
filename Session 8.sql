/*
--1. Membuat view bernama ViewBonus untuk menampilkan BinusId dan nama Customer
--yang namanya lebih dari 10 karakter
CREATE VIEW ViewBonus AS
SELECT REPLACE(CustomerId, 'CU', 'BN') AS 'BinusID', 
	   CustomerName
FROM MsCustomer
WHERE LEN(CustomerName) > 10;
*/

/*
--2. Membuat view bernama ViewCustomerData untuk menampilkan nama customer sebelum spasi, alamat, dan telepon
--untuk customer yang namanya mengandung spasi
CREATE VIEW ViewCustomerData AS
SELECT LEFT(CustomerName, CHARINDEX(' ', CustomerName)) AS 'Name', 
	   CustomerAddress AS 'Address', 
	   CustomerPhone AS 'Phone'
FROM MsCustomer
WHERE LEN(CustomerName) - LEN(REPLACE(CustomerName, ' ', '')) > 0;
*/

/*
--3. Membuat view bernama ViewTreatment untuk menampilkan nama treatment, nama tipe treatment, dan harga
--untuk treatment yang memiliki tipe Hair Treatment dan harganya antara 450000 dan 800000
CREATE VIEW ViewTreatment AS
SELECT TreatmentName, 
       TreatmentTypeName,
       'Rp.' + CAST(MsTreatment.Price AS VARCHAR) AS 'Price'
FROM MsTreatment, 
	 MsTreatmentType
WHERE MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId AND
	  MsTreatmentType.TreatmentTypeName = 'Hair Treatment' AND
	  MsTreatment.Price BETWEEN 450000 AND 800000;
*/

/*
--4. Membuat view dengan nama ViewTransaction untuk menampilkan nama staff, nama customer, tanggal transaksi, dan tipe pembayaran
--untuk transaksi yang terjadi pada antara tanggal 21 dan 25 lalu dibayar dengan credit
CREATE VIEW ViewTransaction AS
SELECT StaffName, 
       CustomerName,
       CONVERT(DATE, TransactionDate, 106) AS 'TransactionDate',
       PaymentType
FROM MsStaff, 
	 MsCustomer, 
	 HeaderSalonServices
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
	  MsStaff.StaffId = HeaderSalonServices.StaffId AND
	  DAY(TransactionDate) BETWEEN 21 AND 25 AND
	  PaymentType = 'Credit';
*/

/*
--5. Membuat view dengan nama ViewBonusCustomer' untuk menampilkan BonusId, nama, hari transaksi, dan tanggal transaksi
--untuk transaksi dengan customer yang namanya mengandung spasi dan nama terakhir staff yang mengandung huruf a
CREATE VIEW ViewBonusCustomer AS
SELECT REPLACE(MsCustomer.CustomerId, 'CU', 'BN') AS "BonusID",
       LOWER(
	    SUBSTRING(
		 MsCustomer.CustomerName, 
         CHARINDEX(' ', MsCustomer.CustomerName) + 1, 
         LEN(MsCustomer.CustomerName)
        )
	   ) AS 'Name',
       DATENAME(WEEKDAY, TransactionDate) AS 'Day',
       CONVERT(DATE, TransactionDate, 101) AS 'TransactionDate'
FROM MsCustomer, 
	 HeaderSalonServices
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
	  LEN(CustomerName) - LEN(REPLACE(CustomerName, ' ', '')) > 0 AND
	  CustomerName LIKE '%a';
*/

/*
--6. Membuat view bernama ViewTransactionByLivia untuk menampilkan id transaksi, tanggal, dan nama treatment
--untuk setiap transaksi yang terjadi pada tanggal 21 dan dilakukan oleh Livia Ashianti
CREATE VIEW ViewTransactionByLivia AS
SELECT HeaderSalonServices.TransactionId,
       CONVERT(DATE, TransactionDate, 107) AS 'Date',
	   TreatmentName
FROM MsStaff, 
	 MsTreatment, 
	 HeaderSalonServices, 
	 DetailSalonServices
WHERE MsStaff.StaffId = HeaderSalonServices.StaffId AND 
	  MsTreatment.TreatmentId = DetailSalonServices.TreatmentId AND
	  DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId AND 
	  DAY(TransactionDate) = 21 AND
	  StaffName LIKE 'Livia Ashianti';
*/

/*
--7. Membuat view dengan nama ViewCustomerData untuk id, nama, alamat, dan telepon
--untuk setiap customer yang namanya mengandung spasi
ALTER VIEW ViewCustomerData AS
SELECT RIGHT(CustomerId, CHARINDEX('U', CustomerId) + 1) AS 'ID',
            CustomerName AS 'Name',
            CustomerAddress AS 'Address',
            CustomerPhone AS 'Phone'
FROM MsCustomer
WHERE CHARINDEX(' ', CustomerName) > 0;
*/

-- 8. Membuat view dengan nama ViewCustomer untuk menampilkan id, nama, dan gender customer
--lalu insert data
/*
CREATE VIEW ViewCustomer AS
SELECT CustomerId,
	   CustomerName,
	   CustomerGender
FROM MsCustomer;
*/

/*
INSERT INTO ViewCustomer(CustomerId, CustomerName, CustomerGender)
VALUES ('CU006', 'Cristian', 'Male');
*/

/*
--9. Menghapus data pada ViewCustomerData dengan id 005 lalu tampilkan seluruh data
DELETE FROM ViewCustomerData
WHERE ID = '005';
*/

/*
SELECT * 
FROM ViewCustomer;
*/

/*
-- 10. Menghapus ViewCustomerData.
DROP VIEW ViewCustomerData;
*/
