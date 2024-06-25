CREATE PROCEDURE CalcularVentasPorTipoProducto
AS
BEGIN
    -- Crear una tabla temporal para almacenar los resultados
    CREATE TABLE #VentasPorTipoProducto (
        TipoProducto NVARCHAR(50),
        CantidadVendida DECIMAL(18, 2)
    );

    -- Insertar las ventas por tipo de producto
    INSERT INTO #VentasPorTipoProducto (TipoProducto, CantidadVendida)
    SELECT TP.Nombre AS TipoProducto, SUM(FD.Cantidad) AS CantidadVendida
    FROM FACTURA F 
    INNER JOIN FACTURADETALLE FD ON F.FacturaID = FD.FacturaID
    JOIN PRODUCTO P ON FD.ProductoID = P.ProductoID
    JOIN TIPOPRODUCTO TP ON P.TipoProductoID = TP.TipoProductoID
    GROUP BY TP.Nombre;

    -- Seleccionar los resultados finales
    SELECT TipoProducto, CantidadVendida
    FROM #VentasPorTipoProducto;

    -- Limpiar la tabla temporal
    DROP TABLE #VentasPorTipoProducto;
END;