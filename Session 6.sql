--No 1
--Menampilkan tipe treatment, nama treatment, dan harga 
--dimana tipe treatment memiliki kata 'hair' atau 'nail' dengan harga di bawah 100000
SELECT TreatmentTypeName,
	   TreatmentName,
	   Price
FROM MsTreatmentType
	 JOIN MsTreatment ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
WHERE (
		TreatmentTypeName LIKE '%hair%' OR
		TreatmentTypeName LIKE '%nail%'
	  ) AND
	  Price < 100000

--No 2
--Menampilkan nama staff dan email staff dengan mengambil huruf pertama dan nama belakang
--dimana staff melayani pada hari Kamis
SELECT DISTINCT StaffName,
	   LOWER(LEFT(StaffName, 1)) + 
       LOWER(RIGHT(StaffName, CHARINDEX(' ', REVERSE(StaffName)) - 1)) + 
       '@oosalon.com' AS 'StaffEmail'
FROM MsStaff
	 JOIN HeaderSalonServices ON MsStaff.StaffId = HeaderSalonServices.StaffId
WHERE DATENAME(WEEKDAY, TransactionDate) = 'Thursday'

--No 3
--Menampilkan ID transaksi yang diubah dan belum, tanggal transaksi, nama staff, dan nama customer
--Dimana transaksi terjadi dua hari sebelum tanggal 24
SELECT REPLACE(TransactionID, 'TR', 'Trans') AS 'New Transaction Id',
	   TransactionId AS 'Old Transaction Id',
	   TransactionDate,
	   StaffName,
	   CustomerName
FROM HeaderSalonServices
	 JOIN MsStaff ON HeaderSalonServices.StaffId = MsStaff.StaffId
	 JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE DATEDIFF(DAY, TransactionDate, '2012/12/24') = 2

--No 4
--Menampilkan tanggal 5 hari setelah dan saat transaksi, dan nama customer
--dimana transaksi tidak terjadi pada tanggal 20
SELECT DATEADD(DAY, 5, TransactionDate) AS 'New Transaction Date',
	   TransactionDate AS 'Old Transaction Date',
	   CustomerName
FROM HeaderSalonServices
	 JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE DATEPART(DAY, TransactionDate) != 20

--No 5
--Menampilkan hari transaksi, nama customer, dan nama treatment
--dimana staff yang melayani adalah perempuan dan top stylist
SELECT DATENAME(WEEKDAY, TransactionDate) AS 'Day',
	   CustomerName,
	   TreatmentName
FROM HeaderSalonServices
	 JOIN MsCustomer ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	 JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
	 JOIN MsStaff ON HeaderSalonServices.StaffId = MsStaff.StaffId
WHERE StaffGender IN('Female') AND
	  StaffPosition LIKE '%TOP%'
ORDER BY CustomerName	

--No 6
--Menampilkan data top 1 dari customer yang terdiri dari ID, nama, ID transaksi, dan total treatment
SELECT TOP 1 MsCustomer.CustomerId,
	   CustomerName,
	   HeaderSalonServices.TransactionId,
	   COUNT(TreatmentId) AS 'Total Treatment'
FROM MsCustomer
     JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
GROUP BY MsCustomer.CustomerId, 
         CustomerName, 
         HeaderSalonServices.TransactionId
ORDER BY 'Total Treatment' DESC

--No 7
--Menampilkan ID customer, ID transaksi, nama customer, dan total harga treatment
--dimana total harga treatment lebih besar dari harga rata - rata treatment
SELECT MsCustomer.CustomerId,
	   HeaderSalonServices.TransactionId,
	   CustomerName,
	   SUM(Price) AS 'Total Price'
FROM MsCustomer
	 JOIN HeaderSalonServices ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
	 JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
	 JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
GROUP BY MsCustomer.CustomerId,
	     HeaderSalonServices.TransactionId,
		 CustomerName
HAVING SUM(Price) > (
		  SELECT SUM(a.Hasil) FROM(
	          SELECT AVG(MsTreatment.Price) AS Hasil
          ) AS a
       )
ORDER BY 'Total Price' DESC	   

--No 8
--Menampilkan nama staff dengan tambahan 'Mr. ' atau 'Mrs. ', posisi, dan gaji 
SELECT CONCAT('Mr. ', StaffName) AS 'Name',
	   StaffPosition,
	   StaffSalary
FROM MsStaff
WHERE StaffGender IN('Male')
UNION
SELECT CONCAT('Mrs. ', StaffName) AS 'Name',
	   StaffPosition,
	   StaffSalary
FROM MsStaff
WHERE StaffGender IN('Female')
ORDER BY 'Name', StaffPosition

--No 9
--Menampilkan nama treatment, harga, dan status sebagai harga minimum atau maximum
SELECT TreatmentName,
	   CONCAT('Rp. ', Price) AS 'Price',
	   'Minimum Price' AS 'Status'
FROM MsTreatment
WHERE Price = (
		SELECT MIN(Price) FROM MsTreatment
	  )
UNION
SELECT TreatmentName,
	   CONCAT('Rp. ', Price) AS 'Price',
	   'Maximum Price' AS 'Status'
FROM MsTreatment
WHERE Price = (
		SELECT MAX(Price) FROM MsTreatment
	  )

--No 10
--Menampilkan nama customer atau staff, panjang karakter nama, dan status sebagai customer atau staff
SELECT CustomerName,
	   LEN(CustomerName) AS 'Lenght of Name',
	   'Customer' AS 'Status'
FROM MsCustomer
WHERE LEN(CustomerName) = (
		SELECT MAX(LEN(CustomerName)) FROM MsCustomer
	  )
UNION
SELECT StaffName,
	   LEN(StaffName) AS 'Lenght of Name',
	   'Staff' AS 'Status'
FROM MsStaff
WHERE LEN(StaffName) = (
		SELECT MAX(LEN(StaffName)) FROM MsStaff
	  )





	   

