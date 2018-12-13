IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'dcem'
     AND SPECIFIC_NAME = 'dcemCorrigePoliza' 
)
   DROP PROCEDURE dcem.dcemCorrigePoliza;
GO
------------------------------------------------------------------------------------------------------
--Prop�sito. Corrige el nodo p�liza para los asientos con error
--Requisito. Este sp se ejecuta desde la aplicaci�n
--14/6/17 jcf Actualiza p�lizas xml
-- modificar la aplicaci�n:
--	1. update dcempoliza set nodoTransaccion = dbo.dcemfcntransaccion(...) where error = 1
--  2. armar el xml desde la tabla
--	3. validar cada asiento
--  4. actualizar la tabla dcempoliza. Marcar los asientos con error
--
create PROCEDURE dcem.dcemCorrigePoliza
AS
	update dcem.dcempoliza 
	set nodoTransaccion =  dbo.dcemfcntransaccion(0, 0, 0, jrnentry, TRXDATE), err = 0
	where err = 1;

GO

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: dcem.dcemCorrigePoliza'
ELSE PRINT 'Error en la creaci�n de: dcem.dcemCorrigePoliza'
GO

----------------------------------------------------------------------------------------------------
-- =============================================
-- test
-- =============================================
--update dcem.dcemPoliza set err = 1
--where JRNENTRY = 261;

--exec dcem.dcemCorrigePoliza
