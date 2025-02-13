SCRIPT CREACION MODELO E/R E INSERCION DE LOS DATOS:

CREATE DATABASE IF NOT EXISTS DecowrapsDB;
USE DecowrapsDB;

-- Tabla de Empleados
CREATE TABLE Empleado (
    EmpleadoID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Cargo VARCHAR(50) NOT NULL
);

-- Tabla de Clientes
CREATE TABLE Cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Pais VARCHAR(50) NOT NULL
);

-- Tabla de Transportadoras
CREATE TABLE Transportadora (
    TransportadoraID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

-- Tabla de Productos
CREATE TABLE Producto (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    LineaProducto VARCHAR(100) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio > 0)
);

-- Tabla de Proveedores
CREATE TABLE Proveedor (
    ProveedorID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(20) NOT NULL
);

-- Tabla Intermedia Producto_Proveedor (Muchos a Muchos)
CREATE TABLE Producto_Proveedor (
    ProductoID INT,
    ProveedorID INT,
    PRIMARY KEY (ProductoID, ProveedorID),
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID) ON DELETE CASCADE,
    FOREIGN KEY (ProveedorID) REFERENCES Proveedor(ProveedorID) ON DELETE CASCADE
);

-- Tabla de Pedidos
CREATE TABLE Pedido (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    FechaPedido DATE NOT NULL,
    ClienteID INT,
    EmpleadoID INT,
    TransportadoraID INT,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID) ON DELETE CASCADE,
    FOREIGN KEY (EmpleadoID) REFERENCES Empleado(EmpleadoID) ON DELETE SET NULL,
    FOREIGN KEY (TransportadoraID) REFERENCES Transportadora(TransportadoraID) ON DELETE SET NULL
);

-- Tabla de DetallePedido (Cada pedido tiene productos)
CREATE TABLE DetallePedido (
    DetalleID INT AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT,
    ProductoID INT,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario > 0),
    FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID) ON DELETE CASCADE,
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID) ON DELETE CASCADE
);


-- ISNMERSION DE LA DATA DE PRUEBA 

INSERT INTO Cliente (Nombre, Pais) VALUES 
('RUIZ', 'Colombia'),
('PEREZ', 'Argentina'),
('GOMEZ', 'Brasil'),
('GOMEZ', 'Colombia'),
('PEREZ', 'Colombia'),
('GOMEZ', 'Peru'),
('RUIZ', 'Bolivia');

INSERT INTO Producto (Nombre, LineaProducto, Precio) VALUES
('Ramo de Rosas', 'Flores', 110),
('Tulipanes', 'Flores', 300),
('Orquídea', 'Flores', 250),
('Caja de Suculentas', 'Plantas', 37),
('Ramo de Girasoles', 'Flores', 60);

INSERT INTO Pedido (FechaPedido, ClienteID) VALUES
('2020-02-10', (SELECT ClienteID FROM Cliente WHERE Nombre = 'RUIZ' LIMIT 1)),
('2020-03-15', (SELECT ClienteID FROM Cliente WHERE Nombre = 'PEREZ' LIMIT 1)),
('2020-04-20', (SELECT ClienteID FROM Cliente WHERE Nombre = 'GOMEZ' LIMIT 1)),
('2020-05-05', (SELECT ClienteID FROM Cliente WHERE Nombre = 'RUIZ' LIMIT 1)),
('2020-06-10', (SELECT ClienteID FROM Cliente WHERE Nombre = 'GOMEZ' LIMIT 1));

INSERT INTO DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario) VALUES
(1, 1, 25, 110), 
(2, 2, 30, 300),  
(3, 3, 10, 250), 
(4, 4, 5, 37),  
(5, 5, 40, 60);  

-- 3. CONSULTA SOLICITADA:

SELECT 
    p.LineaProducto,
    dp.ProductoID,
    p.Nombre AS NombreProducto,
    SUM(dp.Cantidad) AS TotalVentas
FROM DetallePedido dp
JOIN Pedido ped ON dp.PedidoID = ped.PedidoID
JOIN Producto p ON dp.ProductoID = p.ProductoID
WHERE ped.FechaPedido BETWEEN '2020-01-01' AND '2020-08-31'
GROUP BY p.LineaProducto, dp.ProductoID, p.Nombre
HAVING SUM(dp.Cantidad) > 20
ORDER BY TotalVentas DESC;


-- 4. PROBLEMA LIBROS 

CREATE TABLE Libro (
    LibroID INT AUTO_INCREMENT PRIMARY KEY,
    Autor VARCHAR(255) NOT NULL,
    Titulo VARCHAR(255) NOT NULL,
    CantidadPalabras INT NOT NULL CHECK (CantidadPalabras > 0)
);


