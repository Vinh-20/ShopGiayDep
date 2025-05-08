use QLShopGiayDep

create table Brands(
	ID int not null primary key identity(1,1),
	[Name] nvarchar(200) null,
);

create table Products(
	ID int not null primary key identity(1,1),
	[Name] nvarchar(200) null,
	Price bigint null,
	[Image] varchar(200) null,
	Discount int null,
	ID_Type int,
	ID_Brand int,
	FOREIGN KEY (ID_Brand) REFERENCES Brands(ID) ON DELETE SET NULL ON UPDATE SET NULL,
	FOREIGN KEY (ID_Type) REFERENCES TypeProducts(ID) ON DELETE SET NULL ON UPDATE SET NULL
);
create table TypeProducts(
	ID int not null primary key identity(1,1),
	[Name] nvarchar(200) null
)


create table ProductDetails(
	ID int not null primary key identity(1,1),
	Quantity bigint,
	Size int,
	ID_Product int,
	FOREIGN KEY(ID_Product) REFERENCES Products(ID) ON DELETE SET NULL ON UPDATE SET NULL,
);


create table Customers(
	ID int not null primary key identity(1,1),
	[Name] nvarchar(200) null,
	Phone varchar(11) null,
	Gender nvarchar(10),
	Score int
);

create table Invoices(
	ID int not null primary key identity(1,1),
	CreaDate DateTime,
	ID_Staff int,
	ID_Customer int,
	FOREIGN KEY(ID_Customer) REFERENCES Customers(ID) ON DELETE SET NULL ON UPDATE SET NULL,
	FOREIGN KEY(ID_Staff) REFERENCES Staffs(ID) ON DELETE SET NULL ON UPDATE SET NULL,
);

create table InvoiceDetails(
	ID_Invoice int,
	ID_Product int,
	BuyQuantity int,
	Primary key(ID_Invoice, ID_Product),
	FOREIGN KEY(ID_Product) REFERENCES Products(ID) ON DELETE Cascade,
	FOREIGN KEY(ID_Invoice) REFERENCES Invoices(ID) ON DELETE Cascade,
);

drop table invoicedetails

create table Accounts(
	ID int not null primary key identity(1,1),
	Username varchar(50) not null,
	[Password] varchar(20) not null,
	[Role] bit,
);


Create table Staffs(
	ID int not null primary key identity(1,1),
	[Name] nvarchar(200) null,
	Phone varchar(11),
	BirthDate Date,
	Gender nvarchar(10),
	ID_Account int,
	Salary bigint,
	FOREIGN KEY(ID_Account) REFERENCES Accounts(ID) ON DELETE Cascade,
);
-- Insert value Accounts
INSERT INTO Accounts 
values 
('admin', 'admin', 1),
('duydang', '1', 0),
('dang1', '1', 0),
('dang2', '1', 0),
('dang3', '1', 0),
('dang4', '1', 0),
('dang5', '1', 0),
('dang6', '1', 0)
select * from Accounts
-- Insert value Staffs

INSERT INTO Staffs
values
(N'Trần Duy Đăng', '0868337747', '2003-08-20', N'Nam', 1, 10000000),
(N'Phan Tuấn Nghĩa', '0868337748', '2001-07-19', N'Nam', 2, 5000000),
(N'Lê Thị Ngân', '0123456678', '2002-02-11', N'Nữ', 3, 6000000),
(N'Phan Thị Mỹ Kim', '0846244324', '1992-01-20', N'Nữ', 4, 5500000),
(N'Trần Hoài Anh', '0868337749', '2001-04-22', N'Nam', 5, 5000000),
(N'Phạm Thành Trung', '01206884510', '2000-05-30', N'Nam', 6, 5000000),
(N'Lê Phan Bội Châu', '01206884511', '1999-06-11', N'Nữ', 7, 3000000),
(N'Trần Hồng Phúc', '01206884512', '2000-05-12', N'Nữ', 8, 4000000)
select * from Staffs

