use BUDGET
GO
IF NOT EXISTS (SELECT schema_id FROM sys.schemas WHERE name = 'ICG')
	EXEC('Create Schema ICG')
GO
--CREACION DE LA TABLA DE EMPRESAS EN LAS CUALES SE VA A REALIZAR LA REPLICA DE DATOS
DROP TABLE IF Exists ICG.EMPRESAS
GO
CREATE TABLE ICG.EMPRESAS(
	IDEMPRESA VARCHAR(20) NOT NULL,
	NOMBRE VARCHAR(100) NOT NULL,
	IDCATEGORIA INT NOT NULL,
	IDSUBCATEGORIA INT NOT NULL,
	FECHAINICIO DATE NOT NULL,
	SERVIDORBD NVARCHAR(100) NOT NULL,
	NOMBREBD NVARCHAR(100) NOT NULL,
	USUARIOBD NVARCHAR(50) NOT NULL,
	CONTRASENABD NVARCHAR(50) NOT NULL,
	ACTIVA BIT NOT NULL,
	PAIS VARCHAR(4) NULL)
GO
--CREACION DE VISTA  PARA OBTENER LAS EMPRESAS ACTIVAS 
DROP VIEW IF Exists ICG.V_EMPRESAS_OBTENER
GO
CREATE VIEW ICG.V_EMPRESAS_OBTENER
AS
	SELECT IDEMPRESA,	NOMBRE ,	IDCATEGORIA ,	IDSUBCATEGORIA,	FECHAINICIO ,	SERVIDORBD ,	NOMBREBD ,	USUARIOBD ,	CONTRASENABD ,	ACTIVA ,	PAIS
	FROM ICG.EMPRESAS WHERE ACTIVA =1
GO
--SE BORRAN LOS DATOS PARA EJECUTAR EL SCRIPT POR SEGUNDA VEZ
DELETE FROM [ICG].[Empresas]
GO
--SE INSERTAN LLOS DATOS
INSERT [ICG].[Empresas] ([IdEmpresa], [Nombre], [IdCategoria], [IdSubCategoria], [FechaInicio], [ServidorBD], [NombreBD], [UsuarioBD], [ContrasenaBD], [Activa], [Pais]) VALUES 
('1002000100','Promerica', 1, 1, CAST(N'2019-02-06' AS Date),' ',' ',' ',' ', 0,'CRI')
,('1002000101','Oficinas Centrales', 1, 1, CAST(N'2019-02-06' AS Date),' ',' ',' ',' ', 0,'CRI')
,('3101255589','OutBack', 2, 1, CAST(N'2021-03-24' AS Date),'3.224.17.235, 14333','OUTBACK','icgadmin','masterkey', 0,'CRI')
,('3101473595','Crate & Barrel', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','CRATE','icgadmin','masterkey', 0,'CRI')
,('3101483597','Forever 21', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','FOREVERCR','icgadmin','masterkey', 0,'CRI')
,('3101665313','Johnny Rockets', 2, 1, CAST(N'2021-03-24' AS Date),'3.224.17.235, 14333','JROCKETS','icgadmin','masterkey', 0,'CRI')
,('3101748898','Cortefiel', 1, 4, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','CTFSTORES','icgadmin','masterkey', 0,'CRI')
,('3101748899','Springfield', 1, 1, CAST(N'2021-03-19' AS Date),'3.224.17.235, 14333','CTFSTORES_SPF','icgadmin','masterkey', 0,'CRI')
,('3101748900','Women Secret', 1, 1, CAST(N'2021-03-19' AS Date),'3.224.17.235, 14333','CTFSTORES_WS','icgadmin','masterkey',0,'CRI')
,('3101748901','Max Mara', 1, 4, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','MMSTORE_2','icgadmin','masterkey', 0,'CRI')
,('3101748904','Adolfo Dominguez', 1, 4, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','ADSTORE_2','icgadmin','masterkey', 0,'CRI')
,('3101749040','OVS', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','OVSSTORE','icgadmin','masterkey', 0,'CRI')
,('3101749079','Mango', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','MNGSTORE','icgadmin','masterkey', 0,'CRI')
,('3101769587','GAP', 1, 1, CAST(N'2021-01-17' AS Date),'3.224.17.235, 14333','GAP_2','icgadmin','masterkey', 0,'CRI')
,('3101769588','Old Navy', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','OLDNAVY_2','icgadmin','masterkey', 0,'CRI')
,('3101769589','Banana Republic', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','BANANA_2','icgadmin','masterkey', 0,'CRI')
,('3101789536','Olive Garden', 2, 1, CAST(N'2021-03-24' AS Date),'3.224.17.235, 14333','OLIVEGARDEN','icgadmin','masterkey', 0,'CRI')
,('3101790041','banana', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','banana','icgadmin','masterkey', 1,'CRI')
,('63675846','MNG Mango Guatemala', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','MANGOGT','icgadmin','masterkey', 0,'GTM')
,('84864273','Forever Guatemala', 1, 1, CAST(N'2021-04-05' AS Date),'3.224.17.235, 14333','FOREVERGT','icgadmin','masterkey', 0,'GTM')
,('86781294','Springfield Guatemala', 1, 1, CAST(N'2021-03-17' AS Date),'3.224.17.235, 14333','SPF_Guatemala','icgadmin','masterkey', 0,'GTM')
GO
--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE ORDERNES DE COMPRA
--***************************************************************************************************************************************************************************************************************************************
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PURCHASE_ORDER' AND table_schema = 'dbo' AND column_name = 'IS_PAID')  
ALTER TABLE BUD_MTR_PURCHASE_ORDER ADD  IS_PAID BIT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PURCHASE_ORDER' AND table_schema = 'dbo' AND column_name = 'ENVIADOICG')  
ALTER TABLE BUD_MTR_PURCHASE_ORDER ADD  ENVIADOICG BIT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PURCHASE_ORDER_PRODUCT' AND table_schema = 'dbo' AND column_name = 'ENVIADOICG')  
ALTER TABLE BUD_MTR_PURCHASE_ORDER_PRODUCT ADD  ENVIADOICG BIT
GO
DROP PROCEDURE IF EXISTS [ICG].[SP_ORDENCOMPRA_ENCABEZADO_OBTENER]
GO
CREATE Procedure [ICG].[SP_ORDENCOMPRA_ENCABEZADO_OBTENER]
As
Begin
	 SELECT DISTINCT  ST.NAME,PO.PK_BUD_MTR_PURCHASE_ORDER IDPEDIDO,TRIM(S.VALUE_IDENTIFICATION) AS PROVEEDOR,C.CODE AS ISOMONEDA,PO.REFERENCE_NUMBER as NUMPEDIDO,H.NAME SOCIEDAD,
			PO.TAX_AMOUNT AS TOTALIMPUESTOS ,PO.TOTAL_GENERAL AS TOTALNETO ,PO.SUBTOTAL AS TOTALBRUTO,   E.CENTROCOSTE AS CENTROCOSTE, E.CODALMACEN, E.IDEMPRESA,
			APPROVE_DATE as FECHAAPROBACION,S.COMMERCIAL_NAME AS NOMBREPROVEEDOR, ST.NAME AS TIENDA
	 FROM dbo.BUD_MTR_PURCHASE_ORDER PO
	 INNER JOIN BUD_MTR_COIN C ON PO.FK_BUD_MTR_COIN=C.PK_BUD_MTR_COIN
	 INNER JOIN BUD_MTR_SUPPLIER S ON PO.FK_BUD_MTR_SUPPLIER=S.PK_BUD_MTR_SUPPLIER
	 INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = PO.PK_BUD_MTR_PURCHASE_ORDER
	INNER JOIN BUD_MTR_PURCHASE_ORDER_OWNER A ON PO.PK_BUD_MTR_PURCHASE_ORDER=A.FK_BUD_MTR_PURCHASE_ORDER
	INNER JOIN dbo.BUD_MTR_COMPANY B ON B.PK_BUD_MTR_COMPANY = A.FK_BUD_MTR_COMPANY
	INNER JOIN dbo.BUD_MTR_STORE ST ON ST.PK_BUD_MTR_STORE = A.FK_BUD_MTR_STORE
	LEFT JOIN ICG.CENTROCOSTOSxEMPRESAS E ON E.CODALMACEN=ST.CODALMACEN
	 WHERE PO.FK_GBL_CAT_CATALOG_STATUS IN (114, 132,131)  AND A.ACTIVE=1 
	 AND PO.ENVIADOICG=0 and IDEMPRESA is not null--1
End
update BUD_MTR_PURCHASE_ORDER set  ENVIADOICG=0 where REFERENCE_NUMBER='PO-0004650'
GO
DROP PROCEDURE IF EXISTS [ICG].[SP_ORDENCOMPRA_DETALLE_OBTENER]
GO
CREATE Procedure [ICG].[SP_ORDENCOMPRA_DETALLE_OBTENER](
 @NUMPEDIDO VARCHAR(60) 
)
As
BEGIN
   SELECT DISTINCT P.REFERENCE_NUMBER AS NUMPEDIDO,e.CODALMACEN,e.CENTROCOSTE, E.IDEMPRESA,A.FK_BUD_MTR_PURCHASE_ORDER AS IDPEDIDO, A.QTY  AS CANTIDAD,
               A.AMOUNT AS TOTAL, A.SUBTOTAL AS SUBTOTAL,A.TAX_AMOUNT_PERCENTAGE  AS TOTALIMPUESTO,
			   A.TAX_AMOUNT_PERCENTAGE AS PORCENTAJEIMPUESTO,A.DESCRIPTION_PRODUCT AS DESCRIPCION, AR.DESCRIPCION AS   DESCRIPCIONICG
			   FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A WITH (NOLOCK)
            INNER JOIN dbo.BUD_MTR_PRODUCT B
                ON B.PK_BUD_MTR_PRODUCT = A.FK_BUD_MTR_PRODUCT
			INNER JOIN BUD_MTR_PURCHASE_ORDER_OWNER O ON O.FK_BUD_MTR_PURCHASE_ORDER=A.FK_BUD_MTR_PURCHASE_ORDER
			INNER JOIN dbo.BUD_MTR_COMPANY C ON C.PK_BUD_MTR_COMPANY = O.FK_BUD_MTR_COMPANY
			INNER JOIN dbo.BUD_MTR_STORE ST ON ST.PK_BUD_MTR_STORE = O.FK_BUD_MTR_STORE
			LEFT JOIN ICG.CENTROCOSTOSxEMPRESAS E ON E.CODALMACEN=ST.CODALMACEN
			INNER JOIN BUD_MTR_PURCHASE_ORDER P ON A.FK_BUD_MTR_PURCHASE_ORDER=P.PK_BUD_MTR_PURCHASE_ORDER 
			INNER JOIN ICG.GASTOS AR ON B.CODARTICULO=AR.CODARTICULO
 where P.REFERENCE_NUMBER=@NUMPEDIDO AND A.ACTIVE=1 and P.FK_GBL_CAT_CATALOG_STATUS IN (114,132)
            
End
GO
DROP PROCEDURE IF EXISTS [ICG].[SP_ORDEN_PROCESADA]
GO
CREATE PROCEDURE [ICG].[SP_ORDEN_PROCESADA]
(
	
	@NUMPEDIDO VARCHAR(60)

)
AS
BEGIN
	UPDATE BUD_MTR_PURCHASE_ORDER SET 
	ENVIADOICG=1
	WHERE REFERENCE_NUMBER=@NUMPEDIDO
END
	
GO


--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE PROVEEDORES
--***************************************************************************************************************************************************************************************************************************************

IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_SUPPLIER' AND table_schema = 'dbo' AND column_name = 'ENVIADO_ICG')  
ALTER TABLE BUD_MTR_SUPPLIER ADD  ENVIADO_ICG BIT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_SUPPLIER' AND table_schema = 'dbo' AND column_name = 'CUENTACONTABLE')  
ALTER TABLE BUD_MTR_SUPPLIER ADD  CUENTACONTABLE NVARCHAR(12)
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_SUPPLIER' AND table_schema = 'dbo' AND column_name = 'FORMAPAGO')  
ALTER TABLE BUD_MTR_SUPPLIER ADD  FORMAPAGO NVARCHAR(100)
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_BANK_DETAIL' AND table_schema = 'dbo' AND column_name = 'PRINCIPAL')  
ALTER TABLE BUD_MTR_BANK_DETAIL ADD  PRINCIPAL BIT
GO
DROP PROCEDURE IF EXISTS [dbo].[PA_CON_BUD_MTR_BANK_DETAIL_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_BANK_DETAIL_GET]
(
    @P_FK_BUD_MTR_SUPPLIER INT = 0,
    @P_ACTIVE BIT = 0
)
AS
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_FK_BUD_MTR_SUPPLIER   = ' + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_SUPPLIER, 0)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR, ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        SELECT PK_BUD_MTR_BANK_DETAIL = ISNULL(A.PK_BUD_MTR_BANK_DETAIL, 0),
               CREATION_DATE = ISNULL(A.CREATION_DATE, '1900-01-01'),
               CREATION_USER = ISNULL(A.CREATION_USER, ''),
               MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
               MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
               FK_BUD_CAT_CATALOG_BANK = ISNULL(A.FK_BUD_CAT_CATALOG_BANK, 0),
               FK_BUD_CAT_CATALOG_COIN = ISNULL(A.FK_BUD_CAT_CATALOG_COIN, 0),
               FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
               ACCOUNT1 = ISNULL(A.ACCOUNT, ''),
               ACCOUNT2 = ISNULL(A.ACCOUNT_2, ''),
               ACCOUNT3 = ISNULL(A.ACCOUNT_3, ''),
               ACTIVE = ISNULL(A.ACTIVE, 0),
               BANK = ISNULL(B.NAME, ''),
               COIN = ISNULL(C.VALUE, ''),
			   CODE_ABA = ISNULL(A.CODE_ABA,''),
			   CODE_SWIFT = ISNULL(A.CODE_SWIFT,''),
			   ADDRESS = ISNULL(A.ADDRESS,''),
			   PRINCIPAL
        FROM BUD_MTR_BANK_DETAIL A
            INNER JOIN dbo.BUD_MTR_BANK B
                ON B.PK_BUD_MTR_BANK = A.FK_BUD_CAT_CATALOG_BANK
            INNER JOIN dbo.GLB_CAT_CATALOG C
                ON C.PK_GLB_CAT_CATALOG = A.FK_BUD_CAT_CATALOG_COIN
        WHERE (A.FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER)
              AND A.ACTIVE = 1;

			  
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;


GO

DROP TRIGGER IF EXISTS [dbo].[tr_cambiarESTADO]
GO
CREATE TRIGGER [dbo].[tr_cambiarESTADO] ON [dbo].[BUD_MTR_SUPPLIER]
    AFTER INSERT
    AS
    BEGIN
      UPDATE BUD_MTR_SUPPLIER
      SET ENVIADO_ICG=0
      FROM inserted
      WHERE BUD_MTR_SUPPLIER.VALUE_IDENTIFICATION = inserted.VALUE_IDENTIFICATION;
    END
GO

ALTER TABLE [dbo].[BUD_MTR_SUPPLIER] ENABLE TRIGGER [tr_cambiarESTADO]
GO --SELECT * FROM BUD_MTR_SUPPLIER select * from BUD_MTR_BANK_DETAIL
DROP PROCEDURE IF EXISTS [dbo].[PA_MAN_BUD_MTR_BANK_DETAIL_SAVE]
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_BANK_DETAIL_SAVE]
(
    @P_PK_BUD_MTR_BANK_DETAIL INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_CAT_CATALOG_BANK INT = 0,
    @P_FK_BUD_CAT_CATALOG_COIN INT = 0,
    @P_FK_BUD_MTR_SUPPLIER INT = 0,
    @P_ACCOUNT1 VARCHAR(100) = '',
    @P_ACCOUNT2 VARCHAR(100) = '',
    @P_ACCOUNT3 VARCHAR(100) = '',
    @P_ACTIVE BIT = 0,
	@P_CODE_SWIFT VARCHAR(100) = '',
    @P_CODE_ABA VARCHAR(100) = '',
    @P_ADDRESS VARCHAR(256) = '',
	@P_PRINCIPAL BIT=0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_MAN_BUD_MTR_BANK_DETAIL_SAVE
Descripcion:	
Creado por: 	lbolanos
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_MAN_BUD_MTR_BANK_DETAIL_SAVE]
@P_PK_BUD_MTR_BANK_DETAIL    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    ='1900-01-01'
,@P_FK_BUD_CAT_CATALOG_BANK    =0
,@P_FK_BUD_CAT_CATALOG_COIN    =0
,@P_FK_BUD_MTR_SUPPLIER    =0
,@P_ACCOUNT    =''
,@P_ACTIVE    =0

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    28/11/2019 17:19:38
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_BANK_DETAIL    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_BANK_DETAIL, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_CAT_CATALOG_BANK    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_CAT_CATALOG_BANK, 0))
              + '@P_FK_BUD_CAT_CATALOG_COIN    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_CAT_CATALOG_COIN, 0))
              + '@P_FK_BUD_MTR_SUPPLIER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_SUPPLIER, 0))
              + '@P_ACCOUNT1    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_ACCOUNT1, '')) + '@P_ACCOUNT2    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACCOUNT2, '')) + '@P_ACCOUNT3    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACCOUNT3, '')) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0))+ '@P_CODE_SWIFT    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_CODE_SWIFT, 0))+ '@P_CODE_ABA    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_CODE_ABA, 0))+ '@P_ADDRESS    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ADDRESS, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF EXISTS
        (
            SELECT *
            FROM BUD_MTR_BANK_DETAIL WITH (NOLOCK)
            WHERE PK_BUD_MTR_BANK_DETAIL = @P_PK_BUD_MTR_BANK_DETAIL
        )
        BEGIN
            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.FK_BUD_CAT_CATALOG_BANK = @P_FK_BUD_CAT_CATALOG_BANK,
                A.FK_BUD_CAT_CATALOG_COIN = @P_FK_BUD_CAT_CATALOG_COIN,
                A.FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER,
                A.ACCOUNT = @P_ACCOUNT1,
                A.ACCOUNT_2 = @P_ACCOUNT2,
                A.ACCOUNT_3 = @P_ACCOUNT3,
                A.ACTIVE = @P_ACTIVE,
				A.CODE_SWIFT = @P_CODE_SWIFT,
				A.CODE_ABA = @P_CODE_ABA,
				A.ADDRESS = @P_ADDRESS,
				A.PRINCIPAL=@P_PRINCIPAL
            FROM BUD_MTR_BANK_DETAIL A
            WHERE A.PK_BUD_MTR_BANK_DETAIL = @P_PK_BUD_MTR_BANK_DETAIL;
			 update BUD_MTR_SUPPLIER set 
			 ENVIADO_ICG=0
			 where PK_BUD_MTR_SUPPLIER=@P_FK_BUD_MTR_SUPPLIER
        END;
        ELSE
        BEGIN
            INSERT INTO BUD_MTR_BANK_DETAIL
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_CAT_CATALOG_BANK,
                FK_BUD_CAT_CATALOG_COIN,
                FK_BUD_MTR_SUPPLIER,
                ACCOUNT,
                ACCOUNT_2,
                ACCOUNT_3,
                ACTIVE,
				CODE_SWIFT,
				CODE_ABA,
				ADDRESS,
				PRINCIPAL
            )
            VALUES
            (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER, @P_FK_BUD_CAT_CATALOG_BANK,
             @P_FK_BUD_CAT_CATALOG_COIN, @P_FK_BUD_MTR_SUPPLIER, @P_ACCOUNT1, @P_ACCOUNT2, @P_ACCOUNT3, @P_ACTIVE,
			 @P_CODE_SWIFT,@P_CODE_ABA,@P_ADDRESS, @P_PRINCIPAL);

			 update BUD_MTR_SUPPLIER set 
			 ENVIADO_ICG=0
			 where PK_BUD_MTR_SUPPLIER=@P_FK_BUD_MTR_SUPPLIER

			--select @@identity
			set @P_PK_BUD_MTR_BANK_DETAIL= @@identity
			 SELECT * FROM BUD_MTR_BANK_DETAIL WHERE PK_BUD_MTR_BANK_DETAIL=@P_PK_BUD_MTR_BANK_DETAIL;

        END;
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
DROP PROCEDURE IF EXISTS [ICG].[SP_PROVEEDOR_OBTENER]
GO
CREATE Procedure [ICG].[SP_PROVEEDOR_OBTENER]
AS
BEGIN
select CUENTACONTABLE as CODCONTABLE,REGISTRAL_NAME as NOMPROVEEDOR,COMMERCIAL_NAME as NOMCOMERCIAL, 
       VALUE_IDENTIFICATION as CIF,VALUE_IDENTIFICATION as NIF20,LEGAL_REPRESENTATIVE as PERSONACONTACTO,
	   PRINCIPAL_PHONE as TELEFONO1, ISNULL(C.PHONE, 'N/D') as TELEFONO2, EMAIL_NOTIFICATION as E_MAIL,'' as FAX,  D.VALUE AS PAIS,'' AS PROVINCIA,
	   ADDRESS_SUPPLIER AS DIRECCION1,BD.ACCOUNT as NUMCUENTA, '' as CODBANCO, BK.NAME as NOMBREBANCO, BD.ADDRESS as DIRECCIONBANCO,  '' as CODCONTABLECOMPRA, BD.ACCOUNT as CODIGOIBAN, '' as PERSONAJURIDICA,
	   LINE_BUSINESS AS GIRONEGOCIO, BD.CODE_SWIFT AS CODIGOSWIFT, BD.CODE_ABA AS CODIGOABA, C.JOB_POSITION AS POSICION,A.FORMAPAGO,
	   C.MOBILE AS CELULARCONTACTO, C.EMAIL AS EMAILCONTACTO, CO.VALUE AS MONEDA,CT.VALUE AS TIPOIDENTIFICACION, CAST(0 as bit) as LISTANEGRA
	   from BUD_MTR_SUPPLIER A
 LEFT JOIN
            (
                SELECT MAX(PK_BUD_MTR_CONTACT_SUPPLIER) AS MAX_PK,
                       FK_BUD_MTR_SUPPLIER
                FROM dbo.BUD_MTR_CONTACT_SUPPLIER
                WHERE ACTIVE = 1
                GROUP BY FK_BUD_MTR_SUPPLIER
            ) B
			    ON B.FK_BUD_MTR_SUPPLIER = A.PK_BUD_MTR_SUPPLIER
LEFT JOIN dbo.BUD_MTR_BANK_DETAIL BD
               ON BD.FK_BUD_MTR_SUPPLIER = A.PK_BUD_MTR_SUPPLIER
 LEFT JOIN dbo.GLB_CAT_CATALOG D
                ON D.PK_GLB_CAT_CATALOG = A.FK_BUD_CAT_CATALOG_COUNTRY
 LEFT JOIN dbo.BUD_MTR_CONTACT_SUPPLIER C
                ON B.MAX_PK = C.PK_BUD_MTR_CONTACT_SUPPLIER
LEFT JOIN  dbo.GLB_CAT_CATALOG CO 
				ON BD.FK_BUD_CAT_CATALOG_COIN = CO.PK_GLB_CAT_CATALOG
LEFT JOIN dbo.GLB_CAT_CATALOG CT ON A.FK_BUD_CAT_IDENTIFICATION=CT.PK_GLB_CAT_CATALOG
LEFT JOIN dbo.BUD_MTR_BANK BK on BD.FK_BUD_CAT_CATALOG_BANK=BK.PK_BUD_MTR_BANK
    WHERE ENVIADO_ICG=0 AND BD.PRINCIPAL=1

END
GO
DROP PROCEDURE IF EXISTS [ICG].[SP_EstadoProveedor_Modificar]
GO
CREATE Procedure [ICG].[SP_EstadoProveedor_Modificar] (
 @NIF20 VARCHAR(20)
)
AS
BEGIN	
		UPDATE BUD_MTR_SUPPLIER SET ENVIADO_ICG=1 WHERE VALUE_IDENTIFICATION=@NIF20
END
GO
--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE ALMECEN/CENTRO DE COSTOS
--***************************************************************************************************************************************************************************************************************************************
DROP TABLE IF EXISTS [ICG].[CENTROCOSTOSxEMPRESAS]
CREATE TABLE [ICG].[CENTROCOSTOSxEMPRESAS](
	[CODALMACEN] [nvarchar](3) NOT NULL,
	[CENTROCOSTE] [nvarchar](6) NULL,
	[DESCRIPCION] [varchar](30) NULL,
	[IDEMPRESA] [varchar](20) NOT NULL,
	[FECHA_CREACION] [datetime] NULL,
	[ENVIADO] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CODALMACEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP Procedure IF EXISTS [ICG].[SP_ALMACEN_GUARDAR]
GO
CREATE Procedure [ICG].[SP_ALMACEN_GUARDAR]
(
	@CostCenter VARCHAR(MAX)
)
As
Begin
		DECLARE @CodAlmacen NVARCHAR(3),@CentroCoste NVARCHAR(6), @Descripcion VARCHAR(200),@IdEmpresa VARCHAR(20)

	Select	@CodAlmacen = P.CodAlmacen, @CentroCoste = P.CentroCoste, @Descripcion = P.Descripcion, @IdEmpresa=P.IdEmpresa
			From OPENJSON (@CostCenter) WITH ( CodAlmacen NVARCHAR(3),CentroCoste NVARCHAR(6), Descripcion VARCHAR(200),IdEmpresa VARCHAR(20)) as P


	If Not exists ( Select CodAlmacen from ICG.CENTROCOSTOSxEMPRESAS Where CodAlmacen = @CodAlmacen AND IDEMPRESA =@IdEmpresa)
	Begin
		Insert Into ICG.CENTROCOSTOSxEMPRESAS(CodAlmacen,CENTROCOSTE, DESCRIPCION,IDEMPRESA,FECHA_CREACION,ENVIADO) Values (@CodAlmacen,@CentroCoste, @Descripcion,@IdEmpresa, GETDATE(),0)
	End
	Else
	Begin
		Update ICG.CENTROCOSTOSxEMPRESAS set 
		DESCRIPCION =@Descripcion,
		FECHA_CREACION = GETDATE(),
		CENTROCOSTE=@CentroCoste,
		ENVIADO=0
		Where CodAlmacen = @CodAlmacen AND IDEMPRESA =@IdEmpresa
	End
End

--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTS  PARA SERVICIO DE CUENTA CONTABLE
--***************************************************************************************************************************************************************************************************************************************
DROP TABLE IF EXISTS [ICG].[CUENTACONTABLExEMPRESAS]
CREATE TABLE [ICG].[CUENTACONTABLExEMPRESAS](
	[CODCONTABLE] [nvarchar](12) NOT NULL,
	[DESCRIPCION] [varchar](30) NULL,
	[IDEMPRESA] [varchar](20) NOT NULL,
	[FECHA_CREACION] [datetime] NULL
) ON [PRIMARY]
GO
DROP Procedure IF EXISTS [ICG].[SP_VerificarAlmacen_Consulta]
GO
Create Procedure [ICG].[SP_VerificarAlmacen_Consulta]
(
	
	@CodAlmacen varchar(3),
	@IdEmpresa varchar(20),
	@Exist int OUTPUT 
)
As
Begin

	
	IF exists (SELECT CODALMACEN,DESCRIPCION, IDEMPRESA  FROM ICG.CENTROCOSTOSxEMPRESAS 	WHERE IDEMPRESA=@IdEmpresa and CODALMACEN=CodAlmacen) 
	BEGIN
		set @Exist= 1
	END
	ELSE
	BEGIN
		set @Exist= 0
	END

End
GO
DROP Procedure IF EXISTS [ICG].[SP_CENTROCOSTOS_OBTENER]
GO
CREATE Procedure [ICG].[SP_CENTROCOSTOS_OBTENER]
As
Begin

	 Select DISTINCT DESCRIPCION,CENTROCOSTE,CODALMACEN from ICG.CENTROCOSTOSxEMPRESAS where ENVIADO=0
End
GO
USE [BUDGET]
GO
DROP TABLE IF EXISTS [ICG].[CENTROCOSTOS]
GO
CREATE TABLE [ICG].[CENTROCOSTOS](
	[CodAlmacen] [varchar](6) NOT NULL,
	[DESCRIPCION] [varchar](200) NULL,
	[Centrocoste] [varchar](6) NULL,
	[ACTIVO] [bit] NULL,
	[FECHA_CREACION] [datetime] NULL,
) 
GO
DROP Procedure IF EXISTS [ICG].[SP_CENTROCOSTOS_GUARDAR]
GO
CREATE Procedure [ICG].[SP_CENTROCOSTOS_GUARDAR]
(
		
		@DESCRIPCION nvarchar(250),
		@CENTROCOSTO VARCHAR(6),
		@CodAlmacen VARCHAR(6)
		
)
As
Begin

	If Not exists ( Select DESCRIPCION,* from ICG.CENTROCOSTOS Where DESCRIPCION = @DESCRIPCION )
	Begin
		Insert Into ICG.CENTROCOSTOS (CodAlmacen,DESCRIPCION,centrocoste,ACTIVO,FECHA_CREACION) VALUES (@CodAlmacen,@DESCRIPCION,@CENTROCOSTO,1,GETDATE())
		update ICG.CENTROCOSTOSxEMPRESAS set 
		enviado=1
		where DESCRIPCION = @DESCRIPCION

	End
	
End
GO





--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE ALMECEN/CUENTA CONTABLE
--***************************************************************************************************************************************************************************************************************************************
DROP TABLE IF EXISTS [ICG].[CUENTASCONTABLESxEMPRESAS] 
GO
CREATE TABLE [ICG].[CUENTASCONTABLESxEMPRESAS](
	[CODCONTABLE] [nvarchar](12) NOT NULL,
	[IDEMPRESA] [varchar](20) NOT NULL,
	[FECHA_CREACION] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CODCONTABLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP TABLE IF EXISTS [ICG].[CUENTASCONTABLES]
GO
CREATE TABLE [ICG].[CUENTASCONTABLES](
	[CODCONTABLE] [nvarchar](12) NOT NULL,
	[DESCRIPCION] [varchar](200) NULL,
	[ACTIVO] [bit] NULL,
	[FECHA_CREACION] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CODCONTABLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP Procedure IF Exists [ICG].[SP_CUENTACONTABLExEMPRESAS_GUARDAR]
GO
Create Procedure [ICG].[SP_CUENTACONTABLExEMPRESAS_GUARDAR]
(
	@Cuenta VARCHAR(MAX)
)
As
Begin
		DECLARE @CodContable NVARCHAR(12), @Descripcion VARCHAR(200),@IdEmpresa VARCHAR(20)

	Select	@CodContable = P.CodContable,  @Descripcion = P.Descripcion, @IdEmpresa=P.IdEmpresa
			From OPENJSON (@Cuenta) WITH ( CodContable NVARCHAR(12), Descripcion VARCHAR(200),IdEmpresa VARCHAR(20)) as P


	If Not exists ( Select CODCONTABLE from ICG.CUENTACONTABLExEMPRESAS Where CODCONTABLE = @CodContable AND IDEMPRESA =@IdEmpresa)
	Begin
		Insert Into ICG.CUENTACONTABLExEMPRESAS(CODCONTABLE, DESCRIPCION,IDEMPRESA,FECHA_CREACION) Values (@CodContable, @Descripcion,@IdEmpresa, GETDATE())
	End
	Else
	Begin
		Update ICG.CUENTACONTABLExEMPRESAS set 
		DESCRIPCION =@Descripcion,
		FECHA_CREACION = GETDATE()
		Where CodContable = @CodContable AND IDEMPRESA =@IdEmpresa
	End
End
GO
DROP Procedure IF Exists [ICG].[SP_CUENTACONTABLE_OBTENER]
GO
CREATE procedure [ICG].[SP_CUENTACONTABLE_OBTENER]
AS
BEGIN
	select distinct codcontable from ICG.CUENTACONTABLExEMPRESAS
END
GO
DROP Procedure IF Exists [ICG].[SP_CUENTACONTABLE_GUARDAR]
GO
Create Procedure [ICG].[SP_CUENTACONTABLE_GUARDAR]
(
		@CodContable nvarchar(12)
		
)
As
Begin

	If Not exists ( Select CodContable from ICG.CUENTASCONTABLES Where CodContable = @CodContable )
	Begin
		Insert Into ICG.CUENTASCONTABLES (CodContable,FECHA_CREACION,ACTIVO) VALUES (@CodContable,GETDATE(),1)
	End
	
End
GO

--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE PRODUCTOS
--***************************************************************************************************************************************************************************************************************************************
DROP TABLE IF EXISTS [ICG].[ARTICULOS]
GO
CREATE TABLE [ICG].[ARTICULOS](
	[CODARTICULO] [int] NOT NULL,
	[DESCRIPCION] [nvarchar](40) NULL,
	[REFPROVEEDOR] [nvarchar](15) NULL,
	[IDEMPRESA] [varchar](20) NOT NULL,
	[FECHAREGISTRO] [datetime] NULL,
	[IMPUESTO] [float] NULL,
	[ENVIADO] [bit] NULL
) ON [PRIMARY]
GO
DROP Procedure IF EXISTS [ICG].[SP_Articulos_Guardar]
GO
CREATE Procedure [ICG].[SP_Articulos_Guardar]
(
		@Product nVarchar(max)
)
As
Begin
	 Declare @CODARTICULO int,
	@DESCRIPCION nvarchar(40),
	@REFPROVEEDOR nvarchar(15) ,
	@IdEmpresa varchar(20), @IMPUESTO float

	Select	@CODARTICULO = P.CodArticulo, @DESCRIPCION = P.Descripcion, @REFPROVEEDOR = P.RefProveedor, @IdEmpresa=P.IdEmpresa, @IMPUESTO =P.Impuesto 
			From OPENJSON (@Product) WITH (CodArticulo int, Descripcion nVarchar(40), RefProveedor nvarchar(15),IdEmpresa varchar(20),Impuesto float) as P

	If Not exists ( Select CODARTICULO from ICG.Articulos Where CODARTICULO = @CODARTICULO and IDEMPRESA=@IdEmpresa  )
	Begin
		Insert Into ICG.ARTICULOS(CODARTICULO, DESCRIPCION,REFPROVEEDOR, IDEMPRESA,FECHAREGISTRO, IMPUESTO, ENVIADO) Values (@CODARTICULO, @DESCRIPCION,@REFPROVEEDOR, @IDEMPRESA, GETDATE(),@IMPUESTO,0)
	End
	Else
	Begin
		Update ICG.ARTICULOS set 
		DESCRIPCION =@DESCRIPCION,
		REFPROVEEDOR=@REFPROVEEDOR,
		IDEMPRESA = @IDEMPRESA,
		IMPUESTO=@IMPUESTO,
		FECHAREGISTRO = GETDATE(),
		ENVIADO=0
		Where CODARTICULO = @CODARTICULO and IDEMPRESA=@IDEMPRESA
	End
End
GO
DROP Procedure IF EXISTS [ICG].[SP_VerificarArticulos_Consulta]
GO
CREATE Procedure [ICG].[SP_VerificarArticulos_Consulta]
(
	
	@CodArticulo int,
	@IdEmpresa varchar(20),
	@Exist int OUTPUT 
)
As
Begin

	
	IF exists (SELECT CODARTICULO,DESCRIPCION, REFPROVEEDOR, IDEMPRESA  FROM ICG.ARTICULOS 	WHERE IDEMPRESA=@IdEmpresa and CODARTICULO=@CodArticulo) 
	BEGIN
		set @Exist= 1
	END
	ELSE
	BEGIN
		set @Exist= 0
	END

End
GO
DROP Procedure IF EXISTS [ICG].[SP_GASTOS_OBTENER]
GO
CREATE PROCEDURE [ICG].[SP_GASTOS_OBTENER]
As
Begin

	 Select DISTINCT CODARTICULO,DESCRIPCION, IMPUESTO from ICG.ARTICULOS WHERE ENVIADO=0
End
GO
DROP Procedure IF EXISTS [ICG].[SP_GASTOS_GUARDAR]
GO
CREATE Procedure [ICG].[SP_GASTOS_GUARDAR]
(
		@DESCRIPCION nvarchar(250),
		@IMPUESTO float
)
As
Begin

	If Not exists ( Select DESCRIPCION from ICG.GASTOS Where DESCRIPCION = @DESCRIPCION )
	Begin
		Insert Into ICG.GASTOS (DESCRIPCION,FECHACREACION, IMPUESTO) VALUES (@DESCRIPCION,GETDATE(), @IMPUESTO)

		update ICG.ARTICULOS set enviado=1 where DESCRIPCION =@DESCRIPCION
	End
	
End
GO
--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE SOCIEDADES
--***************************************************************************************************************************************************************************************************************************************
---CompanyStore
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_COMPANY' AND table_schema = 'dbo' AND column_name = 'VALUE_IDENTIFICATION')  
ALTER TABLE BUD_MTR_COMPANY ADD  VALUE_IDENTIFICATION INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_COMPANY' AND table_schema = 'dbo' AND column_name = 'CODEMPRESA')  
ALTER TABLE BUD_MTR_COMPANY ADD  CODEMPRESA INT
go

DROP Procedure IF EXISTS [ICG].[SP_Sociedades_Guardar]
GO
Create Procedure [ICG].[SP_Sociedades_Guardar]
(
    @Society varchar(max)
)
AS
BEGIN
   
   		DECLARE @P_CODEMPRESA INT = 0,
		@VALUE_IDENTIFICATION VARCHAR(150) = '',
		@P_NAME VARCHAR(150) = '',
		@P_DESCRIPTION VARCHAR(300) = ''
		
		

		Select	@VALUE_IDENTIFICATION = P.Value_Identification,  @P_NAME = P.Name, @P_DESCRIPTION=P.Description,@P_CODEMPRESA=P.CodEmpresa
			From OPENJSON (@Society) WITH (Value_Identification Varchar(150), Description Varchar(150), Name varchar(200),CodEmpresa int) as P

       

        IF EXISTS(SELECT *FROM BUD_MTR_COMPANY WHERE VALUE_IDENTIFICATION = @VALUE_IDENTIFICATION and CODEMPRESA= @P_CODEMPRESA)
        BEGIN
		begin tran;
            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = 'ICG',
                A.NAME = @P_NAME,
                A.DESCRIPTION = @P_DESCRIPTION,
				a.CODEMPRESA= @P_CODEMPRESA
            FROM BUD_MTR_COMPANY A
            WHERE A.VALUE_IDENTIFICATION = @VALUE_IDENTIFICATION and CODEMPRESA= @P_CODEMPRESA ;
			commit tran;	

        END
        ELSE
        BEGIN
		begin tran;
            INSERT INTO BUD_MTR_COMPANY
            (CREATION_DATE,CREATION_USER,MODIFICATION_DATE,MODIFICATION_USER,FK_BUD_CAT_CATALOG_ACCOUNT,NAME,DESCRIPTION,NUMBER_STORE,ACTIVE,VALUE_IDENTIFICATION,CODEMPRESA)
            VALUES
            (GETDATE()    , 'ICG'       ,GETDATE()        ,'ICG',            1,                        @P_NAME, @P_DESCRIPTION, 0, 1, @VALUE_IDENTIFICATION,@P_CODEMPRESA);
			
		commit tran;	
        END;
END;
GO
DROP Procedure IF EXISTS [ICG].[SP_Sociedades_Consulta]
GO
CREATE Procedure [ICG].[SP_Sociedades_Consulta]
(
	
	@CodEmpresa int,
	@Value_Identification varchar(20),
	@Exist int OUTPUT 
)
As
Begin

	
	IF exists (SELECT CodEmpresa,DESCRIPTION, NAME, Value_Identification  FROM BUD_MTR_COMPANY 	WHERE CodEmpresa=@CodEmpresa and Value_Identification=@Value_Identification) 
	BEGIN
		set @Exist= 1
	END
	ELSE
	BEGIN
		set @Exist= 0
	END

End
GO

--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA API DEL BUDGET
--***************************************************************************************************************************************************************************************************************************************

IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'FK_BUD_MTR_CATEGORY')  
ALTER TABLE BUD_MTR_PRODUCT ADD  FK_BUD_MTR_CATEGORY INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'FK_BUD_MTR_SUBCATEGORY')  
ALTER TABLE BUD_MTR_PRODUCT ADD  FK_BUD_MTR_SUBCATEGORY INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'FK_BUD_MTR_TYPE')  
ALTER TABLE BUD_MTR_PRODUCT ADD  FK_BUD_MTR_TYPE INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'FK_STATUS')  
ALTER TABLE BUD_MTR_PRODUCT ADD  FK_STATUS INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'PK_USER_CREATOR')  
ALTER TABLE BUD_MTR_PRODUCT ADD  PK_USER_CREATOR INT
go
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'PK_USER_APPROVER')  
ALTER TABLE BUD_MTR_PRODUCT ADD  PK_USER_APPROVER INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'COMMENT')  
ALTER TABLE BUD_MTR_PRODUCT ADD  COMMENT VARCHAR(256)
GO 
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'FK_BUD_MTR_PURCHASE_ORDER')  
ALTER TABLE BUD_MTR_PRODUCT ADD  FK_BUD_MTR_PURCHASE_ORDER INT
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_PRODUCT' AND table_schema = 'dbo' AND column_name = 'CODARTICULO')  
ALTER TABLE BUD_MTR_PRODUCT ADD  CODARTICULO INT
GO

