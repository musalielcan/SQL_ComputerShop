-- Komputer satışı ilə məşğul olan mağaza uçun database yaradın. Suallara uyğundblərinizi və tablelər arasındakı əlaqəni yaradın.
CREATE DATABASE ComputerShopDB
USE ComputerShopDB

-- TABLES
CREATE TABLE Categories(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50)
);

CREATE TABLE Products(
    Id INT PRIMARY KEY IDENTITY,
    CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
    Brand NVARCHAR(50),
    Model NVARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Branches(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50),
    Address NVARCHAR(100)
);

CREATE TABLE Employees(
    Id INT PRIMARY KEY IDENTITY,
    BranchId INT FOREIGN KEY REFERENCES Branches(Id),
    Name NVARCHAR(50),
    Surname NVARCHAR(50),
    FatherName NVARCHAR(50),
    Age INT,
    Salary DECIMAL(10,2)
);

CREATE TABLE Sales(
    Id INT PRIMARY KEY IDENTITY,
    ProductId INT FOREIGN KEY REFERENCES Products(Id),
    EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
    BranchId INT FOREIGN KEY REFERENCES Branches(Id),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Categories (Name) VALUES
('Laptop'),
('Desktop'),
('Monitor'),
('Keyboard'),
('Mouse'),
('Printer'),
('Network Device'),
('Storage'),
('Accessories'),
('Tablet');

INSERT INTO Products (CategoryId, Brand, Model, Price, Stock) VALUES
(1, 'Lenovo', 'ThinkPad X1', 2800, 12),
(1, 'HP', 'Pavilion 15', 1500, 20),
(2, 'Dell', 'Optiplex 3080', 1300, 10),
(3, 'Samsung', 'Odyssey G5', 900, 15),
(4, 'Logitech', 'MX Keys', 170, 30),
(5, 'Razer', 'DeathAdder', 80, 40),
(6, 'Canon', 'LBP 6230', 320, 8),
(7, 'TP-Link', 'Archer C6', 120, 25),
(8, 'Seagate', 'Expansion 2TB', 140, 18),
(9, 'Xiaomi', 'PowerBank 20k', 50, 50);

INSERT INTO Branches (Name, Address) VALUES
('Nərimanov', 'Nərimanov m/s yaxınlığı'),
('28 May', 'Nizami küçəsi 45'),
('Gənclik', 'F. Xoyski 98'),
('Elmlər', 'H.Cavid pr. 12'),
('Xalqlar', 'Xalqlar Dostluğu m/s'),
('Neftçilər', 'Neftçilər pr. 78'),
('Sahil', 'Sahil metrosu çıxışı'),
('İnşaatçılar', 'İnşaatçılar pr. 33'),
('Memar Əcəmi', 'Əcəmi metrosu'),
('Sumqayıt', 'Sumqayıt şəhəri, 17 mk.');

INSERT INTO Employees (BranchId, Name, Surname, FatherName, Age, Salary) VALUES
(1, 'Murad', 'Quliyev', 'Elçin', 27, 900),
(2, 'Aysel', 'Məmmədova', 'Mehman', 24, 850),
(3, 'Elvin', 'Həsənov', 'Rövşən', 30, 1100),
(4, 'Rəşad', 'Əliyev', 'Qalib', 33, 1400),
(5, 'Nigar', 'Qasımova', 'Tahir', 25, 950),
(6, 'Turan', 'Musalı', 'Vüqar', 26, 1000),
(7, 'Ləman', 'Hüseynova', 'Ikram', 28, 1050),
(8, 'Cavid', 'Abdullayev', 'Əziz', 33, 1300),
(9, 'Aydan', 'Səlimova', 'Fikrət', 23, 800),
(10,'Kamran', 'Rzayev', 'Nazim', 31, 1250);

INSERT INTO Sales (ProductId, EmployeeId, BranchId, Quantity, SaleDate) VALUES
(1, 1, 1, 2, '2025-12-01'),
(2, 2, 2, 1, '2025-12-02'),
(3, 3, 3, 3, '2025-12-03'),
(4, 4, 4, 1, '2025-12-04'),
(5, 5, 5, 5, '2025-12-05'),
(6, 6, 6, 2, '2025-12-06'),
(7, 7, 7, 1, '2025-12-07'),
(8, 8, 8, 4, '2025-12-08'),
(9, 9, 9, 3, '2025-12-09'),
(10,10,10,2, '2025-12-10');


SELECT*FROM Categories
SELECT*FROM Products
SELECT*FROM Branches
SELECT*FROM Employees
SELECT*FROM Sales

--  1. Bütün məhsulların siyahısına baxmaq üçün sorğu yazın
SELECT*FROM Products;

--  2. Bütün işçilərin siyahısına baxmaq üçün sorğu yazın
SELECT*FROM Employees;

--  3. Məhsullara kateqoriyaları ilə birgə baxmaq üçün sorğu yazın
SELECT p.Id, p.Brand, p.Model, p.Price, c.Name Category
FROM Products p
JOIN Categories c ON p.CategoryId = c.Id;

--  4. Adı Murad olan işçinin məlumatlarına baxmaq üçün sorğu yazın
SELECT*FROM Employees
WHERE Name='Murad';

--  5. Yaşı 25-dən kiçik olan işçilərin siyahısına baxmaq üçün sorğu
SELECT*FROM Employees
WHERE Age<25;

--  6. Hər modeldən neçə məhsulun olduğunu tapın
SELECT Model,COUNT(*) ProductCount 
FROM Products
GROUP BY Model;

--  7. Hər markada hər modelin neçə məhsulu olduğunu tapın
SELECT Brand,Model,COUNT(*) Count 
FROM Products
GROUP BY Brand,Model;

--  8. Hər filial üzrə aylıq satış məbləğinin hesablanması
SELECT b.Name Branch, SUM(p.Price * s.Quantity) MonthlyAmount
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
JOIN Branches b ON s.BranchId = b.Id
WHERE MONTH(SaleDate) = MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY b.Name;

--  9. Ay ərzində ən çox satış olunan model
SELECT TOP 1 p.Model, SUM(s.Quantity) AS TotalSold
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate) = MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY p.Model
ORDER BY TotalSold DESC;

