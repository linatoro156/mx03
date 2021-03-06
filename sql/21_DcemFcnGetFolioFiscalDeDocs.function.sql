
IF OBJECT_ID ('dbo.DcemFnGetFolioFiscalDeDocumento') IS NOT NULL
   DROP FUNCTION dbo.[DcemFnGetFolioFiscalDeDocumento]
GO

create function [dbo].[DcemFnGetFolioFiscalDeDocumento]
(
@ORCTRNUM varchar(21) 
,@ORTRXTYP smallint 
) returns table
as
--Propósito. Obtiene folio fiscal del documento
--25/01/18 jcf Creación
--
return ( 
   select rtrim(dx.UUID) foliofiscal,
          rtrim(dx.receptorRfc) RFC 
     from dbo.vwCfdiDatosDelXml dx
	where dx.soptype = @ORTRXTYP
		and dx.sopnumbe = @ORCTRNUM
		and dx.estado = 'emitido'
          ) 
GO

IF (@@Error = 0) PRINT 'Creación exitosa de la función: [DcemFnGetFolioFiscalDeDocumento]()'
ELSE PRINT 'Error en la creación de la función: [DcemFnGetFolioFiscalDeDocumento]()'
GO