-- Insert Value Customers

INSERT INTO Customers
VALUES
    (N'Nguyễn Kiều Hoa', '0123456789', N'Nữ', 1),
    (N'Lê Bảo Anh', '0123456790', N'Nữ', 1),
    (N'Phan Tuấn Trung', '0123456791', N'Nam', 1),
    (N'Lê Thị Nguyệt Thảo', '0123456792', N'Nữ', 1),
    (N'Trần Anh Công', '0123456793', N'Nam', 1),
    (N'Lê Thị Kim An', '0123456794', N'Nữ', 1),
    (N'Phạm Lê Thiên Triệu', '0123456795', N'Nam', 1),
    (N'Phan Tuyết Trinh', '0123456796', N'Nữ', 1),
    (N'Trần Anh Tú', '0123456797', N'Nam', 1),
    (N'Nguyễn Thị Thanh Trúc', '0123456798', N'Nữ', 1);
select * from Customers

-- Insert Value Invoices

INSERT INTO Invoices
VALUES 
    ('2022-01-01T12:30:00', 1,17),
    ('2022-01-02T15:45:00', 2,17),
    ('2022-01-03T09:00:00', 3,18),
    ('2022-01-04T18:20:00', 4,20),
    ('2022-01-05T14:10:00', 5,21),
    ('2022-01-06T11:55:00', 6,22),
    ('2022-01-07T17:30:00', 7,24),
    ('2022-01-08T08:40:00', 8,23),
    ('2022-01-09T13:15:00', 9,19),
    ('2022-01-10T16:25:00', 10,22);
select * from Invoices

-- Insert value Brands
INSERT INTO Brands
VALUES 
    ('Nike'),
	('Adidas'),
	('MLB'),
	('Puma'),
	('Vans'),
	('Converse')
select * from brands
-- Insert value Products

INSERT INTO Products
VALUES 
    ('Product 1', 250000, 10,N'Giày', 1),
    ('Product 2', 240000, 0,N'Dép', 1),
    ('Product 3', 150000, 20,N'Giày', 2),
    ('Product 4', 350000, 25,N'Dép', 2),
    ('Product 5', 200000, 0,N'Giày', 3),
    ('Product 6', 300000, 5,N'Dép', 3),
    ('Product 7', 400000, 40,N'Giày', 4),
    ('Product 8', 1500000, 0,N'Dép', 4),
    ('Product 9', 2500000,0,N'Giày', 5),
    ('Product 10', 250000,0,N'Dép', 5);
select * from products
--Insert value ProductDetails

INSERT INTO ProductDetails
VALUES 
    (100, 37, 1),
	(50, 38, 1),
	(70, 39, 1),
	(30, 40, 1),
	(10, 41, 1),
	(90, 42, 1),
	(100, 37, 2),
	(50, 38, 2),
	(70, 39, 2),
	(30, 40, 2),
	(10, 41, 2),
	(90, 42, 2),
	(50, 38, 3),
(70, 39, 3),
(30, 40, 3),
(10, 41, 3),
(90, 42, 3),
(50, 38, 4),
(70, 39, 4),
(30, 40, 4),
(10, 41, 4),
(90, 42, 4),
(50, 38, 5),
(70, 39, 5),
(30, 40, 5),
(10, 41, 5),
(90, 42, 5),
(50, 38, 6),
(70, 39, 6),
(30, 40, 6),
(10, 41, 6),
(90, 42, 6),
(50, 38, 7),
(70, 39, 7),
(30, 40, 7),
(10, 41, 7),
(90, 42, 7),
(50, 38, 8),
(70, 39, 8),
(30, 40, 8),
(10, 41, 8),
(90, 42, 8),
(50, 38, 9),
(70, 39, 9),
(30, 40, 9),
(10, 41, 9),
(90, 42, 9),
(50, 38, 10),
(70, 39, 10),
(30, 40, 10),
(10, 41, 10),
(90, 42, 10)

