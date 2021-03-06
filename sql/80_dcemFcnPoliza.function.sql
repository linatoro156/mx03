	-------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.DcemFcnPoliza') IS NOT NULL
   DROP FUNCTION dbo.[DcemFcnPoliza]
GO

create function [dbo].[DcemFcnPoliza](@year1 SMALLINT, @periodid SMALLINT)
returns xml 
as
--Propósito. Póliza
--12/2014 jmg Creación
--13/6/17 jcf Corrige estructura nodo Poliza
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
		dbo.dcemfcntransaccion(0, 0, 0, jrnentry, trxdate)
	from dbo.dcemvwtransaccion
	where YEAR(trxdate) = @year1
	  and month(trxdate) = @periodid
	  --and jrnentry between 92000 and 92300
	GROUP BY JRNENTRY, TRXDATE, REFRENCE
FOR XML path('PLZ:Poliza'), type
)
 return @cncp
end
go
IF (@@Error = 0) PRINT 'Creación exitosa de la función: DcemFcnPoliza()'
ELSE PRINT 'Error en la creación de la función: DcemFcnPoliza()'
GO
--------------------------------------------------------------------
--test
--select TOP 1000 *
--from dcemvwtransaccion
--	where YEAR(trxdate) = 2017
--	  and month(trxdate) = 1
--	  and sourcdoc NOT in ('SJ', 'GJ')
--	  and jrnentry between 92000 and 92300
--order by jrnentry


--select dbo.[DcemFcnPoliza](2017, 1)
