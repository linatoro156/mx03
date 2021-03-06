IF OBJECT_ID ('dbo.DcemFcnAuxiliarFolios') IS NOT NULL
   DROP FUNCTION dbo.[DcemFcnAuxiliarFolios]
GO

create function [dbo].[DcemFcnAuxiliarFolios](@periodid SMALLINT, @year1 SMALLINT)
returns xml 
as
--Propósito. Nodo auxiliar de Folios
--02/2015 jmg Creación
--22/04/15 jcf Replanteo de consulta
--29/01/18 jcf Cambia atributos para v1.3
--
begin
 declare @cncp xml;
 WITH XMLNAMESPACES
(
    'http://www.w3.org/2001/XMLSchema-instance' as "xsi",
    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios' as "RepAux"    
 )     
select @cncp = 
(
SELECT
	'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios/AuxiliarFolios_1_3.xsd' '@xsi:schemaLocation',
	'1.3'																	'@Version',
	ltrim(rtrim( replace(TAXREGTN, 'RFC ', '' )))							'@RFC',
	right( '00' + cast( @periodid AS varchar(2)), 2 )						'@Mes',
	@YEAR1																	'@Anio',
	'AF'																	'@TipoSolicitud',
	dbo.DcemFcnDetFolios(@YEAR1, @periodid)
FROM DYNAMICS..SY01500 
where INTERID = DB_NAME()
FOR XML path('RepAux:RepAuxFol'), type
)
return @cncp
end

go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: DcemFcnAuxiliarFolios()'
ELSE PRINT 'Error en la creación de la función: DcemFcnAuxiliarFolios()'
GO
-----------------------------------------------------------------------
--select dbo.[DcemFcnAuxiliarFolios](1, 2015)
