	-------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.DcemFcnGetPolizaDesdeTabla') IS NOT NULL
   DROP FUNCTION dbo.[DcemFcnGetPolizaDesdeTabla]
GO

create function [dbo].[DcemFcnGetPolizaDesdeTabla](@year1 SMALLINT, @periodid SMALLINT)
returns xml 
as
--Propósito. Póliza
--Requisito. Las pólizas deben estar en una tabla
--14/6/17 jcf Creación
--
begin
 declare @cncp xml;
  WITH XMLNAMESPACES
(
    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo' as "PLZ"
)

 select @cncp = (
	 select 
		jrnentry							'@NumUnIdenPol',
		cast(trxdate as date)				'@Fecha',
		dbo.DcemFcnReplace(rtrim(refrence)) '@Concepto',
		nodoTransaccion.query('.')
	from dcem.dcemPoliza
	where YEAR(trxdate) = @year1
	  and month(trxdate) = @periodid
FOR XML path('PLZ:Poliza'), type
)
 return @cncp
end
go
IF (@@Error = 0) PRINT 'Creación exitosa de la función: [DcemFcnGetPolizaDesdeTabla]()'
ELSE PRINT 'Error en la creación de la función: [DcemFcnGetPolizaDesdeTabla]()'
GO
--------------------------------------------------------------------
--test
--select dbo.DcemFcnGetPolizaDesdeTabla(2017, 1)