select * from productdetails

-- Insert value invoiceDetails

INSERT INTO invoiceDetails
values (1,2,1),
(1,3,1),
(1,4,2),
(1,5,1),
(2,3,1),
(2,4,1),
(3,1,2),
(4,6,1),
(5,5,1),
(2,7,1),
(7,7,1),
(4,9,1)
select * from invoicedetails

-- Data Orders
select invoices.ID, Invoices.CreaDate, sum(InvoiceDetails.BuyQuantity) as N'Số lượng sản phẩm',Customers.Name, Phone, Gender, Score from invoices inner join invoiceDetails on invoices.ID = invoiceDetails.ID_invoice
inner join Customers on customers.ID = Invoices.ID_Customer group by Invoices.ID, Invoices.CreaDate, Customers.Name, Phone, Gender, Score

select Products.ID, Products.Name, Price, Discount, Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID

insert into typeproducts values(N'Giày'), (N'Dép'), (N'Phụ Kiện')
select * from typeproducts

select * from products

create procedure AddProduct
(@name nvarchar(200), @price bigint, @discount int, @id_brand int, @id_type int)
as
begin
	insert into products values(@name, @price, @discount, @id_brand, @id_type);
end

exec AddProduct N'Giày Vans 11', 120000, 10, 3, 1

select * from products
select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
where products.[Name] like N'%duc%'

create procedure SearchProductsByType
(@type varchar(50), @searchInput nvarchar(200))
as
begin
	if @type = 'Brand'
	begin
		select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
		where brands.[Name] like N'%'+@searchInput+'%';
	end
	else if @type = 'Type'
	begin
		select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
		where TypeProducts.[Name] like N'%'+@searchInput+'%';
	end
	else if @type = 'ID'
	begin
		select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
		where Products.ID like '%'+@searchInput+'%';
	end
	else if @type = 'Name'
	begin
		select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
		where Products.[Name] like N'%'+@searchInput+'%';
	end
	else if @type = 'Price'
	begin
		select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
		where Products.Price like '%'+@searchInput+'%';
	end
	else if @type = 'Discount'
	begin
		select Products.ID, Products.Name, Price, Discount, TypeProducts.Name as Type, Brands.Name as 'BrandName' from products inner join Brands on Products.ID_Brand = Brands.ID inner join TypeProducts on Products.ID_Type = TypeProducts.ID
		where Products.Discount like '%'+@searchInput+'%';
	end
end

exec sp_help products

create proc updateproduct
@id int, @name nvarchar(400), @price bigint, @discount int, @id_brand int, @id_type int
as
begin 
	update products set [Name] = @name, Price = @price, Discount = @discount, ID_Brand = @id_brand, ID_Type = @id_type 
	where ID = @id
end

exec updateproduct 1, 'Hihi', 100000, 10, 1, 2
select * from products
exec SearchProductsByType 'ID', 2
select ID from brands where Name = 'Nike'
select * from products where id = 1
select * from TypeProducts
select * from brands

select * from products 


select ID from TypeProducts where Name = N'Giày'
select ID from brands where name = ' puma'

select * from Products where Name = 'product 11' and price = 150000 and discount = 24 and id_brand = 4 and id_type = 1 and Quantity = 110;
delete products where id = 17 or id = 18 or id = 19 or id = 20

select * from products


select * from staffs

select * from invoices inner join invoicedetails on invoices.ID = InvoiceDetails.ID_Invoice inner join Customers on invoices.ID_Customer 
= customers.id 



select invoices.ID, Invoices.CreaDate, sum(InvoiceDetails.BuyQuantity) as N'Sản Phẩm',Customers.Name, Phone, Gender, Score from invoices inner join invoiceDetails on invoices.ID = invoiceDetails.ID_invoice inner join Customers on customers.ID = Invoices.ID_Customer 
group by Invoices.ID, Invoices.CreaDate, Customers.Name, Phone, Gender, Score

