
-------------------------------------------------------------------------------------------------
IF OBJECT_ID ('dbo.dcemFnGetMetodosPagoRM') IS NOT NULL
   DROP FUNCTION dbo.dcemFnGetMetodosPagoRM
GO

create function dbo.dcemFnGetMetodosPagoRM(@chekbkid varchar(15), @pyenttyp smallint, @cardname varchar(15))
returns table
as
--Prop�sito. Obtiene m�todos de pago RM
--Requisitos. 
--08/03/13 jcf Creaci�n 
--26/06/14 jcf Modifica m�todo de pago del tipo 1: efectivo
--19/02/15 jcf Modifica c�digo de m�todo de pago
--29/01/18 jcf Replantea el m�todo de pago. La configuraci�n de medios depende de si la chequera es tratada como una cuenta bancaria CB
--
return
( 	
	select cm.chekbkid, 
		case when left(UPPER(cm.locatnid), 2) = 'CB' then	--ch representa una cuenta bancaria
 				case @pyenttyp  
 					when 0 then '02'					--cheque
 					when 1 then '03'					--transf. electr�nica
 					when 2 then left(@cardname,2)
 					when 3 then '03'					--transf. electr�nica

					--pago simult�neo
					--when 4 then '03'				--transf. electr�nica
 				--	when 5 then '02'				--cheque
 				--	when 6 then left(@cardname,2)	--tarjeta
					else null 
				end
			else									--representa un medio de pago
 				left(Rtrim(cm.locatnid), 2)
		end	codMetodoPago,

		case when left(UPPER(cm.locatnid), 2) = 'CB' then	--ch representa una cuenta bancaria
				case @pyenttyp
					WHEN 0 then 'CHEQUE'
					when 1 then 'TRANSFERENCIA'
					when 2 then 'OTRO'
					when 3 then 'TRANSFERENCIA' 
					else ''
				end
			else								--representa un medio de pago
 				Rtrim(cm.dscriptn)
		end medioid
	from CM00100 cm
	where cm.chekbkid = @chekbkid

	--select 
	--case when @pyenttyp=3 then 'TRANSFERENCIA' 
	--	when @pyenttyp=2 then 'TARJETA DE CR�DITO'
	--	when @pyenttyp=0 then 'CHEQUE'
	--	when @pyenttyp=1 then 'TRANSFERENCIA'		--EFECTIVO
	--	else ''
	--end medioid, 
	--case when @pyenttyp=3 then '03' 
	--	when @pyenttyp=2 then '04'		--TARJETA DE CR�DITO
	--	when @pyenttyp=0 then '02'		--CHEQUE
	--	when @pyenttyp=1 then '03'		--TRANSFERENCIA DE FONDOS
	--	else ''
	--end	codMetodoPago
)
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la funci�n: dcemFnGetMetodosPagoRM()'
ELSE PRINT 'Error en la creaci�n de la funci�n: dcemFnGetMetodosPagoRM()'
GO

