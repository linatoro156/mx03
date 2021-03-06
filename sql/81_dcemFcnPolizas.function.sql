IF OBJECT_ID ('dbo.DcemFcnPolizas') IS NOT NULL
   DROP FUNCTION dbo.[DcemFcnPolizas]
GO

create function [dbo].[DcemFcnPolizas](@periodid SMALLINT, @year1 SMALLINT)
returns xml 
as
--Propósito. Polizas
--12/2014 jmg Creación
--07/04/15 jcf Replanteo de consulta
--14/06/17 jcf Obtiene pólizas desde tabla
--25/01/18 jcf Modificaciones para v1.3
--
begin
 declare @cncp xml;
   --
 WITH XMLNAMESPACES
(
    'http://www.w3.org/2001/XMLSchema-instance' as "xsi",
    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo' as "PLZ"
)
 --
 select @cncp = (
		SELECT
			'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo  http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo/PolizasPeriodo_1_3.xsd' as '@xsi:schemaLocation',
			'1.3'												'@Version',
			ltrim(rtrim(replace(cia.TAXREGTN, 'RFC ', '')))		'@RFC',
			right( '00' + cast( @periodid AS varchar(2)), 2 ) 	'@Mes',
			@YEAR1												'@Anio',
			'AF'												'@TipoSolicitud',
			dbo.DcemFcnGetPolizaDesdeTabla(@YEAR1, @periodid)
			--dbo.dcemfcnpoliza(@YEAR1, @periodid)
		FROM DYNAMICS..SY01500 cia
		where cia.INTERID = DB_NAME()
		FOR XML path('PLZ:Polizas'), type
)
 return @cncp
end

go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: DcemFcnPolizas()'
ELSE PRINT 'Error en la creación de la función: DcemFcnPolizas()'
GO
