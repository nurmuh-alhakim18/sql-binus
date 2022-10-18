--No 1
--Memasukkan data-data baru pada tabel MsStaff, HeaderSalonServices, DetailSalonServices
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

--No 2
--Memasukkan data pada HeaderSalonServices, dengan tanggal 3 hari setelah hari ini
INSERT INTO HeaderSalonServices(TransactionId, CustomerId, StaffId, TransactionDate, PaymentType)
VALUES
('TR019', 'CU005', 'SF004', DATEADD(day, 3, CAST(GETDATE() AS DATE)), 'Credit');

--No 3
--Memasukkan data pada MsStaff, dengan gaji dengan rentang 3.000.000-5.000.000 secara random
INSERT INTO MsStaff(StaffId, StaffName ,StaffGender, StaffPhone ,StaffAddress, StaffSalary, StaffPosition)
VALUES
('SF010', 'Effendy Lesmana', 'Male', '085218587878', 'Tanggerang City Street no 88', FLOOR(RAND() * (5000000 - 3000000 + 1) + 3000000), 'Stylist');

--No 4
--Mengubah kolom CustomerPhone yang awalnya 08->628
UPDATE MsCustomer
SET CustomerPhone = REPLACE(CustomerPhone, '08', '628');

--No 5
--Mengubah data Effendy Lesmana, Stylist->Top stylist dan menambah gaji sebanyak 7.000.000
UPDATE MsStaff
SET StaffPosition = REPLACE(StaffPosition, 'Stylist', 'Top Stylist'),
	StaffSalary = StaffSalary + 7000000
WHERE StaffName LIKE 'Effendy Lesmana'

--No 6
--Mengubah nama customer yang memiliki spasi dengan ketentuan TransactionDate pada tanggal 24
UPDATE MsCustomer
SET CustomerName = LEFT(CustomerName, CHARINDEX(' ', CustomerName))
FROM MsCustomer JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE DATEPART(DAY, TransactionDate) = 24

--No 7
--Menambahkan Ms. pada customer dengan id CU002 dan CU003
UPDATE MsCustomer
SET CustomerName = CONCAT('Ms. ', CustomerName)
WHERE CustomerId IN('CU002', 'CU003')

--No 8
--Mengubah alamat customer dimana customer tersebut dilayani oleh Indra Saswita pada hari Kamis
UPDATE MsCustomer
SET CustomerAddress = 'Daan Mogot Baru Street No. 23'
WHERE EXISTS(
SELECT CustomerId 
FROM HeaderSalonServices, MsStaff
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND MsStaff.StaffId = HeaderSalonServices.StaffId AND StaffName LIKE 'Indra Saswita' AND DATENAME(WEEKDAY, HeaderSalonServices.TransactionDate) = 'Thursday'
);

--No 9
--Menghapus data HeaderSalonServices dengan ketentuan nama customer tidak memiliki spasi
DELETE FROM HeaderSalonServices
FROM HeaderSalonServices JOIN MsCustomer
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE CHARINDEX(' ', CustomerName) = 0

--No 10
--Menghapus data MsTreatment yang tidak memiliki kata treatment
DELETE FROM MsTreatment
WHERE TreatmentName NOT LIKE ('%treatment%')
