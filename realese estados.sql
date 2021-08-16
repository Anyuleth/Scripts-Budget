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
					Update BUD_MTR_PURCHASE_ORDER set 
						   FK_GBL_CAT_CATALOG_STATUS=188--@V_PK_GBL_CATALOG_STATUS_BORRADOR
				WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
			    --   exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'PRODUCTOSRECHAZADOS' ;
				END;

					IF  ( @COUNTPENDING=0 AND @COUNTAPPROVE=@TOTALAPPROVE )
				BEGIN

				
					Update BUD_MTR_PURCHASE_ORDER set 
						FK_GBL_CAT_CATALOG_STATUS=112--@V_PK_GBL_CATALOG_STATUS_SAVE
					WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
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

    

			

				IF  (@COUNTPENDING>=1)
				BEGIN
					Update BUD_MTR_PURCHASE_ORDER set 
						   FK_GBL_CAT_CATALOG_STATUS=188--@V_PK_GBL_CATALOG_STATUS_BORRADOR
				WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
				 --  exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'ORDENPENDIENTE' ;
				END;

					IF  ( @COUNTPENDING=0 AND @COUNTAPPROVE=@TOTALAPPROVE )
				BEGIN

				

					Update BUD_MTR_PURCHASE_ORDER set 
						FK_GBL_CAT_CATALOG_STATUS=112--@V_PK_GBL_CATALOG_STATUS_SAVE
					WHERE PK_BUD_MTR_PURCHASE_ORDER= @P_FK_BUD_MTR_PURCHASE_ORDER
					--exec [ICG].[SP_NOTIFICACION_ORDEN_PRODUCTOS] @REFERENCE_NUMBER,@P_FK_BUD_MTR_PURCHASE_ORDER ,@P_PK_USER_CREATOR, 'PRODUCTOSAPROBADOS' 
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