DROP Procedure IF EXISTS [dbo].[PA_CON_BUD_MTR_COMPANY_STORE_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_COMPANY_STORE_GET]
(
    @P_PK_BUD_MTR_COMPANY_STORE INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_COMPANY INT = 0,
    @P_FK_BUD_MTR_STORE INT = 0,
    @P_ACTIVE BIT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_CON_BUD_MTR_COMPANY_STORE_GET
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_CON_BUD_MTR_COMPANY_STORE_GET]
@P_PK_BUD_MTR_COMPANY_STORE    ='0'
,@P_CREATION_DATE    =''1900-01-01''
,@P_CREATION_USER    =''''
,@P_MODIFICATION_DATE    =''1900-01-01''
,@P_MODIFICATION_USER    =''''
,@P_FK_BUD_MTR_COMPANY    ='0'
,@P_FK_BUD_MTR_STORE    =''''
,@P_ACTIVE    ='0'

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    11/19/2019 4:21:49 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
        DECLARE @TABLE_STORE_RESULT AS TABLE
        (
            FK_BUD_MTR_COMPANY INT,
            FK_BUD_MTR_STORE INT,
			FK_BUD_MTR_COMMERCIAL INT,
            NAME_STORE VARCHAR(500),
            HAVE_COMPANY BIT
        );
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@@P_PK_BUD_MTR_COMPANY_STORE    = ' + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_COMPANY_STORE, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR, ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR, ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_MTR_COMPANY    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_COMPANY, 0))
              + '@P_FK_BUD_MTR_STORE    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_STORE, '')) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR, ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO
		
        INSERT INTO @TABLE_STORE_RESULT
        (
            FK_BUD_MTR_COMPANY,
            FK_BUD_MTR_STORE,
			FK_BUD_MTR_COMMERCIAL,
            NAME_STORE,
            HAVE_COMPANY
        )
        SELECT 0,
               A.PK_BUD_MTR_STORE,A.FK_BUD_MTR_COMMERCIAL,
               CONCAT(A.NAME, ' - ', A.ADDRESS),
               0
        FROM dbo.BUD_MTR_STORE A
            LEFT JOIN dbo.BUD_MTR_COMPANY_STORE B
                ON B.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE AND B.ACTIVE = 1
        WHERE A.ACTIVE = 1
              AND B.PK_BUD_MTR_COMPANY_STORE IS NULL
        UNION
        SELECT 0,
               A.PK_BUD_MTR_STORE,A.FK_BUD_MTR_COMMERCIAL,
               CONCAT(A.NAME, ' - ', A.ADDRESS),
               1
        FROM dbo.BUD_MTR_STORE A
            LEFT JOIN dbo.BUD_MTR_COMPANY_STORE B
                ON B.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE

        WHERE A.ACTIVE = 1
              AND B.FK_BUD_MTR_COMPANY = @P_FK_BUD_MTR_COMPANY
			  AND b.ACTIVE = 1

        
        SELECT *
        FROM @TABLE_STORE_RESULT

		ORDER BY NAME_STORE
		
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      END TRY
    BEGIN CATCH
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;



GO
---Bud_Mtr_Category
DROP TABLE IF EXISTS [dbo].[BUD_MTR_CATEGORY]
GO
CREATE TABLE [dbo].[BUD_MTR_CATEGORY](
	[PK_BUD_MTR_CATEGORY] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [varchar](200) NULL,
	[ACTIVE] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_BUD_MTR_CATEGORY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP Procedure IF EXISTS [dbo].[PA_MAN_BUD_MTR_CATEGORY_GET]
GO
CREATE Procedure [dbo].[PA_MAN_BUD_MTR_CATEGORY_GET]
As
Begin
		SELECT PK_BUD_MTR_CATEGORY,DESCRIPTION,ACTIVE   FROM BUD_MTR_CATEGORY
End
GO
DROP Procedure IF EXISTS [dbo].[PA_MAN_BUD_MTR_CATEGORY_SAVE]
GO
Create Procedure [dbo].[PA_MAN_BUD_MTR_CATEGORY_SAVE](
	@P_DESCRIPTION VARCHAR(300)
)
As
Begin
		IF NOT EXISTS (SELECT PK_BUD_MTR_CATEGORY,DESCRIPTION   FROM BUD_MTR_CATEGORY WHERE DESCRIPTION=@P_DESCRIPTION)
		BEGIN
			INSERT INTO BUD_MTR_CATEGORY (DESCRIPTION,ACTIVE)VALUES (@P_DESCRIPTION,1)
		END
		SELECT PK_BUD_MTR_CATEGORY,DESCRIPTION   FROM BUD_MTR_CATEGORY where DESCRIPTION=@P_DESCRIPTION

End
GO
DROP Procedure IF Exists PA_MAN_BUD_MTR_CATEGORY_DELETE
GO
Create Procedure PA_MAN_BUD_MTR_CATEGORY_DELETE(
	@PK_BUD_MTR_CATEGORY INT,
	@ACTIVE BIT
)
As
Begin
		UPDATE BUD_MTR_CATEGORY SET 
		ACTIVE=@ACTIVE
		WHERE PK_BUD_MTR_CATEGORY=@PK_BUD_MTR_CATEGORY

End
GO
---Bud_Mtr_SubCategory
DROP TABLE IF Exists [dbo].[BUD_MTR_SUBCATEGORY]
GO
CREATE TABLE [dbo].[BUD_MTR_SUBCATEGORY](
	[PK_BUD_MTR_SUBCATEGORY] [int] IDENTITY(1,1) NOT NULL,
	[PK_BUD_MTR_CATEGORY] [int] NULL,
	[DESCRIPTION] [varchar](200) NULL,
	[ACTIVE] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_BUD_MTR_SUBCATEGORY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_SUBCATEGORY_GET]
GO
CREATE Procedure [dbo].[PA_MAN_BUD_MTR_SUBCATEGORY_GET]
As
Begin
		SELECT PK_BUD_MTR_SUBCATEGORY,DESCRIPTION,ACTIVE,PK_BUD_MTR_CATEGORY   FROM BUD_MTR_SUBCATEGORY
End
GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_SUBCATEGORY_SAVE]
GO
Create Procedure [dbo].[PA_MAN_BUD_MTR_SUBCATEGORY_SAVE](
	@P_DESCRIPTION VARCHAR(300),
	@PK_BUD_MTR_CATEGORY INT
)
As
Begin
		IF NOT EXISTS (SELECT DESCRIPTION,DESCRIPTION   FROM BUD_MTR_SUBCATEGORY WHERE DESCRIPTION=@P_DESCRIPTION)
		BEGIN
			INSERT INTO BUD_MTR_SUBCATEGORY (DESCRIPTION,ACTIVE,PK_BUD_MTR_CATEGORY)VALUES (@P_DESCRIPTION,1,@PK_BUD_MTR_CATEGORY)
		END
		
End
GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_SUBCATEGORY_DELETE]
GO
Create Procedure [dbo].[PA_MAN_BUD_MTR_SUBCATEGORY_DELETE](
	@P_MAN_PK_BUD_MTR_PRODUCT INT,
	@ACTIVE BIT
)
As
Begin
		UPDATE BUD_MTR_SUBCATEGORY SET 
		ACTIVE=@ACTIVE
		WHERE PK_BUD_MTR_SUBCATEGORY=@P_MAN_PK_BUD_MTR_PRODUCT

End
GO
---Bud_Mtr_Type
DROP TABLE IF Exists [dbo].[BUD_MTR_TYPE]
GO
CREATE TABLE [dbo].[BUD_MTR_TYPE](
	[PK_BUD_MTR_TYPE] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [varchar](200) NULL,
	[ACTIVE] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_BUD_MTR_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_TYPE_GET]
GO
Create Procedure [dbo].[PA_MAN_BUD_MTR_TYPE_GET]
As
Begin
		SELECT PK_BUD_MTR_TYPE,DESCRIPTION,ACTIVE   FROM BUD_MTR_TYPE
End
GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_TYPE_SAVE]
GO
Create Procedure [dbo].[PA_MAN_BUD_MTR_TYPE_SAVE](
	@P_DESCRIPTION VARCHAR(300)
)
As
Begin
		IF NOT EXISTS (SELECT DESCRIPTION,DESCRIPTION   FROM BUD_MTR_TYPE WHERE DESCRIPTION=@P_DESCRIPTION)
		BEGIN
			INSERT INTO BUD_MTR_TYPE (DESCRIPTION,ACTIVE)VALUES (@P_DESCRIPTION,1)
		END

End
GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_TYPE_DELETE]
GO
Create Procedure [dbo].[PA_MAN_BUD_MTR_TYPE_DELETE](
	@P_MAN_PK_BUD_MTR_PRODUCT INT,
	@ACTIVE BIT
)
As
Begin
		UPDATE BUD_MTR_TYPE SET 
		ACTIVE=@ACTIVE
		WHERE PK_BUD_MTR_TYPE=@P_MAN_PK_BUD_MTR_PRODUCT
   
End
GO
---Articulos
DROP TABLE IF EXISTS [ICG].[GASTOS]
GO
CREATE TABLE [ICG].[GASTOS](
	[CODARTICULO] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPCION] [nvarchar](250) NULL,
	[IMPUESTO] [float] NULL,
	[FECHACREACION] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CODARTICULO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
DROP Procedure IF Exists [ICG].[SP_Articulos_Consulta]
GO
CREATE Procedure [ICG].[SP_Articulos_Consulta]
As
Begin
   SELECT CODARTICULO,DESCRIPCION,IMPUESTO FROM ICG.GASTOS

End
GO
-- BUD_MTR_STATUS
DROP TABLE IF Exists [dbo].[BUD_MTR_STATUS]
GO
CREATE TABLE [dbo].[BUD_MTR_STATUS](
	[PK_BUD_MTR_STATUS] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [varchar](200) NULL,
	[ACTIVE] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_BUD_MTR_STATUS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT INTO BUD_MTR_STATUS (DESCRIPTION,ACTIVE) VALUES ('Aprobado',1),('Rechazado',1),('Pendiente',1)
GO
--PARAMETROS
DROP TABLE IF Exists [ICG].[PARAMETROS]
GO
CREATE TABLE [ICG].[PARAMETROS](
	[DESCRIPCION] [nvarchar](max) NULL,
	[PARAMETRO] [varchar](max) NULL,
	[CODIGO] [varchar](5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT INTO ICG.PARAMETROS (PARAMETRO, CODIGO,DESCRIPCION) VALUES('La orden tiene productos sin aprobar','OTPSA',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html  xmlns="http://www.w3.org/1999/xhtml">  <head>   <meta http-equiv="Content-type" content="text/html; charset=utf-8" />   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />   <meta http-equiv="X-UA-Compatible" content="IE=edge" />   <meta name="format-detection" content="date=no" />   <meta name="format-detection" content="address=no" />   <meta name="format-detection" content="telephone=no" />   <style type="text/css" media="screen">          /* Linked Styles */          body {              padding: 0 !important;              margin: 0 !important;              display: block !important;              min-width: 100% !important;              width: 100% !important;              background: #ffffff;              -webkit-text-size-adjust: none          }            a {              color: #FFFFFF;              text-decoration: none          }            p {              padding: 0 !important;              margin: 0 !important          }            img {              -ms-interpolation-mode: bicubic; /* Allow smoother rendering of resized image in Internet Explorer */                  padding-bottom: 1rem;          }            .text-center {              text-align: center;          }            .text-left {              text-align: left          }            .pl-3 {              padding-left: 3rem;          }            .pb-1 {              padding-bottom: .5rem;          }            .custom-border {                  border: 1px solid #D0D0D0;          }            .w-50 {              width: 50%;          }            .pr-5 {              padding-right: 5rem;          }            .pb-3 {              padding-bottom: 3rem;          }            .box-shadow {              /*box-shadow: -2px 4px 7px 2px rgba(0,0,0,0.75);*/              border: 1.5px solid rgba(0, 0, 0, 0.25);          }            .p-all {              padding: 14px !important;          }            .position-table {              margin: 0;              border-top: none;          }    h3 {              font-size: 1.75rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }            h5 {              font-size: 1.25rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }          /* Mobile styles */          @media only screen and (max-device-width: 480px), only screen and (max-width: 480px) {       .pl-3 {                  padding-left: 1rem;              }                div [class="mobile-br-1"] {                  height: 1px !important;              }                div[class="mobile-br-1-B"] {                  height: 1px !important;                  background: #ffffff !important;                  display: block !important;              }                div[class="mobile-br-5"] {                  height: 5px !important;              }                div[class="mobile-br-10"] {                  height: 10px !important;              }                div[class="mobile-br-15"] {                  height: 15px !important;              }                div[class="mobile-br-20"] {                  height: 20px !important;              }                div[class="mobile-br-30"] {                  height: 30px !important;              }                th[class="m-td"],              td[class="m-td"],              div[class="hide-FOR-mobile"],              span[class="hide-FOR-mobile"] {                  display: none !important;                  width: 0 !important;                  height: 0 !important;                  font-size: 0 !important;                  line-height: 0 !important;                  min-height: 0 !important;              }                span[class="mobile-BLOCK"] {                  display: block !important;              }                div[class="img-m-center"] {                  text-align: center !important;              }                div[class="h2-white-m-center"],              div[class="text-white-m-center"],              div[class="text-white-r-m-center"],              div[class="h2-m-center"],              div[class="text-m-center"],              div[class="text-r-m-center"],              td[class="text-TOP"],              div[class="text-TOP"],              div[class="h6-m-center"],              div[class="text-m-center"],              div[class="text-TOP-date"],              div[class="text-white-TOP"],              td[class="text-white-TOP"],              td[class="text-white-TOP-r"],              div[class="text-white-TOP-r"] {                  text-align: center !important;              }                div[class="fluid-img"] img,              td[class="fluid-img"] img {                  width: 100% !important;                  max-width: 100% !important;                  height: auto !important;              }                table[class="mobile-shell"] {                  width: 100% !important;                  min-width: 100% !important;              }                table[class="center"] {                  margin: 0 auto;              }                th[class="COLUMN-rtl"],              th[class="COLUMN-rtl2"],              th[class="COLUMN-TOP"],              th[class="COLUMN"] {                  float: left !important;                  width: 100% !important;                  display: block !important;              }                td[class="td"] {                  width: 100% !important;                  min-width: 100% !important;              }                td[class="CONTENT-spacing"] {                  width: 15px !important;              }                td[class="CONTENT-spacing2"] {                  width: 10px !important;              }          }      </style>   <style> #customers {   font-family: Arial, Helvetica, sans-serif;   border-collapse: collapse;   width: 100%;   margin: auto; }  #customers td, #customers th {   border: 1px solid #ddd;   padding: 8px; }  #customers tr:nth-child(even){background-color: #f2f2f2;}  #customers tr:hover {background-color: #ddd;}  #customers th {   padding-top: 12px;   padding-bottom: 12px;   text-align: center;   background-color: #1f4e78;   color: white; }</style>  </head>  <body class="body" style="padding:0 !important; margin:0 !important; display:block !important; min-width:100% !important; width:100% !important; background:#ffffff; -webkit-text-size-adjust:none">   <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78">    <tr>     <td align="center" valign="top">      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78">       <tr>        <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>        <td align="center">         <table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell">          <tr>           <td class="td" style="width:90%; min-width:90%; font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0">            <table width="100%" border="0" cellspacing="0" cellpadding="0">             <tr>              <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>              <td>               <table width="100%" border="0" cellspacing="0" cellpadding="0" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">                <tr>                 <td height="30" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td>                </tr>               </table>               <table width="100%" border="0" cellspacing="0" cellpadding="0">                <tr>                 <th class="column" style="font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0" width="300">                  <table width="100%" border="0" cellspacing="0" cellpadding="0">                   <tr>                    <td>                     <div class="img" style="font-size:0pt; line-height:0pt; text-align:left">                      <div class="img-m-center" style="font-size:0pt; line-height:0pt">                       <a href="" target="_blank">                                               </a>                      </div>                     </div>                     <div style="font-size:0pt; line-height:0pt;" class="mobile-br-20"></div>                     <div style="height: 2rem; margin: 0;background-color: #ffffff;"></div>                    </td>                   </tr>                  </table>                 </th>                </tr>               </table>              </td>              <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>             </tr>            </table>           </td>          </tr>         </table>        </td>        <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1" bgcolor="#FFFFFF"></td>       </tr>      </table>      <div mc:repeatable="Select" mc:variant="Section 1">       <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#e6e6e6">        <tr>         <td width="90%" align="center" bgcolor="#FFFFFF">          <table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell text-center box-shadow position-table" bgcolor="#FFFFFF" style="margin-top: -60px;">           <tr>            <td class="td" style="width:90%; min-width:90%; font-size:22pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0">             <table width="100%" border="0" cellspacing="0" cellpadding="0">              <tr>               <td>               <h3>Productos Pendientes de Aprobar</h3>               </td>              </tr>              <tr>               <td>                <h5> La orden de compra # reference_number tiene la siguiente lista de productos sin aprobar. </h5>               </td>              </tr>             </table>            </td>           </tr>                           <tr class="text-left">             <td class="pl-3 pb-1">                          </td>            </tr>           </tr>           <td>             tablereference                  </td>                                <tr class="text-left">            <br>                       </td>          </tr>         </table>                 </div>       </td>      </tr>       </table>                 </table>          </body>   </html>'
)
GO

INSERT INTO ICG.PARAMETROS (PARAMETRO, CODIGO,DESCRIPCION) VALUES('La orden tiene productos sin aprobar','PA',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html  xmlns="http://www.w3.org/1999/xhtml">  <head>   <meta http-equiv="Content-type" content="text/html; charset=utf-8" />   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />   <meta http-equiv="X-UA-Compatible" content="IE=edge" />   <meta name="format-detection" content="date=no" />   <meta name="format-detection" content="address=no" />   <meta name="format-detection" content="telephone=no" />   <style type="text/css" media="screen">          /* Linked Styles */          body {              padding: 0 !important;              margin: 0 !important;              display: block !important;              min-width: 100% !important;              width: 100% !important;              background: #ffffff;              -webkit-text-size-adjust: none          }            a {              color: #FFFFFF;              text-decoration: none          }            p {              padding: 0 !important;              margin: 0 !important          }            img {              -ms-interpolation-mode: bicubic; /* Allow smoother rendering of resized image in Internet Explorer */                  padding-bottom: 1rem;          }            .text-center {              text-align: center;          }            .text-left {              text-align: left          }            .pl-3 {              padding-left: 3rem;          }            .pb-1 {              padding-bottom: .5rem;          }            .custom-border {                  border: 1px solid #D0D0D0;          }            .w-50 {              width: 50%;          }            .pr-5 {              padding-right: 5rem;          }            .pb-3 {              padding-bottom: 3rem;          }            .box-shadow {              /*box-shadow: -2px 4px 7px 2px rgba(0,0,0,0.75);*/              border: 1.5px solid rgba(0, 0, 0, 0.25);          }            .p-all {              padding: 14px !important;          }            .position-table {              margin: 0;              border-top: none;          }    h3 {              font-size: 1.75rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }            h5 {              font-size: 1.25rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }          /* Mobile styles */          @media only screen and (max-device-width: 480px), only screen and (max-width: 480px) {       .pl-3 {                  padding-left: 1rem;              }                div [class="mobile-br-1"] {                  height: 1px !important;              }                div[class="mobile-br-1-B"] {                  height: 1px !important;                  background: #ffffff !important;                  display: block !important;              }                div[class="mobile-br-5"] {                  height: 5px !important;              }                div[class="mobile-br-10"] {                  height: 10px !important;              }                div[class="mobile-br-15"] {                  height: 15px !important;              }                div[class="mobile-br-20"] {                  height: 20px !important;              }                div[class="mobile-br-30"] {                  height: 30px !important;              }                th[class="m-td"],              td[class="m-td"],              div[class="hide-FOR-mobile"],              span[class="hide-FOR-mobile"] {                  display: none !important;                  width: 0 !important;                  height: 0 !important;                  font-size: 0 !important;                  line-height: 0 !important;                  min-height: 0 !important;              }                span[class="mobile-BLOCK"] {                  display: block !important;              }                div[class="img-m-center"] {                  text-align: center !important;              }                div[class="h2-white-m-center"],              div[class="text-white-m-center"],              div[class="text-white-r-m-center"],              div[class="h2-m-center"],              div[class="text-m-center"],              div[class="text-r-m-center"],              td[class="text-TOP"],              div[class="text-TOP"],              div[class="h6-m-center"],              div[class="text-m-center"],              div[class="text-TOP-date"],              div[class="text-white-TOP"],              td[class="text-white-TOP"],              td[class="text-white-TOP-r"],              div[class="text-white-TOP-r"] {                  text-align: center !important;              }                div[class="fluid-img"] img,              td[class="fluid-img"] img {                  width: 100% !important;                  max-width: 100% !important;                  height: auto !important;              }                table[class="mobile-shell"] {                  width: 100% !important;                  min-width: 100% !important;              }                table[class="center"] {                  margin: 0 auto;              }                th[class="COLUMN-rtl"],              th[class="COLUMN-rtl2"],              th[class="COLUMN-TOP"],              th[class="COLUMN"] {                  float: left !important;                  width: 100% !important;                  display: block !important;              }                td[class="td"] {                  width: 100% !important;                  min-width: 100% !important;              }                td[class="CONTENT-spacing"] {                  width: 15px !important;              }                td[class="CONTENT-spacing2"] {                  width: 10px !important;              }          }      </style>   <style> #customers {   font-family: Arial, Helvetica, sans-serif;   border-collapse: collapse;   width: 100%;   margin: auto; }  #customers td, #customers th {   border: 1px solid #ddd;   padding: 8px; }  #customers tr:nth-child(even){background-color: #f2f2f2;}  #customers tr:hover {background-color: #ddd;}  #customers th {   padding-top: 12px;   padding-bottom: 12px;   text-align: center;   background-color: #1f4e78;   color: white; }</style>  </head>  <body class="body" style="padding:0 !important; margin:0 !important; display:block !important; min-width:100% !important; width:100% !important; background:#ffffff; -webkit-text-size-adjust:none">   <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78">    <tr>     <td align="center" valign="top">      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78">       <tr>        <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>        <td align="center">         <table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell">          <tr>           <td class="td" style="width:90%; min-width:90%; font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0">            <table width="100%" border="0" cellspacing="0" cellpadding="0">             <tr>              <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>              <td>               <table width="100%" border="0" cellspacing="0" cellpadding="0" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">                <tr>                 <td height="30" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td>                </tr>               </table>               <table width="100%" border="0" cellspacing="0" cellpadding="0">                <tr>                 <th class="column" style="font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0" width="300">                  <table width="100%" border="0" cellspacing="0" cellpadding="0">                   <tr>                    <td>                     <div class="img" style="font-size:0pt; line-height:0pt; text-align:left">                      <div class="img-m-center" style="font-size:0pt; line-height:0pt">                      <img src="http://172.23.24.117:1001/assets/img/Logo-ARH.png"/>                  </div>                     </div>                     <div style="font-size:0pt; line-height:0pt;" class="mobile-br-20"></div>                     <div style="height: 2rem; margin: 0;background-color: #ffffff;"></div>                    </td>                   </tr>                  </table>                 </th>                </tr>               </table>              </td>              <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>             </tr>            </table>           </td>          </tr>         </table>        </td>        <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1" bgcolor="#FFFFFF"></td>       </tr>      </table>      <div mc:repeatable="Select" mc:variant="Section 1">       <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#e6e6e6">        <tr>         <td width="90%" align="center" bgcolor="#FFFFFF">          <table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell text-center box-shadow position-table" bgcolor="#FFFFFF" style="margin-top: -60px;">           <tr>            <td class="td" style="width:90%; min-width:90%; font-size:22pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0">             <table width="100%" border="0" cellspacing="0" cellpadding="0">              <tr>               <td>               <h3>Aprobación de Productos</h3>               </td>              </tr>              <tr>               <td>                <h5> La orden de compra # reference_number tiene la siguiente lista de productos aprobados. </h5>               </td>              </tr>             </table>            </td>           </tr>                           <tr class="text-left">             <td class="pl-3 pb-1">                          </td>            </tr>           </tr>           <td>             tablereference                  </td>                                <tr class="text-left">            <br>                       </td>          </tr>         </table>                 </div>       </td>      </tr>       </table>                 </table>          </body>   </html>'
)
GO
INSERT INTO ICG.PARAMETROS (PARAMETRO, CODIGO,DESCRIPCION) VALUES('La orden tiene productos rechazados','PR',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html  xmlns="http://www.w3.org/1999/xhtml">  <head>   <meta http-equiv="Content-type" content="text/html; charset=utf-8" />   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />   <meta http-equiv="X-UA-Compatible" content="IE=edge" />   <meta name="format-detection" content="date=no" />   <meta name="format-detection" content="address=no" />   <meta name="format-detection" content="telephone=no" />   <style type="text/css" media="screen">          /* Linked Styles */          body {              padding: 0 !important;              margin: 0 !important;              display: block !important;              min-width: 100% !important;              width: 100% !important;              background: #ffffff;              -webkit-text-size-adjust: none          }            a {              color: #FFFFFF;              text-decoration: none          }            p {              padding: 0 !important;              margin: 0 !important          }            img {              -ms-interpolation-mode: bicubic; /* Allow smoother rendering of resized image in Internet Explorer */                  padding-bottom: 1rem;          }            .text-center {              text-align: center;          }            .text-left {              text-align: left          }            .pl-3 {              padding-left: 3rem;          }            .pb-1 {              padding-bottom: .5rem;          }            .custom-border {                  border: 1px solid #D0D0D0;          }            .w-50 {              width: 50%;          }            .pr-5 {              padding-right: 5rem;          }            .pb-3 {              padding-bottom: 3rem;          }            .box-shadow {              /*box-shadow: -2px 4px 7px 2px rgba(0,0,0,0.75);*/              border: 1.5px solid rgba(0, 0, 0, 0.25);          }            .p-all {              padding: 14px !important;          }            .position-table {              margin: 0;              border-top: none;          }    h3 {              font-size: 1.75rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }            h5 {              font-size: 1.25rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }          /* Mobile styles */          @media only screen and (max-device-width: 480px), only screen and (max-width: 480px) {       .pl-3 {                  padding-left: 1rem;              }                div [class="mobile-br-1"] {                  height: 1px !important;              }                div[class="mobile-br-1-B"] {                  height: 1px !important;                  background: #ffffff !important;                  display: block !important;              }                div[class="mobile-br-5"] {                  height: 5px !important;              }                div[class="mobile-br-10"] {                  height: 10px !important;              }                div[class="mobile-br-15"] {                  height: 15px !important;              }                div[class="mobile-br-20"] {                  height: 20px !important;              }                div[class="mobile-br-30"] {                  height: 30px !important;              }                th[class="m-td"],              td[class="m-td"],              div[class="hide-FOR-mobile"],              span[class="hide-FOR-mobile"] {                  display: none !important;                  width: 0 !important;                  height: 0 !important;                  font-size: 0 !important;                  line-height: 0 !important;                  min-height: 0 !important;              }                span[class="mobile-BLOCK"] {                  display: block !important;              }                div[class="img-m-center"] {                  text-align: center !important;              }                div[class="h2-white-m-center"],              div[class="text-white-m-center"],              div[class="text-white-r-m-center"],              div[class="h2-m-center"],              div[class="text-m-center"],              div[class="text-r-m-center"],              td[class="text-TOP"],              div[class="text-TOP"],              div[class="h6-m-center"],              div[class="text-m-center"],              div[class="text-TOP-date"],              div[class="text-white-TOP"],              td[class="text-white-TOP"],              td[class="text-white-TOP-r"],              div[class="text-white-TOP-r"] {                  text-align: center !important;              }                div[class="fluid-img"] img,              td[class="fluid-img"] img {                  width: 100% !important;                  max-width: 100% !important;                  height: auto !important;              }                table[class="mobile-shell"] {                  width: 100% !important;                  min-width: 100% !important;              }                table[class="center"] {                  margin: 0 auto;              }                th[class="COLUMN-rtl"],              th[class="COLUMN-rtl2"],              th[class="COLUMN-TOP"],              th[class="COLUMN"] {                  float: left !important;                  width: 100% !important;                  display: block !important;              }                td[class="td"] {                  width: 100% !important;                  min-width: 100% !important;              }                td[class="CONTENT-spacing"] {                  width: 15px !important;              }                td[class="CONTENT-spacing2"] {                  width: 10px !important;              }          }      </style>   <style> #customers {   font-family: Arial, Helvetica, sans-serif;   border-collapse: collapse;   width: 100%;   margin: auto; }  #customers td, #customers th {   border: 1px solid #ddd;   padding: 8px; }  #customers tr:nth-child(even){background-color: #f2f2f2;}  #customers tr:hover {background-color: #ddd;}  #customers th {   padding-top: 12px;   padding-bottom: 12px;   text-align: center;   background-color: #1f4e78;   color: white; }</style>  </head>  <body class="body" style="padding:0 !important; margin:0 !important; display:block !important; min-width:100% !important; width:100% !important; background:#ffffff; -webkit-text-size-adjust:none">   <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78">    <tr>     <td align="center" valign="top">      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78">       <tr>        <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>        <td align="center">         <table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell">          <tr>           <td class="td" style="width:90%; min-width:90%; font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0">            <table width="100%" border="0" cellspacing="0" cellpadding="0">             <tr>              <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>              <td>               <table width="100%" border="0" cellspacing="0" cellpadding="0" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">                <tr>                 <td height="30" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td>                </tr>               </table>               <table width="100%" border="0" cellspacing="0" cellpadding="0">                <tr>                 <th class="column" style="font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0" width="300">                  <table width="100%" border="0" cellspacing="0" cellpadding="0">                   <tr>                    <td>                                        <div style="font-size:0pt; line-height:0pt;" class="mobile-br-20"></div>                     <div style="height: 2rem; margin: 0;background-color: #ffffff;"></div>                    </td>                   </tr>                  </table>                 </th>                </tr>               </table>              </td>              <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td>             </tr>            </table>           </td>          </tr>         </table>        </td>        <td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1" bgcolor="#FFFFFF"></td>       </tr>      </table>      <div mc:repeatable="Select" mc:variant="Section 1">       <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#e6e6e6">        <tr>         <td width="90%" align="center" bgcolor="#FFFFFF">          <table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell text-center box-shadow position-table" bgcolor="#FFFFFF" style="margin-top: -60px;">           <tr>            <td class="td" style="width:90%; min-width:90%; font-size:22pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0">             <table width="100%" border="0" cellspacing="0" cellpadding="0">              <tr>               <td>               <h3>Productos Rechazados</h3>               </td>              </tr>              <tr>               <td>                <h5> La orden de compra # reference_number tiene la siguiente lista de productos rechazados. </h5>               </td>              </tr>             </table>            </td>           </tr>                           <tr class="text-left">             <td class="pl-3 pb-1">                          </td>            </tr>           </tr>           <td>             tablereference                  </td>                                <tr class="text-left">            <br>                       </td>          </tr>         </table>                 </div>       </td>      </tr>       </table>                 </table>          </body>   </html>'
)
go
---Bud_Mtr_Product
DROP Procedure IF Exists [dbo].[PA_CON_BUD_MTR_PRODUCT_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_PRODUCT_GET] (@P_PK_BUD_MTR_PRODUCT INT = 0)
AS

BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER = '@P_PK_BUD_MTR_PRODUCT    = ' + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_PRODUCT, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO
		
        SELECT PK_BUD_MTR_PRODUCT = ISNULL(A.PK_BUD_MTR_PRODUCT, 0),
               CREATION_DATE = ISNULL(A.CREATION_DATE, '1900-01-01'),
               CREATION_USER = ISNULL(A.CREATION_USER, ''),
               MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
               MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
               --FK_GBL_CAT_CATALOG_PRODUCT_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_PRODUCT_TYPE, 0),
               --FK_GBL_CAT_CATALOG_CATEGORY_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_CATEGORY_TYPE, 0),
              -- FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
               NAME = ISNULL(A.NAME, ''),
               ACTIVE = ISNULL(A.ACTIVE, 0),
              -- CATEGORY = ISNULL(B.VALUE, ''),
               A.CODARTICULO, 
			   IA.DESCRIPCION AS GASTOICG,
			   IA.IMPUESTO AS TAX_AMOUNT_PERCENTAGE,
			   A.FK_BUD_MTR_CATEGORY,
			   A.FK_BUD_MTR_SUBCATEGORY ,
			   A.FK_BUD_MTR_TYPE ,
			   A.FK_STATUS ,
			   C.DESCRIPTION AS CATEGORY,
			   S.DESCRIPTION AS SUBCATEGORY,
			   T.DESCRIPTION AS TYPE,
			   ST.DESCRIPTION AS STATUS,
			   A.FK_BUD_MTR_PURCHASE_ORDER,
			   B.REFERENCE_NUMBER
			FROM BUD_MTR_PRODUCT A
			LEFT JOIN ICG.GASTOS IA
				ON IA.CODARTICULO=A.CODARTICULO
			LEFT JOIN BUD_MTR_CATEGORY C 
				ON A.FK_BUD_MTR_CATEGORY=C.PK_BUD_MTR_CATEGORY
			LEFT JOIN BUD_MTR_SUBCATEGORY S
				ON A.FK_BUD_MTR_SUBCATEGORY=S.PK_BUD_MTR_SUBCATEGORY
			LEFT JOIN BUD_MTR_TYPE T 
				ON A.FK_BUD_MTR_TYPE=T.PK_BUD_MTR_TYPE
			LEFT JOIN BUD_MTR_STATUS ST
				ON A.FK_STATUS =ST.PK_BUD_MTR_STATUS
			LEFT JOIN BUD_MTR_PURCHASE_ORDER B ON A.FK_BUD_MTR_PURCHASE_ORDER=B.PK_BUD_MTR_PURCHASE_ORDER
			order by CREATION_DATE desc
		
	
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
DROP Procedure IF Exists [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS]
GO
CREATE PROCEDURE [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS](
@REFERENCE_NUMBER varchar(300),
@PK_BUD_MTR_PURCHASE_ORDER int,
@PK_CREATOR INT,
@ACCION VARCHAR(30))
AS
BEGIN
	DECLARE @C_BODY_EMAIL NVARCHAR(MAX),@body varchar(max), @V_PROFILEBD_SEND_EMAIL varchar(max), @EMAIL VARCHAR(300), @sub varchar(300)

	SELECT @EMAIL=EMAIL FROM SSO_BUDGET.DBO.SEG_MTR_USER WHERE PK_SEG_MTR_USER=@PK_CREATOR


	       	  	DECLARE @COUNTPENDING INT , @COUNTAPPROVE INT, @COUNTREJECTED INT, @TOTALAPPROVE INT

            SELECT @TOTALAPPROVE= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER AND  A.ACTIVE=1;

			SELECT @COUNTREJECTED= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (2) AND A.ACTIVE=1;

			SELECT @COUNTPENDING= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (3) AND A.ACTIVE=1;

			SELECT @COUNTAPPROVE=COUNT(*)  FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				INNER JOIN BUD_MTR_PURCHASE_ORDER C ON A.FK_BUD_MTR_PURCHASE_ORDER=C.PK_BUD_MTR_PURCHASE_ORDER
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER  AND  B.FK_STATUS not in (2) and C.FK_GBL_CAT_CATALOG_STATUS=188 AND A.ACTIVE=1


	
	SELECT @V_PROFILEBD_SEND_EMAIL = A.VALUE
				FROM dbo.GLB_PAR_PARAMETER A WITH (NOLOCK)
			WHERE A.SEARCH_KEY = 'PROFILEBD_SEND_EMAIL';
	IF @ACCION='ORDENPENDIENTE'
	BEGIN

	Update BUD_MTR_PURCHASE_ORDER set 
						   FK_GBL_CAT_CATALOG_STATUS=188
     where PK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER

		set @sub = concat('Productos Pendientes para Orden de Compra #', @REFERENCE_NUMBER)
		set @BODY = cast( (
		select td = dbtable + '</td><td>' + cast( entities as varchar(30) ) + '</td><td>' + cast( rows as varchar(30) )+ '</td><td>' + cast( nota as varchar(30) )+ '</td><td>' + cast( status as varchar(30) )
		from (
			  select dbtable  =P.NAME,
					 entities = P.MODIFICATION_USER,
					 rows     = P.MODIFICATION_DATE,
					 nota= coalesce(P.COMMENT,''),
					 status =s.DESCRIPTION
      			from BUD_MTR_PURCHASE_ORDER_PRODUCT OP
			inner join BUD_MTR_PRODUCT P ON OP.FK_BUD_MTR_PRODUCT=PK_BUD_MTR_PRODUCT
			inner join BUD_MTR_STATUS s on P.FK_STATUS=s.PK_BUD_MTR_STATUS
			INNER join BUD_MTR_PURCHASE_ORDER PO ON OP.FK_BUD_MTR_PURCHASE_ORDER=PO.PK_BUD_MTR_PURCHASE_ORDER
				where  PO.PK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER and P.FK_STATUS IN (3) and OP.ACTIVE=1
			  ) as d
		for xml path( 'tr' ), type ) as varchar(max) )

		set @BODY = ' <div style="text-align:center; align="center"">
													<table  id="customers" >'
				  + '<tr><th>Producto</th><th>Creador</th><th>Fecha Petición</th><th>Nota</th><th>Estado</th></tr>'
				  + replace( replace( @body, '&lt;', '<' ), '&gt;', '>' )
				  + '</table></div>'

		SELECT @C_BODY_EMAIL=DESCRIPCION FROM ICG.PARAMETROS where CODIGO='OTPSA'
		
		
				SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'reference_number',@REFERENCE_NUMBER );

				SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'tablereference', @BODY);
	END

	IF @ACCION='PRODUCTOSECHAZADOS' AND @COUNTREJECTED>=1
	BEGIN
	Update BUD_MTR_PURCHASE_ORDER set 
						   FK_GBL_CAT_CATALOG_STATUS=188
     where PK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER
		set @sub =  concat('Productos Rechazados para Orden de Compra #', @REFERENCE_NUMBER)
		set @BODY = cast( (
		select td = dbtable + '</td><td>' + cast( entities as varchar(30) ) + '</td><td>' + cast( rows as varchar(30) )+ '</td><td>' + cast( nota as varchar(30) )+ '</td><td>' + cast( status as varchar(30) )
		from (
			  select dbtable  =P.NAME,
					 entities = P.MODIFICATION_USER,
					 rows     = P.MODIFICATION_DATE,
					 nota= coalesce(P.COMMENT,''),
					 status =s.DESCRIPTION
      			from BUD_MTR_PURCHASE_ORDER_PRODUCT OP
			inner join BUD_MTR_PRODUCT P ON OP.FK_BUD_MTR_PRODUCT=PK_BUD_MTR_PRODUCT
			inner join BUD_MTR_STATUS s on P.FK_STATUS=s.PK_BUD_MTR_STATUS
			INNER join BUD_MTR_PURCHASE_ORDER PO ON OP.FK_BUD_MTR_PURCHASE_ORDER=PO.PK_BUD_MTR_PURCHASE_ORDER
				where  PO.PK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER and P.FK_STATUS IN (2) and OP.ACTIVE=1
			  ) as d
		for xml path( 'tr' ), type ) as varchar(max) )

		set @BODY = ' <div style="text-align:center; align="center"">
													<table  id="customers" >'
				  + '<tr><th>Producto</th><th>Creador</th><th>Fecha Petición</th><th>Nota</th><th>Estado</th></tr>'
				  + replace( replace( @body, '&lt;', '<' ), '&gt;', '>' )
				  + '</table></div>'

		SELECT @C_BODY_EMAIL=DESCRIPCION FROM ICG.PARAMETROS where CODIGO='PR'
		
		
				SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'reference_number',@REFERENCE_NUMBER );

				SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'tablereference', @BODY);
	END


	IF @ACCION='PRODUCTOSAPROBADOS' AND  @COUNTPENDING=0 AND @COUNTAPPROVE=@TOTALAPPROVE 
	BEGIN
	Update BUD_MTR_PURCHASE_ORDER set 
						FK_GBL_CAT_CATALOG_STATUS=112
    where PK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER

		set @sub = concat('Productos Aprobados para Orden de Compra #', @REFERENCE_NUMBER)
		set @BODY = cast( (
			select td = dbtable + '</td><td>' + cast( entities as varchar(30) ) + '</td><td>' + cast( rows as varchar(30) )+ '</td><td>' + cast( nota as varchar(30) )+ '</td><td>' + cast( status as varchar(30) )
		from (
			   select dbtable  =P.NAME,
					 entities = P.MODIFICATION_USER,
					 rows     = P.MODIFICATION_DATE,
					  nota= coalesce(P.COMMENT,''),
					 status =s.DESCRIPTION
      			from BUD_MTR_PURCHASE_ORDER_PRODUCT OP
			inner join BUD_MTR_PRODUCT P ON OP.FK_BUD_MTR_PRODUCT=PK_BUD_MTR_PRODUCT  
			inner join BUD_MTR_STATUS s on P.FK_STATUS=s.PK_BUD_MTR_STATUS
				INNER join BUD_MTR_PURCHASE_ORDER PO ON OP.FK_BUD_MTR_PURCHASE_ORDER=PO.PK_BUD_MTR_PURCHASE_ORDER
			where  PO.PK_BUD_MTR_PURCHASE_ORDER=@PK_BUD_MTR_PURCHASE_ORDER and  P.FK_STATUS=1 and OP.ACTIVE=1
			  ) as d
		for xml path( 'tr' ), type ) as varchar(max) )

		set @BODY = ' <div style="text-align:center; align="center"">
													<table  id="customers" >'
				  + '<tr><th>Producto</th><th>Creador</th><th>Fecha Petición</th><th>Nota</th><th>Estado</th></tr>'
				  + replace( replace( @body, '&lt;', '<' ), '&gt;', '>' )
				  + '</table></div>'

		SELECT @C_BODY_EMAIL=DESCRIPCION FROM ICG.PARAMETROS where CODIGO='PA'

		
				SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'reference_number',@REFERENCE_NUMBER );

				SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'tablereference', @BODY);
	END
	
		
	EXEC msdb.dbo.sp_send_dbmail @profile_name = @V_PROFILEBD_SEND_EMAIL,
											 @recipients ='anyucardenas.24@gmail.com',--;rafael.barrantes@ar-holdings.com;anyuleth.cortes@ar-holdings.com',--@EMAIL, --para pase poner la variable correcta
											 @subject =@sub ,
											 @body = @C_BODY_EMAIL,
											 @body_format = 'html';

										
END



GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_PRODUCT_PENDING_SAVE]
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_PRODUCT_PENDING_SAVE]
(
    @P_PK_BUD_MTR_PRODUCT INT = 0,		@P_CREATION_USER VARCHAR(256) = '', @P_MODIFICATION_USER VARCHAR(256) = '',		@P_FK_BUD_MTR_CATEGORY INT=0,
    @P_FK_BUD_MTR_SUBCATEGORY INT=0,	@P_FK_BUD_MTR_TYPE INT=0,		    @P_FK_BUD_MTR_STATUS INT =0,				@P_NAME VARCHAR(300) = '',
    @P_ACTIVE BIT = 0,					@P_CODARTICULO INT =0,				@P_PK_USER_CREATOR INT =0,					@P_PK_USER_APPROVER INT =0,
	@P_FK_BUD_MTR_PURCHASE_ORDER INT =0, @P_COMMENT  VARCHAR(256) = ''
)
AS
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
		 declare   @REFERENCE_NUMBER varchar(300)
			 select @REFERENCE_NUMBER=REFERENCE_NUMBER from BUD_MTR_PURCHASE_ORDER    WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
        DECLARE @V_PK_BUD_MTR_PRODUCT INT = 0;
        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_PRODUCT    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_PRODUCT, 0))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              + CONVERT(VARCHAR(MAX), ISNULL(@P_NAME, '')) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES
		   DECLARE @C_BODY_EMAIL NVARCHAR(MAX)= N'',  @V_PROFILEBD_SEND_EMAIL NVARCHAR(256) = N'',
                @C_SEARCH_KEY_PARAMETER_PROFILE_SEND_EMAIL VARCHAR(100) = 'PROFILEBD_SEND_EMAIL'
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO



        IF EXISTS(SELECT PK_BUD_MTR_PRODUCT FROM BUD_MTR_PRODUCT WITH (NOLOCK) WHERE PK_BUD_MTR_PRODUCT = @P_PK_BUD_MTR_PRODUCT )
        BEGIN

            UPDATE A
            SET A.CREATION_DATE = GETDATE(),
                A.CREATION_USER = @P_CREATION_USER,
                A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
				A.FK_BUD_MTR_CATEGORY =@P_FK_BUD_MTR_CATEGORY,
				A.FK_BUD_MTR_SUBCATEGORY =@P_FK_BUD_MTR_SUBCATEGORY,
				A.FK_BUD_MTR_TYPE =@P_FK_BUD_MTR_TYPE,
				A.FK_STATUS  =@P_FK_BUD_MTR_STATUS,
                A.NAME = @P_NAME,
                A.ACTIVE = @P_ACTIVE,
				A.CODARTICULO=@P_CODARTICULO,
				A.PK_USER_CREATOR=@P_PK_USER_CREATOR,
				A.PK_USER_APPROVER=@P_PK_USER_APPROVER,
				A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER, 
				A.COMMENT=@P_COMMENT
            FROM BUD_MTR_PRODUCT A
            WHERE A.PK_BUD_MTR_PRODUCT = @P_PK_BUD_MTR_PRODUCT;
         
            SELECT *
            FROM dbo.BUD_MTR_PRODUCT A
                LEFT JOIN dbo.BUD_MTR_PRODUCT_SUPPLIER B
                    ON B.FK_BUD_MTR_PRODUCT = A.PK_BUD_MTR_PRODUCT
            WHERE PK_BUD_MTR_PRODUCT = @P_PK_BUD_MTR_PRODUCT;

		
        END;
        ELSE
        BEGIN
            IF EXISTS (SELECT TOP 1 1 FROM dbo.BUD_MTR_PRODUCT WITH (NOLOCK) WHERE NAME = @P_NAME)
            BEGIN
                RAISERROR('Ya existe un producto con este nombre', 15, 20);
            END;
            INSERT INTO BUD_MTR_PRODUCT
            (CREATION_DATE, CREATION_USER, MODIFICATION_DATE, MODIFICATION_USER,FK_BUD_MTR_CATEGORY,FK_BUD_MTR_SUBCATEGORY ,
				FK_BUD_MTR_TYPE ,FK_STATUS , NAME,ACTIVE,CODARTICULO,PK_USER_CREATOR,PK_USER_APPROVER,FK_BUD_MTR_PURCHASE_ORDER, COMMENT)
            VALUES
            (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER,@P_FK_BUD_MTR_CATEGORY,@P_FK_BUD_MTR_SUBCATEGORY,
		@P_FK_BUD_MTR_TYPE,@P_FK_BUD_MTR_STATUS,@P_NAME, @P_ACTIVE,@P_CODARTICULO, @P_PK_USER_CREATOR,@P_PK_USER_APPROVER, @P_FK_BUD_MTR_PURCHASE_ORDER, coalesce(@P_COMMENT,''));


            SET @V_PK_BUD_MTR_PRODUCT = SCOPE_IDENTITY();

            SELECT *
            FROM dbo.BUD_MTR_PRODUCT A
                LEFT JOIN dbo.BUD_MTR_PRODUCT_SUPPLIER B
                    ON B.FK_BUD_MTR_PRODUCT = A.PK_BUD_MTR_PRODUCT
            WHERE PK_BUD_MTR_PRODUCT = @V_PK_BUD_MTR_PRODUCT;
			--1	Aprobado
			--2	Rechazado
			--3	Pendiente
			
        END;
		
			
			       	  	DECLARE @COUNTPENDING INT , @COUNTAPPROVE INT, @COUNTREJECTED INT, @TOTALAPPROVE INT

            SELECT @TOTALAPPROVE= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND  A.ACTIVE=1;

			SELECT @COUNTREJECTED= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (2) AND A.ACTIVE=1;

			SELECT @COUNTPENDING= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (3) AND A.ACTIVE=1;

			SELECT @COUNTAPPROVE=COUNT(*)  FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				INNER JOIN BUD_MTR_PURCHASE_ORDER C ON A.FK_BUD_MTR_PURCHASE_ORDER=C.PK_BUD_MTR_PURCHASE_ORDER
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER  AND  B.FK_STATUS not in (2) and C.FK_GBL_CAT_CATALOG_STATUS=188 AND A.ACTIVE=1

    

			

				IF  (@COUNTREJECTED>=1)
				BEGIN
				----	Update BUD_MTR_PURCHASE_ORDER set 
				----		   FK_GBL_CAT_CATALOG_STATUS=188--@V_PK_GBL_CATALOG_STATUS_BORRADOR
				----WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
			    exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'PRODUCTOSECHAZADOS' 
				END;

					IF  ( @COUNTPENDING=0 AND @COUNTAPPROVE=@TOTALAPPROVE )
				BEGIN

				
				----	Update BUD_MTR_PURCHASE_ORDER set 
				----		FK_GBL_CAT_CATALOG_STATUS=112--@V_PK_GBL_CATALOG_STATUS_SAVE
				----	WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
				exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'PRODUCTOSAPROBADOS' 
				END;
			
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
	
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;


GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_PRODUCT_SAVE]
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_PRODUCT_SAVE]
(
    @P_PK_BUD_MTR_PRODUCT INT = 0,
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_USER VARCHAR(256) = '',
	@P_FK_BUD_MTR_CATEGORY INT=0,
    @P_FK_BUD_MTR_SUBCATEGORY INT=0,
    @P_FK_BUD_MTR_TYPE INT=0,
    @P_FK_BUD_MTR_STATUS INT =0,
    @P_NAME VARCHAR(300) = '',
    @P_ACTIVE BIT = 0,
	@P_CODARTICULO INT =0,
	@P_FK_BUD_MTR_PURCHASE_ORDER INT=0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS: 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    _MAN_BUD_MTR_PRODUCT_SAVE
Descripcion:	
Creado por: 	lbolanos
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[_MAN_BUD_MTR_PRODUCT_SAVE]
@P_PK_BUD_MTR_PRODUCT    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    =''
,@P_FK_GBL_CAT_CATALOG_PRODUCT_TYPE    =0
,@P_FK_GBL_CAT_CATALOG_CATEGORY_TYPE    =0
,@P_FK_BUD_MTR_ACCOUNT    =0
,@P_CODE    =''
,@P_NAME    =''
,@P_ACTIVE    =0

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    09/12/2019 16:11:12
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
        DECLARE @V_PK_BUD_MTR_PRODUCT INT = 0;
        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_PRODUCT    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_PRODUCT, 0))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              --+ '@P_FK_GBL_CAT_CATALOG_PRODUCT_TYPE    = '
              --+ CONVERT(VARCHAR(MAX), ISNULL(@P_FK_GBL_CAT_CATALOG_PRODUCT_TYPE, 0))
              --+ '@P_FK_GBL_CAT_CATALOG_CATEGORY_TYPE    = '
              --+ CONVERT(VARCHAR(MAX), ISNULL(@P_FK_GBL_CAT_CATALOG_CATEGORY_TYPE, 0)) + '@P_FK_BUD_MTR_ACCOUNT    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_NAME, '')) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO



        IF EXISTS
        (
            SELECT *
            FROM BUD_MTR_PRODUCT WITH (NOLOCK)
            WHERE PK_BUD_MTR_PRODUCT = @P_PK_BUD_MTR_PRODUCT
        )
        BEGIN

            UPDATE A
            SET A.CREATION_DATE = GETDATE(),
                A.CREATION_USER = @P_CREATION_USER,
                A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
				A.FK_BUD_MTR_CATEGORY =@P_FK_BUD_MTR_CATEGORY,
				A.FK_BUD_MTR_SUBCATEGORY =@P_FK_BUD_MTR_SUBCATEGORY,
				A.FK_BUD_MTR_TYPE =@P_FK_BUD_MTR_TYPE,
				A.FK_STATUS  =@P_FK_BUD_MTR_STATUS,
                A.NAME = @P_NAME,
                A.ACTIVE = @P_ACTIVE,
				A.CODARTICULO=@P_CODARTICULO,
				A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER
            FROM BUD_MTR_PRODUCT A
            WHERE A.PK_BUD_MTR_PRODUCT = @P_PK_BUD_MTR_PRODUCT;


            SELECT *
            FROM dbo.BUD_MTR_PRODUCT A
                LEFT JOIN dbo.BUD_MTR_PRODUCT_SUPPLIER B
                    ON B.FK_BUD_MTR_PRODUCT = A.PK_BUD_MTR_PRODUCT
            WHERE PK_BUD_MTR_PRODUCT = @P_PK_BUD_MTR_PRODUCT;
        END;
        ELSE
        BEGIN
            IF EXISTS
            (
                SELECT TOP 1
                       1
                FROM dbo.BUD_MTR_PRODUCT WITH (NOLOCK)
                WHERE NAME = @P_NAME
            )
            BEGIN
                RAISERROR('Ya existe un producto con este nombre', 15, 20);
            END;
            INSERT INTO BUD_MTR_PRODUCT
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_MTR_CATEGORY,
				FK_BUD_MTR_SUBCATEGORY ,
				FK_BUD_MTR_TYPE ,
				FK_STATUS ,
                NAME,
                ACTIVE,
				CODARTICULO,
				FK_BUD_MTR_PURCHASE_ORDER
            )
            VALUES
            (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER,@P_FK_BUD_MTR_CATEGORY,@P_FK_BUD_MTR_SUBCATEGORY,@P_FK_BUD_MTR_TYPE,@P_FK_BUD_MTR_STATUS,
              @P_NAME, @P_ACTIVE,@P_CODARTICULO,@P_FK_BUD_MTR_PURCHASE_ORDER);


            SET @V_PK_BUD_MTR_PRODUCT = SCOPE_IDENTITY();

            SELECT *
            FROM dbo.BUD_MTR_PRODUCT A
                LEFT JOIN dbo.BUD_MTR_PRODUCT_SUPPLIER B
                    ON B.FK_BUD_MTR_PRODUCT = A.PK_BUD_MTR_PRODUCT
            WHERE PK_BUD_MTR_PRODUCT = @V_PK_BUD_MTR_PRODUCT;



        END;

	 	  	
			       	  	DECLARE @COUNTPENDING INT , @COUNTAPPROVE INT, @TOTALPENDING INT, @TOTALAPPROVE INT

            SELECT @TOTALAPPROVE= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND  A.ACTIVE=1;

			SELECT @TOTALPENDING= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (2,3) AND A.ACTIVE=1;

			SELECT @COUNTPENDING= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (3) AND A.ACTIVE=1;

			SELECT @COUNTAPPROVE=COUNT(*)  FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				INNER JOIN BUD_MTR_PURCHASE_ORDER C ON A.FK_BUD_MTR_PURCHASE_ORDER=C.PK_BUD_MTR_PURCHASE_ORDER
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER  AND  B.FK_STATUS not in (2) and C.FK_GBL_CAT_CATALOG_STATUS=188 AND A.ACTIVE=1

    

			

				--IF  (@COUNTPENDING>=1)
				--BEGIN
				--	Update BUD_MTR_PURCHASE_ORDER set 
				--		   FK_GBL_CAT_CATALOG_STATUS=188--@V_PK_GBL_CATALOG_STATUS_BORRADOR
				--WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
				-- -- exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'ORDENPENDIENTE' ;
				--END;

				--	IF  ( @COUNTPENDING=0 AND @COUNTAPPROVE=@TOTALAPPROVE )
				--BEGIN

				

				--	Update BUD_MTR_PURCHASE_ORDER set 
				--		FK_GBL_CAT_CATALOG_STATUS=112--@V_PK_GBL_CATALOG_STATUS_SAVE
				--	WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
				--	--exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'PRODUCTOSAPROBADOS' 
				--END;
			


    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
	
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
DROP Procedure IF Exists [dbo].[PA_BUD_MTR_PRODUCT_DELETE]
GO
CREATE PROCEDURE [dbo].[PA_BUD_MTR_PRODUCT_DELETE]
(
    @P_PK_BUD_MTR_PRODUCT INT = 0
)
AS
BEGIN
		UPDATE BUD_MTR_PRODUCT SET ACTIVE=0 WHERE PK_BUD_MTR_PRODUCT=@P_PK_BUD_MTR_PRODUCT
END
GO
---Bud_Mtr_Store select * from BUD_MTR_STORE
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_STORE' AND table_schema = 'dbo' AND column_name = 'CENTROCOSTE')  
ALTER TABLE BUD_MTR_STORE ADD  CENTROCOSTE NVARCHAR(6)
GO
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'BUD_MTR_STORE' AND table_schema = 'dbo' AND column_name = 'CODALMACEN')  
ALTER TABLE BUD_MTR_STORE ADD  CODALMACEN NVARCHAR(3)
GO
DROP Procedure IF Exists [dbo].[PA_CON_BUD_MTR_STORE_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_STORE_GET]
(
    @P_PK_BUD_MTR_STORE INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_COMMERCIAL INT = 0,
    @P_NAME VARCHAR(100) = '',
    @P_ADDRESS VARCHAR(500) = '',
    @P_DATE_OPENING DATETIME = '1900-01-01',
    @P_DIMENSION DECIMAL = 0.00,
    @P_ACTIVE BIT = 0,
    @P_SHOW_RESULT BIT = 0,
    @P_FK_SEG_MTR_USER INT = 0,
    @P_OPTIONS_STORE INT = 0,
	@P_FK_BUD_MTR_COMPANY INT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_CON_BUD_MTR_STORE_GET
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_CON_BUD_MTR_STORE_GET]
@P_PK_BUD_MTR_STORE    ='0'
,@P_CREATION_DATE    =''1900-01-01''
,@P_CREATION_USER    =''''
,@P_MODIFICATION_DATE    =''1900-01-01''
,@P_MODIFICATION_USER    =''''
,@P_FK_BUD_MTR_COMMERCIAL    ='0'
,@P_NAME    =''''
,@P_ADDRESS    =''''
,@P_DATE_OPENING    =''1900-01-01''
,@P_DIMENSION    ='0.00'
,@P_ACTIVE    ='0'

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    7/26/2019 10:21:33 AM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
        DECLARE @V_STORE_TYPE_CATALOG_SEARCH_KEY VARCHAR(100) = 'contact_type_store',
                @V_PK_STORE_TYPE_CATALOG INT;
        -----------------------------
        --CONSTANTES
        --ASIGNACION

        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_STORE    = ' + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_STORE, 0)) + '@P_CREATION_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_CREATION_DATE, '1900-01-01')) + '@P_CREATION_USER    = '
              + CONVERT(VARCHAR, ISNULL(@P_CREATION_USER, '')) + '@P_MODIFICATION_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_DATE, '1900-01-01')) + '@P_MODIFICATION_USER    = '
              + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_USER, '')) + '@P_FK_BUD_MTR_COMMERCIAL    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_COMMERCIAL, 0)) + '@P_NAME    = '
              + CONVERT(VARCHAR, ISNULL(@P_NAME, '')) + '@P_ADDRESS    = ' + CONVERT(VARCHAR, ISNULL(@P_ADDRESS, ''))
              + '@P_DATE_OPENING    = ' + CONVERT(VARCHAR, ISNULL(@P_DATE_OPENING, '1900-01-01'))
              + '@P_DIMENSION    = ' + CONVERT(VARCHAR, ISNULL(@P_DIMENSION, 0.00)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR, ISNULL(@P_ACTIVE, 0)) + '@P_SHOW_RESULT    = '
              + CONVERT(VARCHAR, ISNULL(@P_SHOW_RESULT, 0)) + '@P_FK_SEG_MTR_USER    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_SEG_MTR_USER, 0)) + '@P_OPTIONS_STORE    = '
              + CONVERT(VARCHAR, ISNULL(@P_OPTIONS_STORE, 0));

        -----------------------------
        --CONSTANTES
        SELECT @V_PK_STORE_TYPE_CATALOG = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_STORE_TYPE_CATALOG_SEARCH_KEY;
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF (ISNULL(@P_OPTIONS_STORE, 0) = 1)
        BEGIN
            SELECT DISTINCT PK_BUD_MTR_STORE = ISNULL(A.PK_BUD_MTR_STORE, 0),
                   CREATION_DATE = ISNULL(A.CREATION_DATE, '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_COMMERCIAL = ISNULL(A.FK_BUD_MTR_COMMERCIAL, 0),
                   NAME = ISNULL(A.NAME, '') + '-' + ISNULL(A.ADDRESS, ''),
                   ADDRESS = ISNULL(A.ADDRESS, ''),
                   DATE_OPENING = ISNULL(A.DATE_OPENING, '1900-01-01'),
                   DIMENSION = ISNULL(A.DIMENSION, 0.00),
                   ACTIVE = ISNULL(A.ACTIVE, 0),
                   dbo.FNC_GET_CONTACT_DETAIL_VALUE(@V_PK_STORE_TYPE_CATALOG, A.PK_BUD_MTR_STORE) AS CONTACT_DETAIL,
                   CODE_STORE = ISNULL(A.CODE_STORE, ''),
                   RENT_STORE = ISNULL(A.RENT, 0),
                   PERCENTAGE_SALE_TARGET = ISNULL(A.PERCENTAGE_SALE_TARGET, 0),
                   DELIVERY_PACKING_PERCENTAGE = ISNULL(A.DELIVERY_PACKING_PERCENTAGE, 0),
                   TAXED_PACKING_PERCENTAGE = ISNULL(A.TAXED_PACKING_PERCENTAGE, 0),
                   A.SHOW_RESULT,
                   A.INCLUDE_TOTAL,
                   SALES_SQUARE_METERS = ISNULL(A.SALES_SQUARE_METERS, 0),
                   CASE
                       WHEN B.PK_BUD_MTR_USER_COMMERCIAL IS NULL THEN
                           0
                       ELSE
                           1
                   END AS ALLOWS_FILTER,
				   CODALMACEN,
				   CENTROCOSTE, CS.FK_BUD_MTR_COMPANY
            FROM BUD_MTR_STORE A WITH (NOLOCK)
                INNER JOIN dbo.BUD_MTR_USER_COMMERCIAL B WITH (NOLOCK)
                    ON B.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE
                       AND B.FK_SEG_MTR_USER = @P_FK_SEG_MTR_USER
                       AND B.ACTIVE = 1
                LEFT JOIN dbo.BUD_MTR_BUDGET_HEADER C WITH (NOLOCK)
                    ON C.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE
				LEFT JOIN dbo.BUD_MTR_COMPANY_STORE CS 
				ON C.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE	AND C.ACTIVE = 1
				LEFT JOIN BUD_MTR_COMPANY CC ON CS.FK_BUD_MTR_COMPANY=CC.PK_BUD_MTR_COMPANY
            WHERE C.PK_BUD_MTR_BUDGET_HEADER IS NULL
            ORDER BY NAME;
        END;
        ELSE
        BEGIN
            SELECT DISTINCT PK_BUD_MTR_STORE = ISNULL(A.PK_BUD_MTR_STORE, 0),
                   CREATION_DATE = ISNULL(A.CREATION_DATE, '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_COMMERCIAL = ISNULL(A.FK_BUD_MTR_COMMERCIAL, 0),
                   NAME = ISNULL(A.NAME, ''),
                   ADDRESS = ISNULL(A.ADDRESS, ''),
                   DATE_OPENING = ISNULL(A.DATE_OPENING, '1900-01-01'),
                   DIMENSION = ISNULL(A.DIMENSION, 0.00),
                   ACTIVE = ISNULL(A.ACTIVE, 0),
                   dbo.FNC_GET_CONTACT_DETAIL_VALUE(@V_PK_STORE_TYPE_CATALOG, A.PK_BUD_MTR_STORE) AS CONTACT_DETAIL,
                   CODE_STORE = ISNULL(A.CODE_STORE, ''),
                   RENT_STORE = ISNULL(A.RENT, 0),
                   PERCENTAGE_SALE_TARGET = ISNULL(A.PERCENTAGE_SALE_TARGET, 0),
                   DELIVERY_PACKING_PERCENTAGE = ISNULL(A.DELIVERY_PACKING_PERCENTAGE, 0),
                   TAXED_PACKING_PERCENTAGE = ISNULL(A.TAXED_PACKING_PERCENTAGE, 0),
                   A.SHOW_RESULT,
                   A.INCLUDE_TOTAL,
                   SALES_SQUARE_METERS = ISNULL(A.SALES_SQUARE_METERS, 0),
                   CASE
                       WHEN B.PK_BUD_MTR_USER_COMMERCIAL IS NULL THEN
                           0
                       ELSE
                           1
                   END AS ALLOWS_FILTER,
				      CODALMACEN,
				   CENTROCOSTE,
				   CC.VALUE_IDENTIFICATION, 
				   C.FK_BUD_MTR_COMPANY
            FROM BUD_MTR_STORE A WITH (NOLOCK)
                LEFT JOIN dbo.BUD_MTR_USER_COMMERCIAL B
                    ON B.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE
                       AND B.FK_SEG_MTR_USER = @P_FK_SEG_MTR_USER
                       AND B.ACTIVE = 1
				LEFT JOIN dbo.BUD_MTR_COMPANY_STORE C 
				ON C.FK_BUD_MTR_STORE = A.PK_BUD_MTR_STORE	AND C.ACTIVE = 1
				LEFT JOIN BUD_MTR_COMPANY CC ON C.FK_BUD_MTR_COMPANY=CC.PK_BUD_MTR_COMPANY
            WHERE (
                      A.PK_BUD_MTR_STORE = @P_PK_BUD_MTR_STORE
                      OR @P_PK_BUD_MTR_STORE = 0
                  )
                  AND
                  (
                      A.FK_BUD_MTR_COMMERCIAL = @P_FK_BUD_MTR_COMMERCIAL
                      OR @P_FK_BUD_MTR_COMMERCIAL = 0
                  )
                  AND
                  (
                      A.NAME = @P_NAME
                      OR @P_NAME = ''
                  )
                  AND
                  (
                      A.ACTIVE = @P_ACTIVE
                      OR @P_ACTIVE = 0
                  )
                  AND
                  (
                      A.SHOW_RESULT = @P_SHOW_RESULT
                      OR @P_SHOW_RESULT = 0
                  )
				  AND ( C.FK_BUD_MTR_COMPANY = @P_FK_BUD_MTR_COMPANY OR
				  @P_FK_BUD_MTR_COMPANY = 0)
            ORDER BY NAME;
        END;


        IF (@P_PK_BUD_MTR_STORE > 0)
        BEGIN
            SELECT A.PK_BUD_MTR_COMMERCIAL,
                   A.OVERHEAD,
                   A.TAXED_PACKING_PERCENTAGE,
                   A.DELIVERY_PACKING_PERCENTAGE, 
				   CC.VALUE_IDENTIFICATION, 
				   C.FK_BUD_MTR_COMPANY
            FROM dbo.BUD_MTR_COMMERCIAL A WITH (NOLOCK)
                INNER JOIN dbo.BUD_MTR_STORE B
                 ON B.FK_BUD_MTR_COMMERCIAL = A.PK_BUD_MTR_COMMERCIAL
				LEFT JOIN dbo.BUD_MTR_COMPANY_STORE C 
				ON C.FK_BUD_MTR_STORE = B.PK_BUD_MTR_STORE	AND C.ACTIVE = 1
				LEFT JOIN BUD_MTR_COMPANY CC ON C.FK_BUD_MTR_COMPANY=CC.PK_BUD_MTR_COMPANY
            WHERE B.PK_BUD_MTR_STORE = @P_PK_BUD_MTR_STORE
                  AND A.ACTIVE = 1
                  AND B.ACTIVE = 1;
        END;

    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    --RETURN 1;
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;

GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_STORE_SAVE]
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_STORE_SAVE]
( 
    @P_PK_BUD_MTR_STORE INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_COMMERCIAL INT = 0,
    @P_NAME VARCHAR(100) = '',
    @P_ADDRESS VARCHAR(500) = '',
    @P_DATE_OPENING DATETIME = '1900-01-01',
    @P_DIMENSION DECIMAL(18, 2) = 0.00,
    @P_ACTIVE BIT = 0,
    @P_RENT_STORE DECIMAL(18, 2) = 0.00,
    @P_PERCENTAGE_SALE_TARGET DECIMAL(18, 2) = 0.00,
    @P_DELIVERY_PACKING_PERCENTAGE DECIMAL(18, 2) = 0.00,
    @P_TAXED_PACKING_PERCENTAGE DECIMAL(18, 2) = 0.00,
    @P_INCLUDE_TOTAL BIT = 0,
    @P_SHOW_RESULT BIT = 0,
	@P_SALES_SQUARE_METERS DECIMAL(18,6),
	@P_CODALMACEN NVARCHAR(3),
	@P_CENTROCOSTE NVARCHAR(6)
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_MAN_BUD_MTR_STORE_SAVE
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_MAN_BUD_MTR_STORE_SAVE]
@P_PK_BUD_MTR_STORE    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    =''
,@P_FK_BUD_MTR_COMMERCIAL    =0
,@P_NAME    =''
,@P_ADDRESS    =''
,@P_DATE_OPENING    ='1900-01-01'
,@P_DIMENSION    =0.00
,@P_ACTIVE    =0

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    7/26/2019 10:21:40 AM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        DECLARE @V_DESCRIPTION_GLB_MTR_CONSECUTIVE_TYPE_STORE VARCHAR(50) = 'Tienda',
                @V_PK_GLB_MTR_CONSECUTIVE_TYPE_STORE INT = 0,
                @V_OPORTUNITY_CODE VARCHAR(100) = '';

        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION

        SELECT @V_PK_GLB_MTR_CONSECUTIVE_TYPE_STORE = PK_GLB_MTR_CONSECUTIVE_TYPE
        FROM dbo.GLB_MTR_CONSECUTIVE_TYPE
        WHERE NAME = @V_DESCRIPTION_GLB_MTR_CONSECUTIVE_TYPE_STORE;
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_STORE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_STORE, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_MTR_COMMERCIAL    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_COMMERCIAL, 0))
              + '@P_DELIVERY_PACKING_PERCENTAGE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_DELIVERY_PACKING_PERCENTAGE, 0)) + '@P_TAXED_PACKING_PERCENTAGE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_TAXED_PACKING_PERCENTAGE, 0)) + '@P_NAME    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_NAME, '')) + '@P_ADDRESS    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ADDRESS, '')) + '@P_DATE_OPENING    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_DATE_OPENING, '1900-01-01')) + '@P_DIMENSION    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_DIMENSION, 0.00)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0)) + '@P_RENT_STORE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_RENT_STORE, 0)) + '@P_PERCENTAGE_SALE_TARGET    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_PERCENTAGE_SALE_TARGET, 0)) + '@P_INCLUDE_TOTAL    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_INCLUDE_TOTAL, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF EXISTS
        (
            SELECT 1
            FROM BUD_MTR_STORE WITH (NOLOCK)
            WHERE PK_BUD_MTR_STORE = @P_PK_BUD_MTR_STORE
        )
        BEGIN
            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.FK_BUD_MTR_COMMERCIAL = CASE
                                              WHEN @P_FK_BUD_MTR_COMMERCIAL = 0
                                                   AND A.FK_BUD_MTR_COMMERCIAL <> 0 THEN
                                                  A.FK_BUD_MTR_COMMERCIAL
                                              ELSE
                                                  @P_FK_BUD_MTR_COMMERCIAL
                                          END,
                A.NAME = CASE
                             WHEN @P_NAME = ''
                                  AND A.NAME <> '' THEN
                                 A.NAME
                             ELSE
                                 @P_NAME
                         END,
                A.ADDRESS = CASE
                                WHEN @P_ADDRESS = ''
                                     AND A.ADDRESS <> '' THEN
                                    A.ADDRESS
                                ELSE
                                    @P_ADDRESS
                            END,
                A.DATE_OPENING = CASE
                                     WHEN @P_DATE_OPENING = '1900-01-01'
                                          AND A.DATE_OPENING <> '1900-01-01' THEN
                                         A.DATE_OPENING
                                     ELSE
                                         @P_DATE_OPENING
                                 END,
                A.DIMENSION = @P_DIMENSION,
                A.ACTIVE = @P_ACTIVE,
                A.RENT = @P_RENT_STORE,
                A.PERCENTAGE_SALE_TARGET = @P_PERCENTAGE_SALE_TARGET,
                A.TAXED_PACKING_PERCENTAGE = @P_TAXED_PACKING_PERCENTAGE,
                A.DELIVERY_PACKING_PERCENTAGE = @P_DELIVERY_PACKING_PERCENTAGE,
                A.INCLUDE_TOTAL = @P_INCLUDE_TOTAL,
                A.SHOW_RESULT = @P_SHOW_RESULT,
				a.SALES_SQUARE_METERS = @P_SALES_SQUARE_METERS,
				a.CODALMACEN=@P_CODALMACEN ,
	            a.CENTROCOSTE=@P_CENTROCOSTE 
            FROM BUD_MTR_STORE A
            WHERE A.PK_BUD_MTR_STORE = @P_PK_BUD_MTR_STORE;




            IF (@P_ACTIVE = 1)
            BEGIN
                UPDATE dbo.BUD_MTR_COMMERCIAL
                SET ACTIVE = @P_ACTIVE
                WHERE PK_BUD_MTR_COMMERCIAL = @P_FK_BUD_MTR_COMMERCIAL;
            END;

        END;
        ELSE
        BEGIN

            EXEC dbo.PA_PRO_GLB_MTR_CONSECUTIVE_TYPE_GET_NEXT_VALUE @P_PK_GLB_MTR_CONSECUTIVE_TYPE = @V_PK_GLB_MTR_CONSECUTIVE_TYPE_STORE,
                                                                    @P_MODIFICATION_USER = @P_CREATION_USER,
                                                                    @P_CONSECUTIVE = @V_OPORTUNITY_CODE OUTPUT;

            INSERT INTO BUD_MTR_STORE
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_MTR_COMMERCIAL,
                NAME,
                ADDRESS,
                DATE_OPENING,
                DIMENSION,
                ACTIVE,
                CODE_STORE,
                RENT,
                PERCENTAGE_SALE_TARGET,
                DELIVERY_PACKING_PERCENTAGE,
                TAXED_PACKING_PERCENTAGE,
                INCLUDE_TOTAL,
                SHOW_RESULT,
				SALES_SQUARE_METERS,
				CODALMACEN,
				CENTROCOSTE
            )
            VALUES
            (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER, @P_FK_BUD_MTR_COMMERCIAL, @P_NAME,
             @P_ADDRESS, @P_DATE_OPENING, @P_DIMENSION, @P_ACTIVE, @V_OPORTUNITY_CODE, @P_RENT_STORE,
             @P_PERCENTAGE_SALE_TARGET, @P_DELIVERY_PACKING_PERCENTAGE, @P_TAXED_PACKING_PERCENTAGE, @P_INCLUDE_TOTAL,
             @P_SHOW_RESULT,@P_SALES_SQUARE_METERS, @P_CODALMACEN,@P_CENTROCOSTE);



            SET @P_PK_BUD_MTR_STORE = SCOPE_IDENTITY();



			
			EXEC dbo.PA_PRO_USER_ACCOUNT_COMMERCIAL @P_FK_BUD_MTR_STORE = @P_PK_BUD_MTR_STORE,   -- int
				                                    @P_FK_BUD_MTR_ACCOUNT = 0, -- int
				                                    @P_CREATION_USER = @P_CREATION_USER      -- varchar(100)



            IF EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_COMMERCIAL_CALCULATION
                WHERE FK_BUD_MTR_COMMERCIAL = @P_FK_BUD_MTR_COMMERCIAL
                      AND ACTIVE = 1
            )
            BEGIN

                INSERT INTO dbo.BUD_MTR_STORE_CALCULATION
                (
                    CREATION_DATE,
                    CREATION_USER,
                    MODIFICATION_DATE,
                    MODIFICATION_USER,
                    FK_BUD_MTR_STORE,
                    FK_GLB_CAT_CATALOG_YEAR,
                    FK_GLB_CAT_CATALOG_MONTH,
                    AMOUNT,
                    ACTIVE
                )
                SELECT GETDATE(),                -- CREATION_DATE - datetime
                       @P_CREATION_USER,         -- CREATION_USER - varchar(256)
                       GETDATE(),                -- MODIFICATION_DATE - datetime
                       @P_MODIFICATION_USER,     -- MODIFICATION_USER - varchar(256)
                       @P_PK_BUD_MTR_STORE,      -- FK_BUD_MTR_STORE - int
                       FK_GLB_CAT_CATALOG_YEAR,  -- FK_GLB_CAT_CATALOG_YEAR - int
                       FK_GLB_CAT_CATALOG_MONTH, -- FK_GLB_CAT_CATALOG_MONTH - int
                       AMOUNT,                   -- AMOUNT - decimal(18, 6)
                       1                         -- ACTIVE - bit
                FROM dbo.BUD_MTR_COMMERCIAL_CALCULATION
                WHERE FK_BUD_MTR_COMMERCIAL = @P_FK_BUD_MTR_COMMERCIAL
                      AND ACTIVE = 1;

            END;

        END;

        UPDATE A
        SET NUMBER_STORE = ISNULL(B.NUMBER, 0)
        FROM dbo.BUD_MTR_COMMERCIAL A
            LEFT JOIN
            (
                SELECT COUNT(1) AS NUMBER,
                       FK_BUD_MTR_COMMERCIAL
                FROM dbo.BUD_MTR_STORE
                WHERE ACTIVE = 1
                GROUP BY FK_BUD_MTR_COMMERCIAL
            ) B
                ON B.FK_BUD_MTR_COMMERCIAL = A.PK_BUD_MTR_COMMERCIAL
                   AND A.ACTIVE = 1
        WHERE A.PK_BUD_MTR_COMMERCIAL = @P_FK_BUD_MTR_COMMERCIAL;


        SELECT *
        FROM dbo.BUD_MTR_STORE
        WHERE PK_BUD_MTR_STORE = @P_PK_BUD_MTR_STORE;

    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);

        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());

        SELECT @V_ESTADO_ERROR = ERROR_STATE();

        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;

        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    --RETURN 1;
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
---CentroCostos
DROP Procedure IF Exists [ICG].[SP_CENTROCOSTOS_CONSULTA]
GO
CREATE Procedure [ICG].[SP_CENTROCOSTOS_CONSULTA](
@IdEmpresa varchar(20)
)
As
Begin
		SELECT CODALMACEN,Descripcion FROM ICG.CENTROCOSTOSxEMPRESAS where IDEMPRESA=@IdEmpresa
End
GO
---CuentaContable
DROP Procedure IF Exists [ICG].[SP_CUENTASCONTABLES_CONSULTA]
GO
create Procedure [ICG].[SP_CUENTASCONTABLES_CONSULTA]
As
Begin
		SELECT CODCONTABLE,CODCONTABLE as DESCRIPCION,ACTIVO FROM ICG.CUENTASCONTABLES
End
GO
---Empresas
DROP Procedure IF Exists [ICG].[SP_Empresas_Consulta]
GO
CREATE Procedure [ICG].[SP_Empresas_Consulta]
(@Activa bit)
As
Begin
	
	SELECT IdEmpresa, Nombre  FROM ICG.EMPRESAS WHERE ACTIVA =1
End
GO
---Bud_Mtr_Company
DROP Procedure IF Exists [dbo].[PA_CON_BUD_MTR_COMPANY_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_COMPANY_GET]
(
    @P_PK_BUD_MTR_COMPANY INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_CAT_CATALOG_ACCOUNT INT = 0,
    @P_NAME VARCHAR(150) = '',
    @P_DESCRIPTION VARCHAR(300) = '',
    @P_NUMBER_STORE INT = 0,
    @P_ACTIVE BIT = 0,
    @P_FK_BUD_MTR_INDUSTRY INT = 0,
    @P_FK_GBL_CAT_CATALOG_COUNTRY INT = 0,
    @P_FK_SEG_MTR_USER INT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_CON_BUD_MTR_COMPANY_GET
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_CON_BUD_MTR_COMPANY_GET]
@P_PK_BUD_MTR_COMPANY    ='0'
,@P_CREATION_DATE    =''1900-01-01''
,@P_CREATION_USER    =''''
,@P_MODIFICATION_DATE    =''1900-01-01''
,@P_MODIFICATION_USER    =''''
,@P_FK_BUD_CAT_CATALOG_ACCOUNT    ='0'
,@P_NAME    =''''
,@P_DESCRIPTION    =''''
,@P_NUMBER_STORE    ='0'
,@P_ACTIVE    ='0'

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    11/19/2019 4:21:49 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_COMPANY    = ' + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_COMPANY, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR, ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR, ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_CAT_CATALOG_ACCOUNT    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_CAT_CATALOG_ACCOUNT, 0))
              + '@P_NAME    = ' + CONVERT(VARCHAR, ISNULL(@P_NAME, '')) + '@P_DESCRIPTION    = '
              + CONVERT(VARCHAR, ISNULL(@P_DESCRIPTION, '')) + '@P_NUMBER_STORE    = '
              + CONVERT(VARCHAR, ISNULL(@P_NUMBER_STORE, 0)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR, ISNULL(@P_ACTIVE, 0)) + '@P_FK_BUD_MTR_INDUSTRY    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_INDUSTRY, 0)) + '@P_FK_GBL_CAT_CATALOG_COUNTRY    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_GBL_CAT_CATALOG_COUNTRY, 0)) + '@P_FK_SEG_MTR_USER    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_SEG_MTR_USER, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        SELECT DISTINCT
               PK_BUD_MTR_COMPANY = ISNULL(A.PK_BUD_MTR_COMPANY, 0),
               CREATION_DATE = ISNULL(A.CREATION_DATE, '1900-01-01'),
               CREATION_USER = ISNULL(A.CREATION_USER, ''),
               MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
               MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
               FK_BUD_CAT_CATALOG_ACCOUNT = ISNULL(A.FK_BUD_CAT_CATALOG_ACCOUNT, 0),
			   CCA.NAME CATALOG_ACCOUNT,
			   VALUE_IDENTIFICATION,
               NAME = ISNULL(A.NAME, ''),
               DESCRIPTION = ISNULL(A.DESCRIPTION, ''),
               NUMBER_STORE = ISNULL(A.NUMBER_STORE, 0),
               ACTIVE = ISNULL(A.ACTIVE, 0),
               CASE
                   WHEN E.PK_BUD_MTR_COMPANY IS NULL THEN
                       0
                   ELSE
                       1
               END AS ALLOWS_FILTER
        FROM dbo.BUD_MTR_COMPANY A WITH (NOLOCK)
            LEFT JOIN dbo.BUD_MTR_COMPANY_STORE B
                ON B.FK_BUD_MTR_COMPANY = A.PK_BUD_MTR_COMPANY
            LEFT JOIN dbo.BUD_MTR_STORE C
                ON C.PK_BUD_MTR_STORE = B.FK_BUD_MTR_STORE
            LEFT JOIN dbo.BUD_MTR_COMMERCIAL D
                ON D.PK_BUD_MTR_COMMERCIAL = C.FK_BUD_MTR_COMMERCIAL
			inner join BUD_CAT_CATALOG_ACCOUNT CCA
				on A.FK_BUD_CAT_CATALOG_ACCOUNT=CCA.PK_BUD_CAT_CATALOG_ACCOUNT
            LEFT JOIN
            (
                SELECT DISTINCT
                       A.PK_BUD_MTR_COMPANY
                FROM dbo.BUD_MTR_COMPANY A
                    INNER JOIN dbo.BUD_MTR_COMPANY_STORE B
                        ON B.FK_BUD_MTR_COMPANY = A.PK_BUD_MTR_COMPANY
                    INNER JOIN dbo.BUD_MTR_STORE C
                        ON C.PK_BUD_MTR_STORE = B.FK_BUD_MTR_STORE
                    INNER JOIN dbo.BUD_MTR_USER_COMMERCIAL D
                        ON C.PK_BUD_MTR_STORE = D.FK_BUD_MTR_STORE
                WHERE D.FK_SEG_MTR_USER = @P_FK_SEG_MTR_USER
                      AND D.ACTIVE = 1
                      AND C.ACTIVE = 1
                      AND B.ACTIVE = 1
                      AND A.ACTIVE = 1
            ) E
                ON E.PK_BUD_MTR_COMPANY = A.PK_BUD_MTR_COMPANY
        WHERE (
                  A.PK_BUD_MTR_COMPANY = @P_PK_BUD_MTR_COMPANY
                  OR @P_PK_BUD_MTR_COMPANY = 0
              )
              AND
              (
                  A.FK_BUD_CAT_CATALOG_ACCOUNT = @P_FK_BUD_CAT_CATALOG_ACCOUNT
                  OR @P_FK_BUD_CAT_CATALOG_ACCOUNT = 0
              )
              AND
              (
                  A.ACTIVE = @P_ACTIVE
                  OR @P_ACTIVE = 0
              )
              AND
              (
                  D.FK_BUD_MTR_INDUSTRY = @P_FK_BUD_MTR_INDUSTRY
                  OR @P_FK_BUD_MTR_INDUSTRY = 0
              )
              AND
              (
                  D.FK_GBL_CAT_CATALOG_COUNTRY = @P_FK_GBL_CAT_CATALOG_COUNTRY
                  OR @P_FK_GBL_CAT_CATALOG_COUNTRY = 0
              )
        ORDER BY NAME
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());

        RAISERROR(@ERROR_MESSAGE, 15, 17);
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE;
        RETURN 1;
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;

GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_COMPANY_SAVE]
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_COMPANY_SAVE]
(
    @P_PK_BUD_MTR_COMPANY INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_CAT_CATALOG_ACCOUNT INT = 0,
    @P_NAME VARCHAR(150) = '',
    @P_DESCRIPTION VARCHAR(300) = '',
    @P_NUMBER_STORE INT = 0,
    @P_ACTIVE BIT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_MAN_BUD_MTR_COMPANY_SAVE
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_MAN_BUD_MTR_COMPANY_SAVE]
@P_PK_BUD_MTR_COMPANY    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    =''
,@P_FK_BUD_CAT_CATALOG_ACCOUNT    =0
,@P_NAME    =''
,@P_DESCRIPTION    =''
,@P_NUMBER_STORE    =0
,@P_ACTIVE    =0

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    11/19/2019 4:21:55 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
		DECLARE @V_PK_COMPANY INT = 0;
        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_COMPANY    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_COMPANY, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_CAT_CATALOG_ACCOUNT    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_CAT_CATALOG_ACCOUNT, 0))
              + '@P_NAME    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_NAME, '')) + '@P_DESCRIPTION    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_DESCRIPTION, '')) + '@P_NUMBER_STORE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_NUMBER_STORE, 0)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF EXISTS
        (
            SELECT *
            FROM BUD_MTR_COMPANY WITH (NOLOCK)
            WHERE PK_BUD_MTR_COMPANY = @P_PK_BUD_MTR_COMPANY
        )
        BEGIN
            UPDATE A
            SET A.MODIFICATION_DATE = @P_MODIFICATION_DATE,
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.FK_BUD_CAT_CATALOG_ACCOUNT = @P_FK_BUD_CAT_CATALOG_ACCOUNT,
                A.NAME = @P_NAME,
                A.DESCRIPTION = @P_DESCRIPTION,
                A.ACTIVE = @P_ACTIVE
            FROM BUD_MTR_COMPANY A
            WHERE A.PK_BUD_MTR_COMPANY = @P_PK_BUD_MTR_COMPANY;

			SET @V_PK_COMPANY = @P_PK_BUD_MTR_COMPANY;

        END;
        ELSE
        BEGIN
            INSERT INTO BUD_MTR_COMPANY
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_CAT_CATALOG_ACCOUNT,
                NAME,
                DESCRIPTION,
                NUMBER_STORE,
                ACTIVE
            )
            VALUES
            (@P_CREATION_DATE, @P_CREATION_USER, @P_MODIFICATION_DATE, @P_MODIFICATION_USER,
             @P_FK_BUD_CAT_CATALOG_ACCOUNT, @P_NAME, @P_DESCRIPTION, @P_NUMBER_STORE, @P_ACTIVE);

			 SET @V_PK_COMPANY = SCOPE_IDENTITY();
        END;

		SELECT * FROM dbo.BUD_MTR_COMPANY
		WHERE PK_BUD_MTR_COMPANY = @V_PK_COMPANY;
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:	
			
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());

        RAISERROR(@ERROR_MESSAGE, 15, 17);
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE;
        RETURN 1;
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
---Bud_Mtr_Supplier
DROP Procedure IF Exists [dbo].[PA_CON_BUD_MTR_SUPPLIER_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_SUPPLIER_GET]
(
    @P_PK_BUD_MTR_SUPPLIER INT = 0,
    @P_ACTIVE BIT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_CON_BUD_MTR_SUPPLIER_GET
Descripcion:	
Creado por: 	lbolanos
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_CON_BUD_MTR_SUPPLIER_GET]
@P_PK_BUD_MTR_SUPPLIER    ='0'
,@P_CREATION_DATE    =''1900-01-01''
,@P_CREATION_USER    =''''
,@P_MODIFICATION_DATE    =''1900-01-01''
,@P_MODIFICATION_USER    =''1900-01-01''
,@P_FK_BUD_CAT_CATALOG_COUNTRY    ='0'
,@P_FK_BUD_CAT_IDENTIFICATION    ='0'
,@P_VALUE_IDENTIFICATION    =''''
,@P_REGISTRAL_NAME    =''''
,@P_COMMERCIAL_NAME    =''''
,@P_PRINCIPAL_PHONE    =''''
,@P_EMAIL_FACTURATION    =''''
,@P_ACTIVE    ='0'

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    28/11/2019 17:20:08
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_SUPPLIER    = ' + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_SUPPLIER, 0))
              + CONVERT(VARCHAR, ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        SELECT A.PK_BUD_MTR_SUPPLIER,
			   A.FK_BUD_CAT_CATALOG_COUNTRY,
               A.FK_BUD_CAT_IDENTIFICATION,
               A.VALUE_IDENTIFICATION,
               A.REGISTRAL_NAME,
               A.COMMERCIAL_NAME,
               PRINCIPAL_PHONE = CASE
                                     WHEN A.PRINCIPAL_PHONE IS NULL
                                          OR A.PRINCIPAL_PHONE = '' THEN
                                         'N/D'
                                     ELSE
                                         A.PRINCIPAL_PHONE
                                 END,
               A.EMAIL_NOTIFICATION AS EMAIL_NOTIFICATION,
               A.LEGAL_REPRESENTATIVE,
               A.LINE_BUSINESS,
               A.ADDRESS_SUPPLIER,
               A.ACTIVE,
               D.VALUE AS COUNTRY,
               ISNULL(C.NAME_CONTACT, 'N/D') AS NAME_CONTACT,
               ISNULL(C.MOBILE, 'N/D') AS PHONE,
               A.BLACK_LIST,
               A.LOCKING_REASON,A.CUENTACONTABLE, A.FORMAPAGO
        FROM BUD_MTR_SUPPLIER A
            LEFT JOIN
            (
                SELECT MAX(PK_BUD_MTR_CONTACT_SUPPLIER) AS MAX_PK,
                       FK_BUD_MTR_SUPPLIER
                FROM dbo.BUD_MTR_CONTACT_SUPPLIER
                WHERE ACTIVE = 1
                GROUP BY FK_BUD_MTR_SUPPLIER
            ) B
                ON B.FK_BUD_MTR_SUPPLIER = A.PK_BUD_MTR_SUPPLIER
            LEFT JOIN dbo.BUD_MTR_CONTACT_SUPPLIER C
                ON B.MAX_PK = C.PK_BUD_MTR_CONTACT_SUPPLIER
            LEFT JOIN dbo.GLB_CAT_CATALOG D
                ON D.PK_GLB_CAT_CATALOG = A.FK_BUD_CAT_CATALOG_COUNTRY
        WHERE (
                  A.PK_BUD_MTR_SUPPLIER = @P_PK_BUD_MTR_SUPPLIER
                  OR @P_PK_BUD_MTR_SUPPLIER = 0
              )
              AND
              (
                  A.ACTIVE = @P_ACTIVE
                  OR @P_ACTIVE = 0
              );
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
DROP Procedure IF Exists [dbo].[PA_MAN_BUD_MTR_SUPPLIER_SAVE]
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_SUPPLIER_SAVE]
(
    @P_PK_BUD_MTR_SUPPLIER INT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_CAT_CATALOG_COUNTRY INT = 0,
    @P_FK_BUD_CAT_IDENTIFICATION INT = 0,
    @P_VALUE_IDENTIFICATION VARCHAR(50) = '',
    @P_REGISTRAL_NAME VARCHAR(100) = '',
    @P_COMMERCIAL_NAME VARCHAR(100) = '',
    @P_PRINCIPAL_PHONE VARCHAR(10) = '',
    @P_EMAIL_NOTIFICATION VARCHAR(200) = '',
    @P_ADDRESS_SUPPLIER VARCHAR(256) = '',
    @P_ACTIVE BIT = 0,
    @P_LINE_BUSINESS NVARCHAR(200) = '',
    @P_LEGAL_REPRESENTATIVE NVARCHAR(200) = '',
    @P_BLACK_LIST BIT = 0,
    @P_LOCKING_REASON VARCHAR(200) = '',
    @P_OPTION VARCHAR(100) = '',
	@P_CUENTACONTABLE NVARCHAR(12)='',
	@P_FORMAPAGO NVARCHAR(100)='')
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_MAN_BUD_MTR_SUPPLIER_SAVE
Descripcion:	
Creado por: 	lbolanos
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_MAN_BUD_MTR_SUPPLIER_SAVE]
@P_PK_BUD_MTR_SUPPLIER    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    ='1900-01-01'
,@P_FK_BUD_CAT_CATALOG_COUNTRY    =0
,@P_FK_BUD_CAT_IDENTIFICATION    =0
,@P_VALUE_IDENTIFICATION    =''
,@P_REGISTRAL_NAME    =''
,@P_COMMERCIAL_NAME    =''
,@P_PRINCIPAL_PHONE    =''
,@P_EMAIL_FACTURATION    =''
,@P_ACTIVE    =0

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    28/11/2019 17:20:17
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
        DECLARE @V_PK_BUD_MTR_SUPPLIER INT = 0;
        DECLARE @C_OPTION_SAVE_BLACK_LIST VARCHAR(100) = 'SAVE_BLACK_LIST';
        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_SUPPLIER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_SUPPLIER, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_CAT_CATALOG_COUNTRY    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_CAT_CATALOG_COUNTRY, 0))
              + '@P_FK_BUD_CAT_IDENTIFICATION    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_CAT_IDENTIFICATION, 0))
              + '@P_VALUE_IDENTIFICATION    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_VALUE_IDENTIFICATION, ''))
              + '@P_REGISTRAL_NAME    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_REGISTRAL_NAME, ''))
              + '@P_COMMERCIAL_NAME    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_COMMERCIAL_NAME, ''))
              + '@P_PRINCIPAL_PHONE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PRINCIPAL_PHONE, ''))
              + '@P_EMAIL_NOTIFICATION    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_EMAIL_NOTIFICATION, ''))
              + '@P_ADDRESS_SUPPLIER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_ADDRESS_SUPPLIER, 0)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0)) + '@P_LINE_BUSINESS    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_LINE_BUSINESS, 0)) + '@P_LEGAL_REPRESENTATIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_LEGAL_REPRESENTATIVE, 0)) + '@P_BLACK_LIST    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_BLACK_LIST, 0)) + '@P_LOCKING_REASON    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_LOCKING_REASON, 0))+ '@P_OPTION    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_OPTION, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF EXISTS
        (
            SELECT *
            FROM BUD_MTR_SUPPLIER WITH (NOLOCK)
            WHERE PK_BUD_MTR_SUPPLIER = @P_PK_BUD_MTR_SUPPLIER
        )
        BEGIN
            IF (ISNULL(@P_OPTION, '') = @C_OPTION_SAVE_BLACK_LIST)
            BEGIN
                UPDATE A
                SET A.MODIFICATION_DATE = GETDATE(),
                    A.MODIFICATION_USER = @P_MODIFICATION_USER,
                    A.LOCKING_REASON = @P_LOCKING_REASON,
                    A.BLACK_LIST = @P_BLACK_LIST,
					A.ENVIADO_ICG=0
                FROM BUD_MTR_SUPPLIER A
                WHERE A.PK_BUD_MTR_SUPPLIER = @P_PK_BUD_MTR_SUPPLIER;

            END;
            ELSE
            BEGIN
		
                UPDATE A
                SET A.MODIFICATION_DATE = GETDATE(),
                    A.MODIFICATION_USER = @P_MODIFICATION_USER,
                    A.FK_BUD_CAT_CATALOG_COUNTRY = @P_FK_BUD_CAT_CATALOG_COUNTRY,
                    A.FK_BUD_CAT_IDENTIFICATION = @P_FK_BUD_CAT_IDENTIFICATION,
                    A.VALUE_IDENTIFICATION = @P_VALUE_IDENTIFICATION,
                    A.REGISTRAL_NAME = @P_REGISTRAL_NAME,
                    A.COMMERCIAL_NAME = @P_COMMERCIAL_NAME,
                    A.PRINCIPAL_PHONE = @P_PRINCIPAL_PHONE,
                    A.EMAIL_NOTIFICATION = @P_EMAIL_NOTIFICATION,
                    A.ADDRESS_SUPPLIER = @P_ADDRESS_SUPPLIER,
                    A.ACTIVE = @P_ACTIVE,
                    A.LINE_BUSINESS = @P_LINE_BUSINESS,
                    A.LEGAL_REPRESENTATIVE = @P_LEGAL_REPRESENTATIVE,
					A.CUENTACONTABLE=@P_CUENTACONTABLE,
					A.FORMAPAGO=@P_FORMAPAGO, 
					A.ENVIADO_ICG=0
                FROM BUD_MTR_SUPPLIER A
                WHERE A.PK_BUD_MTR_SUPPLIER = @P_PK_BUD_MTR_SUPPLIER;

            END;
            SELECT *
            FROM dbo.BUD_MTR_SUPPLIER
            WHERE PK_BUD_MTR_SUPPLIER = @P_PK_BUD_MTR_SUPPLIER;
        END;

        ELSE
        BEGIN 
            INSERT INTO BUD_MTR_SUPPLIER
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_CAT_CATALOG_COUNTRY,
                FK_BUD_CAT_IDENTIFICATION,
                VALUE_IDENTIFICATION,
                REGISTRAL_NAME,
                COMMERCIAL_NAME,
                PRINCIPAL_PHONE,
                EMAIL_NOTIFICATION,
                ADDRESS_SUPPLIER,
                ACTIVE,
                LINE_BUSINESS,
                LEGAL_REPRESENTATIVE,
				CUENTACONTABLE,
				ENVIADO_ICG,
				FORMAPAGO
            )
            VALUES
            (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER, @P_FK_BUD_CAT_CATALOG_COUNTRY,
             @P_FK_BUD_CAT_IDENTIFICATION, @P_VALUE_IDENTIFICATION, @P_REGISTRAL_NAME, @P_COMMERCIAL_NAME,
             @P_PRINCIPAL_PHONE, @P_EMAIL_NOTIFICATION, @P_ADDRESS_SUPPLIER, @P_ACTIVE, @P_LINE_BUSINESS,
             @P_LEGAL_REPRESENTATIVE,@P_CUENTACONTABLE,0, @P_FORMAPAGO);


            SET @V_PK_BUD_MTR_SUPPLIER = SCOPE_IDENTITY();

            SELECT *
            FROM dbo.BUD_MTR_SUPPLIER
            WHERE PK_BUD_MTR_SUPPLIER = @V_PK_BUD_MTR_SUPPLIER;
        END;
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO

---Bud_Mtr_Purchase_Order_Product
DROP Procedure IF Exists [dbo].[PA_CON_BUD_MTR_PURCHASE_ORDER_PRODUCT_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_PURCHASE_ORDER_PRODUCT_GET]
(
    @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT BIGINT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_PURCHASE_ORDER BIGINT = 0,
    @P_FK_BUD_MTR_PRODUCT INT = 0,
    @P_QTY INT = 0,
    @P_AMOUNT DECIMAL = 0.00,
    @P_SUBTOTAL DECIMAL = 0.00,
    @P_ACTIVE BIT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_CON_BUD_MTR_PURCHASE_ORDER_PRODUCT_GET
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_CON_BUD_MTR_PURCHASE_ORDER_PRODUCT_GET]
@P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT    ='0'
,@P_CREATION_DATE    =''1900-01-01''
,@P_CREATION_USER    =''''
,@P_MODIFICATION_DATE    =''1900-01-01''
,@P_MODIFICATION_USER    =''''
,@P_FK_BUD_MTR_PURCHASE_ORDER    ='0'
,@P_FK_BUD_MTR_PRODUCT    ='0'
,@P_QTY    ='0'
,@P_AMOUNT    ='0.00'
,@P_SUBTOTAL    ='0.00'
,@P_ACTIVE    ='0'

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    12/17/2019 3:16:40 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        -----------------------------
        --CONSTANTES
        --ASIGNACION
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT    = '
              + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT, 0)) + '@P_CREATION_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_CREATION_DATE, '1900-01-01')) + '@P_CREATION_USER    = '
              + CONVERT(VARCHAR, ISNULL(@P_CREATION_USER, '')) + '@P_MODIFICATION_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_DATE, '1900-01-01')) + '@P_MODIFICATION_USER    = '
              + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_USER, '')) + '@P_FK_BUD_MTR_PURCHASE_ORDER    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_PURCHASE_ORDER, 0)) + '@P_FK_BUD_MTR_PRODUCT    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_PRODUCT, 0)) + '@P_QTY    = '
              + CONVERT(VARCHAR, ISNULL(@P_QTY, 0)) + '@P_AMOUNT    = ' + CONVERT(VARCHAR, ISNULL(@P_AMOUNT, 0.00))
              + '@P_SUBTOTAL    = ' + CONVERT(VARCHAR, ISNULL(@P_SUBTOTAL, 0.00)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR, ISNULL(@P_ACTIVE, 0));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO
		
        SELECT PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER_PRODUCT, 0),
               CREATION_DATE = ISNULL(A.CREATION_DATE, '1900-01-01'),
               CREATION_USER = ISNULL(A.CREATION_USER, ''),
               MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
               MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
               FK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.FK_BUD_MTR_PURCHASE_ORDER, 0),
               FK_BUD_MTR_PRODUCT = ISNULL(A.FK_BUD_MTR_PRODUCT, 0),
               QTY = ISNULL(A.QTY, 0),
               AMOUNT = ISNULL(A.AMOUNT, 0.00),
               SUBTOTAL = ISNULL(A.SUBTOTAL, 0.00),
               ACTIVE = ISNULL(A.ACTIVE, 0),
               B.NAME AS Code_Product,
			   B.FK_STATUS,
				ST.DESCRIPTION AS  STATUS,
			   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
			   TAX_AMOUNT_PERCENTAGE = ISNULL(A.TAX_AMOUNT_PERCENTAGE, 0.00),
			   DESCRIPTION_PRODUCT = ISNULL(A.DESCRIPTION_PRODUCT,'')
			  FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A WITH (NOLOCK)
            INNER JOIN dbo.BUD_MTR_PRODUCT B
                ON B.PK_BUD_MTR_PRODUCT = A.FK_BUD_MTR_PRODUCT
          left JOIN dbo.BUD_MTR_STATUS ST
			   ON B.FK_STATUS =ST.PK_BUD_MTR_STATUS
        WHERE (
                  A.PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT
                  OR @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = 0
              )
              AND
              (
                  A.FK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER
                  OR @P_FK_BUD_MTR_PURCHASE_ORDER = 0
              )
              AND A.ACTIVE = 1;
    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        RAISERROR(@ERROR_MESSAGE, 15, 17);
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE;
        RETURN 1;
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
DROP Procedure IF Exists PA_MAN_BUD_MTR_PURCHASE_ORDER_PRODUCT_SAVE
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_PURCHASE_ORDER_PRODUCT_SAVE]
(
    @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT BIGINT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_PURCHASE_ORDER BIGINT = 0,
    @P_FK_BUD_MTR_PRODUCT INT = 0,
    @P_QTY INT = 0,
    @P_AMOUNT DECIMAL(18, 6) = 0,
    @P_SUBTOTAL DECIMAL(18, 6) = 0,
    @P_ACTIVE BIT = 0,
    @P_TAX_AMOUNT DECIMAL(18, 6) = 0,
    @P_TAX_AMOUNT_PERCENTAGE DECIMAL(18, 2) = 0,
    @P_DESCRIPTION VARCHAR(500) = ''
	
	
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_MAN_BUD_MTR_PURCHASE_ORDER_PRODUCT_SAVE
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_MAN_BUD_MTR_PURCHASE_ORDER_PRODUCT_SAVE]
@P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    =''
,@P_FK_BUD_MTR_PURCHASE_ORDER    =0
,@P_FK_BUD_MTR_PRODUCT    =0
,@P_QTY    =0
,@P_AMOUNT    =0.00
,@P_SUBTOTAL    =0.00
,@P_ACTIVE    =0

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    12/17/2019 3:16:46 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
        DECLARE @TOTAL_AMOUNT DECIMAL(18, 2) = 0;
        DECLARE @TOTAL_COIN DECIMAL(18, 2) = 0;
        DECLARE @TOTAL_GENERAL DECIMAL(18, 2) = 0;
        DECLARE @TOTAL_TAX_AMOUNT DECIMAL(18, 2) = 0;
        DECLARE @TOTAL_BUDGET DECIMAL(18, 2) = 0;
        DECLARE @V_PRINCIPAL_COIN INT = 0;
        DECLARE @V_COIN_PURCHASE_ORDER INT = 0;
        DECLARE @V_AMOUNT_TYPE_CHANGE DECIMAL(18, 6);
		
        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        SELECT @V_PRINCIPAL_COIN = PK_BUD_MTR_COIN
        FROM dbo.BUD_MTR_COIN
        WHERE PRINCIPAL = 1;

        SELECT @V_COIN_PURCHASE_ORDER = FK_BUD_MTR_COIN
        FROM dbo.BUD_MTR_PURCHASE_ORDER
        WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER;

        SELECT @V_AMOUNT_TYPE_CHANGE = AMOUNT_TYPE_CHANGE
        FROM dbo.GLB_MTR_CURRENCY_CONVERT
        WHERE CONSULT_DATE = CONVERT(DATE, GETDATE())
              AND FK_BUD_MTR_COIN = @V_COIN_PURCHASE_ORDER;
        -----------------------------
		    --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT, 0)) + '@P_CREATION_DATE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_DATE, '1900-01-01')) + '@P_CREATION_USER    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, '')) + '@P_MODIFICATION_DATE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_DATE, '1900-01-01')) + '@P_MODIFICATION_USER    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, '')) + '@P_FK_BUD_MTR_PURCHASE_ORDER    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_PURCHASE_ORDER, 0)) + '@P_FK_BUD_MTR_PRODUCT    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_PRODUCT, 0)) + '@P_QTY    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_QTY, 0)) + '@P_AMOUNT    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_AMOUNT, 0.00)) + '@P_SUBTOTAL    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_SUBTOTAL, 0.00)) + '@P_ACTIVE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_ACTIVE, 0)) + '@P_TAX_AMOUNT    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_TAX_AMOUNT, 0)) + '@P_TAX_AMOUNT_PERCENTAGE    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_TAX_AMOUNT_PERCENTAGE, 0)) + '@P_DESCRIPTION    = '
              + CONVERT(VARCHAR(MAX), ISNULL(@P_DESCRIPTION, 0));


        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF EXISTS
        (
            SELECT 1
            FROM BUD_MTR_PURCHASE_ORDER_PRODUCT WITH (NOLOCK)
            WHERE PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT and FK_BUD_MTR_PRODUCT = @P_FK_BUD_MTR_PRODUCT
        )
        BEGIN

            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.QTY = @P_QTY,
                A.AMOUNT = @P_AMOUNT,
                A.SUBTOTAL = @P_SUBTOTAL,
                A.ACTIVE = @P_ACTIVE,
                A.TAX_AMOUNT = @P_TAX_AMOUNT,
                A.TAX_AMOUNT_PERCENTAGE = @P_TAX_AMOUNT_PERCENTAGE,
                A.DESCRIPTION_PRODUCT = @P_DESCRIPTION
			 FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
            WHERE A.PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT and FK_BUD_MTR_PRODUCT = @P_FK_BUD_MTR_PRODUCT;

        END;
        ELSE
        BEGIN
            INSERT INTO BUD_MTR_PURCHASE_ORDER_PRODUCT
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_MTR_PURCHASE_ORDER,
                FK_BUD_MTR_PRODUCT,
                QTY,
                AMOUNT,
                TAX_AMOUNT,
                SUBTOTAL,
                ACTIVE,
                TAX_AMOUNT_PERCENTAGE,
                DESCRIPTION_PRODUCT
            )
            VALUES
            (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER, @P_FK_BUD_MTR_PURCHASE_ORDER, @P_FK_BUD_MTR_PRODUCT, @P_QTY,
             @P_AMOUNT, @P_TAX_AMOUNT, @P_SUBTOTAL, @P_ACTIVE, @P_TAX_AMOUNT_PERCENTAGE, @P_DESCRIPTION);

            SELECT @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = SCOPE_IDENTITY();
        END;


		SELECT @TOTAL_AMOUNT = SUM(SUBTOTAL),
               @TOTAL_TAX_AMOUNT = SUM(TAX_AMOUNT)
        FROM dbo.BUD_MTR_PURCHASE_ORDER_PRODUCT
        WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER
              AND ACTIVE = 1;


        IF (@V_PRINCIPAL_COIN <> @V_COIN_PURCHASE_ORDER)
        BEGIN

            SELECT @TOTAL_COIN = (@TOTAL_AMOUNT + @TOTAL_TAX_AMOUNT),
                   @TOTAL_BUDGET = CASE
                                       WHEN C.DIVIDED = 1 THEN
                   (@TOTAL_AMOUNT / A.AMOUNT_TYPE_CHANGE)
                                       ELSE
                   (@TOTAL_AMOUNT * A.AMOUNT_TYPE_CHANGE)
                                   END,
                   @TOTAL_GENERAL = CASE
                                        WHEN C.DIVIDED = 1 THEN
                   ((@TOTAL_AMOUNT + @TOTAL_TAX_AMOUNT) / A.AMOUNT_TYPE_CHANGE)
                                        ELSE
                   ((@TOTAL_AMOUNT + @TOTAL_TAX_AMOUNT) * A.AMOUNT_TYPE_CHANGE)
                                    END
            FROM dbo.GLB_MTR_CURRENCY_CONVERT A
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER B
                    ON A.FK_BUD_MTR_COIN = B.FK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_COIN C
                    ON C.PK_BUD_MTR_COIN = A.FK_BUD_MTR_COIN
            WHERE A.CONSULT_DATE = CONVERT(DATE, GETDATE())
                  AND B.PK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER;


        END;
        ELSE
        BEGIN
            SELECT @TOTAL_COIN = (@TOTAL_AMOUNT + @TOTAL_TAX_AMOUNT),
                   @TOTAL_BUDGET = @TOTAL_AMOUNT,
                   @TOTAL_GENERAL = (@TOTAL_AMOUNT + @TOTAL_TAX_AMOUNT);
        --FROM dbo.BUD_MTR_PURCHASE_ORDER B
        --WHERE B.PK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER;
        END;

        -- RQ CUENTAS PREOPERATIVAS
        UPDATE A
        SET SUBTOTAL_DOLLARIZED = IIF(@V_PRINCIPAL_COIN = @V_COIN_PURCHASE_ORDER,
                                      A.SUBTOTAL,
                                      CASE
                                          WHEN C.DIVIDED = 1 THEN
                                      (A.SUBTOTAL / @V_AMOUNT_TYPE_CHANGE)
                                          ELSE
                                      (A.SUBTOTAL * @V_AMOUNT_TYPE_CHANGE)
                                      END),
            TAX_AMOUNT_DOLLARIZED = IIF(@V_PRINCIPAL_COIN = @V_COIN_PURCHASE_ORDER,
                                        A.TAX_AMOUNT,
                                        CASE
                                            WHEN C.DIVIDED = 1 THEN
                                                A.TAX_AMOUNT / @V_AMOUNT_TYPE_CHANGE
                                            ELSE
                                                A.TAX_AMOUNT * @V_AMOUNT_TYPE_CHANGE
                                        END)
        FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A WITH (NOLOCK)
            INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER B WITH (NOLOCK)
                ON B.PK_BUD_MTR_PURCHASE_ORDER = A.FK_BUD_MTR_PURCHASE_ORDER
            INNER JOIN dbo.BUD_MTR_COIN C WITH (NOLOCK)
                ON C.PK_BUD_MTR_COIN = B.FK_BUD_MTR_COIN
        WHERE A.PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT;


        SELECT @TOTAL_AMOUNT = SUM(SUBTOTAL),
               @TOTAL_TAX_AMOUNT = SUM(TAX_AMOUNT)
        FROM dbo.BUD_MTR_PURCHASE_ORDER_PRODUCT
        WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER
              AND ACTIVE = 1;


        UPDATE dbo.BUD_MTR_PURCHASE_ORDER
        SET MODIFICATION_DATE = GETDATE(),
            MODIFICATION_USER = @P_MODIFICATION_USER,
            TOTAL_COIN = @TOTAL_COIN,
            TOTAL_GENERAL = @TOTAL_GENERAL,
            TAX_AMOUNT = @TOTAL_TAX_AMOUNT,
            SUBTOTAL = @TOTAL_AMOUNT,
            TOTAL_BUDGET = @TOTAL_BUDGET
        WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_FK_BUD_MTR_PURCHASE_ORDER;


			DECLARE @COUNTPENDING INT , @COUNTAPPROVE INT 

			SELECT @COUNTPENDING= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (2,3) AND A.ACTIVE=1;

			SELECT @COUNTAPPROVE=COUNT(*)  FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				INNER JOIN BUD_MTR_PURCHASE_ORDER C ON A.FK_BUD_MTR_PURCHASE_ORDER=C.PK_BUD_MTR_PURCHASE_ORDER
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_FK_BUD_MTR_PURCHASE_ORDER  AND  B.FK_STATUS not in (2,3) and C.FK_GBL_CAT_CATALOG_STATUS=188 AND A.ACTIVE=1

				IF  ( @COUNTPENDING=0 AND @COUNTAPPROVE>=1 )
				BEGIN
					Update BUD_MTR_PURCHASE_ORDER set 
						FK_GBL_CAT_CATALOG_STATUS=112--@V_PK_GBL_CATALOG_STATUS_SAVE
					WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
					
				END;

				--IF  (@COUNTPENDING>=1)
				--BEGIN
				--	Update BUD_MTR_PURCHASE_ORDER set 
				--		   FK_GBL_CAT_CATALOG_STATUS=188--@V_PK_GBL_CATALOG_STATUS_BORRADOR
				--WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
				--END;

        SELECT OP.*  ,P.NAME AS Code_Product,
               @TOTAL_COIN AS TOTAL_COIN,
               @TOTAL_GENERAL AS TOTAL_GENERAL,
               @TOTAL_TAX_AMOUNT AS TOTAL_TAX_AMOUNT,
               @TOTAL_AMOUNT AS SUBTOTAL_PURCHASE_ORDER
        FROM BUD_MTR_PURCHASE_ORDER_PRODUCT OP
		INNER JOIN BUD_MTR_PRODUCT P ON OP.FK_BUD_MTR_PRODUCT=P.PK_BUD_MTR_PRODUCT
        WHERE PK_BUD_MTR_PURCHASE_ORDER_PRODUCT = @P_PK_BUD_MTR_PURCHASE_ORDER_PRODUCT;


    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;
GO
---Bud_Mtr_Purchase_Order ANYU
DROP Procedure IF Exists [dbo].[PA_CON_BUD_MTR_PURCHASE_ORDER_GET]
GO
CREATE PROCEDURE [dbo].[PA_CON_BUD_MTR_PURCHASE_ORDER_GET]
(
    @P_PK_BUD_MTR_PURCHASE_ORDER BIGINT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_SUPPLIER INT = 0,
    @P_FK_BUD_MTR_COIN INT = 0,
    @P_FK_GBL_CAT_CATALOG_TYPE INT = 0,
    @P_FK_GBL_CAT_CATALOG_STATUS INT = 0,
    @P_TAX_AMOUNT DECIMAL = 0.00,
    @P_TOTAL_COIN DECIMAL = 0.00,
    @P_TOTAL_GENERAL DECIMAL = 0.00,
    @P_REQUIRE_BUDGET BIT = 0,
    @P_START_DATE DATETIME = '1900-01-01',
    @P_END_DATE DATETIME = '1900-01-01',
    @P_SEARCH_KEY_CATALOG_STATUS VARCHAR(256) = '',
    @P_FK_USER_ASSIGNED INT = 0,
    @P_ESTIMATED_DATE DATETIME = '1900-01-01',
    @P_FK_BUD_MTR_STORE INT = 0,
    @P_DATE_APPLIES DATETIME = '1900-01-01',
    @P_FK_CREATION_USER BIGINT = 0
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_CON_BUD_MTR_PURCHASE_ORDER_GET
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_CON_BUD_MTR_PURCHASE_ORDER_GET]
@P_PK_BUD_MTR_PURCHASE_ORDER    ='0'
,@P_CREATION_DATE    =''1900-01-01''
,@P_CREATION_USER    =''''
,@P_MODIFICATION_DATE    =''1900-01-01''
,@P_MODIFICATION_USER    =''''
,@P_FK_BUD_MTR_SUPPLIER    ='0'
,@P_FK_BUD_MTR_COIN    ='0'
,@P_FK_GBL_CAT_CATALOG_TYPE    ='0'
,@P_FK_GBL_CAT_CATALOG_STATUS    ='0'
,@P_TAX_AMOUNT    ='0.00'
,@P_TOTAL_COIN    ='0.00'
,@P_TOTAL_GENERAL    ='0.00'
,@P_REQUIRE_BUDGET    ='0'
,@P_START_DATE    =''1900-01-01''
,@P_END_DATE    =''1900-01-01''

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    12/17/2019 3:15:23 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES

        DECLARE @V_SEARCH_KEY_SAVE VARCHAR(100) = 'purchase_save';
        DECLARE @V_SEARCH_KEY_SEND VARCHAR(100) = 'purchase_send';
        DECLARE @V_SEARCH_KEY_APROVE VARCHAR(100) = 'purchase_approve';
        DECLARE @V_SEARCH_KEY_PAYMENT VARCHAR(100) = 'purchase_payment';
        DECLARE @V_SEARCH_KEY_REJECTED VARCHAR(100) = 'purchase_rejected';
        DECLARE @V_SEARCH_KEY_CANCEL VARCHAR(100) = 'purchase_canceled';
        DECLARE @V_SEARCH_KEY_SEND_INVOICE VARCHAR(100) = 'purchase_send_invoice';
        DECLARE @V_SEARCH_KEY_FINALIZED VARCHAR(100) = 'purchase_finalized';
        DECLARE @V_SEARCH_KEY_INVOICE VARCHAR(100) = 'purchase_invoice';
        DECLARE @V_ALL_PURCHASE_ORDER VARCHAR(100) = 'all';
        DECLARE @V_ALL_PURCHASE_ORDER_REPORT VARCHAR(100) = 'purchase_order_report';
        DECLARE @C_ALL_PURCHASE_WITH_INVOICE_REPORT VARCHAR(100) = 'purchase_order_with_invoice_report';
        DECLARE @V_PURCHASE_ORDER_WITH_INVOICE VARCHAR(100) = 'with_invoice';
        DECLARE @V_PURCHASE_ORDER_WITH_NOT_INVOICE VARCHAR(100) = 'with_not_invoice';
        DECLARE @V_SEARCH_KEY_PURCHASE_ORDER_PENDING_APPROVAL VARCHAR(100) = 'purchase_pending_approval';
        DECLARE @V_SEARCH_KEY_PURCHASE_ORDER_PENDING_APPROVAL_MONEY VARCHAR(100) = 'purchase_pending_approval_money';
        DECLARE @V_SEARCH_KEY_PURCHASE_ORDER_ALL_APPROVAL VARCHAR(100) = 'purchase_approval';
        DECLARE @V_SEARCH_KEY_DOCUMENT_TYPE VARCHAR(50) = 'type_document';
        DECLARE @V_SEARCH_KEY_DOCUMENT_TYPE_INVOICE VARCHAR(50) = 'invoice';
        DECLARE @V_MY_APPROVE_ORDERS VARCHAR(100) = 'my_approve_orders';
        DECLARE @V_SUMARY_PAYMENT_AMOUNT DECIMAL(18, 6) = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_CANCEL INT = 0;
        DECLARE @V_FK_GLB_CAT_CATALOG INT = 0;
        DECLARE @C_SEARCH_KEY_TYPE_CATALOG_BALANCE_ACCOUNT VARCHAR(100) = 'account_type';
		DECLARE	@V_SEARCH_KEY_GBL_CATALOG_BORRADOR VARCHAR(100) = 'purchase_borrador';
		DECLARE	@V_PK_GBL_CATALOG_STATUS_BORRADOR INT = 0;
        --DECLARE @C_SEARCH_KEY_CATALOG_BALANCE_ACCOUNT VARCHAR(100) = 'balance_account';

        DECLARE @C_SEARCH_KEY_CATALOG_BALANCE_ACCOUNT VARCHAR(100) = 'preoperative_account';

        DECLARE @V_STORES VARCHAR(MAX) = '';
        DECLARE @V_PRODUCTS VARCHAR(MAX) = '';

        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SAVE INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_APPROVE INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PAYMENT INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_REJECTED INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND_INVOICE INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_INVOICE INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL_MONEY INT = 0;
        DECLARE @V_FK_BUD_MTR_CAT_CATALOG_STATUS_FINALIZED INT = 0;
        DECLARE @V_FK_KEY_DOCUMENT_TYPE INT = 0;
        DECLARE @V_FK_KEY_DOCUMENT_TYPE_INVOICE INT = 0;
        DECLARE @V_POLITICAL_DAYS INT = 0;
        DECLARE @C_SEARCH_KEY_PARAMETER_POLITICAL_DAYS VARCHAR(256) = 'POLITICAL_DAYS';
        DECLARE @C_SEARCH_KEY_PARAMETER_DAYS_TO_CANCEL VARCHAR(100) = 'DAYS_TO_CANCEL';
        DECLARE @V_DAYS_TO_CANCEL INT = 0;
        DECLARE @C_PREOPERATIVE_PURCHASE_ORDER VARCHAR(100) = 'preoperative_purchase_order';

        DECLARE @T_PURCHASE_ORDER TABLE
        (
            PK_BUD_MTR_PURCHASE_ORDER INT,
            REFERENCE_NUMBER VARCHAR(100),
            REFERENCE_SUPPLIER VARCHAR(100),
            START_DATE DATETIME,
            COMPANY VARCHAR(100),
            COMMERCIAL_NAME VARCHAR(100),
            CREATION_USER VARCHAR(100),
            ACCOUNT_NAME VARCHAR(100),
            VALUE_STATUS VARCHAR(100),
            CODE VARCHAR(100),
            TOTAL_GENERAL DECIMAL(18, 2),
            TOTAL_COIN DECIMAL(18, 2),
            STORE VARCHAR(MAX),
            PRODUCT VARCHAR(MAX),
            COMMENT NVARCHAR(MAX),
            PROCESS BIT
                DEFAULT 0,
            INVOICE_NUMBER VARCHAR(500)
                DEFAULT ''
        );

        DECLARE @T_STORE TABLE
        (
            NAME VARCHAR(MAX)
        );

        DECLARE @T_PRODUCT TABLE
        (
            NAME VARCHAR(MAX)
        );



        -----------------------------
        --CONSTANTES
        --ASIGNACION
				 
		SELECT @V_PK_GBL_CATALOG_STATUS_BORRADOR = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_GBL_CATALOG_BORRADOR;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SAVE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_SAVE;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_SEND;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_APPROVE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_APROVE;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PAYMENT = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_PAYMENT;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_REJECTED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_REJECTED;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND_INVOICE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_SEND_INVOICE;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_FINALIZED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_FINALIZED;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_PURCHASE_ORDER_PENDING_APPROVAL;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL_MONEY = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_PURCHASE_ORDER_PENDING_APPROVAL_MONEY;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_INVOICE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_INVOICE;

        SELECT @V_FK_KEY_DOCUMENT_TYPE = PK_GLB_CAT_TYPE_CATALOG
        FROM dbo.GLB_CAT_TYPE_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_DOCUMENT_TYPE;

        SELECT @V_FK_KEY_DOCUMENT_TYPE_INVOICE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE FK_GBL_CAT_TYPE_CATALOG = @V_FK_KEY_DOCUMENT_TYPE
              AND SEARCH_KEY = @V_SEARCH_KEY_DOCUMENT_TYPE_INVOICE;

        SELECT @V_POLITICAL_DAYS = CONVERT(INT, A.VALUE)
        FROM dbo.GLB_PAR_PARAMETER A WITH (NOLOCK)
        WHERE A.SEARCH_KEY = @C_SEARCH_KEY_PARAMETER_POLITICAL_DAYS;

        SELECT @V_DAYS_TO_CANCEL = CONVERT(INT, A.VALUE)
        FROM dbo.GLB_PAR_PARAMETER A WITH (NOLOCK)
        WHERE A.SEARCH_KEY = @C_SEARCH_KEY_PARAMETER_DAYS_TO_CANCEL;

        SELECT @V_FK_GLB_CAT_CATALOG = A.PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG A WITH (NOLOCK)
            INNER JOIN dbo.GLB_CAT_TYPE_CATALOG B WITH (NOLOCK)
                ON B.PK_GLB_CAT_TYPE_CATALOG = A.FK_GBL_CAT_TYPE_CATALOG
        WHERE A.SEARCH_KEY = @C_SEARCH_KEY_CATALOG_BALANCE_ACCOUNT
              AND B.SEARCH_KEY = @C_SEARCH_KEY_TYPE_CATALOG_BALANCE_ACCOUNT;

        SELECT @V_FK_BUD_MTR_CAT_CATALOG_STATUS_CANCEL = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CANCEL;
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_PURCHASE_ORDER    = ' + CONVERT(VARCHAR, ISNULL(@P_PK_BUD_MTR_PURCHASE_ORDER, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR, ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR, ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR, ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_MTR_SUPPLIER    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_SUPPLIER, 0))
              + '@P_FK_BUD_MTR_COIN    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_BUD_MTR_COIN, 0))
              + '@P_FK_GBL_CAT_CATALOG_TYPE    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_GBL_CAT_CATALOG_TYPE, 0))
              + '@P_FK_GBL_CAT_CATALOG_STATUS    = ' + CONVERT(VARCHAR, ISNULL(@P_FK_GBL_CAT_CATALOG_STATUS, 0))
              + '@P_TAX_AMOUNT    = ' + CONVERT(VARCHAR, ISNULL(@P_TAX_AMOUNT, 0.00)) + '@P_TOTAL_COIN    = '
              + CONVERT(VARCHAR, ISNULL(@P_TOTAL_COIN, 0.00)) + '@P_TOTAL_GENERAL    = '
              + CONVERT(VARCHAR, ISNULL(@P_TOTAL_GENERAL, 0.00)) + '@P_REQUIRE_BUDGET    = '
              + CONVERT(VARCHAR, ISNULL(@P_REQUIRE_BUDGET, 0)) + '@P_START_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_START_DATE, '1900-01-01')) + '@P_END_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_END_DATE, '1900-01-01')) + '@P_FK_USER_ASSIGNED    = '
              + CONVERT(VARCHAR, ISNULL(@P_FK_USER_ASSIGNED, '1900-01-01')) + '@P_ESTIMATED_DATE    = '
              + CONVERT(VARCHAR, ISNULL(@P_ESTIMATED_DATE, '1900-01-01')) + '@P_DATE_APPLIES   ='
              + CONVERT(VARCHAR(MAX), ISNULL(@P_DATE_APPLIES, ''));

        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO
        IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_SAVE)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, ''),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, ''),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = CASE
                                            WHEN D.VALUE = 'En aprobación de presupuesto' THEN
                                                'Supervisor de presupuesto'
                                            ELSE
                                                A.USER_NAME_ASSIGNED
                                        END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   ACCOUNT_NAME = CASE
                                      WHEN F.NAME IS NULL THEN
                                          ISNULL(E.NAME, '')
                                      ELSE
                                          F.NAME + ' - ' + E.NAME
                                  END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                LEFT JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                -- REQUERIMIENTO DE SEGUIDORES
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                -- REQUERIMIENTO DE SEGUIDORES
                LEFT JOIN dbo.BUD_MTR_ACCOUNT F
                    ON E.FK_BUD_MTR_ACCOUNT = F.PK_BUD_MTR_ACCOUNT
            WHERE A.FK_GBL_CAT_CATALOG_STATUS IN( @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SAVE)
            ORDER BY A.PK_BUD_MTR_PURCHASE_ORDER DESC;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_SEND)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
				   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   ACCOUNT_NAME = CASE
                                      WHEN F.NAME IS NULL THEN
                                          ISNULL(E.NAME, '')
                                      ELSE
                                          F.NAME + ' - ' + E.NAME
                                  END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y 
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                LEFT JOIN dbo.BUD_MTR_ACCOUNT F
                    ON E.FK_BUD_MTR_ACCOUNT = F.PK_BUD_MTR_ACCOUNT
            WHERE A.FK_GBL_CAT_CATALOG_STATUS IN ( @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND,
                                                   @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL_MONEY
                                                 )
                  AND A.FK_USER_ASSIGNED = @P_FK_USER_ASSIGNED
            ORDER BY A.PK_BUD_MTR_PURCHASE_ORDER DESC;


        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_PURCHASE_ORDER_ALL_APPROVAL)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   --USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   ACCOUNT_NAME = CASE
                                      WHEN F.NAME IS NULL THEN
                                          ISNULL(E.NAME, '')
                                      ELSE
                                          F.NAME + ' - ' + E.NAME
                                  END,
                   USER_NAME_ASSIGNED = CASE
                                            WHEN D.VALUE = 'En aprobación de presupuesto' THEN
                                                'Supervisor de presupuesto'
                                            --( SELECT M.USER_NAME 
                                            --FROM dbo.BUD_MTR_PURCHASE_ORDER_HIERARCHY M 
                                            --WHERE M.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED AND M.FK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                                            --	AND M.FK_BUD_MTR_STORE = )
                                            ELSE
                                                A.USER_NAME_ASSIGNED
                                        END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                -- REQUERIMIENTO DE SEGUIDORES
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                -- REQUERIMIENTO DE SEGUIDORES

                LEFT JOIN dbo.BUD_MTR_ACCOUNT F
                    ON E.FK_BUD_MTR_ACCOUNT = F.PK_BUD_MTR_ACCOUNT
            WHERE A.FK_GBL_CAT_CATALOG_STATUS IN ( @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL,
                                                   @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL_MONEY,
                                                   @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND
                                                 )
            ORDER BY A.PK_BUD_MTR_PURCHASE_ORDER DESC;


        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_PURCHASE_ORDER_PENDING_APPROVAL)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   ACCOUNT_NAME = CASE
                                      WHEN F.NAME IS NULL THEN
                                          ISNULL(E.NAME, '')
                                      ELSE
                                          F.NAME + ' - ' + E.NAME
                                  END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                LEFT JOIN dbo.BUD_MTR_ACCOUNT F
                    ON E.FK_BUD_MTR_ACCOUNT = F.PK_BUD_MTR_ACCOUNT
            WHERE A.FK_GBL_CAT_CATALOG_STATUS IN ( @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PENDING_APPROVAL)
            ORDER BY A.PK_BUD_MTR_PURCHASE_ORDER DESC;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_APROVE)
        BEGIN
            SELECT DISTINCT
                   A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   INVOICE = 0,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   COMPANY = H.NAME,
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   -- USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   USER_NAME_ASSIGNED = CASE
                                            WHEN D.VALUE = 'En aprobación de presupuesto' THEN
                                                'Supervisor de presupuesto'
                                            --( SELECT M.USER_NAME 
                                            --FROM dbo.BUD_MTR_PURCHASE_ORDER_HIERARCHY M 
                                            --WHERE M.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED AND M.FK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                                            --	AND M.FK_BUD_MTR_STORE = )
                                            ELSE
                                                A.USER_NAME_ASSIGNED
                                        END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   ACCOUNT_NAME = CASE
                                      WHEN F.NAME IS NULL THEN
                                          ISNULL(E.NAME, '')
                                      ELSE
                                          F.NAME + ' - ' + E.NAME
                                  END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                INNER JOIN dbo.BUD_MTR_ACCOUNT F
                    ON E.FK_BUD_MTR_ACCOUNT = F.PK_BUD_MTR_ACCOUNT
                -- REQUERIMIENTO DE SEGUIDORES
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND Z.FK_SEG_MTR_USER = A.FK_CREATION_USER
            -- REQUERIMIENTO DE SEGUIDORES

            WHERE (
                      Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                      OR @P_FK_USER_ASSIGNED = 0
                  )
                  AND (A.FK_GBL_CAT_CATALOG_STATUS IN ( @V_FK_BUD_MTR_CAT_CATALOG_STATUS_APPROVE,
                                                        @V_FK_BUD_MTR_CAT_CATALOG_STATUS_PAYMENT,
                                                        @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND_INVOICE,
                                                        @V_FK_BUD_MTR_CAT_CATALOG_STATUS_FINALIZED
                                                      )
                      )
            ORDER BY 1 DESC;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_REJECTED)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   ACCOUNT_NAME = ISNULL(E.NAME, ''),
                   --USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, '')
                   USER_NAME_ASSIGNED = CASE
                                            WHEN D.VALUE = 'En aprobación de presupuesto' THEN
                                                'Supervisor de presupuesto'
                                            --( SELECT M.USER_NAME 
                                            --FROM dbo.BUD_MTR_PURCHASE_ORDER_HIERARCHY M 
                                            --WHERE M.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED AND M.FK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                                            --	AND M.FK_BUD_MTR_STORE = )
                                            ELSE
                                                A.USER_NAME_ASSIGNED
                                        END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                -- REQUERIMIENTO DE SEGUIDORES
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                -- REQUERIMIENTO DE SEGUIDORES

                LEFT JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
            WHERE (A.FK_GBL_CAT_CATALOG_STATUS = @V_FK_BUD_MTR_CAT_CATALOG_STATUS_REJECTED)
                  AND CONVERT(DATE, A.REJECTED_DATE) > CONVERT(DATE, DATEADD(DAY, -@V_DAYS_TO_CANCEL, GETDATE()))
            ORDER BY PK_BUD_MTR_PURCHASE_ORDER DESC;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_PURCHASE_ORDER_WITH_INVOICE)
        BEGIN
            SELECT DISTINCT
                   A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = CASE
                                      WHEN ISNULL(A.TOTAL_GENERAL, 0) - ISNULL(K.AMOUNT, 0) <= 0 THEN
                                          'Enviar a revisión'
                                      ELSE
                                          ISNULL(D.VALUE, '')
                                  END,
                   STYLE = ISNULL(D.STYLE, ''),
                   1 AS INVOICE,
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   TOTAL_INVOICE = ISNULL(A.TOTAL_GENERAL, 0) - ISNULL(K.AMOUNT, 0),
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_INVOICE F WITH (NOLOCK)
                    ON F.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.GLB_MTR_DOCUMENT E
                    ON F.PK_BUD_MTR_PURCHASE_ORDER_INVOICE = E.FK_MAIN
                       AND E.FK_GBL_CAT_CATALOG_TABLE = @V_FK_KEY_DOCUMENT_TYPE_INVOICE
                       AND E.ACTIVE = 1
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN
                (
                    SELECT J.FK_BUD_MTR_PURCHASE_ORDER,
                           SUM(J.AMOUNT) AS AMOUNT
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE J
                    GROUP BY J.FK_BUD_MTR_PURCHASE_ORDER
                ) K
                    ON K.FK_BUD_MTR_PURCHASE_ORDER = H.FK_BUD_MTR_PURCHASE_ORDER
                -- REQUERIMIENTO DE SEGUIDORES
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z WITH (NOLOCK)
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
            -- REQUERIMIENTO DE SEGUIDORES
            WHERE Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                  AND A.FK_GBL_CAT_CATALOG_STATUS IN (@V_FK_BUD_MTR_CAT_CATALOG_STATUS_INVOICE)
            ORDER BY PK_BUD_MTR_PURCHASE_ORDER DESC;
        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_PURCHASE_ORDER_WITH_NOT_INVOICE)
        BEGIN
            SELECT DISTINCT
                   A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   0 AS INVOICE,
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   TOTAL_INVOICE = ISNULL(A.TOTAL_GENERAL, 0) - ISNULL(K.AMOUNT, 0),
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z WITH (NOLOCK)
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                LEFT JOIN
                (
                    SELECT V.FK_BUD_MTR_PURCHASE_ORDER,
                           COUNT(1) AS INVOICE
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE V WITH (NOLOCK)
                        INNER JOIN dbo.GLB_MTR_DOCUMENT W WITH (NOLOCK)
                            ON W.FK_MAIN = V.PK_BUD_MTR_PURCHASE_ORDER_INVOICE
                               AND W.ACTIVE = 1
                               AND W.FK_GBL_CAT_CATALOG_TABLE = @V_FK_KEY_DOCUMENT_TYPE_INVOICE
                    GROUP BY V.FK_BUD_MTR_PURCHASE_ORDER
                ) I
                    ON I.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                LEFT JOIN
                (
                    SELECT J.FK_BUD_MTR_PURCHASE_ORDER,
                           SUM(J.AMOUNT) AS AMOUNT
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE J
                    GROUP BY J.FK_BUD_MTR_PURCHASE_ORDER
                ) K
                    ON K.FK_BUD_MTR_PURCHASE_ORDER = H.FK_BUD_MTR_PURCHASE_ORDER
            WHERE A.FK_GBL_CAT_CATALOG_STATUS = @V_FK_BUD_MTR_CAT_CATALOG_STATUS_INVOICE
                  AND I.FK_BUD_MTR_PURCHASE_ORDER IS NULL
            ORDER BY PK_BUD_MTR_PURCHASE_ORDER DESC;
        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_ALL_PURCHASE_ORDER)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   --USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   AMORTIZATION = ISNULL(A.AMORTIZATION, 0),
                   ACCOUNT_NAME = ISNULL(E.NAME, ''),
                   USER_NAME_ASSIGNED = CASE
                                            WHEN D.VALUE = 'En aprobación de presupuesto' THEN
                                                'Supervisor de presupuesto'
                                            --( SELECT M.USER_NAME 
                                            --FROM dbo.BUD_MTR_PURCHASE_ORDER_HIERARCHY M 
                                            --WHERE M.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED AND M.FK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                                            --	AND M.FK_BUD_MTR_STORE = )
                                            ELSE
                                                A.USER_NAME_ASSIGNED
                                        END,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                -- REQUERIMIENTO DE SEGUIDORES
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                      AND Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                -- REQUERIMIENTO DE SEGUIDORES
                LEFT JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
            WHERE (
                      CONVERT(DATE, A.REJECTED_DATE) > CONVERT(DATE, DATEADD(DAY, -@V_DAYS_TO_CANCEL, GETDATE()))
                      OR A.REJECTED_DATE IS NULL
                  )
            ORDER BY A.PK_BUD_MTR_PURCHASE_ORDER DESC;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_SEND_INVOICE)
        BEGIN
            SELECT A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, ''),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, ''),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   ACCOUNT_NAME = ISNULL(E.NAME, ''),
                   OUTSTANDING_BALANCE = 0.0,
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
            WHERE (
                      A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                      OR @P_PK_BUD_MTR_PURCHASE_ORDER = 0
                  )
                  AND (A.FK_GBL_CAT_CATALOG_STATUS = @V_FK_BUD_MTR_CAT_CATALOG_STATUS_SEND_INVOICE)
            ORDER BY PK_BUD_MTR_PURCHASE_ORDER DESC;
        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_MY_APPROVE_ORDERS)
        BEGIN
            SELECT PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, ''),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, ''),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   COMPANY = H.NAME,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   ACCOUNT_NAME = ISNULL(E.NAME, ''),
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   DATE_APPLIES = ISNULL(A.DATE_APPLIES, '1900-01-01'),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN
                (
                    SELECT FK_BUD_MTR_PURCHASE_ORDER,
                           FK_USER_ACTION
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_ACTION
                    GROUP BY FK_BUD_MTR_PURCHASE_ORDER,
                             FK_USER_ACTION
                ) I
                    ON A.PK_BUD_MTR_PURCHASE_ORDER = I.FK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
            WHERE I.FK_USER_ACTION = @P_FK_USER_ASSIGNED
            ORDER BY A.PK_BUD_MTR_PURCHASE_ORDER DESC;
        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_PAYMENT)
        BEGIN
            SELECT DISTINCT
                   PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   --CREATION_DATE = ISNULL(CONVERT(DATE,A.CREATION_DATE), '1900-01-01'),
                   --CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   --MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   --MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   --FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   FK_CREATION_USER = ISNULL(A.FK_CREATION_USER, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(CONVERT(DATE, A.END_DATE), '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(CONVERT(DATE, A.SEND_DATE), '1900-01-01'),
                   APPROVE_DATE = ISNULL(CONVERT(DATE, A.APPROVE_DATE), '1900-01-01'),
                   CODE = ISNULL(F.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(E.COMMERCIAL_NAME, ''),
                   SYMBOL = '$', --ISNULL(F.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(I.VALUE, ''),
                   STYLE = ISNULL(I.STYLE, ''),
                   INVOICE = CASE
                                 WHEN G.INVOICE > 0 THEN
                                     1
                                 ELSE
                                     0
                             END,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   COMPANY = H.NAME,
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(E.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(E.PRINCIPAL_PHONE, ' / ', E.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   TOTAL_PAYMENT = ISNULL(B.AMOUNT, 0),
                   REGISTRATION_DATE = ISNULL(CONVERT(DATE, B.REGISTRATION_DATE), '1990-01-01'),
                   EXPIRATION_DATE = ISNULL(CONVERT(DATE, DATEADD(DAY, B.DAYS, B.REGISTRATION_DATE)), '1990-01-01'),
                   OUTSTANDING_BALANCE = FORMAT(
                                                   (A.TOTAL_GENERAL - (ISNULL(SUM(B.AMOUNT), 0))
                                                    - ISNULL(J.SUMARY_PAYMENT_AMOUNT, 0)
                                                   ),
                                                   'N1'
                                               ),
                   FK_BUD_MTR_PURCHASE_ORDER_INVOICE = ISNULL(B.PK_BUD_MTR_PURCHASE_ORDER_INVOICE, 0),
                   INVOICE_NUMBER = ISNULL(B.INVOICE_NUMBER, ''),
                   ACCOUNT_NAME = ISNULL(K.NAME, ''),
                   AMORTIZATION = ISNULL(A.AMORTIZATION, 0),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_INVOICE B WITH (NOLOCK)
                    ON B.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND B.ACTIVE = 1
                INNER JOIN dbo.BUD_MTR_SUPPLIER E
                    ON E.PK_BUD_MTR_SUPPLIER = A.FK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.BUD_MTR_COIN F
                    ON F.PK_BUD_MTR_COIN = A.FK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_ACCOUNT K
                    ON K.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = B.FK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.GLB_CAT_CATALOG I
                    ON A.FK_GBL_CAT_CATALOG_STATUS = I.PK_GLB_CAT_CATALOG
                LEFT JOIN
                (
                    SELECT EE.FK_BUD_MTR_PURCHASE_ORDER,
                           ISNULL(SUM(EE.AMOUNT), 0) AS SUMARY_PAYMENT_AMOUNT
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE EE
                    WHERE EE.PAYMENT = 1
                    GROUP BY EE.FK_BUD_MTR_PURCHASE_ORDER
                ) J
                    ON J.FK_BUD_MTR_PURCHASE_ORDER = B.FK_BUD_MTR_PURCHASE_ORDER
                LEFT JOIN
                (
                    SELECT CC.FK_BUD_MTR_PURCHASE_ORDER,
                           COUNT(1) AS INVOICE
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE CC WITH (NOLOCK)
                        LEFT JOIN dbo.GLB_MTR_DOCUMENT DD WITH (NOLOCK)
                            ON CC.PK_BUD_MTR_PURCHASE_ORDER_INVOICE = DD.FK_MAIN
                    GROUP BY CC.FK_BUD_MTR_PURCHASE_ORDER
                ) G
                    ON G.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
            WHERE CONVERT(DATE,
                          DATEADD(   DAY,
                                     CASE
                                         WHEN B.IMMEDIATE_PAYMENT = 1 THEN
                                             1
                                         ELSE
                                     (B.DAYS + @V_POLITICAL_DAYS)
                                     END,
                                     B.REGISTRATION_DATE
                                 ),
                          103
                         ) <= CONVERT(DATE, @P_ESTIMATED_DATE, 103)
                  --  WHERE CONVERT(DATE, DATEADD(DAY, B.DAYS, B.REGISTRATION_DATE), 103) <= CONVERT(DATE, @P_ESTIMATED_DATE, 103)  ( + @V_POLITICAL_DAYS)
                  AND B.PAYMENT = 0
            GROUP BY A.PK_BUD_MTR_PURCHASE_ORDER,
                     A.REFERENCE_NUMBER,
                     A.REFERENCE_SUPPLIER,
                     E.COMMERCIAL_NAME,
                     F.CODE,
                     B.REGISTRATION_DATE,
                     A.TOTAL_GENERAL,
                     G.INVOICE,
                     FK_BUD_MTR_COIN,
                     FK_GBL_CAT_CATALOG_TYPE,
                     FK_GBL_CAT_CATALOG_STATUS,
                     A.FK_BUD_MTR_ACCOUNT,
                     TAX_AMOUNT,
                     TOTAL_COIN,
                     REQUIRE_BUDGET,
                     START_DATE,
                     END_DATE,
                     I.VALUE,
                     STYLE,
                     INVOICE,
                     SUBTOTAL,
                     NOT_USE_BUDGET,
                     CURRENT_ORDER,
                     ADDRESS_SUPPLIER,
                     SEND_DATE,
                     APPROVE_DATE,
                     USER_NAME_ASSIGNED,
                     SYMBOL,
                     H.NAME,
                     E.PRINCIPAL_PHONE,
                     E.EMAIL_NOTIFICATION,
                     A.TOTAL_GENERAL,
                     J.SUMARY_PAYMENT_AMOUNT,
                     FK_CREATION_USER,
                     B.AMOUNT,
                     B.DAYS,
                     B.PK_BUD_MTR_PURCHASE_ORDER_INVOICE,
                     B.INVOICE_NUMBER,
                     K.NAME,
                     A.AMORTIZATION
            ORDER BY 1 DESC;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_SEARCH_KEY_INVOICE)
        BEGIN
            SELECT DISTINCT
                   A.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = CASE
                                      WHEN ISNULL(A.TOTAL_GENERAL, 0) - ISNULL(K.AMOUNT, 0) <= 0 THEN
                                          'Enviar a revisión'
                                      ELSE
                                          ISNULL(D.VALUE, '')
                                  END,
                   STYLE = ISNULL(D.STYLE, ''),
                   INVOICE = CASE
                                 WHEN I.INVOICE IS NULL THEN
                                     0
                                 ELSE
                                     1
                             END,
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   COMPANY = H.NAME,
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   TOTAL_PAYMENT = 0,
                   TOTAL_INVOICE = ISNULL(A.TOTAL_GENERAL, 0) - ISNULL(K.AMOUNT, 0),
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_FOLLOWERS Z WITH (NOLOCK)
                    ON Z.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                       AND Z.FK_SEG_MTR_USER = @P_FK_USER_ASSIGNED
                LEFT JOIN
                (
                    SELECT J.FK_BUD_MTR_PURCHASE_ORDER,
                           SUM(J.AMOUNT) AS AMOUNT
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE J
                    GROUP BY J.FK_BUD_MTR_PURCHASE_ORDER
                ) K
                    ON K.FK_BUD_MTR_PURCHASE_ORDER = H.FK_BUD_MTR_PURCHASE_ORDER
                LEFT JOIN
                (
                    SELECT V.FK_BUD_MTR_PURCHASE_ORDER,
                           COUNT(1) AS INVOICE
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE V WITH (NOLOCK)
                        INNER JOIN dbo.GLB_MTR_DOCUMENT W WITH (NOLOCK)
                            ON W.FK_MAIN = V.PK_BUD_MTR_PURCHASE_ORDER_INVOICE
                               AND W.ACTIVE = 1
                               AND W.FK_GBL_CAT_CATALOG_TABLE = @V_FK_KEY_DOCUMENT_TYPE_INVOICE
                    GROUP BY V.FK_BUD_MTR_PURCHASE_ORDER
                ) I
                    ON I.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
            WHERE A.FK_GBL_CAT_CATALOG_STATUS = @V_FK_BUD_MTR_CAT_CATALOG_STATUS_INVOICE
            ORDER BY 1 DESC;
        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @V_ALL_PURCHASE_ORDER_REPORT)
        BEGIN

            INSERT INTO @T_PURCHASE_ORDER
            (
                PK_BUD_MTR_PURCHASE_ORDER,
                REFERENCE_NUMBER,
                REFERENCE_SUPPLIER,
                START_DATE,
                COMPANY,
                COMMERCIAL_NAME,
                CREATION_USER,
                ACCOUNT_NAME,
                VALUE_STATUS,
                CODE,
                TOTAL_GENERAL,
                TOTAL_COIN,
                STORE,
                PRODUCT,
                COMMENT,
                PROCESS
            )
            SELECT A.PK_BUD_MTR_PURCHASE_ORDER,                                   -- PK_BUD_MTR_PURCHASE_ORDER
                   ISNULL(A.REFERENCE_NUMBER, ''),                                -- REFERENCE_NUMBER - varchar(100)
                   ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),                              -- REFERENCE_SUPPLIER - varchar(100)
                   ISNULL(A.START_DATE, '1900-01-01'),                            -- START_DATE - datetime
                   ISNULL(H.NAME, ''),                                            -- COMPANY - varchar(100)
                   ISNULL(C.COMMERCIAL_NAME, ''),                                 -- COMMERCIAL_NAME - varchar(100)
                   ISNULL(A.CREATION_USER, ''),                                   -- CREATION_USER - varchar(100)
                   ISNULL(CONCAT(F.NAME, ' - ', E.NAME), ''),                     -- ACCOUNT_NAME - varchar(100)
                   ISNULL(D.VALUE, ''),                                           -- VALUE_STATUS - varchar(100)
                   ISNULL(B.CODE, ''),                                            -- CODE - varchar(100)
                   ISNULL(A.TOTAL_GENERAL, 0),                                    -- TOTAL_GENERAL - decimal(18, 2)
                   ISNULL(A.TOTAL_COIN, 0),                                       -- TOTAL_COIN  -  decimal(18,2)
                   dbo.FNC_GET_STORE_INFORMATION(A.PK_BUD_MTR_PURCHASE_ORDER),    -- STORE - varchar(max)
                   dbo.FNC_GET_PRODUCT_INFORMATION(A.PK_BUD_MTR_PURCHASE_ORDER),  --PRODUCT - VARCHAR(MAX)
                   dbo.FNC_GET_COMMENTS_INFORMATION(A.PK_BUD_MTR_PURCHASE_ORDER), --COMMENT
                   0                                                              -- PROCESS - bit
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                LEFT JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                LEFT JOIN dbo.BUD_MTR_ACCOUNT F WITH (NOLOCK)
                    ON F.PK_BUD_MTR_ACCOUNT = E.FK_BUD_MTR_ACCOUNT
            WHERE --CONVERT(DATE, START_DATE) >= CONVERT(DATE, A.DATE_APPLIES)
                CONVERT(DATE, START_DATE) >= CONVERT(DATE, @P_START_DATE)
                AND
                (
                    CONVERT(DATE, A.END_DATE) <= CONVERT(DATE, @P_END_DATE)
                    OR A.END_DATE IS NULL
                );

            SELECT *
            FROM @T_PURCHASE_ORDER
            ORDER BY START_DATE;

        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @C_PREOPERATIVE_PURCHASE_ORDER)
        BEGIN

            SELECT DESCRIPTION_PRODUCT = D.DESCRIPTION_PRODUCT,
                   SUBTOTAL_DOLLARIZED = ISNULL(D.SUBTOTAL_DOLLARIZED, 0),
                   TAX_AMOUNT_DOLLARIZED = ISNULL(D.TAX_AMOUNT_DOLLARIZED, 0),
                   QUANTITY = ISNULL(D.QTY, 0)
            FROM dbo.BUD_MTR_ACCOUNT A WITH (NOLOCK)
                INNER JOIN dbo.GLB_CAT_CATALOG B WITH (NOLOCK)
                    ON B.PK_GLB_CAT_CATALOG = A.FK_GBL_CAT_CATALOG_ACCOUNT_TYPE
                       AND B.PK_GLB_CAT_CATALOG = @V_FK_GLB_CAT_CATALOG
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER C WITH (NOLOCK)
                    ON C.FK_BUD_MTR_ACCOUNT = A.PK_BUD_MTR_ACCOUNT
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_PRODUCT D WITH (NOLOCK)
                    ON D.FK_BUD_MTR_PURCHASE_ORDER = C.PK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER E WITH (NOLOCK)
                    ON E.FK_BUD_MTR_PURCHASE_ORDER = C.PK_BUD_MTR_PURCHASE_ORDER
            WHERE A.ACTIVE = 1
                  AND B.ACTIVE = 1
                  AND D.ACTIVE = 1
                  AND E.ACTIVE = 1
                  AND E.FK_BUD_MTR_STORE = @P_FK_BUD_MTR_STORE
                  AND C.FK_GBL_CAT_CATALOG_STATUS NOT IN ( @V_FK_BUD_MTR_CAT_CATALOG_STATUS_REJECTED,
                                                           @V_FK_BUD_MTR_CAT_CATALOG_STATUS_CANCEL
                                                         );
        END;
        ELSE IF (@P_SEARCH_KEY_CATALOG_STATUS = @C_ALL_PURCHASE_WITH_INVOICE_REPORT)
        BEGIN


            INSERT INTO @T_PURCHASE_ORDER
            (
                PK_BUD_MTR_PURCHASE_ORDER,
                REFERENCE_NUMBER,
                REFERENCE_SUPPLIER,
                START_DATE,
                COMPANY,
                COMMERCIAL_NAME,
                CREATION_USER,
                ACCOUNT_NAME,
                VALUE_STATUS,
                CODE,
                TOTAL_GENERAL,
                TOTAL_COIN,
                STORE,
                PRODUCT,
                COMMENT,
                PROCESS,
                INVOICE_NUMBER
            )
            SELECT A.PK_BUD_MTR_PURCHASE_ORDER,                                   -- PK_BUD_MTR_PURCHASE_ORDER
                   ISNULL(A.REFERENCE_NUMBER, ''),                                -- REFERENCE_NUMBER - varchar(100)
                   ISNULL(A.REFERENCE_SUPPLIER, 0),                               -- REFERENCE_SUPPLIER - varchar(100)
                   ISNULL(A.START_DATE, '1900-01-01'),                            -- START_DATE - datetime
                   ISNULL(H.NAME, ''),                                            -- COMPANY - varchar(100)
                   ISNULL(C.COMMERCIAL_NAME, ''),                                 -- COMMERCIAL_NAME - varchar(100)
                   ISNULL(A.CREATION_USER, ''),                                   -- CREATION_USER - varchar(100)
                   ISNULL(CONCAT(F.NAME, ' - ', E.NAME), ''),                     -- ACCOUNT_NAME - varchar(100)
                   ISNULL(D.VALUE, ''),                                           -- VALUE_STATUS - varchar(100)
                   ISNULL(B.CODE, ''),                                            -- CODE - varchar(100)
                   ISNULL(A.TOTAL_GENERAL, 0),                                    -- TOTAL_GENERAL - decimal(18, 2)
                   ISNULL(A.TOTAL_COIN, 0),                                       -- TOTAL_COIN  -  decimal(18,2)
                   dbo.FNC_GET_STORE_INFORMATION(A.PK_BUD_MTR_PURCHASE_ORDER),    -- STORE - varchar(max)
                   dbo.FNC_GET_PRODUCT_INFORMATION(A.PK_BUD_MTR_PURCHASE_ORDER),  --PRODUCT - VARCHAR(MAX)
                   dbo.FNC_GET_COMMENTS_INFORMATION(A.PK_BUD_MTR_PURCHASE_ORDER), -- COMMENT
                   0,                                                             -- PROCESS - bit
                   ISNULL(G.INVOICE_NUMBER, '')
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                       AND A.FK_CREATION_USER = @P_FK_CREATION_USER
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
                INNER JOIN
                (
                    SELECT X.FK_BUD_MTR_PURCHASE_ORDER,
                           Y.NAME
                    FROM dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                        INNER JOIN dbo.BUD_MTR_COMPANY Y
                            ON Y.PK_BUD_MTR_COMPANY = X.FK_BUD_MTR_COMPANY
                    WHERE X.ACTIVE = 1
                    GROUP BY X.FK_BUD_MTR_PURCHASE_ORDER,
                             Y.NAME
                ) H
                    ON H.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                LEFT JOIN dbo.BUD_MTR_ACCOUNT E
                    ON E.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                LEFT JOIN dbo.BUD_MTR_ACCOUNT F WITH (NOLOCK)
                    ON F.PK_BUD_MTR_ACCOUNT = E.FK_BUD_MTR_ACCOUNT
                LEFT JOIN dbo.BUD_MTR_PURCHASE_ORDER_INVOICE G
                    ON G.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER;

            SELECT *
            FROM @T_PURCHASE_ORDER;

        END;
        ELSE
        BEGIN

            SELECT a.IS_PAID,PK_BUD_MTR_PURCHASE_ORDER = ISNULL(A.PK_BUD_MTR_PURCHASE_ORDER, 0),
                   CREATION_DATE = ISNULL(CONVERT(DATE, A.CREATION_DATE), '1900-01-01'),
                   CREATION_USER = ISNULL(A.CREATION_USER, ''),
                   MODIFICATION_DATE = ISNULL(A.MODIFICATION_DATE, '1900-01-01'),
                   MODIFICATION_USER = ISNULL(A.MODIFICATION_USER, ''),
                   FK_BUD_MTR_SUPPLIER = ISNULL(A.FK_BUD_MTR_SUPPLIER, 0),
                   FK_BUD_MTR_COIN = ISNULL(A.FK_BUD_MTR_COIN, 0),
                   FK_GBL_CAT_CATALOG_TYPE = ISNULL(A.FK_GBL_CAT_CATALOG_TYPE, 0),
                   FK_GBL_CAT_CATALOG_STATUS = ISNULL(A.FK_GBL_CAT_CATALOG_STATUS, 0),
                   FK_BUD_MTR_ACCOUNT = ISNULL(A.FK_BUD_MTR_ACCOUNT, 0),
                   TAX_AMOUNT = ISNULL(A.TAX_AMOUNT, 0.00),
                   TOTAL_COIN = ISNULL(A.TOTAL_COIN, 0.00),
                   TOTAL_GENERAL = ISNULL(A.TOTAL_GENERAL, 0.00),
                   REQUIRE_BUDGET = ISNULL(A.REQUIRE_BUDGET, 0),
                   START_DATE = ISNULL(CONVERT(DATE, A.START_DATE), '1900-01-01'),
                   END_DATE = ISNULL(A.END_DATE, '1900-01-01'),
                   REFERENCE_NUMBER = ISNULL(A.REFERENCE_NUMBER, ''),
                   REFERENCE_SUPPLIER = ISNULL(A.REFERENCE_SUPPLIER, ''),
                   SEND_DATE = ISNULL(A.SEND_DATE, '1900-01-01'),
                   APPROVE_DATE = ISNULL(A.APPROVE_DATE, '1900-01-01'),
                   CODE = ISNULL(B.CODE, ''),
                   COMMERCIAL_NAME = ISNULL(C.COMMERCIAL_NAME, ''),
                   SYMBOL = ISNULL(B.SYMBOL, ''),
                   VALUE_STATUS = ISNULL(D.VALUE, ''),
                   STYLE = ISNULL(D.STYLE, ''),
                   SUBTOTAL = ISNULL(A.SUBTOTAL, 0),
                   NOT_USE_BUDGET = ISNULL(A.NOT_USE_BUDGET, 0),
                   CURRENT_ORDER = ISNULL(A.CURRENT_ORDER, 0),
                   ADDRESS_SUPPLIER = ISNULL(C.ADDRESS_SUPPLIER, ''),
                   CONTACTS_LIST = ISNULL(CONCAT(C.PRINCIPAL_PHONE, ' / ', C.EMAIL_NOTIFICATION), ''),
                   USER_NAME_ASSIGNED = ISNULL(A.USER_NAME_ASSIGNED, ''),
                   AMOUNT_BUDGET = CASE
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           A.AMOUNT_BUDGET
                                       ELSE
                                           0
                                   END,
                   BUDGET_STATUS = CASE
                                       WHEN A.NOT_USE_BUDGET = 1 THEN
                                           'Omite'
                                       WHEN A.REQUIRE_BUDGET = 1 THEN
                                           'Supera'
                                       ELSE
                                           'Posee'
                                   END,
                   MONTHS_RECURRENCE = ISNULL(A.MONTHS_RECURRENCE, 0),
                   STORE =
                   (
                       SELECT CONCAT(Y.NAME, ' - ', Y.ADDRESS, ' | ') AS [text()]
                       FROM dbo.BUD_MTR_PURCHASE_ORDER Z
                           INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER X
                               ON X.FK_BUD_MTR_PURCHASE_ORDER = Z.PK_BUD_MTR_PURCHASE_ORDER
                                  AND Z.PK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                                  AND X.ACTIVE = 1
                           INNER JOIN dbo.BUD_MTR_STORE Y
                               ON Y.PK_BUD_MTR_STORE = X.FK_BUD_MTR_STORE
                       FOR XML PATH('')
                   )
            FROM BUD_MTR_PURCHASE_ORDER A
                INNER JOIN dbo.BUD_MTR_COIN B
                    ON A.FK_BUD_MTR_COIN = B.PK_BUD_MTR_COIN
                INNER JOIN dbo.BUD_MTR_SUPPLIER C
                    ON A.FK_BUD_MTR_SUPPLIER = C.PK_BUD_MTR_SUPPLIER
                INNER JOIN dbo.GLB_CAT_CATALOG D
                    ON A.FK_GBL_CAT_CATALOG_STATUS = D.PK_GLB_CAT_CATALOG
            WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
            ORDER BY PK_BUD_MTR_PURCHASE_ORDER DESC;

        END;




    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH
        --ErrorHandler:		
        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);
        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();
        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;
        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;


GO
DROP Procedure IF Exists PA_MAN_BUD_MTR_PURCHASE_ORDER_SAVE
GO
CREATE PROCEDURE [dbo].[PA_MAN_BUD_MTR_PURCHASE_ORDER_SAVE]
(
    @P_PK_BUD_MTR_PURCHASE_ORDER BIGINT = 0,
    @P_CREATION_DATE DATETIME = '1900-01-01',
    @P_CREATION_USER VARCHAR(256) = '',
    @P_MODIFICATION_DATE DATETIME = '1900-01-01',
    @P_MODIFICATION_USER VARCHAR(256) = '',
    @P_FK_BUD_MTR_SUPPLIER INT = 0,
    @P_FK_BUD_MTR_COIN INT = 0,
    @P_FK_GBL_CAT_CATALOG_TYPE INT = 0,
    @P_FK_GBL_CAT_CATALOG_STATUS INT = 0,
    @P_TAX_AMOUNT DECIMAL(18, 6) = 0.00,
    @P_TOTAL_COIN DECIMAL(18, 6) = 0.00,
    @P_TOTAL_GENERAL DECIMAL(18, 6) = 0.00,
    @P_REQUIRE_BUDGET BIT = 0,
    @P_START_DATE DATETIME = '1900-01-01',
    @P_END_DATE DATETIME = '1900-01-01',
    @P_REFERENCE_NUMBER VARCHAR(256) = '',
    @P_REFERENCE_SUPPLIER VARCHAR(256) = '',
    @P_APPROVE_DATE DATETIME = '1900-01-01',
    @P_SEND_DATE DATETIME = '1900-01-01',
    @P_PURCHASE_ORDER_OPTION INT = 0,
    @P_NOT_USE_BUDGET BIT = 0,
    @P_CURRENT_ORDER BIT = 0,
    @P_FK_BUD_MTR_ACCOUNT INT = 0,
    @P_FK_USER_ASSIGNED INT = 0,
    @P_FK_CREATION_USER INT = 0,
    @P_OPTION_ACTION INT = 0, -- 1. APPROVE / 2. REJECTED
    @P_USER_NAME_ASSIGNED VARCHAR(100) = '',
    @P_AMORTIZATION INT = 0,
    @P_TOTAL_PAYMENT DECIMAL(18, 6) = 0,
    @P_FK_BUD_MTR_PURCHASE_ORDER_INVOICE INT = 0,
    @P_MONTHS_RECURRENCE INT = 0,
    @P_DATE_APPLIES DATETIME = '1900-01-01',
    @P_ARRAY_PURCHASE_ORDER VARCHAR(MAX) = ''
)
AS
/* 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
COMENTARIOS:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>CREACION:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Objeto:		    PA_MAN_BUD_MTR_PURCHASE_ORDER_SAVE
Descripcion:	
Creado por: 	Erick Sibaja
Version:    	1.0.0
Ejemplo de uso:

USE [BUDGET]
GO

DECLARE	@return_value			INT,

 EXEC	@return_value = [dbo].[PA_MAN_BUD_MTR_PURCHASE_ORDER_SAVE]
@P_PK_BUD_MTR_PURCHASE_ORDER    =0
,@P_CREATION_DATE    ='1900-01-01'
,@P_CREATION_USER    =''
,@P_MODIFICATION_DATE    ='1900-01-01'
,@P_MODIFICATION_USER    =''
,@P_FK_BUD_MTR_SUPPLIER    =0
,@P_FK_BUD_MTR_COIN    =0
,@P_FK_GBL_CAT_CATALOG_TYPE    =0
,@P_FK_GBL_CAT_CATALOG_STATUS    =0
,@P_TAX_AMOUNT    =0.00
,@P_TOTAL_COIN    =0.00
,@P_TOTAL_GENERAL    =0.00
,@P_REQUIRE_BUDGET    =0
,@P_START_DATE    ='1900-01-01'
,@P_END_DATE    ='1900-01-01'

SELECT	'RETURN Value' = @return_value

GO

Fecha:  	    12/17/2019 3:15:32 PM
Observaciones: 	Posibles observaciones


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>>MODIFICACIONES:
(Por cada modificacion se debe de agregar un item, con su respectiva  informacion, favor que sea de forma ascendente con respecto a las 
modificaciones, ademas de identificar en el codigo del procedimiento el cambio realizado, de la siguiente forma
--Numero modificacion: ##, Modificado por: Desarrollador, Observaciones: Descripcion a detalle del cambio)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
Numero modificacion: 	Numero de secuencia de la modificacion, comensar de 1,2,3,...n, en adelante
Descripcion: 			Descripcion de la modificacion realizada
Uso: 					Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Modificado por: 		Desarrollador
Version: 				1.1.0 o 1.1.1, esto tomando como base la version de la creacion, ultima modificacion, y el tipo de cambio realizado en el procedimiento
Ejemplo de uso: 		Si algo cambio en la forma de la ejecucion, se coloca, si no colocar "Igual al Iten de CREACION"
Fecha: 					Fecha de la modificacion
Observaciones: 			Posibles observaciones
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
BEGIN

    SET XACT_ABORT, NOCOUNT ON; --added to prevent extra result sets from interfering with SELECT statements.

    BEGIN TRY
        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --DECLARACION 
        -----------------------------
        --VARIABLES
        DECLARE @V_SEARCH_KEY_GBL_CATALOG_STATUS_SAVE VARCHAR(50) = 'purchase_save',
                @V_SEARCH_KEY_GBL_CATALOG_STATUS_CANCELED VARCHAR(50) = 'purchase_canceled',
                @V_SEARCH_KEY_CATALOG_PURCHASE_TRANSITION VARCHAR(100) = 'purchase_order_transition',
                @V_SEARCH_KEY_CATALOG_TRANSFER_NOT_APPLIED VARCHAR(100) = 'applied_not_state',
                @V_SEARCH_KEY_CATALOG_TRANSFER_APPLIED VARCHAR(100) = 'applied_state',
                @V_SEARCH_KEY_CATALOG_TYPE_TRANSITION VARCHAR(100) = 'transition_type',
                @V_SEARCH_KEY_CATALOG_TYPE_TRANSFER_STATE VARCHAR(100) = 'budget_transfer_state',
                @V_SEARCH_KEY_GBL_CATALOG_STATUS_FINALIZED VARCHAR(100) = 'purchase_finalized',
                @V_SEARCH_KEY_CATALOG_STATUS_SEND VARCHAR(100) = 'purchase_send',
                @V_SEARCH_KEY_CATALOG_RETUNR_PURCHASE VARCHAR(100) = 'purchase_return',
				@V_SEARCH_KEY_GBL_CATALOG_BORRADOR VARCHAR(100) = 'purchase_borrador',
                @V_PK_CATALOG_STATUS_SEND INT = 0,
                @V_PK_TYPE_CATALOG_TRANSITION INT = 0,
                @V_PK_TYPE_CATALOG_TRANSFER_STATE INT = 0,
                @V_PK_GBL_CATALOG_STATUS_SAVE INT = 0,
				@V_PK_GBL_CATALOG_STATUS_BORRADOR INT = 0,
				@V_PK_GBL_CATALOG_STATUS_ INT = 0,
                @V_PK_GBL_CATALOG_STATUS_FINALIZED INT = 0,
                @V_PK_GBL_CATALOG_STATUS_CANCELED INT = 0,
                @V_PK_CATALOG_PURCHASE_TRANSITION INT = 0,
                @V_PK_CATALOG_TRANSFER_NOT_APPLIED INT = 0,
                @V_PK_CATALOG_TRANSFER_APPLIED INT = 0,
                @V_USER_EMAIL VARCHAR(256) = '',
                @V_SUMMARY_INVOICE DECIMAL(18, 6),
                @V_FK_USER_SUPERVISOR INT = 0,
                @V_USER_SUPERVISOR_EMAIL VARCHAR(256) = '';

        DECLARE @V_SEARCH_KEY_GLB_MTR_CONSECUTIVE_TYPE_STORE VARCHAR(50) = 'REF',
                @V_PK_GLB_MTR_CONSECUTIVE_TYPE_STORE INT = 0,
                @V_OPORTUNITY_CODE VARCHAR(100) = '';

        DECLARE @V_ERROR_SEND BIT = 0;
        DECLARE @V_MESSAGE VARCHAR(100) = '',
                @V_SEARCH_KEY_TYPE_PURCHASE_ORDER_STATUS VARCHAR(100) = 'purchase_order_status',
                @V_PK_TYPE_PURCHASE_ORDER_STATUS INT = 0,
                @V_SEARCH_KEY_PURCHASE_ORDER_STATE_PENDING_APPROVAL VARCHAR(100) = 'purchase_pending_approval',
                @V_PK_PURCHASE_ORDER_STATE_PENDING_APPROVAL INT = 0,
                @V_SEARCH_KEY_CATALOG_PURCHASE_ORDER_REJECTED VARCHAR(100) = 'purchase_rejected',
                @V_PK_CATALOG_PURCHASE_ORDER_REJECTED INT = 0,
                @V_SEARCH_KEY_CATALOG_PURCHASE_ORDER_APPROVE VARCHAR(100) = 'purchase_approve',
                @V_PK_CATALOG_PURCHASE_ORDER_APPROVE INT = 0,
                @V_SEARCH_KEY_CATALOG_PURCHASE_APPROVAL_MONEY VARCHAR(300) = 'purchase_pending_approval_money',
                @V_PK_CATALOG_PURCHASE_ORDER_APPROVAL_MONEY INT = 0,
                @V_AMOUNT_TYPE_CHANGE DECIMAL(18, 6),
                @V_FK_CATALOG_PURCHASE_ORDER_RETURN INT = 0,
                @V_AMOUNT_REFUND DECIMAL(18, 2) = 0,
                @V_FK_MTR_ACCOUNT_TYPE_PURCHASE_ORDER INT = 0,
                @FK_GLB_CAT_CATALOG_BALANCE INT = 0,
                @C_SEARCH_KEY_TYPE_CATALOG_BALANCE_ACCOUNT VARCHAR(100) = 'account_type',
                @C_SEARCH_KEY_CATALOG_BALANCE_ACCOUNT VARCHAR(100) = 'preoperative_account';

        DECLARE @V_CATALOG_YEAR INT = 0,
                @V_YEAR VARCHAR(100) = '',
                @V_MONTH VARCHAR(100) = '',
                @V_SEARCH_KEY_PERIOD VARCHAR(100) = 'period',
                @V_PK_TYPE_CATALOG_PERIOD INT = 0,
                @V_SEARCH_KEY_YEAR VARCHAR(100) = 'year',
                @V_PK_TYPE_CATALOG_YEAR INT = 0;

        --OPTIONS PURCHASE ORDER
        DECLARE @V_OPTION_SAVE_ALL INT = 1;
        DECLARE @V_OPTION_UPDATE_TOTALS INT = 2;
        DECLARE @V_OPTION_UPDATE_STATUS INT = 3;
        DECLARE @V_OPTION_UPDATE_SEND INT = 4;
        DECLARE @V_OPTION_APPROVE_SUPERVISOR_BUDGET INT = 5;
        DECLARE @V_OPTION_APPROVE_SUPERVISOR_OWNER INT = 6;
        DECLARE @V_OPTION_APPROVE_SUPERVISOR_RANGE INT = 7;
        DECLARE @V_OPTION_UPDATE_ACCOUNT INT = 8;
        DECLARE @V_OPTION_VALIDATE_PAYMENT INT = 9;
        DECLARE @V_OPTION_CANCEL_PAYMENT_AND_PURCHACE_ORDER INT = 10;
        DECLARE @V_OPTION_SEND_UPDATE INT = 11;
        DECLARE @V_OPTION_APPROVE_SUPERVISOR_BUDGET_ALL INT = 12;
        DECLARE @V_OPTION_RETURN_PURCHASE INT = 13;
        DECLARE @V_PRINCIPAL_COIN INT = 0;
        DECLARE @TOTAL_COIN DECIMAL(18, 6) = 0;
        DECLARE @TOTAL_GENERAL DECIMAL(18, 6) = 0;
        DECLARE @TOTAL_AMOUNT DECIMAL(18, 6) = 0;
        DECLARE @TOTAL_BUDGET DECIMAL(18, 6) = 0;
        DECLARE @V_CREATION_USER_EMAIL VARCHAR(256) = '';
        DECLARE @V_ASSIGNED_USER_EMAIL VARCHAR(256) = '';
        DECLARE @V_SUBTITLE_CANCELED VARCHAR(256)
            = 'El supervisor de cuenta contable rechaza la ejecución de la orden de compra [orden]';
        DECLARE @V_SUBTITLE_FINALIZED VARCHAR(256)
            = 'El supervisor de cuenta contable ha finalizado la orden de compra [orden]';
        DECLARE @V_SUBTITLE_SEND_FINALIZED VARCHAR(256)
            = 'El supervisor de cuenta contable ha enviado a la etapa de gestión de pago la orden de compra [orden]';

        DECLARE @V_SUBTITLE_CANCELED_ASSIGNED VARCHAR(256)
            = 'Has rechazado la ejecución de la orden de compra [orden]';
        DECLARE @V_SUBTITLE_FINALIZED_ASSIGNED VARCHAR(256) = 'Has finalizado la orden de compra [orden]';
        DECLARE @V_SUBTITLE_SEND_FINALIZED_ASSIGNED VARCHAR(256)
            = 'Has enviado a la etapa de gestión de pago la orden de compra [orden]';
        DECLARE @V_SUBTITLE_SEND_FOLLOWER VARCHAR(256) = 'Ahora eres seguidor de la siguiente orden de compra';

        DECLARE @T_PURCHASE_ORDER TABLE
        (
            FK_BUD_PURCHASE_ORDER INT,
            IT_PROCEES BIT
                DEFAULT 0
        );
        --Administracion errores
        -----------------------------
        --CONSTANTES
        --ASIGNACION
        SELECT @V_PK_GLB_MTR_CONSECUTIVE_TYPE_STORE = PK_GLB_MTR_CONSECUTIVE_TYPE
        FROM dbo.GLB_MTR_CONSECUTIVE_TYPE
        WHERE SEARCH_KEY = @V_SEARCH_KEY_GLB_MTR_CONSECUTIVE_TYPE_STORE;

        SELECT @V_PK_GBL_CATALOG_STATUS_SAVE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_GBL_CATALOG_STATUS_SAVE;
		 
		SELECT @V_PK_GBL_CATALOG_STATUS_BORRADOR = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_GBL_CATALOG_BORRADOR;
	

        SELECT @V_PK_GBL_CATALOG_STATUS_FINALIZED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_GBL_CATALOG_STATUS_FINALIZED;

        SELECT @V_PK_GBL_CATALOG_STATUS_CANCELED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_GBL_CATALOG_STATUS_CANCELED;

        SELECT @V_PK_CATALOG_STATUS_SEND = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_STATUS_SEND;

        SELECT @V_FK_CATALOG_PURCHASE_ORDER_RETURN = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_RETUNR_PURCHASE;

        SELECT @V_PRINCIPAL_COIN = PK_BUD_MTR_COIN
        FROM dbo.BUD_MTR_COIN
        WHERE PRINCIPAL = 1;

        SELECT @V_PK_TYPE_CATALOG_TRANSITION = PK_GLB_CAT_TYPE_CATALOG
        FROM dbo.GLB_CAT_TYPE_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_TYPE_TRANSITION;

        SELECT @V_PK_TYPE_CATALOG_TRANSFER_STATE = PK_GLB_CAT_TYPE_CATALOG
        FROM dbo.GLB_CAT_TYPE_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_TYPE_TRANSFER_STATE;

        SELECT @V_PK_CATALOG_PURCHASE_TRANSITION = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_PURCHASE_TRANSITION
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_CATALOG_TRANSITION;

        SELECT @V_PK_CATALOG_TRANSFER_NOT_APPLIED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_TRANSFER_NOT_APPLIED
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_CATALOG_TRANSFER_STATE;

        SELECT @V_PK_CATALOG_TRANSFER_APPLIED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_TRANSFER_APPLIED
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_CATALOG_TRANSFER_STATE;

        SELECT @V_SUBTITLE_CANCELED = REPLACE(@V_SUBTITLE_CANCELED, '[orden]', A.REFERENCE_NUMBER),
               @V_SUBTITLE_FINALIZED = REPLACE(@V_SUBTITLE_FINALIZED, '[orden]', A.REFERENCE_NUMBER),
               @V_SUBTITLE_SEND_FINALIZED = REPLACE(@V_SUBTITLE_SEND_FINALIZED, '[orden]', A.REFERENCE_NUMBER),
               @V_SUBTITLE_CANCELED_ASSIGNED = REPLACE(@V_SUBTITLE_CANCELED_ASSIGNED, '[orden]', A.REFERENCE_NUMBER),
               @V_SUBTITLE_FINALIZED_ASSIGNED = REPLACE(@V_SUBTITLE_FINALIZED_ASSIGNED, '[orden]', A.REFERENCE_NUMBER),
               @V_SUBTITLE_SEND_FINALIZED_ASSIGNED
                   = REPLACE(@V_SUBTITLE_SEND_FINALIZED_ASSIGNED, '[orden]', A.REFERENCE_NUMBER)
        FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
        WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

        SELECT @V_CREATION_USER_EMAIL = B.EMAIL
        FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
            INNER JOIN SSO_BUDGET..SEG_MTR_USER B WITH (NOLOCK)
                ON B.PK_SEG_MTR_USER = CONVERT(BIGINT, A.FK_CREATION_USER)
        WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

        SELECT @V_ASSIGNED_USER_EMAIL = B.EMAIL
        FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
            INNER JOIN SSO_BUDGET..SEG_MTR_USER B WITH (NOLOCK)
                ON B.PK_SEG_MTR_USER = CONVERT(BIGINT, A.FK_USER_ASSIGNED)
        WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;


        SELECT @V_PK_TYPE_PURCHASE_ORDER_STATUS = PK_GLB_CAT_TYPE_CATALOG
        FROM dbo.GLB_CAT_TYPE_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_TYPE_PURCHASE_ORDER_STATUS;


        SELECT @V_PK_CATALOG_PURCHASE_ORDER_REJECTED = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_PURCHASE_ORDER_REJECTED
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_PURCHASE_ORDER_STATUS;

        SELECT @V_PK_CATALOG_PURCHASE_ORDER_APPROVE = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_PURCHASE_ORDER_APPROVE
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_PURCHASE_ORDER_STATUS;

        SELECT @V_PK_CATALOG_PURCHASE_ORDER_APPROVAL_MONEY = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG
        WHERE SEARCH_KEY = @V_SEARCH_KEY_CATALOG_PURCHASE_APPROVAL_MONEY
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_PURCHASE_ORDER_STATUS;

        SELECT @FK_GLB_CAT_CATALOG_BALANCE = A.PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG A WITH (NOLOCK)
            INNER JOIN dbo.GLB_CAT_TYPE_CATALOG B WITH (NOLOCK)
                ON B.PK_GLB_CAT_TYPE_CATALOG = A.FK_GBL_CAT_TYPE_CATALOG
        WHERE A.SEARCH_KEY = @C_SEARCH_KEY_CATALOG_BALANCE_ACCOUNT
              AND B.SEARCH_KEY = @C_SEARCH_KEY_TYPE_CATALOG_BALANCE_ACCOUNT;


        SELECT @V_YEAR = CONVERT(VARCHAR(100), YEAR(A.DATE_APPLIES)),
               @V_MONTH = CONVERT(VARCHAR(100), MONTH(A.DATE_APPLIES) - 1)
        FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
        WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;


        SELECT @V_CATALOG_YEAR = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG WITH (NOLOCK)
        WHERE SEARCH_KEY = @V_YEAR
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_CATALOG_YEAR;

        SELECT @V_PK_TYPE_CATALOG_PERIOD = PK_GLB_CAT_CATALOG
        FROM dbo.GLB_CAT_CATALOG WITH (NOLOCK)
        WHERE VALUE = @V_MONTH
              AND FK_GBL_CAT_TYPE_CATALOG = @V_PK_TYPE_CATALOG_PERIOD;
        -----------------------------
        --VARIABLES
        --Administracion errores
        DECLARE @PARAMETER VARCHAR(MAX);
        SELECT @PARAMETER
            = '@P_PK_BUD_MTR_PURCHASE_ORDER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_PK_BUD_MTR_PURCHASE_ORDER, 0))
              + '@P_CREATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_DATE, '1900-01-01'))
              + '@P_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_CREATION_USER, ''))
              + '@P_MODIFICATION_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_DATE, '1900-01-01'))
              + '@P_MODIFICATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_MODIFICATION_USER, ''))
              + '@P_FK_BUD_MTR_SUPPLIER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_SUPPLIER, 0))
              + '@P_FK_BUD_MTR_COIN    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_COIN, 0))
              + '@P_FK_GBL_CAT_CATALOG_TYPE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_GBL_CAT_CATALOG_TYPE, 0))
              + '@P_FK_GBL_CAT_CATALOG_STATUS    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_GBL_CAT_CATALOG_STATUS, 0))
              + '@P_TAX_AMOUNT    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_TAX_AMOUNT, 0.00)) 
			  + '@P_TOTAL_COIN    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_TOTAL_COIN, 0.00)) 
			  + '@P_TOTAL_GENERAL    = '+ CONVERT(VARCHAR(MAX), ISNULL(@P_TOTAL_GENERAL, 0.00)) 
			  + '@P_REQUIRE_BUDGET    = '+ CONVERT(VARCHAR(MAX), ISNULL(@P_REQUIRE_BUDGET, 0)) 
			  + '@P_START_DATE    = '   + CONVERT(VARCHAR(MAX), ISNULL(@P_START_DATE, '1900-01-01')) 
			  + '@P_END_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_END_DATE, '1900-01-01')) 
			  + '@P_REFERENCE_NUMBER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_REFERENCE_NUMBER, '1900-01-01')) 
			  + '@P_REFERENCE_SUPPLIER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_REFERENCE_SUPPLIER, '')) 
			  + '@P_SEND_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_SEND_DATE, '')) 
			  + '@P_APPROVE_DATE    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_APPROVE_DATE, '')) 
			  + '@P_FK_BUD_MTR_ACCOUNT    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_BUD_MTR_ACCOUNT, '')) 
			  + '@P_FK_USER_ASSIGNED    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_USER_ASSIGNED, '')) 
			  + '@P_FK_CREATION_USER    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_FK_CREATION_USER, '')) 
			  + '@P_OPTION_ACTION    = ' + CONVERT(VARCHAR(MAX), ISNULL(@P_OPTION_ACTION, '')) 
			  + '@P_DATE_APPLIES   =' + CONVERT(VARCHAR(MAX), ISNULL(@P_DATE_APPLIES, ''))
			  + '@P_PURCHASE_ORDER_OPTION = '  + CONVERT(VARCHAR(MAX), ISNULL(@P_PURCHASE_ORDER_OPTION, ''));



        -----------------------------
        --CONSTANTES

        --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        -----------------------------
        --CUERPO PROCEDIMIENTO

        IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_SAVE_ALL)
        BEGIN

            IF EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_SUPPLIER a WITH (NOLOCK)
                WHERE a.BLACK_LIST = 1
                      AND a.PK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
            )
            BEGIN
                RAISERROR('No puedes crear una orden de compra con un proveedor que está en la lista negra', 15, 20);
            END;

            IF EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_PURCHASE_ORDER A
                WHERE A.REFERENCE_SUPPLIER = @P_REFERENCE_SUPPLIER
                      AND A.FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
                      AND A.PK_BUD_MTR_PURCHASE_ORDER <> @P_PK_BUD_MTR_PURCHASE_ORDER
					  AND A.FK_GBL_CAT_CATALOG_STATUS NOT IN (@V_PK_CATALOG_PURCHASE_ORDER_REJECTED, @V_PK_GBL_CATALOG_STATUS_CANCELED)
					   
            )
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                RAISERROR('El número de cotización ya se encuentra registrado', 15, 20);
            END;


            IF EXISTS
            (
                SELECT *
                FROM BUD_MTR_PURCHASE_ORDER WITH (NOLOCK)
                WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
            )
            BEGIN


                IF EXISTS
                (
                    SELECT *
                    FROM dbo.BUD_MTR_PURCHASE_ORDER A
                    WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                          AND A.FK_GBL_CAT_CATALOG_STATUS NOT IN ( @V_PK_CATALOG_STATUS_SEND,
                                                                   @V_PK_GBL_CATALOG_STATUS_SAVE, 
																   @V_PK_GBL_CATALOG_STATUS_BORRADOR
                                                                 )
                )
                BEGIN
                    RAISERROR(
                                 'No puedes actualizar la orden de compra porque el supervisor de cuenta ya la aprobó', 
                                 15,
                                 20
                             );
                END;
                ELSE
                BEGIN
                    UPDATE A
                    SET A.MODIFICATION_DATE = GETDATE(),
                        A.MODIFICATION_USER = @P_MODIFICATION_USER,
                        A.FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER,
                        A.FK_GBL_CAT_CATALOG_TYPE = @P_FK_GBL_CAT_CATALOG_TYPE,
                        A.REFERENCE_SUPPLIER = @P_REFERENCE_SUPPLIER,
                        A.NOT_USE_BUDGET = @P_NOT_USE_BUDGET,
                        A.CURRENT_ORDER = @P_CURRENT_ORDER,
                        A.AMORTIZATION = @P_AMORTIZATION,
                        A.MONTHS_RECURRENCE = @P_MONTHS_RECURRENCE,
                        A.DATE_APPLIES = @P_DATE_APPLIES
                    FROM BUD_MTR_PURCHASE_ORDER A
                    WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;
                END;
            END;
            ELSE
            BEGIN

                IF EXISTS
                (
                    SELECT *
                    FROM dbo.BUD_MTR_PURCHASE_ORDER A
                    WHERE A.REFERENCE_SUPPLIER = @P_REFERENCE_SUPPLIER
                          AND A.FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
                          AND A.PK_BUD_MTR_PURCHASE_ORDER <> @P_PK_BUD_MTR_PURCHASE_ORDER
						  AND A.FK_GBL_CAT_CATALOG_STATUS NOT IN (@V_PK_CATALOG_PURCHASE_ORDER_REJECTED, @V_PK_GBL_CATALOG_STATUS_CANCELED)
                )
                BEGIN
                    SELECT @V_ERROR_SEND = 1;
                    SELECT @V_MESSAGE = 'El número de cotización ya se encuentra registrado';
                END;



                EXEC dbo.PA_PRO_GLB_MTR_CONSECUTIVE_TYPE_GET_NEXT_VALUE @P_PK_GLB_MTR_CONSECUTIVE_TYPE = @V_PK_GLB_MTR_CONSECUTIVE_TYPE_STORE,
                                                                        @P_MODIFICATION_USER = @P_CREATION_USER,
                                                                        @P_CONSECUTIVE = @V_OPORTUNITY_CODE OUTPUT;

                INSERT INTO BUD_MTR_PURCHASE_ORDER
                (
                    CREATION_DATE,
                    CREATION_USER,
                    MODIFICATION_DATE,
                    MODIFICATION_USER,
                    FK_BUD_MTR_SUPPLIER,
                    FK_BUD_MTR_COIN,
                    FK_GBL_CAT_CATALOG_TYPE,
                    FK_GBL_CAT_CATALOG_STATUS,
                    TAX_AMOUNT,
                    TOTAL_COIN,
                    TOTAL_GENERAL,
                    REQUIRE_BUDGET,
                    START_DATE,
                    END_DATE,
                    REFERENCE_NUMBER,
                    REFERENCE_SUPPLIER,
                    APPROVE_DATE,
                    SEND_DATE,
                    NOT_USE_BUDGET,
                    CURRENT_ORDER,
                    FK_BUD_MTR_ACCOUNT,
                    FK_USER_ASSIGNED,
                    FK_CREATION_USER,
                    AMORTIZATION,
                    MONTHS_RECURRENCE,
                    DATE_APPLIES,
					ENVIADOICG
                )
                VALUES
                (GETDATE(), @P_CREATION_USER, GETDATE(), @P_MODIFICATION_USER, @P_FK_BUD_MTR_SUPPLIER,
                 @P_FK_BUD_MTR_COIN, @P_FK_GBL_CAT_CATALOG_TYPE, @V_PK_GBL_CATALOG_STATUS_SAVE, @P_TAX_AMOUNT,
                 @P_TOTAL_COIN, @P_TOTAL_GENERAL, @P_REQUIRE_BUDGET, GETDATE(), NULL, @V_OPORTUNITY_CODE,
                 @P_REFERENCE_SUPPLIER, @P_APPROVE_DATE, @P_SEND_DATE, @P_NOT_USE_BUDGET, @P_CURRENT_ORDER, NULL, NULL,
                 @P_FK_CREATION_USER, @P_AMORTIZATION, @P_MONTHS_RECURRENCE, @P_DATE_APPLIES,0);

                SET @P_PK_BUD_MTR_PURCHASE_ORDER = SCOPE_IDENTITY();

                INSERT INTO dbo.BUD_MTR_PURCHASE_ORDER_HISTORY
                (
                    CREATION_DATE,
                    CREATION_USER,
                    MODIFICATION_DATE,
                    MODIFICATION_USER,
                    FK_BUD_MTR_PURCHASE_ORDER,
                    FK_GBL_CAT_CATALOG_STATUS,
                    START_DATE,
                    END_DATE,
                    FK_USER_ASSIGNED,
                    OBSERVATION
                )
                VALUES
                (   GETDATE(),                           -- CREATION_DATE - datetime
                    @P_CREATION_USER,                    -- CREATION_USER - varchar(256)
                    GETDATE(),                           -- MODIFICATION_DATE - datetime
                    @P_CREATION_USER,                    -- MODIFICATION_USER - varchar(256)
                    @P_PK_BUD_MTR_PURCHASE_ORDER,        -- FK_BUD_MTR_PURCHASE_ORDER - bigint
                    @V_PK_GBL_CATALOG_STATUS_SAVE,       -- FK_GBL_CAT_CATALOG_STATUS - int
                    GETDATE(),                           -- START_DATE - datetime
                    NULL,                                -- END_DATE - datetime
                    @P_FK_CREATION_USER,                 -- FK_USER_ASSIGNED - int
                    'La orden de compra se ha guardado.' -- OBSERVATION - varchar(500)
                    );

                EXEC dbo.PA_MAN_BUD_MTR_PURCHASE_ORDER_FOLLOWERS_SAVE @P_PK_BUD_MTR_PURCHASE_ORDER_FOLLOWERS = 0,                  -- bigint
                                                                      @P_CREATION_USER = @P_CREATION_USER,                         -- varchar(256)
                                                                      @P_CREATION_DATE = '2020-10-03 00:10:12',                    -- datetime
                                                                      @P_MODIFICATION_USER = @P_CREATION_USER,                     -- varchar(256)
                                                                      @P_MODIFICATION_DATE = '2020-10-03 00:10:12',                -- datetime
                                                                      @P_FK_SEG_MTR_USER = @P_FK_CREATION_USER,                    -- int
                                                                      @P_FK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                                      @P_FK_GBL_CAT_CATALOG_STATUS = 0,                            -- int
                                                                      @P_USER_NAME = @P_CREATION_USER,                             -- varchar(256)
                                                                      @P_ACTIVE = 1,                                               -- bit
                                                                      @P_IS_CREATOR = 1;                                           -- bit

            END;
        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_UPDATE_TOTALS)
        BEGIN

            SELECT @TOTAL_AMOUNT = SUM(SUBTOTAL)
            FROM dbo.BUD_MTR_PURCHASE_ORDER_PRODUCT
            WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                  AND ACTIVE = 1;

            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.FK_BUD_MTR_COIN = @P_FK_BUD_MTR_COIN,
                A.AMORTIZATION = @P_AMORTIZATION
            FROM BUD_MTR_PURCHASE_ORDER A
            WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            IF (@V_PRINCIPAL_COIN <> @P_FK_BUD_MTR_COIN)
            BEGIN

                SELECT @TOTAL_COIN = (@TOTAL_AMOUNT + @P_TAX_AMOUNT),
                       @TOTAL_BUDGET = CASE
                                           WHEN C.DIVIDED = 1 THEN
                       (@TOTAL_AMOUNT / A.AMOUNT_TYPE_CHANGE)
                                           ELSE
                       (@TOTAL_AMOUNT * A.AMOUNT_TYPE_CHANGE)
                                       END,
                       @TOTAL_GENERAL = CASE
                                            WHEN C.DIVIDED = 1 THEN
                       ((@TOTAL_AMOUNT + @P_TAX_AMOUNT) / A.AMOUNT_TYPE_CHANGE)
                                            ELSE
                       ((@TOTAL_AMOUNT + @P_TAX_AMOUNT) * A.AMOUNT_TYPE_CHANGE)
                                        END,
                       @V_AMOUNT_TYPE_CHANGE = A.AMOUNT_TYPE_CHANGE
                FROM dbo.GLB_MTR_CURRENCY_CONVERT A
                    INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER B
                        ON A.FK_BUD_MTR_COIN = B.FK_BUD_MTR_COIN
                    INNER JOIN dbo.BUD_MTR_COIN C
                        ON C.PK_BUD_MTR_COIN = A.FK_BUD_MTR_COIN
                WHERE A.CONSULT_DATE = CONVERT(DATE, GETDATE())
                      AND B.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;



            END;
            ELSE
            BEGIN
                SELECT @TOTAL_COIN = (@TOTAL_AMOUNT + @P_TAX_AMOUNT),
                       @TOTAL_BUDGET = @TOTAL_AMOUNT,
                       @TOTAL_GENERAL = (@TOTAL_AMOUNT + @P_TAX_AMOUNT);
            END;


            -- RQ CUENTAS PREOPERATIVAS
            UPDATE A
            SET SUBTOTAL_DOLLARIZED = IIF(@V_PRINCIPAL_COIN = @P_FK_BUD_MTR_COIN,
                                          A.SUBTOTAL,
                                          CASE
                                              WHEN C.DIVIDED = 1 THEN
                                          (A.SUBTOTAL / @V_AMOUNT_TYPE_CHANGE)
                                              ELSE
                                          (A.SUBTOTAL * @V_AMOUNT_TYPE_CHANGE)
                                          END),
                TAX_AMOUNT_DOLLARIZED = IIF(@V_PRINCIPAL_COIN = @P_FK_BUD_MTR_COIN,
                                            A.TAX_AMOUNT,
                                            CASE
                                                WHEN C.DIVIDED = 1 THEN
                                                    A.TAX_AMOUNT / @V_AMOUNT_TYPE_CHANGE
                                                ELSE
                                                    A.TAX_AMOUNT * @V_AMOUNT_TYPE_CHANGE
                                            END)
            FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A WITH (NOLOCK)
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER B WITH (NOLOCK)
                    ON B.PK_BUD_MTR_PURCHASE_ORDER = A.FK_BUD_MTR_PURCHASE_ORDER
                INNER JOIN dbo.BUD_MTR_COIN C WITH (NOLOCK)
                    ON C.PK_BUD_MTR_COIN = B.FK_BUD_MTR_COIN
            WHERE B.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;


            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.TAX_AMOUNT = @P_TAX_AMOUNT,
                A.TOTAL_COIN = @TOTAL_COIN,
                A.TOTAL_GENERAL = @TOTAL_GENERAL,
                A.TOTAL_BUDGET = @TOTAL_BUDGET
            FROM dbo.BUD_MTR_PURCHASE_ORDER A
            WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;
        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_UPDATE_STATUS)
        BEGIN


            IF (@P_FK_GBL_CAT_CATALOG_STATUS <> @V_PK_GBL_CATALOG_STATUS_SAVE)
            BEGIN

                IF @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_CANCELED
                BEGIN

                    UPDATE dbo.BUD_MTR_BUDGET_TRANSFER_TRANSITION_MOVEMENT
                    SET MODIFICATION_DATE = GETDATE(),
                        MODIFICATION_USER = @P_MODIFICATION_USER,
                        FK_CAT_CATALOG_STATUS = @V_PK_CATALOG_TRANSFER_NOT_APPLIED
                    WHERE FK_CAT_CATALOG_TYPE = @V_PK_CATALOG_PURCHASE_TRANSITION
                          AND FK_MASTER_IDENTIFIER = @P_PK_BUD_MTR_PURCHASE_ORDER;
                END;

                SELECT @V_SUMMARY_INVOICE = SUM(AMOUNT)
                FROM dbo.BUD_MTR_PURCHASE_ORDER_INVOICE A WITH (NOLOCK)
                WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;


                IF
                (
                    SELECT A.TOTAL_GENERAL
                    FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
                    WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                ) <> @V_SUMMARY_INVOICE
                BEGIN
                    RAISERROR('La sumatoria de las facturas no concuerda con el total de la orden de compra', 15, 20);
                END;

                --IF NOT EXISTS ( SELECT TOP 1 1 
                --			FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH ( NOLOCK )
                --				INNER JOIN dbo.GLB_MTR_DOCUMENT B WITH ( NOLOCK ) ON B.FK_MAIN = A.PK_BUD_MTR_PURCHASE_ORDER
                --			WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER  
                --)
                --BEGIN
                --	RAISERROR('No se puede enviar la orden de compra debido a NO HAY DOCUMENT',15, 20);				
                --END


                UPDATE dbo.BUD_MTR_PURCHASE_ORDER_HISTORY
                SET MODIFICATION_DATE = GETDATE(),
                    MODIFICATION_USER = @P_MODIFICATION_USER,
                    END_DATE = GETDATE()
                WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                      AND END_DATE IS NULL;

                INSERT INTO dbo.BUD_MTR_PURCHASE_ORDER_HISTORY
                (
                    CREATION_DATE,
                    CREATION_USER,
                    MODIFICATION_DATE,
                    MODIFICATION_USER,
                    FK_BUD_MTR_PURCHASE_ORDER,
                    FK_GBL_CAT_CATALOG_STATUS,
                    START_DATE,
                    END_DATE,
                    FK_USER_ASSIGNED,
                    OBSERVATION
                )
                VALUES
                (   GETDATE(),                    -- CREATION_DATE - datetime
                    @P_MODIFICATION_USER,         -- CREATION_USER - varchar(256)
                    GETDATE(),                    -- MODIFICATION_DATE - datetime
                    @P_MODIFICATION_USER,         -- MODIFICATION_USER - varchar(256)
                    @P_PK_BUD_MTR_PURCHASE_ORDER, -- FK_BUD_MTR_PURCHASE_ORDER - bigint
                    @P_FK_GBL_CAT_CATALOG_STATUS, -- FK_GBL_CAT_CATALOG_STATUS - int
                    GETDATE(),                    -- START_DATE - datetime
                    CASE
                        WHEN @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_CANCELED
                             OR @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_FINALIZED THEN
                            GETDATE()
                        ELSE
                            NULL
                    END,                          -- END_DATE - datetime
                    @P_FK_CREATION_USER,          -- FK_USER_ASSIGNED - int
                    CASE
                        WHEN @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_CANCELED THEN
                            'El usuario ha cancelado la orden de compra'
                        WHEN @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_FINALIZED THEN
                            'El usuario ha finalizado la orden de compra'
                        ELSE
                            'El usuario ha enviado a la etapa gestion de pago'
                    END                           -- OBSERVATION - varchar(500)
                    );

                UPDATE A
                SET A.MODIFICATION_DATE = GETDATE(),
                    A.MODIFICATION_USER = @P_MODIFICATION_USER,
                    A.FK_GBL_CAT_CATALOG_STATUS = @P_FK_GBL_CAT_CATALOG_STATUS,
                    A.END_DATE = CASE
                                     WHEN @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_FINALIZED THEN
                                         GETDATE()
                                     ELSE
                                         A.END_DATE
                                 END,
                    A.AMORTIZATION = @P_AMORTIZATION,
                    A.REJECTED_DATE = CASE
                                          WHEN @P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_CANCELED THEN
                                              GETDATE()
                                          ELSE
                                              A.REJECTED_DATE
                                      END
                FROM dbo.BUD_MTR_PURCHASE_ORDER A
                WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;


                IF (@P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_CANCELED)
                BEGIN
                    EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                                               @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                                               @P_SUBTITLE = @V_SUBTITLE_CANCELED,                          -- nvarchar(max)
                                               @P_USER_EMAIL = @V_CREATION_USER_EMAIL,                      -- varchar(256)
                                               @P_IS_SUPPLIER = 0,                                          -- bit
                                               @P_IS_FOLLOWERS = 1,
                                               @P_SUBJECT = 'Orden de compra cancelada';

                --      EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                --                                 @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                --                                 @P_SUBTITLE = @V_SUBTITLE_CANCELED_ASSIGNED,                 -- nvarchar(max)
                --                                 @P_USER_EMAIL = @V_ASSIGNED_USER_EMAIL,                      -- varchar(256)
                --                                 @P_IS_SUPPLIER = 0,                                          -- bit
                --@P_IS_FOLLOWERS = 0,
                --@P_SUBJECT = 'Orden de compra rechazada'
                END;
                ELSE IF (@P_FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_FINALIZED)
                BEGIN
                    EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                                               @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                                               @P_SUBTITLE = @V_SUBTITLE_FINALIZED,                         -- nvarchar(max)
                                               @P_USER_EMAIL = @V_CREATION_USER_EMAIL,                      -- varchar(256)
                                               @P_IS_SUPPLIER = 0,                                          -- bit
                                               @P_IS_FOLLOWERS = 1,
                                               @P_SUBJECT = 'Orden de compra finalizada';

                --      EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                --                                 @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                --                                 @P_SUBTITLE = @V_SUBTITLE_FINALIZED_ASSIGNED,                -- nvarchar(max)
                --                                 @P_USER_EMAIL = @V_ASSIGNED_USER_EMAIL,                      -- varchar(256)
                --                                 @P_IS_SUPPLIER = 0,                                          -- bit
                --@P_IS_FOLLOWERS = 0,
                --@P_SUBJECT = 'Orden de compra finalizada'
                END;
                ELSE
                BEGIN
                    EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                                               @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                                               @P_SUBTITLE = @V_SUBTITLE_SEND_FINALIZED,                    -- nvarchar(max)
                                               @P_USER_EMAIL = @V_CREATION_USER_EMAIL,                      -- varchar(256)
                                               @P_IS_SUPPLIER = 0,                                          -- bit
                                               @P_IS_FOLLOWERS = 1,
                                               @P_SUBJECT = 'Orden enviada a la etapa de gestión de pago';

                --      EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                --                                 @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                --                                 @P_SUBTITLE = @V_SUBTITLE_SEND_FINALIZED_ASSIGNED,           -- nvarchar(max)
                --                                 @P_USER_EMAIL = @V_ASSIGNED_USER_EMAIL,                      -- varchar(256)
                --                                 @P_IS_SUPPLIER = 0,                                          -- bit
                --@P_IS_FOLLOWERS = 0,
                --@P_SUBJECT = 'Orden de compra finalizada'
                END;

            END;
            ELSE
            BEGIN
                UPDATE A
                SET A.MODIFICATION_DATE = GETDATE(),
                    A.MODIFICATION_USER = @P_MODIFICATION_USER,
                    A.FK_GBL_CAT_CATALOG_STATUS = @P_FK_GBL_CAT_CATALOG_STATUS,
                    A.AMORTIZATION = @P_AMORTIZATION
                FROM dbo.BUD_MTR_PURCHASE_ORDER A
                WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

                UPDATE dbo.BUD_MTR_BUDGET_TRANSFER_TRANSITION_MOVEMENT
                SET MODIFICATION_DATE = GETDATE(),
                    MODIFICATION_USER = @P_MODIFICATION_USER,
                    FK_CAT_CATALOG_STATUS = @V_PK_CATALOG_TRANSFER_NOT_APPLIED
                WHERE FK_CAT_CATALOG_TYPE = @V_PK_CATALOG_PURCHASE_TRANSITION
                      AND FK_MASTER_IDENTIFIER = @P_PK_BUD_MTR_PURCHASE_ORDER;
            END;


        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_UPDATE_SEND)
        BEGIN


            IF NOT EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_PURCHASE_ORDER_PRODUCT
                WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
            )
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                SELECT @V_MESSAGE = 'Debes agregar productos a la orden de compra';
            END;

            IF NOT EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_BANK_DETAIL
                WHERE FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
            )
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                SELECT @V_MESSAGE = 'Debe de agregar información bancaria para el proveedor seleccionado';
            END;

            --IF NOT EXISTS
            --(
            --    SELECT *
            --    FROM dbo.BUD_MTR_CONTACT_SUPPLIER
            --    WHERE FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
            --)
            --BEGIN
            --    SELECT @V_ERROR_SEND = 1;
            --    SELECT @V_MESSAGE = 'Debe de agregar información de contacto para el proveedor seleccionado';
            --END;

            IF EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_SUPPLIER a WITH (NOLOCK)
                WHERE a.BLACK_LIST = 1
                      AND a.PK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
            )
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                SELECT @V_MESSAGE = 'No puedes crear una orden de compra con un proveedor que está en la lista negra';
            END;

            IF EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_PURCHASE_ORDER A
                WHERE A.REFERENCE_SUPPLIER = @P_REFERENCE_SUPPLIER
                      AND A.FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER
                      AND A.PK_BUD_MTR_PURCHASE_ORDER <> @P_PK_BUD_MTR_PURCHASE_ORDER
					  AND A.FK_GBL_CAT_CATALOG_STATUS NOT IN (@V_PK_CATALOG_PURCHASE_ORDER_REJECTED, @V_PK_GBL_CATALOG_STATUS_CANCELED)
            )
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                SELECT @V_MESSAGE = 'El número de cotización ya se encuentra registrado';
            END;

            IF
            (
                SELECT COUNT(FK_BUD_MTR_ACCOUNT)
                FROM dbo.BUD_MTR_PURCHASE_ORDER
                WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
            ) = 0
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                SELECT @V_MESSAGE = 'Debes asociar la orden de compra a una cuenta';
            END;

            IF EXISTS
            (
                SELECT *
                FROM dbo.BUD_MTR_PURCHASE_ORDER A
                WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                      AND A.FK_GBL_CAT_CATALOG_STATUS NOT IN ( @V_PK_CATALOG_STATUS_SEND, @V_PK_GBL_CATALOG_STATUS_SAVE )
            )
            BEGIN
                SELECT @V_ERROR_SEND = 1;
                SELECT @V_MESSAGE
                    = 'No puedes actualizar la orden de compra porque el supervisor de cuenta ya la aprobó';
            END;
            ELSE IF (@V_ERROR_SEND = 1)
            BEGIN
                RAISERROR(@V_MESSAGE, 15, 20);
            END;


            UPDATE dbo.BUD_MTR_PURCHASE_ORDER
            SET MODIFICATION_USER = @P_MODIFICATION_USER,
                MODIFICATION_DATE = GETDATE(),
                FK_BUD_MTR_SUPPLIER = @P_FK_BUD_MTR_SUPPLIER,
                FK_GBL_CAT_CATALOG_TYPE = @P_FK_GBL_CAT_CATALOG_TYPE,
                REFERENCE_SUPPLIER = @P_REFERENCE_SUPPLIER,
                FK_BUD_MTR_ACCOUNT = @P_FK_BUD_MTR_ACCOUNT,
                NOT_USE_BUDGET = @P_NOT_USE_BUDGET,
                CURRENT_ORDER = @P_CURRENT_ORDER,
                AMORTIZATION = @P_AMORTIZATION,
                DATE_APPLIES = @P_DATE_APPLIES
            WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            EXEC dbo.PA_PRO_PURCHASE_ORDER_VALIDATE @P_PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                    @P_CREATION_USER = @P_CREATION_USER;





        --IF EXISTS ( SELECT 1
        --    FROM dbo.BUD_MTR_PURCHASE_ORDER
        --    WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER AND REQUIRE_BUDGET = 0 ) 
        --BEGIN
        --    EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
        --                               @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
        --                               @P_SUBTITLE = N'Has enviado la orden de compra a revisión',  -- nvarchar(max)
        --                               @P_USER_EMAIL = @V_USER_EMAIL,                               -- varchar(256)
        -- @P_IS_FOLLOWERS = 1
        --END;


        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_APPROVE_SUPERVISOR_BUDGET)
        BEGIN

            EXEC dbo.PA_PRO_PURCHASE_ORDER_VALIDATE_APPROVE_BUDGET @P_PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                                   @P_CREATION_USER = @P_CREATION_USER,                         -- varchar(256)
                                                                   @P_FK_USER_ASSIGNED = @P_FK_CREATION_USER,                   -- int
                                                                   @P_OPTION = @P_OPTION_ACTION,                                -- int
                                                                   @P_USER_NAME_ASSIGNED = @P_USER_NAME_ASSIGNED;


        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_APPROVE_SUPERVISOR_OWNER)
        BEGIN

            EXEC dbo.PA_PRO_PURCHASE_ORDER_VALIDATE_APPROVE_OWNER @P_PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                                  @P_CREATION_USER = @P_CREATION_USER,                         -- varchar(256)
                                                                  @P_FK_USER_ASSIGNED = @P_FK_CREATION_USER,                   -- int
                                                                  @P_OPTION = @P_OPTION_ACTION,
                                                                  @P_USER_NAME_ASSIGNED = @P_USER_NAME_ASSIGNED;               -- int


        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_APPROVE_SUPERVISOR_RANGE)
        BEGIN

            EXEC dbo.PA_PRO_PURCHASE_ORDER_VALIDATE_APPROVE_RANGE @P_PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                                  @P_CREATION_USER = @P_CREATION_USER,                         -- varchar(256)
                                                                  @P_FK_USER_ASSIGNED = @P_FK_CREATION_USER,                   -- int
                                                                  @P_OPTION = @P_OPTION_ACTION,                                -- int
                                                                  @P_USER_NAME_ASSIGNED = @P_USER_NAME_ASSIGNED;


        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_VALIDATE_PAYMENT)
        BEGIN
		

            EXEC dbo.PA_PRO_PURCHASE_ORDER_VALIDATE_PAYMENT @P_PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                            @P_CREATION_USER = @P_CREATION_USER,                         -- varchar(256)
                                                            @P_FK_USER_ASSIGNED = @P_FK_CREATION_USER,                   -- int
                                                            @P_TOTAL_PAYMENT = @P_TOTAL_PAYMENT,                         -- decimal(18, 6)
                                                            @P_FK_BUD_MTR_PURCHASE_ORDER_INVOICE = @P_FK_BUD_MTR_PURCHASE_ORDER_INVOICE;
        
		update BUD_MTR_PURCHASE_ORDER set
		is_paid=1
		where PK_BUD_MTR_PURCHASE_ORDER=@P_PK_BUD_MTR_PURCHASE_ORDER
		END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_UPDATE_ACCOUNT)
        BEGIN
            UPDATE A
            SET A.MODIFICATION_DATE = GETDATE(),
                A.MODIFICATION_USER = @P_MODIFICATION_USER,
                A.FK_BUD_MTR_ACCOUNT = @P_FK_BUD_MTR_ACCOUNT
            FROM BUD_MTR_PURCHASE_ORDER A
            WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;
        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_CANCEL_PAYMENT_AND_PURCHACE_ORDER)
        BEGIN

		update BUD_MTR_PURCHASE_ORDER set
		is_paid=1
		where PK_BUD_MTR_PURCHASE_ORDER=@P_PK_BUD_MTR_PURCHASE_ORDER
            --OBTENEMOS EL TIPO DE CUENTA LIGADO A LA ORDEN DE COMPRA
            SELECT @V_FK_MTR_ACCOUNT_TYPE_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
            FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
                INNER JOIN dbo.BUD_MTR_ACCOUNT B WITH (NOLOCK)
                    ON B.PK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
            WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            -- ACTUALIZAMOS LA ORDEN A CANCELADA
            UPDATE dbo.BUD_MTR_PURCHASE_ORDER
            SET MODIFICATION_DATE = GETDATE(),
                MODIFICATION_USER = @P_MODIFICATION_USER,
                REJECTED_DATE = GETDATE(),
                FK_GBL_CAT_CATALOG_STATUS = @V_PK_GBL_CATALOG_STATUS_CANCELED
            WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            -- DESACTIVAMOS LAS FACTURAS DE LA ORDEN DE COMPRA
            UPDATE dbo.BUD_MTR_PURCHASE_ORDER_INVOICE
            SET ACTIVE = 0
            WHERE FK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            --OBTENEMOS EL  MONTO A REEMBOLSAR
            SELECT @V_AMOUNT_REFUND = SUM(AMOUNT)
            FROM BUD_MTR_BUDGET_TRANSFER_TRANSITION_MOVEMENT
            WHERE FK_MASTER_IDENTIFIER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            -- VALIDAMOS SI LA CUENTA DE LA ORDEN DE COMPRA ES DE TIPO PREOPERATIVA
            IF @V_FK_MTR_ACCOUNT_TYPE_PURCHASE_ORDER = @FK_GLB_CAT_CATALOG_BALANCE
            BEGIN
                -- REEMBOLSAMOS 
                UPDATE C
                SET C.CONSUMED_AMOUNT = C.CONSUMED_AMOUNT - @V_AMOUNT_REFUND,
                    C.REMAINING_AMOUNT = C.REMAINING_AMOUNT + @V_AMOUNT_REFUND
                FROM dbo.BUD_MTR_PURCHASE_ORDER A
                    INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER B
                        ON B.FK_BUD_MTR_PURCHASE_ORDER = A.PK_BUD_MTR_PURCHASE_ORDER
                    INNER JOIN dbo.BUD_MTR_CONTROL_BUDGET_TRANSFER C
                        ON C.FK_BUT_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                           AND C.FK_GBL_CAT_CATALOG_YEAR = @V_CATALOG_YEAR
                           AND C.FK_GBL_CAT_CATALOG_MONTH = @V_PK_TYPE_CATALOG_PERIOD
                           AND C.FK_BUD_MTR_STORE = B.FK_BUD_MTR_STORE
                    INNER JOIN dbo.BUD_MTR_BUDGET_TRANSFER_TRANSITION_MOVEMENT D
                        ON D.FK_MASTER_IDENTIFIER = A.PK_BUD_MTR_PURCHASE_ORDER
                WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER
                      AND B.ACTIVE = 1;
            END;
            ELSE
            BEGIN
                -- REEMBOLSAMOS
                UPDATE A
                SET A.CONSUMED_AMOUNT = A.CONSUMED_AMOUNT - @V_AMOUNT_REFUND,
                    A.REMAINING_AMOUNT = A.REMAINING_AMOUNT + @V_AMOUNT_REFUND
                FROM dbo.BUD_MTR_CONTROL_BUDGET_TRANSFER A
                    INNER JOIN dbo.BUD_MTR_BUDGET_TRANSFER_TRANSITION_MOVEMENT B
                        ON B.FK_BUD_MTR_BUDGET_DETAIL = A.FK_BUD_MTR_BUDGET_DETAIL
                WHERE FK_MASTER_IDENTIFIER = @P_PK_BUD_MTR_PURCHASE_ORDER
                      AND B.FK_CAT_CATALOG_STATUS = @V_PK_CATALOG_TRANSFER_APPLIED;
            END;

            -- DESACCTIVAMOS LOS FLOTANTES
            UPDATE A
            SET FK_CAT_CATALOG_STATUS = @V_PK_CATALOG_TRANSFER_NOT_APPLIED
            FROM BUD_MTR_BUDGET_TRANSFER_TRANSITION_MOVEMENT A
            WHERE A.FK_MASTER_IDENTIFIER = @P_PK_BUD_MTR_PURCHASE_ORDER;

        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_SEND_UPDATE)
        BEGIN

            ------------------------------------------------------------------
            -- SETP 1: SE OBTIENE EL CORREO DEL USUARIO QUE CREO LA OC
            ------------------------------------------------------------------

            SELECT @V_USER_EMAIL = B.EMAIL
            FROM dbo.BUD_MTR_PURCHASE_ORDER A WITH (NOLOCK)
                INNER JOIN SSO_BUDGET..SEG_MTR_USER B WITH (NOLOCK)
                    ON B.PK_SEG_MTR_USER = A.FK_CREATION_USER
            WHERE A.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            ------------------------------------------------------------------
            -- SETP 2: SE OBTIENE EL  USUARIO QUE ES SUPERVISOR DE CUENTA
            ------------------------------------------------------------------

            SELECT @V_FK_USER_SUPERVISOR = A.FK_SEG_MTR_USER
            FROM dbo.BUD_MTR_PURCHASE_ORDER_HIERARCHY A
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER B
                    ON B.FK_BUD_MTR_ACCOUNT = A.FK_BUD_MTR_ACCOUNT
                INNER JOIN dbo.BUD_MTR_PURCHASE_ORDER_OWNER C
                    ON B.PK_BUD_MTR_PURCHASE_ORDER = C.FK_BUD_MTR_PURCHASE_ORDER
                       AND A.FK_BUD_MTR_STORE = C.FK_BUD_MTR_STORE
                INNER JOIN SSO_BUDGET.dbo.SEG_MTR_USER D
                    ON A.FK_SEG_MTR_USER = D.PK_SEG_MTR_USER
            WHERE A.IS_SUPERVISOR = 1
                  AND A.ACTIVE = 1
                  AND C.ACTIVE = 1
                  AND B.PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            ------------------------------------------------------------------
            -- SETP 3: SE ENVIA EL CORREO AL USUARIO QUE CREO LA OC
            ------------------------------------------------------------------

            --IF (ISNULL(@V_USER_EMAIL, '') <> '')
            --BEGIN
            --    EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
            --                               @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
            --                               @P_SUBTITLE = N'Has enviado la orden de compra a revisión',  -- nvarchar(max)
            --                               @P_USER_EMAIL = @V_USER_EMAIL,                               -- varchar(256)
            -- @P_IS_FOLLOWERS = 1
            --END;


            ------------------------------------------------------------------
            -- SETP 4: SE OBTIENE EL CORREO DEL USUARIO QUE ES SUPERVISOR DE CUENTA 
            ------------------------------------------------------------------
            SELECT @V_USER_SUPERVISOR_EMAIL = A.EMAIL
            FROM SSO_BUDGET..SEG_MTR_USER A WITH (NOLOCK)
            WHERE A.PK_SEG_MTR_USER = @V_FK_USER_SUPERVISOR;


            ------------------------------------------------------------------
            -- SETP 5: SE ENVIA EL CORREO AL USUARIO SUPERVISOR DE CUENTA
            ------------------------------------------------------------------
            IF (ISNULL(@V_USER_SUPERVISOR_EMAIL, '') <> '')
            BEGIN
                EXEC dbo.PA_PRO_SEND_EMAIL @P_FK_BUT_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- int
                                           @P_TITLE = N'Orden de Compra',                               -- nvarchar(max)
                                           @P_SUBTITLE = N'Se te ha asignado una orden de compra',      -- nvarchar(max)
                                           @P_USER_EMAIL = @V_USER_SUPERVISOR_EMAIL,                    -- varchar(256)
                                           @P_IS_FOLLOWERS = 0,
                                           @P_SUBJECT = 'Orden nueva';
            END;

        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_APPROVE_SUPERVISOR_BUDGET_ALL)
        BEGIN

            INSERT INTO @T_PURCHASE_ORDER
            (
                FK_BUD_PURCHASE_ORDER,
                IT_PROCEES
            )
            SELECT pk_Bud_Mtr_Purchase_Order,
                   0
            FROM
                OPENJSON(@P_ARRAY_PURCHASE_ORDER)
                WITH
                (
                    pk_Bud_Mtr_Purchase_Order INT '$.pk_Bud_Mtr_Purchase_Order'
                );


            WHILE EXISTS (SELECT 1 FROM @T_PURCHASE_ORDER WHERE IT_PROCEES = 0)
            BEGIN

                SELECT TOP 1
                       @P_PK_BUD_MTR_PURCHASE_ORDER = A.FK_BUD_PURCHASE_ORDER
                FROM @T_PURCHASE_ORDER A
                WHERE IT_PROCEES = 0;

                EXEC dbo.PA_PRO_PURCHASE_ORDER_VALIDATE_APPROVE_BUDGET @P_PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER, -- bigint
                                                                       @P_CREATION_USER = @P_CREATION_USER,                         -- varchar(256)
                                                                       @P_FK_USER_ASSIGNED = @P_FK_CREATION_USER,                   -- int
                                                                       @P_OPTION = @P_OPTION_ACTION,                                -- int
                                                                       @P_USER_NAME_ASSIGNED = @P_USER_NAME_ASSIGNED;

                UPDATE @T_PURCHASE_ORDER
                SET IT_PROCEES = 1
                WHERE FK_BUD_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;
            END;

        END;
        ELSE IF (@P_PURCHASE_ORDER_OPTION = @V_OPTION_RETURN_PURCHASE)
        BEGIN


            SELECT @P_FK_CREATION_USER = FK_CREATION_USER
            FROM dbo.BUD_MTR_PURCHASE_ORDER
            WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

            -- se actualiza al estado devuelta
            UPDATE dbo.BUD_MTR_PURCHASE_ORDER
            SET FK_GBL_CAT_CATALOG_STATUS = @V_FK_CATALOG_PURCHASE_ORDER_RETURN,
                FK_USER_ASSIGNED = @P_FK_CREATION_USER
            WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;


            --se inserta en la bitacora
            INSERT INTO dbo.BUD_MTR_PURCHASE_ORDER_HISTORY
            (
                CREATION_DATE,
                CREATION_USER,
                MODIFICATION_DATE,
                MODIFICATION_USER,
                FK_BUD_MTR_PURCHASE_ORDER,
                FK_GBL_CAT_CATALOG_STATUS,
                START_DATE,
                END_DATE,
                FK_USER_ASSIGNED,
                OBSERVATION
            )
            VALUES
            (   GETDATE(),                                                            -- CREATION_DATE - datetime
                @P_CREATION_USER,                                                     -- CREATION_USER - varchar(256)
                GETDATE(),                                                            -- MODIFICATION_DATE - datetime
                @P_CREATION_USER,                                                     -- MODIFICATION_USER - varchar(256)
                @P_PK_BUD_MTR_PURCHASE_ORDER,                                         -- FK_BUD_MTR_PURCHASE_ORDER - bigint
                @V_FK_CATALOG_PURCHASE_ORDER_RETURN,                                  -- FK_GBL_CAT_CATALOG_STATUS - int
                GETDATE(),                                                            -- START_DATE - datetime
                GETDATE(),                                                            -- END_DATE - datetime
                @P_FK_USER_ASSIGNED,                                                  -- FK_USER_ASSIGNED - int
                'El usuario ' + @P_MODIFICATION_USER + ' devolvio la orden de compra' -- OBSERVATION - varchar(500)
                );


			
			    
				
	

        END;

			  --ENVIAR CORREO AL USUARIO CREADOR ANYU

			  	DECLARE @COUNTPENDING INT , @COUNTAPPROVE INT 

			SELECT @COUNTPENDING= COUNT(*) FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_PK_BUD_MTR_PURCHASE_ORDER AND B.FK_STATUS  in (2,3) AND A.ACTIVE=1;

			SELECT @COUNTAPPROVE=COUNT(*)  FROM BUD_MTR_PURCHASE_ORDER_PRODUCT A
				INNER JOIN BUD_MTR_PRODUCT B ON A.FK_BUD_MTR_PRODUCT=B.PK_BUD_MTR_PRODUCT 
				INNER JOIN BUD_MTR_PURCHASE_ORDER C ON A.FK_BUD_MTR_PURCHASE_ORDER=C.PK_BUD_MTR_PURCHASE_ORDER
				WHERE A.FK_BUD_MTR_PURCHASE_ORDER=@P_PK_BUD_MTR_PURCHASE_ORDER  AND  B.FK_STATUS not in (2,3) and C.FK_GBL_CAT_CATALOG_STATUS=188 AND A.ACTIVE=1

				IF  ( @COUNTPENDING=0 AND @COUNTAPPROVE>=1 )
				BEGIN
					Update BUD_MTR_PURCHASE_ORDER set 
						FK_GBL_CAT_CATALOG_STATUS=112--@V_PK_GBL_CATALOG_STATUS_SAVE
					WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_PK_BUD_MTR_PURCHASE_ORDER
				--	exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @P_REFERENCE_NUMBER,@P_PK_BUD_MTR_PURCHASE_ORDER ,@P_FK_USER_ASSIGNED, 'PRODUCTOSAPROBADOS' 
				END;

				IF  (@COUNTPENDING>=1)
				BEGIN
					Update BUD_MTR_PURCHASE_ORDER set 
						   FK_GBL_CAT_CATALOG_STATUS=188--@V_PK_GBL_CATALOG_STATUS_BORRADOR
				WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_PK_BUD_MTR_PURCHASE_ORDER
				  -- exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @P_REFERENCE_NUMBER,@P_PK_BUD_MTR_PURCHASE_ORDER ,@P_FK_USER_ASSIGNED, 'ORDENPENDIENTE' ;
				END;

	

        SELECT *
        FROM dbo.BUD_MTR_PURCHASE_ORDER
        WHERE PK_BUD_MTR_PURCHASE_ORDER = @P_PK_BUD_MTR_PURCHASE_ORDER;

    --COMMIT TRANSACTION 
    --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    END TRY
    BEGIN CATCH

        DECLARE @PROCESS_NAME VARCHAR(MAX);
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        DECLARE @DATE_ERROR VARCHAR(MAX);

        DECLARE @V_ESTADO_ERROR INT;

        SELECT @PROCESS_NAME = OBJECT_NAME(@@procid);
        SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
        SELECT @DATE_ERROR = CONVERT(VARCHAR(MAX), GETDATE());
        SELECT @V_ESTADO_ERROR = ERROR_STATE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;


        EXEC dbo.PA_MAN_GLB_MTR_EXCEPTION_SAVE @P_PK_GLB_MTR_EXCEPTION = 0,
                                               @P_CREATION_USER = @DATE_ERROR,
                                               @P_MODULE = '',
                                               @P_PROCESS_NAME = @PROCESS_NAME,
                                               @P_PARAMETER = @PARAMETER,
                                               @P_ERROR_MESSAGE = @ERROR_MESSAGE OUTPUT,
                                               @P_ESTADO = @V_ESTADO_ERROR;

        RAISERROR(@ERROR_MESSAGE, 15, @V_ESTADO_ERROR);
        RETURN 1;
    END CATCH;
    --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
    --COMMIT TRAN 	
    RETURN 0;
END;

GO
insert into GLB_CAT_CATALOG (CREATION_DATE,CREATION_USER,MODIFICATION_DATE,MODIFICATION_USER,FK_GLB_CAT_CATALOG,FK_GBL_CAT_TYPE_CATALOG,SEARCH_KEY,VALUE,DESCRIPTION,STYLE,EDITABLE,ACTIVE) values(
'2021-06-12 16:23:26.283','sevensoft','2020-03-12 16:23:26.283','sevensoft',NULL,20,'purchase_borrador','Borrador','Borrador','#427bff',1,	1)
go
insert into GLB_CAT_CATALOG (CREATION_DATE,CREATION_USER,MODIFICATION_DATE,MODIFICATION_USER,FK_GLB_CAT_CATALOG,FK_GBL_CAT_TYPE_CATALOG,SEARCH_KEY,VALUE,DESCRIPTION,STYLE,EDITABLE,ACTIVE) values
('2020-01-10 11:51:36.817','Sevensoft','2020-01-10 11:51:36.817','Sevensoft',NULL,	21,'supplier','BUD_MTR_SUPPLIER','Tipos de archivos para contratos de proveedores','',1,1)
go
DROP TABLE IF EXISTS [ICG].[FORMASPAGO]
CREATE TABLE [ICG].[FORMASPAGO](
	[CODFORMAPAGO] INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
	[DESCRIPCION] [varchar](30) NULL,
	[FECHA_CREACION] [datetime] NULL
) ON [PRIMARY]
GO
DROP PROCEDURE IF EXISTS [ICG].[SP_FORMASPAGO_OBTENER]
GO
CREATE PROCEDURE [ICG].[SP_FORMASPAGO_OBTENER]
AS
BEGIN

	 SELECT CODFORMAPAGO,DESCRIPCION FROM ICG.FORMASPAGO 
END
GO
INSERT INTO ICG.FORMASPAGO (DESCRIPCION) VALUES 
('CxP Prov Plazo 8 días Colones'),('CxP Prov Plazo 8 días Dólares'),('CxP Prov Plazo 15 días Colones'),('CxP Prov Plazo 15 días Dólares'),('CxP Prov Plazo 20 días Colones'),('CxP Prov Plazo 20 días Dólares'),('CxP Prov Plazo 30 días Colones'),('CxP Prov Plazo 30 días Dólares'),
('CxP Proveedor 60 días Colones')