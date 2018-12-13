-------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.dcemFnGetDatosBancarios') IS NOT NULL
   DROP FUNCTION dbo.dcemFnGetDatosBancarios
GO

create function dbo.dcemFnGetDatosBancarios(@chekbkid varchar(15))
returns table
as
--Prop�sito. Obtiene datos de la cuenta y el banco
--Requisitos. 
--24/12/15 jcf Creaci�n 
--29/01/16 jcf Agrega par�metro para seleccionar el c�digo del banco
--26/01/18 jcf Redise�a query
--
return
( 	
	select cb.CHEKBKID, --cb.bnkactnm, 
		case when isnull(cb.EFTBANKACCT, '') != '' then cb.EFTBANKACCT 
			else cb.bnkactnm
		end bnkactnm,
		cb.bankid, cb.bankname, cb.country, 
		left(cb.BANKID, 3) codBancoSat, 
		case when left(cb.BANKID, 3) = '999' then
			cb.BANKNAME
		else
			null
		end nomBancoExt
	from dbo.cmFnGetDatosDeChequera(@chekbkid) cb
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: dcemFnGetDatosBancarios()'
ELSE PRINT 'Error en la creaci�n de la funci�n: dcemFnGetDatosBancarios()'
GO

--select *
--from cm00100 cb

--select *
--from dbo.dcemFnGetDatosBancarios('AMEX           ')

--select *
--from dbo.dcemFnGetDatosBancarios(
--select *
--from vwPmTransaccionesTodas
--where bchsourc in (
----'PM_Trxent'    ,  
--'XXPM_Trxent'   
----'Rcvg Trx Entry' ,
----'PM_Payment'     
----'XXPM_Payment'   ,
----'Ret Trx Entry'  
----'nfMCP_Payment'
--  )
