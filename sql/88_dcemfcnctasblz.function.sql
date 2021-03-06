
IF OBJECT_ID ('dbo.dcemfcnctasblz') IS NOT NULL
   DROP FUNCTION dbo.[dcemfcnctasblz]
GO

create function [dbo].[dcemfcnctasblz](@periodid SMALLINT, @year1 SMALLINT)

returns xml 
as
--Propósito. Nodo cuenta. Contiene saldos y detalle de asientos
--02/2015 jmg Creación
--09/04/15 jcf Replanteo de consulta
--29/01/18 jcf Cambia atributos para v1.3
--
begin
 declare @cncp xml;
 
  WITH XMLNAMESPACES
(
    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas' as "AuxiliarCtas"
)
  select @cncp = 
 (
  select 
	left(ltrim(rtrim(b.ACTNUMST)), 100)	'@NumCta',
	ltrim(rtrim(c.ACTDESCR))			'@DesCta',
	cast(dbo.DcemFcnObtieneSaldo(a.ACTINDX,@periodid,@year1) as numeric(19,2))  '@SaldoIni',
	cast(dbo.DcemFcnObtieneSaldo(a.ACTINDX,@periodid,@year1) + (debitamt - CRDTAMNT) as numeric(19,2)) '@SaldoFin',
	dbo.DcemFcnDetalleAux(@periodid, @YEAR1, a.actindx)
  from dbo.dcemvwSaldos a
	inner join GL00105 b
	on b.ACTINDX = a.ACTINDX
	inner join GL00100 c 
	on c.ACTINDX = a.ACTINDX
 where a.PERIODID = @periodid
   and a.year1 = @year1
 FOR XML path('AuxiliarCtas:Cuenta'), type
 )
 return @cncp
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: [dcemfcnctasblz]()'
ELSE PRINT 'Error en la creación de la función: [dcemfcnctasblz]()'
GO
---------------------------------------------------------------------------------------
--sp_columns gl00100

--select dbo.dcemfcnctasblz(1, 2015)