CREATE OR ALTER PROCEDURE CalcularVentasGlobales
AS
BEGIN
    -- Crear una tabla temporal para almacenar los resultados
    CREATE TABLE #VentasGlobales (
        Producto NVARCHAR(50),
        CantidadVendida DECIMAL(18, 2)
    );

    -- Insertar las ventas de hardware
    INSERT INTO #VentasGlobales (Producto, CantidadVendida)
    SELECT 'Hardware', SUM(FD.Cantidad)
    FROM FACTURA F 
    INNER JOIN FACTURADETALLE FD ON F.FacturaID = FD.FacturaID
    INNER JOIN PRODUCTO P ON FD.ProductoID = P.ProductoID
    INNER JOIN TIPOPRODUCTO TP ON P.TipoProductoID = TP.TipoProductoID
    INNER JOIN CLIENTE C ON F.ClienteID = C.ClienteID
    INNER JOIN TIPOCUENTA TC ON C.TipoCuentaID = TC.TipoCuentaID
    WHERE TP.Nombre = 'Hardware' AND TC.NombreCuenta = 'Global';

    -- Insertar las ventas de software
    INSERT INTO #VentasGlobales (Producto, CantidadVendida)
    SELECT 'Software', SUM(FD.Cantidad)
    FROM FACTURA F 
    INNER JOIN FACTURADETALLE FD ON F.FacturaID = FD.FacturaID
    INNER JOIN PRODUCTO P ON FD.ProductoID = P.ProductoID
    INNER JOIN TIPOPRODUCTO TP ON P.TipoProductoID = TP.TipoProductoID
    INNER JOIN CLIENTE C ON F.ClienteID = C.ClienteID
    INNER JOIN TIPOCUENTA TC ON C.TipoCuentaID = TC.TipoCuentaID
    WHERE TP.Nombre = 'Software' AND TC.NombreCuenta = 'Global';

    -- Seleccionar los resultados finales
    SELECT Producto, CantidadVendida
    FROM #VentasGlobales;

    -- Limpiar la tabla temporal
    DROP TABLE #VentasGlobales;
END;
GO