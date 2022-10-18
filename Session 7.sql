--Nama	: Nur Muhammad Alhakim
--NIM	: 2440108225

--No 1
--Menampilkan TreatmentId dan TreatmentName untuk setiap treatment 
--dengan ID TM001 atau TM002
SELECT TreatmentId,
	   TreatmentName
FROM MsTreatment
WHERE TreatmentId IN('TM001') OR 
	  TreatmentId IN('TM002');

--No 2
--Menampilkan TreatmentName dan Price untuk setiap treatment
--yang bukan tipe Hair Treatment dan Message / Spa
SELECT TreatmentName,
	   Price
FROM MsTreatment, 
	 MsTreatmentType
WHERE MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId AND
	  TreatmentTypeName NOT IN('Hair Treatment') AND
	  TreatmentTypeName NOT IN('Message / Spa')

--No 3
--Menampilkan CustomerName, CustomerPhone, dan CustomerAddress untuk setiap customer
--yang namanya lebih dari 8 karakter dan bertransaksi pada Jumat
SELECT CustomerName,
	   CustomerPhone,
	   CustomerAddress
FROM MsCustomer, 
	 HeaderSalonServices
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
	  LEN(CustomerName) > 8 AND
	  DATENAME(WEEKDAY, TransactionDate) = 'Friday'

--No 4
--Menampilkan TreatmentTypeName, TreatmentName, dan Price untuk setiap treatment
--yang diambil oleh customer dengan nama Putra pada tanggal 22
SELECT TreatmentTypeName,
	   TreatmentName,
	   Price
FROM MsTreatmentType, 
	 MsTreatment, 
	 MsCustomer, 
	 HeaderSalonServices, 
	 DetailSalonServices
WHERE MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId AND
	  MsTreatment.TreatmentId = DetailSalonServices.TreatmentId AND
	  DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId AND
	  HeaderSalonServices.CustomerId = MsCustomer.CustomerId AND
	  CustomerName LIKE '%Putra%' AND
	  DATENAME(DAY, TransactionDate) = 22

--No 5
--Menampilkan StaffName, CustomerName, dan TransactionDate dengan format Mon dd,yyyy untuk setiap treatment
--yang memiliki ID berakhiran angka genap
SELECT StaffName, 
	   CustomerName, 
	   CONVERT(VARCHAR, HeaderSalonServices.TransactionDate, 107) AS TransactionDate
FROM MsStaff, 
	 MsCustomer,
	 HeaderSalonServices, 
	 DetailSalonServices
WHERE EXISTS(
	  SELECT TreatmentId      
	  FROM MsTreatment 
      WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
		    MsStaff.StaffId = HeaderSalonServices.StaffId AND     
			HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId AND
			DetailSalonServices.TreatmentId = MsTreatment.TreatmentId AND
			CONVERT(INT, RIGHT(TreatmentId, 1)) % 2 = 0
      )

--No 6
--Menampilkan CustomerName, CustomerPhone, dan CustomerAddress untuk setiap customer
--yang dilayani oleh staff yang jumlah karakternya ganjil
SELECT CustomerName,
	   CustomerPhone,
	   CustomerAddress
FROM MsCustomer
WHERE EXISTS(
	  SELECT StaffName
      FROM MsStaff, 
		   HeaderSalonServices
      WHERE MsStaff.StaffId = HeaderSalonServices.StaffId AND
		    MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
			LEN(StaffName) % 2 = 1
	  )

--No 7
--Menampilkan ID dari 3 karakter terakhir dan nama tengah staff untuk setiap staff
--yang namanya setidaknya 3 kata dan belum melayani customer laki-laki
SELECT RIGHT(StaffId, 3) AS 'ID',
	   SUBSTRING(StaffName, CHARINDEX(' ', StaffName) + 1, CHARINDEX(' ', StaffName) + 1) AS 'Name'
FROM MsStaff
WHERE EXISTS(
	  SELECT CustomerName
      FROM MsCustomer, HeaderSalonServices
      WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId AND
			LEN(StaffName) - LEN(REPLACE(StaffName, ' ', '')) >= 2 AND
			CustomerGender NOT LIKE 'Male'
	  )

--No 8
--Menampilkan TreatmentTypeName, TreatmentName, dan Price untuk setiap treatment
--yang harganya lebih dari rata-rata harga treatment secara keseluruhan
SELECT TreatmentTypeName,
	   TreatmentName,
	   Price
FROM MsTreatmentType,
	 MsTreatment
WHERE MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId AND
	  Price > (SELECT AVG(Price) FROM MsTreatment)

--No 9
--Menampilkan StaffName, StaffPosition, dan StaffSalary untuk setiap staff
--yang memiliki gaji tertinggi dan terendah
SELECT StaffName,
	   StaffPosition,
	   StaffSalary
FROM MsStaff
WHERE StaffSalary = (SELECT MAX(StaffSalary) FROM MsStaff)
UNION
SELECT StaffName, 
	   StaffPosition, 
	   StaffSalary 
FROM MsStaff
WHERE StaffSalary = (SELECT MIN(StaffSalary) FROM MsStaff)

--No 10
--Menampilkan CustomerName, CustomerPhone, CustomerAddress, dan Count Treatment
--yang didapat dari total treatment customer untuk setiap transaksi dengan total treatment tertinggi
SELECT CustomerName, 
	   CustomerPhone, 
	   CustomerAddress, 
	   Treatment.Count_Treatment AS 'Count Treatment' 
FROM HeaderSalonServices 
	 JOIN MsCustomer 
	 ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
	 JOIN (SELECT DetailSalonServices.TransactionId, COUNT(DetailSalonServices.TreatmentId) AS 'Count_Treatment' FROM DetailSalonServices GROUP BY DetailSalonServices.TransactionId) AS Treatment
	 ON HeaderSalonServices.TransactionId = Treatment.TransactionId
WHERE Treatment.Count_Treatment = (SELECT MAX(Count_Treatment) 
FROM (SELECT DetailSalonServices.TransactionId, COUNT(DetailSalonServices.TreatmentId) AS 'Count_Treatment' FROM DetailSalonServices GROUP BY DetailSalonServices.TransactionId) AS Treatment)

