--No 1
--Menampilkan semua data staff perempuan
SELECT *
FROM MsStaff
WHERE StaffGender LIKE('Female')

--No 2
--Menampilkan nama staff yang memiliki m dinamanya dengan gaji di atas 10000000
SELECT StaffName,
	   StaffSalary = 'Rp. ' + CAST(StaffSalary AS VARCHAR)
FROM MsStaff
WHERE StaffName LIKE '%m%' AND StaffSalary >= 10000000

--No 3
--Menampilkan nama treatment, harga yang bertipe message / spa or beauty care
SELECT TreatmentName,
	   Price
FROM MsTreatment 
	 JOIN MsTreatmentType ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
WHERE TreatmentTypeName IN('Message / Spa', 'Beauty Care')

--No 4
--Menampilkan nama staff, posisi, tanggal 
--dimana gaji staff di antara 7000000 dan 10000000
SELECT StaffName,
	   StaffPosition,
	   CONVERT(VARCHAR, TransactionDate, 107) AS TransactionDate
FROM MsStaff
	 JOIN HeaderSalonServices ON MsStaff.StaffId = HeaderSalonServices.StaffId
WHERE StaffSalary BETWEEN 7000000 AND 10000000

--No 5
--Menampilkan nama depan customer, huruf pertama gender, dan tipe pembayaran
--dimana pembayaran dilakukan dengan debit
SELECT LEFT(CustomerName, CHARINDEX(' ', CustomerName)) AS 'Name',
	   SUBSTRING(CustomerGender, 1, 1) AS 'Gender',
	   PaymentType
FROM MsCustomer
	 JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE PaymentType LIKE 'Debit'

--No 6
--Menampilkan inisial nama customer dan hari 
--dimana perbedaan hari kurang dari 3
SELECT CONCAT(UPPER(LEFT(CustomerName, 1)), UPPER(SUBSTRING(CustomerName, CHARINDEX(' ', CustomerName) + 1, 1))) AS 'Initial',
	   DATENAME(WEEKDAY, TransactionDate) AS 'Day'
FROM MsCustomer
	 JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE DATEDIFF(DAY, TransactionDate, '2012/12/24') < 3

--No 7
--Menampilkan tanggal transaksi dan nama customer setelah spasi
SELECT TransactionDate,
	   RIGHT(CustomerName, CHARINDEX(' ', REVERSE(CustomerName))) AS CustomerName
FROM HeaderSalonServices
	 JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE DATENAME(WEEKDAY, TransactionDate) = 'Saturday'

--No 8
--Menampilkan nama staff, nama customer, nomor customer yang diubah awalnya, dan alamat customer
--dimana nama customer dimulai dengan huruf vokal dan nama staff setidaknya 3 kata
SELECT StaffName,
	   CustomerName,
	   REPLACE(CustomerPhone, '08', '+62') AS CustomerPhone,
	   CustomerAddress
FROM HeaderSalonServices
	 JOIN MsStaff ON HeaderSalonServices.StaffId = MsStaff.StaffId
	 JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE (
		CustomerName LIKE 'A%' OR
		CustomerName LIKE 'I%' OR
		CustomerName LIKE 'U%' OR
		CustomerName LIKE 'E%' OR
		CustomerName LIKE 'O%'
	  )
	  AND LEN(StaffName) - LEN(REPLACE(StaffName, ' ', '')) > 1

--No 9
--Menampilkan nama staff, nama treatment, dan term of transaction 
--dimana nama treatment lebih dari 20 karakter
SELECT StaffName,
	   TreatmentName,
	   DATEDIFF(DAY, TransactionDate, '2012/12/24') AS 'Term of Transaction'
FROM MsStaff
	 JOIN HeaderSalonServices ON MsStaff.StaffId = HeaderSalonServices.StaffId
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	 JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE (
		LEN(TreatmentName) > 20 OR
		LEN(TreatmentName) - LEN(REPLACE(TreatmentName, ' ', '')) > 0
	  )
	  
--No 10	
--Menampilkan tanggal transaksi, nama customer, nama treatment, diskon, dan tipe pembayaran
--pada tanggal 22
SELECT TransactionDate,
	   CustomerName,
	   TreatmentName,
	   CAST(Price * 20 / 100 AS INT) AS 'Discount',
	   PaymentType
FROM HeaderSalonServices
	 JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	 JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE DATENAME(DAY, TransactionDate) = 22