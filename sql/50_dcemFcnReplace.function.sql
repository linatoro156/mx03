
IF OBJECT_ID ('dbo.DcemFcnReplace') IS NOT NULL
   DROP FUNCTION dbo.[DcemFcnReplace]
GO

create function [dbo].[DcemFcnReplace] (@campo varchar(51)) returns varchar(51)
--Prop�sito. Reemplaza caracteres especiales
--7/4/15 jcf Correcci�n de par�metros
as
begin
	return(
     (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@campo
       ,'&', '&amp;'),'"', '&quot;'),'<', '&lt;'),'>', '&gt;'),'''', '&apos;')) 
          )
end

GO

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: DcemFcnReplace()'
ELSE PRINT 'Error en la creaci�n de la funci�n: DcemFcnReplace()'
GO
