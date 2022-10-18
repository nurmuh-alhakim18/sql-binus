/*INSERT DATA TAMBAHAN
INSERT INTO MsStaff(StaffId, StaffName ,StaffGender, StaffPhone ,StaffAddress, StaffSalary, StaffPosition)
VALUES
('SF006', 'Jeklin Harefa', 'Female', '085265433322', 'Kebon Jeruk Street no 140', '3000000', 'Stylist'),
('SF007', 'Lavinia', 'Female', '085755500011', 'Kebon Jeruk Street no 153', '3000000', 'Stylist'),
('SF008', 'Stephen Adrianto', 'Male', '085564223311', 'Mandala Street no 14', '3000000', 'Stylist'),
('SF009', 'Rico Wijaya', 'Male', '085710252525', 'Keluarga Street no 78', '3000000', 'Stylist');

INSERT INTO  HeaderSalonServices(TransactionId, CustomerId, StaffId, TransactionDate, PaymentType)
VALUES
('TR010', 'CU001', 'SF004', '2012/12/23', 'Credit'),
('TR011', 'CU002', 'SF006', '2012/12/24', 'Credit'),
('TR012', 'CU003', 'SF007', '2012/12/24', 'Cash'),
('TR013', 'CU004', 'SF005', '2012/12/25', 'Debit'),
('TR014', 'CU005', 'SF007', '2012/12/25', 'Debit'),
('TR015', 'CU005', 'SF005', '2012/12/26', 'Credit'),
('TR016', 'CU002', 'SF001', '2012/12/26', 'Cash'),
('TR017', 'CU003', 'SF002', '2012/12/26', 'Credit'),
('TR018', 'CU005', 'SF001', '2012/12/27', 'Debit');

INSERT INTO DetailSalonServices(TransactionId, TreatmentId)
VALUES
('TR010', 'TM003'),
('TR010', 'TM005'),
('TR010', 'TM010'),
('TR011', 'TM015'),
('TR011', 'TM025'),
('TR012', 'TM009'),
('TR013', 'TM003'),
('TR013', 'TM006'),
('TR013', 'TM015'),
('TR014', 'TM016'),
('TR015', 'TM016'),
('TR015', 'TM006'),
('TR016', 'TM015'),
('TR016', 'TM003'),
('TR016', 'TM005'),
('TR017', 'TM003'),
('TR018', 'TM006'),
('TR018', 'TM005'),
('TR018', 'TM007');
*/

--No 1
--Menampilkan Max dan min price
SELECT MAX(Price) AS 'Maximum Price',
	   MIN(Price) AS 'Minimum Price',
	   CAST(ROUND(AVG(Price), 0) AS DECIMAL(8, 2)) AS 'Average Price'
FROM MsTreatment

--No 2
--Menampilkan posisi staff, gender dan rata - rata gaji
SELECT StaffPosition,
	   LEFT(StaffGender, 1) AS Gender,
	   'Rp. ' + CAST(CAST(AVG(StaffSalary) AS DECIMAL (10, 2)) AS VARCHAR) AS 'Average Salary'
FROM MsStaff
GROUP BY StaffPosition, StaffGender

--No 3
--Menampilkan tanggal dengan format Bulan tanggal, tahun dan total transaksi hari itu
SELECT CONVERT(VARCHAR, TransactionDate, 107) AS TransactionDate,
	   COUNT(TransactionDate) AS 'Total Transaction per Day'
FROM HeaderSalonServices
GROUP BY TransactionDate

--No 4
--Menampilkan Gender customer dan total transaksi
SELECT UPPER(CustomerGender) AS CustomerGender,
	   COUNT(CustomerGender) AS TotalTransaction
FROM MsCustomer
GROUP BY CustomerGender

--No 5
--Menampilkan nama tipe treatment dan total transaksinya
SELECT TreatmentTypeName,
	   COUNT(TransactionId) AS 'Total Transaction'
FROM MsTreatmentType 
	 JOIN MsTreatment ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId 
	 JOIN DetailSalonServices ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId   
GROUP BY TreatmentTypeName
ORDER BY 'Total Transaction' DESC

--No 6
--Menampilkan tanggal dengan format tanggal bulan tahun dan jumlah total uang hari itu
SELECT CONVERT(VARCHAR, TransactionDate, 106) AS 'Date',
	   CONCAT('Rp. ', CAST(SUM(Price) AS VARCHAR)) AS 'Revenue per Day'
FROM HeaderSalonServices
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	 JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
GROUP BY TransactionDate 
HAVING SUM(Price) BETWEEN 1000000 AND 5000000

--No 7
--Menampilkan id tipe treatment yang diubah, nama tipe treatment, dan total jenis treatment pada suatu tipe
SELECT REPLACE(MsTreatmentType.TreatmentTypeId, 'TT0', 'Treatment Type ') AS 'ID',
	   TreatmentTypeName,
	   CONCAT(COUNT(MsTreatment.TreatmentTypeId), ' Treatment') AS 'Total Treatment per Type'
FROM MsTreatmentType 
	 JOIN MsTreatment ON MsTreatmentType.TreatmentTypeId =  MsTreatment.TreatmentTypeId
GROUP BY MsTreatmentType.TreatmentTypeId, TreatmentTypeName
HAVING COUNT(MsTreatment.TreatmentTypeId) > 5
ORDER BY COUNT(MsTreatment.TreatmentTypeId) DESC

--No 8
--Menampilkan nama staff sebelum spasi, id transaksi, dan total treatment pada transaksi
SELECT CASE CHARINDEX(' ', StaffName) 
		WHEN 0 THEN StaffName
		ELSE LEFT(StaffName, CHARINDEX(' ', StaffName))
       END AS StaffName,
	   HeaderSalonServices.TransactionId AS TransactionId,
	   COUNT(DetailSalonServices.TransactionId) AS 'Total Treatment per Transaction'
FROM MsStaff
	 JOIN HeaderSalonServices ON MsStaff.StaffId = HeaderSalonServices.StaffId
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
GROUP BY StaffName, HeaderSalonServices.Transactionid, DetailSalonServices.Transactionid

--No 9
--Menampilkan tanggal, nama customer, treatment yang didapat, dan harga treatment
SELECT TransactionDate,
	   CustomerName,
	   TreatmentName,
	   Price
FROM HeaderSalonServices,																					
	 MsCustomer,
	 MsTreatment,
	 DetailSalonServices,
	 MsStaff
WHERE HeaderSalonServices.CustomerId = MsCustomer.CustomerId
      AND HeaderSalonServices.StaffId = MsStaff.StaffId
	  AND HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	  AND DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
	  AND DATENAME(WEEKDAY, TransactionDate) = 'Thursday'
	  AND StaffName LIKE '%Ryan%'
ORDER BY TransactionDate, CustomerName

--No 10
--Menampilkan tanggal, nama customer, dan total transaksi customer
SELECT TransactionDate,
	   CustomerName,
	   SUM(Price) AS TotalPrice
FROM HeaderSalonServices,
	 MsCustomer,
	 MsTreatment,
	 DetailSalonServices
WHERE HeaderSalonServices.CustomerId = MsCustomer.CustomerId
	  AND HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	  AND DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
	  AND DATENAME(DAY, TransactionDate) > 20
GROUP BY TransactionDate, CustomerName
ORDER BY TransactionDate


