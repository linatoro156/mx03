IF OBJECT_ID ('dbo.DcemFcnTransferencia') IS NOT NULL
   DROP FUNCTION dbo.[DcemFcnTransferencia]
GO

create function [dbo].[DcemFcnTransferencia](@ORCTRNUM varchar(21), @ORTRXTYP smallint, @SOURCDOC VARCHAR(11))
returns xml 
as
--Propósito. Tranferencia
--12/2014 jmg Creación
--07/04/15 jcf corrige docdate y agrega tipo de documento a filtro
--22/04/15 jcf SAT v2 no requiere cobros en póliza
--29/01/18 jcf Habilita cobros
--
begin
 declare @cncp xml;
  WITH XMLNAMESPACES
(
    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo' as "PLZ"
)
 
 select @cncp = (
 
	select dbo.DcemFcnReplace(rtrim(ctaorigensat))    '@CtaOri',
		   dbo.DcemFcnReplace(rtrim(bancoOrigenSat))  '@BancoOriNal',
		   dbo.DcemFcnReplace(rtrim( banOriExt))      '@BancoOriExt',	   
		   dbo.DcemFcnReplace(rtrim(ctadestinosat))   '@CtaDest',
		   dbo.DcemFcnReplace(rtrim(bancoDestinoSat)) '@BancoDestNal',
		   dbo.DcemFcnReplace(rtrim(banDesExt))       '@BancoDestExt',	   
		   cast(docdate as date)					'@Fecha',
		   dbo.DcemFcnReplace(rtrim(beneficiariosat)) '@Benef',
		   dbo.DcemFcnReplace(rtrim(txrgnnum))        '@RFC',
		   cast(docamnt as numeric(16,2))             '@Monto',
		   dbo.DcemFcnReplace(rtrim(ISOCURRC))        '@Moneda',
		   cast(xchgrate as numeric(19,5))            '@TipCamb'
	  from dbo.dcemFnGetDocumentoOriginal (@ORCTRNUM, @ORTRXTYP, @SOURCDOC)
	where --metodopago = 'TRANSFERENCIA'  
		codMetodoPago = '03'
		and voided = 0
		and (
			(@SOURCDOC in ('PMPAY', 'PMCHK', 'PMTRX')
			and @ORTRXTYP = 6)
			or
			(@SOURCDOC in ('CRJ', 'SJ')	--'RMJ', 
			and @ORTRXTYP = 9)
			)

FOR XML path('PLZ:Transferencia'), type
)
 return @cncp
end

go
IF (@@Error = 0) PRINT 'Creación exitosa de la función: DcemFcnTransferencia()'
ELSE PRINT 'Error en la creación de la función: DcemFcnTransferencia()'
GO