SELECT 
    Autor,
    AVG(CantidadPalabras) AS palabra_avg
FROM Libro
GROUP BY Autor
HAVING AVG(CantidadPalabras) > 120000
ORDER BY palabra_avg DESC;


-- 5. PROBLEMA TABLA PRICE

CREATE TABLE Ventas (
    Vendedor VARCHAR(10),
    Anio INT,
    Mes INT,
    Price DECIMAL(10,6)
);
INSERT INTO Ventas (Vendedor, Anio, Mes, Price) VALUES
('MFA', 2020, 1, 0.128),
('MFA', 2019, 1, 0.055),
('MFA', 2019, 2, 0.1),
('MFA', 2020, 2, 0.0911),
('MFA', 2020, 3, 0.12),
('MS', 2020, 1, 455.5),
('MS', 2019, 1, 2520),
('MS', 2019, 2, 600),
('MS', 2020, 2, 1080),
('MS', 2020, 3, 120),
('ZB', 2020, 1, 0.128),
('ZB', 2019, 1, 0.055),
('ZB', 2019, 2, 0.0759),
('ZB', 2020, 2, 0.075),
('ZB', 2020, 3, 0.075);
SELECT 
    Vendedor,
    Anio,
    Mes,
    Price,
    LAG(Price) OVER (PARTITION BY Vendedor ORDER BY Anio, Mes) AS Precio_Anterior,
    Price * LAG(Price) OVER (PARTITION BY Vendedor ORDER BY Anio, Mes) AS Multiplicacion
FROM Ventas;

-- 6. problema venta motos -almacen

CREATE TABLE Motos (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Modelo INT
);

CREATE TABLE Ventas (
    ID INT PRIMARY KEY,
    IdMoto INT,
    IdAlmacen INT,
    FOREIGN KEY (IdMoto) REFERENCES Motos(ID),
    FOREIGN KEY (IdAlmacen) REFERENCES Almacen(ID)
);

CREATE TABLE Almacen (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Ciudad VARCHAR(50)
);

INSERT INTO Motos (ID, Nombre, Modelo) VALUES
(1, 'MT03', 2020),
(2, 'MT07', 2020),
(3, 'MT09', 2020),
(4, 'MT10', 2020);

INSERT INTO Almacen (ID, Nombre, Ciudad) VALUES
(1, 'AAA', 'Bogotá'),
(2, 'BBB', 'Bogotá'),
(3, 'CCC', 'Medellin'),
(4, 'DDD', 'Bogotá'),
(5, 'EEE', 'Bogotá');

INSERT INTO Ventas (ID, IdMoto, IdAlmacen) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);

SELECT 
    a.Ciudad,
    GROUP_CONCAT(m.Nombre ORDER BY m.Nombre SEPARATOR ',') AS Cantidad_de_motos_vendidas
FROM Ventas v
JOIN Motos m ON v.IdMoto = m.ID
JOIN Almacen a ON v.IdAlmacen = a.ID
WHERE a.Ciudad = 'Bogotá'
GROUP BY a.Ciudad;


-- REPORTE POWERBI

CREATE TABLE Vendedor (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Cliente (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Almacen (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Ciudad VARCHAR(100) NOT NULL
);

CREATE TABLE Venta (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    IdVendedor INT,
    IdCliente INT,
    IdAlmacen INT,
    Total DECIMAL(10,2),
    FOREIGN KEY (IdVendedor) REFERENCES Vendedor(Id),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(Id),
    FOREIGN KEY (IdAlmacen) REFERENCES Almacen(Id)
);

SELECT 
    YEAR(v.Fecha) AS Año,
    MONTH(v.Fecha) AS Mes,
    a.Ciudad,
    ven.Nombre AS Vendedor,
    cli.Nombre AS Cliente,
    SUM(v.Total) AS TotalVentas
FROM Venta v
JOIN Vendedor ven ON v.IdVendedor = ven.Id
JOIN Cliente cli ON v.IdCliente = cli.Id
JOIN Almacen a ON v.IdAlmacen = a.Id
WHERE 
    v.Fecha BETWEEN '2023-01-01' AND '2023-12-31' -- Rango de Fechas
    AND (ven.Id = @IdVendedor OR @IdVendedor IS NULL) -- Filtro de Vendedor
    AND (cli.Id = @IdCliente OR @IdCliente IS NULL) -- Filtro de Cliente
GROUP BY Año, Mes, Ciudad, Vendedor, Cliente
ORDER BY Año DESC, Mes DESC, Ciudad, Vendedor;