select * from invoices inner join invoiceDetails on invoices.ID = invoiceDetails.ID_invoice inner join Customers on customers.ID = Invoices.ID_Customer 

select * from invoices

select * from invoicedetails

select * from products inner join ProductDetails on Products.ID = ProductDetails.ID_Product where products.id = 2 and ProductDetails.Quantity > 0

select * from ProductDetails


select * from products inner join TypeProducts on Products.ID_Type = TypeProducts.id

select * from products inner join ProductDetails on products.ID = ProductDetails.ID_Product

select ID, Name, Price from products

select * from products inner join ProductDetails on Products.ID = ProductDetails.ID_Product where products.id = 4 and ProductDetails.Quantity > 0


select max(ID) from products

select * from ProductDetails where ID_Product = 2

select * from ProductDetails

select * from Products

select * from ProductDetails where ID_Product = 2
select * from staffs inner join accounts on staffs.ID_Account = accounts.id

create proc DeleteProductDetailByIDProduct
@idProduct int
as
begin 
	delete ProductDetails where ID_Product = @idProduct
end


select ProductDetails.Quantity from products inner join ProductDetails on Products.ID = ProductDetails.ID_Product where products.id = 2 and size = 37

select * from  products inner join ProductDetails on Products.ID = ProductDetails.ID_Product

select * from products where id = 2

select * from invoices

select * from invoicedetails




create proc GetDataBySDT
@sdt varchar(11)
as
begin
	Select * from Customers where phone like '%'+@sdt+'%';
end


exec GetDataBySDT '679'

create proc AddCustomer
@name nvarchar(200), @phone varchar(11), @gender nvarchar(10), @score int
as
begin
	insert into customers values(@name, @phone, @gender, @score)
end

drop proc Addcustomernoscore


create proc UpdateScoreCustomer
@id int, @score int
as
begin
	update customers set score += @score where id = @id;
end
select * from customers
update customers set score += 1 where id = 2

select * from customers



select * from invoices

create proc AddInvoice
@creaDate datetime, @idcustomer int, @idStaff int
as
begin
	if @idcustomer = -1
	begin
		insert into invoices(CreaDate, ID_Staff) values(@creaDate, @idStaff)
	end
	else 
	begin
		insert into invoices values(@creaDate, @idcustomer, @idStaff)
	end
end

create proc AddInvoiceDetail
@idInvoice int, @idProduct int, @buyquantity int
as 
begin 
	insert into invoicedetails values(@idInvoice, @idProduct, @buyquantity)
end

select * from invoicedetails
select * from invoices

select * from customers

select invoices.ID, Invoices.CreaDate, sum(InvoiceDetails.BuyQuantity) as BuyQuantity,Customers.Name as NameCustomer, Phone, Gender, Score from invoices inner join invoiceDetails on invoices.ID = invoiceDetails.ID_invoice left join Customers on customers.ID = Invoices.ID_Customer where invoices.id = 1007 group by Invoices.ID, Invoices.CreaDate, Customers.Name, Phone, Gender, Score

select invoices.ID, Invoices.CreaDate, sum(InvoiceDetails.BuyQuantity) as BuyQuantity,Customers.Name as NameCustomer, Phone, Gender, Score from invoices inner join invoiceDetails on invoices.ID = invoiceDetails.ID_invoice inner join Customers on customers.ID = Invoices.ID_Customer group by Invoices.ID, Invoices.CreaDate, Customers.Name, Phone, Gender, Score


select [Name] as N'Tên sản phẩm', BuyQuantity as N'SL', Price as N'Đơn Giá',
Discount as N'Khuyến mãi',
BuyQuantity * (Price - (Price * Discount / 100)) as N'Thành Tiền'
from invoicedetails inner join products on invoicedetails.ID_Product = products.id 
where ID_Invoice = 1004


select * from accounts

select * from invoices where MONTH(CreaDate) = 1