--  10. Ay ərzində ən az satış edən işçi
SELECT TOP 1 e.Name, e.Surname, SUM(s.Quantity) AS TotalSales
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate)=YEAR(GETDATE())
GROUP BY e.Name, e.Surname
ORDER BY TotalSales ASC;

--  11. Ay ərzində 3000-dən çox satış edən işçilərin siyahısı
SELECT e.Name, e.Surname, SUM(p.Price * s.Quantity) AS TotalAmount
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY e.Name, e.Surname
HAVING SUM(p.Price * s.Quantity) > 3000;

--  12. İşcilərin ad soyad və ata adlarını eyni xanada göstərən sorğu yazın
SELECT CONCAT(Name, ' ', Surname, ' ', FatherName) AS FullName
FROM Employees;

--  13. Məhsulun ad və qarşısında adın uzunluğunu göstərən sorğu yazın. Məs : Lenova (7)
SELECT Model, LEN(Model) AS Length
FROM Products;

--  14. Ən bahalı Məhsulu göstərən sorğu yazın
SELECT TOP 1 *
FROM Products
ORDER BY Price DESC;

--  15. Ən bahalı və ən ucuz məhsulu eyni sorğuda göstərin
SELECT 'Max' AS Type, * 
FROM Products 
WHERE Price = (SELECT MAX(Price) FROM Products)
UNION ALL
SELECT 'Min', *
FROM Products
WHERE Price = (SELECT MIN(Price) FROM Products);

--  16. Məhsulları qiymətinə görə kateqoriyalara bölün. Qiyməti:
--   1000AZN-dən aşağı – münasib
--   1000-2500AZN –orta qiymətli
--   2500-dən yuxarı – baha olaraq qeyd edin
SELECT Brand, Model, Price,
       CASE
           WHEN Price < 1000 THEN 'Münasib'
           WHEN Price BETWEEN 1000 AND 2500 THEN 'Orta qiymətli'
           ELSE 'Baha'
       END AS PriceCategory
FROM Products;

--  17. Cari ayda olan bütün satışların cəmini tapın
SELECT SUM(p.Price * s.Quantity) AS TotalThisMonth
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE());

--  18. Cari ayda ən çox satış edən işçinin məlumatlarını çıxaran sorğu yazın 
SELECT TOP 1 e.*, SUM(p.Price * s.Quantity) AS TotalAmount
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY e.Id, e.Name, e.Surname, e.FatherName, e.BranchId, e.Age, e.Salary
ORDER BY TotalAmount DESC;

--  19. Cari ayda ən çox qazanc gətirən işçinin məlumatlarını çıxaran sorğu yazın
SELECT TOP 1 e.*, SUM(p.Price * s.Quantity) AS TotalAmount
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY e.Id, e.Name, e.Surname, e.FatherName, e.BranchId, e.Age, e.Salary
ORDER BY TotalAmount DESC;

--  20. Ən çox satış edən işçinin cari ay maaşını 50% artırın
UPDATE Employees
SET Salary = Salary * 1.5
WHERE Id = (
    SELECT TOP 1 e.Id
    FROM Sales s
    JOIN Employees e ON s.EmployeeId = e.Id
    JOIN Products p ON s.ProductId = p.Id
    WHERE MONTH(SaleDate)=MONTH(GETDATE())
      AND YEAR(SaleDate) = YEAR(GETDATE())
    GROUP BY e.Id
    ORDER BY SUM(p.Price * s.Quantity) DESC
);

-- 21. Hər filialdakı işçi sayını tapın
SELECT 
    b.Name AS BranchName,
    COUNT(e.Id) AS EmployeeCount
FROM Branches b
LEFT JOIN Employees e ON e.BranchId = b.Id
GROUP BY b.Name;

-- 22. Hər filialda mövcud olan məhsul sayını tapın
SELECT b.Name BranchName,
COUNT(P.Id) ProductCount
FROM Sales s 
JOIN Branches b ON s.BranchId=b.Id
JOIN Products p ON s.ProductId=p.Id
GROUP BY b.Name

-- 23. Hər işçinin cari ayda satdığı məhsulların yekun qiymətini tapın
SELECT CONCAT(e.Name, ' ', e.Surname, ' ', e.FatherName) Employee, SUM(p.Price*s.Quantity) TotalAmount 
FROM Sales s
JOIN Employees e ON s.EmployeeId=e.Id
JOIN Products p ON s.ProductId=p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY e.Name, e.Surname, e.FatherName, p.Price, s.Quantity

-- 24. Satılan hər məhsuldan 1% qazanc əldə etdiyini nəzərə alaraq cari ayda 
--  hər bir satıcının maaşını hesablayın.


-- 25. Hər filial üzrə cari aydakı qazancı hesablayın.
SELECT b.Name Branch, SUM(p.Price * s.Quantity) MonthlyAmount
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
JOIN Branches b ON s.BranchId = b.Id
WHERE MONTH(SaleDate) = MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY b.Name;

-- 26. Cari ay üzrə aylıq hesabatı çıxaran sorğu yazın
SELECT SUM(p.Price * s.Quantity) AS TotalThisMonth
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE());





SELECT*FROM Categories
SELECT*FROM Products
SELECT*FROM Branches
SELECT*FROM Employees
SELECT*FROM Sales