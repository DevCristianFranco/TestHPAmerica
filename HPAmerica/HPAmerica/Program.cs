using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

namespace LeerArchivoCSV
{
    class Program
    {
        static void Main(string[] args)
        {
            // Especifica la ruta relativa del archivo CSV
            string rutaArchivo = "ventas.csv";

            // Leer el archivo CSV y obtener la lista de ventas
            List<Venta> ventas = LeerArchivoVentas(rutaArchivo);

            // Mostrar las ventas leídas de manera ordenada
            Console.WriteLine("Ventas leídas:");
            foreach (var venta in ventas)
            {
                Console.WriteLine($"FacturaID: {venta.FacturaID,-4} Producto: {venta.Producto,-20} Cantidad: {venta.Cantidad,-3} Fecha: {venta.Fecha.ToShortDateString(),-10} ClienteID: {venta.ClienteID,-3} Region: {venta.Region}");
            }

            // Obtener el promedio de ventas en un intervalo de tiempo
            DateTime fechaInicio = DateTime.Parse("2024-06-01");
            DateTime fechaFin = DateTime.Parse("2024-06-10");
            double promedioVentas = CalcularPromedioVentas(ventas, fechaInicio, fechaFin);

            // Añadir un espacio antes de mostrar el promedio de ventas
            Console.WriteLine();
            Console.WriteLine($"Promedio de ventas entre {fechaInicio.ToShortDateString()} y {fechaFin.ToShortDateString()}: {promedioVentas:F2}");

            // Pausar la consola para ver los resultados
            Console.ReadLine();
        }

        static List<Venta> LeerArchivoVentas(string rutaArchivo)
        {
            var ventas = new List<Venta>();
            try
            {
                using (var reader = new StreamReader(rutaArchivo))
                {
                    string linea;
                    reader.ReadLine(); // Leer y descartar la cabecera

                    while ((linea = reader.ReadLine()) != null)
                    {
                        var valores = linea.Split(',');
                        var venta = new Venta
                        {
                            FacturaID = int.Parse(valores[0]),
                            Producto = valores[1],
                            Cantidad = int.Parse(valores[2]),
                            Fecha = DateTime.ParseExact(valores[3], "yyyy-MM-dd", CultureInfo.InvariantCulture),
                            ClienteID = int.Parse(valores[4]),
                            Region = valores[5]
                        };
                        ventas.Add(venta);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al leer el archivo: {ex.Message}");
            }
            return ventas;
        }

        static double CalcularPromedioVentas(List<Venta> ventas, DateTime fechaInicio, DateTime fechaFin)
        {
            int sumaCantidades = 0;
            int numeroVentas = 0;

            foreach (var venta in ventas)
            {
                if (venta.Fecha >= fechaInicio && fechaFin >= venta.Fecha)
                {
                    sumaCantidades += venta.Cantidad;
                    numeroVentas++;
                }
            }

            if (numeroVentas > 0)
            {
                return (double)sumaCantidades / numeroVentas;
            }
            else
            {
                return 0;
            }
        }
    }

    public class Venta
    {
        public int FacturaID { get; set; }
        public string Producto { get; set; }
        public int Cantidad { get; set; }
        public DateTime Fecha { get; set; }
        public int ClienteID { get; set; }
        public string Region { get; set; }
    }
}