select sum(BuyQuantity * (Price - (Price * Discount / 100))) as 'sum' from invoicedetails inner join invoices 
on invoicedetails.ID_Invoice = invoices.id inner join Products on Products.ID = invoicedetails.ID_Product
where year(creadate) = 2022
select sum(BuyQuantity) as 'sumProduct' from invoicedetails

select * from customers where MONTH(creadate) = 4

select *  from products inner join invoicedetails on products.ID = invoicedetails.ID_Product
inner join TypeProducts on Products.ID_Type = TypeProducts.ID 

select * from products
select * from productdetails


create proc insertTK
@tentk varchar(50), @mk varchar(50), @role bit
as
begin
	insert into Accounts values(@tentk, @mk, @role)
end

create proc updateTK
@matk int, @tentk varchar(50), @mk varchar(50), @role bit
as
begin
	update Accounts set Username = @tentk, Password = @mk, Role = @role where ID = @matk
end

select * from accounts


create table TypeAccount(
	ID int not null primary key identity(1,1),
	[Name] nvarchar(50),
);

ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_TypeAccount FOREIGN KEY (ID_TypeAccount) REFERENCES TypeAccount(ID);

select Accounts.ID, Username, Password, TypeAccount.Name from Accounts inner join TypeAccount 
on Accounts.ID_TypeAccount = TypeAccount.ID where username = 'dang1'
select * from accounts inner join staffs on accounts.ID = staffs.ID_Account where username = 'dang1'


-- Table chi tiet hoa don

-- + ID
-- + Số lượng mua
-- + Size
-- + Mã SP
-- + Mã Hóa đơn

CREATE TABLE InvoiceDetails (
    ID int not null primary key identity(1,1),
    ID_Invoice INT,
    ID_Product INT,
    BuyQuantity INT,
	Size int,
    FOREIGN KEY (ID_Invoice) REFERENCES Invoices(ID) ON DELETE Cascade,
    FOREIGN KEY (ID_Product) REFERENCES Products(ID) ON DELETE Cascade
);

insert into InvoiceDetails(ID_Invoice, ID_Product, BuyQuantity)
values(1,2,1),
(1,3,1),
(1,4,2),
(1,5,1),
(2,3,1),
(2,4,1),
(2,7,1),
(4,6,1),
(4,9,1),
(5,5,1),
(1003,2,1),
(1004,2,1),
(1004,3,2),
(1004,7,3),
(1005,2,1),
(1007,2,1),
(1008,2,1),
(1009,2,2),
(1013,2,1)
select * from invoicedetails
select * from products inner join invoicedetails 
on products.ID = invoicedetails.ID_Product inner join TypeProducts 
on Products.ID_Type = TypeProducts.ID where LOWER(TypeProducts.[Name]) like N'giày'


select * from invoicedetails inner join products 
on invoicedetails.ID_Product = products.id inner join invoices 
on invoices.ID = invoicedetails.ID_Invoice
where ID_Invoice = 1004

select DAY(CreaDate) as N'Ngày', MONTH(CreaDate) as N'Tháng',YEAR(CreaDate) as N'Năm', 
FORMAT(CreaDate, 'HH:mm') AS N'Giờ'
from invoicedetails inner join products on invoicedetails.ID_Product = products.id inner join invoices 
on invoices.ID = invoicedetails.ID_Invoice where ID_Invoice = 1004

select * from customers inner join invoices on invoices.ID_Customer = customers.ID where invoices.ID =0

select staffs.Name from staffs inner join invoices on staffs.ID = invoices.ID_staff where invoices.ID = 1004


select * from staffs
select * from accounts

select accounts.ID, username, password from accounts left join staffs on accounts.ID = staffs.ID_Account where staffs.ID is NULL

select * from staffs where ID_Account is NULL

select * from accounts inner join staffs on accounts.ID = staffs.ID_Account where username = 'fff1'


SELECT * FROM Accounts where username = 'fff1' and password = '1'
