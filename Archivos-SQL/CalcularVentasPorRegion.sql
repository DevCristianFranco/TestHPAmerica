CREATE PROCEDURE CalcularVentasPorRegion
AS
BEGIN
    -- Crear una tabla temporal para almacenar los resultados
    CREATE TABLE #VentasPorRegion (
        Region NVARCHAR(50),
        Producto NVARCHAR(50),
        CantidadVendida DECIMAL(18, 2)
    );

    -- Insertar las ventas por región
    INSERT INTO #VentasPorRegion (Region, Producto, CantidadVendida)
    SELECT C.Region AS Region, TP.Nombre AS Producto, SUM(FD.Cantidad) AS CantidadVendida
    FROM FACTURA F 
    INNER JOIN FACTURADETALLE FD ON F.FacturaID = FD.FacturaID
    JOIN PRODUCTO P ON FD.ProductoID = P.ProductoID
    JOIN TIPOPRODUCTO TP ON P.TipoProductoID = TP.TipoProductoID
    INNER JOIN CLIENTE C ON F.ClienteID = C.ClienteID
    GROUP BY C.Region, TP.Nombre;

    -- Seleccionar los resultados finales
    SELECT Region, Producto, CantidadVendida
    FROM #VentasPorRegion;

    -- Limpiar la tabla temporal
    DROP TABLE #VentasPorRegion;
END;