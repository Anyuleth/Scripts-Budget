use olivegarden
GO
--agregar campo libre para guardar giro de negocio
Alter Table [dbo].[PROVEEDORESCAMPOSLIBRES]Add GiroNegocio Varchar(100)
go
Alter Table [dbo].[PROVEEDORESCAMPOSLIBRES]Add CodigoAba Varchar(100)
go
Declare @PosicionFacturas int = (Select Coalesce(Max(Posicion), 0) + 1 From CamposLibresConfig Where Tabla = 6)
Insert into CamposLibresConfig (Tabla, Campo, Etiqueta, Posicion, Tipo, Tamany, TipoValor, Obligatorio, Avisar_Vacio)
Values (6 , 'GiroNegocio','Giro de Negocio', @PosicionFacturas, 3, 100, 1, 0, 0)
GO
Declare @PosicionFacturas int = (Select Coalesce(Max(Posicion), 0) + 1 From CamposLibresConfig Where Tabla = 6)
Insert into CamposLibresConfig (Tabla, Campo, Etiqueta, Posicion, Tipo, Tamany, TipoValor, Obligatorio, Avisar_Vacio)
Values (6 , 'CodigoAba','Codigo ABA', @PosicionFacturas, 3, 100, 1, 0, 0)
GO
IF NOT EXISTS (SELECT schema_id FROM sys.schemas WHERE name = 'BUDGET')
	EXEC('Create Schema BUDGET')
GO
--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE ORDERNES DE COMPRA
--***************************************************************************************************************************************************************************************************************************************
DROP PROCEDURE IF EXISTS BUDGET.SP_ORDEN_CHANGE_PAID
GO
CREATE PROCEDURE BUDGET.SP_ORDEN_CHANGE_PAID
(
  @NUMPEDIDO VARCHAR(20)
)
AS
BEGIN
	UPDATE  BUDGET.ORDENPEDIDO_DETALLE SET
	PAGADA=1
	WHERE NUMPEDIDO=@NUMPEDIDO

END
GO
DROP TABLE IF EXISTS [BUDGET].[ORDENPEDIDO_DETALLE]
GO
CREATE TABLE [BUDGET].[ORDENPEDIDO_DETALLE](
	[IDEMPRESA] [varchar](20) NULL,
	[CENTROCOSTE] [varchar](10) NULL,
	[CODALMACEN] [varchar](10) NULL,
	[NUMPEDIDO] [varchar](100) NULL,
	[IDPEDIDO] [int] NULL,
	[DESCRIPCIONICG] [varchar](200) NULL,
	[DESCRIPCION] [varchar](40) NULL,
	[CANTIDAD] [int] NULL,
	[TOTAL] [decimal](18, 5) NULL,
	[SUBTOTAL] [decimal](18, 5) NULL,
	[TOTALIMPUESTO] [decimal](18, 5) NULL,
	[PORCENTAJEIMPUESTO] [decimal](18, 5) NULL,
	[FECHA_CREACION] [datetime] NULL,
	[PROCESADO] [bit] NULL,
	[PAGADA] [bit] NULL
) ON [PRIMARY]
GO
DROP PROCEDURE IF EXISTS [BUDGET].[SP_VALIDAR_ORDEN]
GO
CREATE PROCEDURE [BUDGET].[SP_VALIDAR_ORDEN]
(
	
	@NUMPEDIDO VARCHAR(60),
	@EXIST INT OUTPUT 
)
AS
BEGIN
	DECLARE @SERIE NVARCHAR(4), @NUMALBARAN INT
	SET @EXIST= 0
	SELECT TOP 1 @NUMALBARAN=NUMALBARAN,@SERIE=NUMSERIE  FROM ALBCOMPRACAB WHERE SUALBARAN =@NUMPEDIDO
	IF EXISTS (SELECT TOP 1 NUMALBARAN FROM ALBCOMPRACAB WHERE SUALBARAN =@NUMPEDIDO) 
	 AND EXISTS (SELECT TOP 1  NUMSERIE,NUMALBARAN FROM ALBCOMPRALIN WHERE NUMSERIE=@SERIE AND NUMALBARAN=@NUMALBARAN) 
	BEGIN
		SET @EXIST= 1
	END
	

END
GO
DROP PROCEDURE IF EXISTS [BUDGET].[SP_ORDENPEDIDO_DETALLE_GUARDAR]
GO
CREATE Procedure [BUDGET].[SP_ORDENPEDIDO_DETALLE_GUARDAR]
(
	@IDEMPRESA VARCHAR(20),
	@CENTROCOSTE  VARCHAR(10),
	@CODALMACEN  VARCHAR(10),
	@NUMPEDIDO VARCHAR(100),
	@IDPEDIDO INT,
	@DESCRIPCION VARCHAR(40), 
	@DESCRIPCIONICG VARCHAR(40), 
	@CANTIDAD INT,
	@TOTAL  DECIMAL(18,5),
	@SUBTOTAL  DECIMAL(18,5),
	@TOTALIMPUESTO  DECIMAL(18,5),
	@PORCENTAJEIMPUESTO  DECIMAL(18,5)
)
As
Begin
		

	IF NOT EXISTS ( SELECT NUMPEDIDO FROM BUDGET.ORDENPEDIDO_DETALLE WHERE NUMPEDIDO=@NUMPEDIDO AND DESCRIPCIONICG=@DESCRIPCIONICG AND IDPEDIDO=@IDPEDIDO AND IDEMPRESA=@IDEMPRESA AND CENTROCOSTE=@CENTROCOSTE AND CODALMACEN=@CODALMACEN)
		BEGIN
			INSERT INTO BUDGET.ORDENPEDIDO_DETALLE(IDEMPRESA,DESCRIPCIONICG,CENTROCOSTE,CODALMACEN,NUMPEDIDO,IDPEDIDO ,DESCRIPCION,CANTIDAD,TOTAL,SUBTOTAL,TOTALIMPUESTO,FECHA_CREACION,PROCESADO,PAGADA) 
			VALUES (@IDEMPRESA,@DESCRIPCIONICG,@CENTROCOSTE,@CODALMACEN,@NUMPEDIDO,@IDPEDIDO,@DESCRIPCION,@CANTIDAD,@TOTAL,@SUBTOTAL,@TOTALIMPUESTO,GETDATE(),0,0)
		END
		ELSE
		BEGIN
			UPDATE BUDGET.ORDENPEDIDO_DETALLE SET 
			NUMPEDIDO=@NUMPEDIDO,
			DESCRIPCION=@DESCRIPCION,
			DESCRIPCIONICG=@DESCRIPCIONICG,
			CANTIDAD=@CANTIDAD,
			TOTAL=@TOTAL,
			SUBTOTAL=@SUBTOTAL,
			TOTALIMPUESTO=@TOTALIMPUESTO,
			FECHA_CREACION=GETDATE()
			WHERE NUMPEDIDO=@NUMPEDIDO AND  IDPEDIDO=@IDPEDIDO AND IDEMPRESA=@IDEMPRESA AND CENTROCOSTE=@CENTROCOSTE AND CODALMACEN=@CODALMACEN
		END
End
GO
DROP PROCEDURE IF EXISTS [BUDGET].[SP_AlbCompraLin_GUARDAR]
GO
CREATE   PROCEDURE [BUDGET].[SP_AlbCompraLin_GUARDAR]
(
	@NUMPEDIDO VARCHAR(100),
	@IDPEDIDO INT
)
AS
BEGIN
IF  EXISTS (SELECT NUMALBARAN FROM ALBCOMPRACAB WHERE SUALBARAN = @NUMPEDIDO)
	BEGIN
		DROP TABLE IF EXISTS #DETALLEDELALBARAN

		DECLARE @EMPRESA VARCHAR(50) = (SELECT TOP 1 FE_CEDULAEMISOR FROM SERIESCAMPOSLIBRES WHERE FE_CEDULAEMISOR IS NOT NULL)
		DECLARE @TIPOIMPUESTO INT=0, @IVA INT , @SUPEDIDO NVARCHAR(15),@SERIE NVARCHAR(4), @NUMALBARAN INT,
		@ARTICULO VARCHAR(200),@CANTIDADALMACENES INT

		SET @CANTIDADALMACENES=(SELECT DISTINCT COUNT(CENTROCOSTE) FROM BUDGET.ORDENPEDIDO_DETALLE WHERE IDPEDIDO=@IDPEDIDO)

		----OBTENER SERIE Y NUMALBARA 
		SELECT @SERIE=NUMSERIE, @NUMALBARAN=NUMALBARAN FROM ALBCOMPRACAB WHERE SUALBARAN=CONVERT(VARCHAR,@NUMPEDIDO);

	-- ==============================================================================
	-- SE CARGA LA TABLA TEMPORAL CON LOS DATOS NECESARIOS PARA 
	-- CREAR EL DETALLE DEL ALBARAN Y ACTUALIZAR EL PEDIDO DEL DETALLE
	-- ==============================================================================
	SELECT	@SERIE AS NUMSERIE, @NUMALBARAN AS NUMALBARAN, 'B' AS N, ROW_NUMBER() OVER (ORDER BY IDPEDIDO) AS NUMLIN, A.CODARTICULO AS CODARTICULO, A.REFPROVEEDOR AS REFERENCIA, D.DESCRIPCION AS DESCRIPCION, '.' AS COLOR,'.'AS TALLA, CANTIDAD AS UNID1, 1 AS UNID2, 1 AS UNID3
			, 1 AS UNID4, CANTIDAD/@CANTIDADALMACENES AS UNIDADESTOTAL, 0 AS UNIDADESPAGADAS,  TOTAL   AS PRECIO, 0 AS DTO, (SUBTOTAL+TOTALIMPUESTO)/@CANTIDADALMACENES  AS TOTAL, a.TipoImpuesto AS TIPOIMPUESTO, TOTALIMPUESTO AS IVA, 0 AS REQ, 0 AS NUMKG,  C.CODALMACEN AS CODALMACEN, 'F' AS DEPOSITO
			,  TOTAL/@CANTIDADALMACENES  AS PRECIOVENTA, 'F' AS USARCOLTALLAS, 0 AS IMPORTEGASTOS, CANTIDAD AS UDSEXPANSION, 'F' AS EXPANDIDA,  SUBTOTAL/@CANTIDADALMACENES AS TOTALEXPANSION,  @SUPEDIDO AS SUPEDIDO, -1 AS CODCLIENTE, 0 AS NUMKGEXPANSION
			, 0 AS CARGO1, 0 AS CARGO2, 'F' AS ESOFERTA, CONCAT('-',0,'%') AS DTOTEXTO, -1 AS CODENVIO, 0 AS UDMEDIDA2, 0 AS UDMEDIDA2EXPANSION, 0 AS PORCRETENCION, 0 AS TIPORETENCION, 0 AS UDSABONADAS
			, N'' AS ABONODE_NUMSERIE, -1 AS ABONODE_NUMALBARAN, N'' AS ABONODE_N, 0 AS IMPORTECARGO1, 0 AS IMPORTECARGO2, 'F' AS LINEAOCULTA, -1 AS IDMOTIVO, 0 AS CODFORMATO, 0 AS CODMACRO,NUMPEDIDO
			INTO	#DETALLEDELALBARAN
	FROM BUDGET.ORDENPEDIDO_DETALLE D
	INNER JOIN ARTICULOS A ON LOWER(D.DESCRIPCIONICG)COLLATE LATIN1_GENERAL_CS_AS=LOWER(A.DESCRIPCION)COLLATE LATIN1_GENERAL_CS_AS
	INNER JOIN ALMACEN  C ON D.CENTROCOSTE COLLATE LATIN1_GENERAL_CS_AS  =C.CENTROCOSTE COLLATE LATIN1_GENERAL_CS_AS AND 
	D.CODALMACEN COLLATE LATIN1_GENERAL_CS_AS=C.CODALMACEN COLLATE LATIN1_GENERAL_CS_AS
	WHERE IDPEDIDO=@IDPEDIDO	AND	PROCESADO = 0 AND A.TIPOARTICULO='G'

	-- ======================================================
	-- SE CREA EL DETALLE DEL ALBARAN -- TIENE QUE SER UNO POR UNO YA QUE EL TRIGGER DE ICG DA ERRORES CUANDO SE HACE INSERT DE TODAS LAS FILAS A LA VEZ
	-- ======================================================

	DECLARE @MAXLIN INT, @MINLIN INT
	SELECT @MAXLIN = COALESCE(MAX(NUMLIN), 0), @MINLIN = COALESCE(MIN(NUMLIN), 0)  FROM #DETALLEDELALBARAN where NUMALBARAN=@NUMALBARAN and NUMSERIE=@SERIE

	
	WHILE @MAXLIN >= @MINLIN
	BEGIN
		BEGIN TRY
			IF NOT EXISTS (SELECT * FROM ALBCOMPRALIN WHERE NUMALBARAN=@NUMALBARAN and NUMSERIE=@SERIE AND NUMLIN=@MINLIN )
			BEGIN
			INSERT INTO ALBCOMPRALIN
				(NUMSERIE, NUMALBARAN, N, NUMLIN, CODARTICULO, REFERENCIA, DESCRIPCION, COLOR, TALLA, UNID1, UNID2, UNID3, UNID4
				, UNIDADESTOTAL, UNIDADESPAGADAS, PRECIO, DTO, TOTAL, TIPOIMPUESTO, IVA, REQ, NUMKG, CODALMACEN, DEPOSITO
				, PRECIOVENTA, USARCOLTALLAS, IMPORTEGASTOS, UDSEXPANSION, EXPANDIDA, TOTALEXPANSION, SUPEDIDO, CODCLIENTE, NUMKGEXPANSION
				, CARGO1, CARGO2, ESOFERTA, DTOTEXTO, CODENVIO, UDMEDIDA2, UDMEDIDA2EXPANSION, PORCRETENCION, TIPORETENCION, UDSABONADAS
				, ABONODE_NUMSERIE, ABONODE_NUMALBARAN, ABONODE_N, IMPORTECARGO1, IMPORTECARGO2, LINEAOCULTA, IDMOTIVO, CODFORMATO, CODMACRO)
			SELECT
				NUMSERIE, NUMALBARAN, N, NUMLIN, CODARTICULO, REFERENCIA, DESCRIPCION, COLOR, TALLA, UNID1, UNID2, UNID3, UNID4
				, UNIDADESTOTAL, UNIDADESPAGADAS, PRECIO, DTO, TOTAL, TIPOIMPUESTO, COALESCE(IVA,13), REQ, NUMKG, CODALMACEN, DEPOSITO
				, PRECIOVENTA, USARCOLTALLAS, IMPORTEGASTOS, UDSEXPANSION, EXPANDIDA, TOTALEXPANSION, SUPEDIDO, CODCLIENTE, NUMKGEXPANSION
				, CARGO1, CARGO2, ESOFERTA, DTOTEXTO, CODENVIO, UDMEDIDA2, UDMEDIDA2EXPANSION, PORCRETENCION, TIPORETENCION, UDSABONADAS
				, ABONODE_NUMSERIE, ABONODE_NUMALBARAN, ABONODE_N, IMPORTECARGO1, IMPORTECARGO2, LINEAOCULTA, IDMOTIVO, CODFORMATO, CODMACRO
			FROM #DETALLEDELALBARAN
			WHERE NUMLIN = @MINLIN
			END
			SET @MINLIN = @MINLIN + 1			
		END TRY
			BEGIN CATCH
				DECLARE @ERRORMESSAGE NVARCHAR(4000), @ERRORSEVERITY INT, @ERRORSTATE INT
				SELECT @ERRORMESSAGE = ERROR_MESSAGE(),  @ERRORSEVERITY = ERROR_SEVERITY(), @ERRORSTATE = ERROR_STATE()


				RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE )
			END CATCH
		END
END


END
GO
DROP table IF EXISTS BUDGET.PARAMETROS
GO
CREATE table BUDGET.PARAMETROS(
DESCRIPCION NVARCHAR(MAX),
PARAMETRO VARCHAR(MAX),
CODIGO VARCHAR(5)
)
GO
INSERT INTO BUDGET.PARAMETROS (PARAMETRO, CODIGO,DESCRIPCION) VALUES('No existe proveedor','NEP',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-type" content="text/html; charset=utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" /><meta http-equiv="X-UA-Compatible" content="IE=edge" /><meta name="format-detection" content="date=no" /><meta name="format-detection" content="address=no" /><meta name="format-detection" content="telephone=no" /><style type="text/css" media="screen">          /* Linked Styles */          body {              padding: 0 !important;              margin: 0 !important;              display: block !important;              min-width: 100% !important;              width: 100% !important;              background: #ffffff;              -webkit-text-size-adjust: none          }            a {              color: #FFFFFF;              text-decoration: none          }            p {              padding: 0 !important;              margin: 0 !important          }            img {              -ms-interpolation-mode: bicubic; /* Allow smoother rendering of resized image in Internet Explorer */                  padding-bottom: 1rem;          }            .text-center {              text-align: center;          }            .text-left {              text-align: left          }            .pl-3 {              padding-left: 3rem;          }            .pb-1 {              padding-bottom: .5rem;          }            .custom-border {                  border: 1px solid #D0D0D0;          }            .w-50 {              width: 50%;          }            .pr-5 {              padding-right: 5rem;          }            .pb-3 {              padding-bottom: 3rem;          }            .box-shadow {              /*box-shadow: -2px 4px 7px 2px rgba(0,0,0,0.75);*/              border: 1.5px solid rgba(0, 0, 0, 0.25);          }            .p-all {              padding: 14px !important;          }            .position-table {              margin: 0;              border-top: none;          }    h3 {              font-size: 1.75rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }            h5 {              font-size: 1.25rem;              margin-bottom: .5rem;              font-weight: 500;              line-height: 1.2;              margin-top: 0;          }          /* Mobile styles */          @media only screen and (max-device-width: 480px), only screen and (max-width: 480px) {       .pl-3 {                  padding-left: 1rem;              }                div [class="mobile-br-1"] {                  height: 1px !important;              }                div[class="mobile-br-1-B"] {                  height: 1px !important;                  background: #ffffff !important;                  display: block !important;              }                div[class="mobile-br-5"] {                  height: 5px !important;              }                div[class="mobile-br-10"] {                  height: 10px !important;              }                div[class="mobile-br-15"] {                  height: 15px !important;              }                div[class="mobile-br-20"] {                  height: 20px !important;              }                div[class="mobile-br-30"] {                  height: 30px !important;              }                th[class="m-td"],              td[class="m-td"],              div[class="hide-FOR-mobile"],              span[class="hide-FOR-mobile"] {                  display: none !important;                  width: 0 !important;                  height: 0 !important;                  font-size: 0 !important;                  line-height: 0 !important;                  min-height: 0 !important;              }                span[class="mobile-BLOCK"] {                  display: block !important;              }                div[class="img-m-center"] {                  text-align: center !important;              }                div[class="h2-white-m-center"],              div[class="text-white-m-center"],              div[class="text-white-r-m-center"],              div[class="h2-m-center"],              div[class="text-m-center"],              div[class="text-r-m-center"],              td[class="text-TOP"],              div[class="text-TOP"],              div[class="h6-m-center"],              div[class="text-m-center"],              div[class="text-TOP-date"],              div[class="text-white-TOP"],              td[class="text-white-TOP"],              td[class="text-white-TOP-r"],              div[class="text-white-TOP-r"] {                  text-align: center !important;              }                div[class="fluid-img"] img,              td[class="fluid-img"] img {                  width: 100% !important;                  max-width: 100% !important;                  height: auto !important;              }                table[class="mobile-shell"] {                  width: 100% !important;                  min-width: 100% !important;              }                table[class="center"] {                  margin: 0 auto;              }                th[class="COLUMN-rtl"],              th[class="COLUMN-rtl2"],              th[class="COLUMN-TOP"],              th[class="COLUMN"] {                  float: left !important;                  width: 100% !important;                  display: block !important;              }                td[class="td"] {                  width: 100% !important;                  min-width: 100% !important;              }                td[class="CONTENT-spacing"] {                  width: 15px !important;              }                td[class="CONTENT-spacing2"] {                  width: 10px !important;              }          }      </style></head><body class="body" style="padding:0 !important; margin:0 !important; display:block !important; min-width:100% !important; width:100% !important; background:#ffffff; -webkit-text-size-adjust:none"><table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78"><tr><td align="center" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#1f4e78"><tr><td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td><td align="center"><table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell"><tr><td class="td" style="width:90%; min-width:90%; font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td><td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%"><tr><td height="30" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td></tr></table><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><th class="column" style="font-size:0pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0" width="300"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td><div class="img" style="font-size:0pt; line-height:0pt; text-align:left"><div class="img-m-center" style="font-size:0pt; line-height:0pt"><a href="" target="_blank"><img src="http://172.23.24.117:1001/assets/img/Logo-ARH.png" mc:edit="image_6" border="0" width="190" style="max-width:190px" height="50" alt="" /></a></div></div><div style="font-size:0pt; line-height:0pt;" class="mobile-br-20"></div><div style="height: 2rem; margin: 0;background-color: #ffffff;"></div></td></tr></table></th></tr></table></td><td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1"></td></tr></table></td></tr></table></td><td class="content-spacing" style="font-size:0pt; line-height:0pt; text-align:left" width="1" bgcolor="#FFFFFF"></td></tr></table><div mc:repeatable="Select" mc:variant="Section 1"><table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#e6e6e6"><tr><td width="90%" align="center" bgcolor="#FFFFFF"><table width="90%" border="0" cellspacing="0" cellpadding="0" class="mobile-shell text-center box-shadow position-table" bgcolor="#FFFFFF" style="margin-top: -60px;"><tr><td class="td" style="width:90%; min-width:90%; font-size:22pt; line-height:0pt; padding:0; margin:0; font-weight:normal; Margin:0"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td><h3>Orden de Compra</h3></td></tr><tr><td><h5> La orden de compra # referencia: reference_number se ha aprobado, pero no cuenta con el proveedor supplier en la sociedad  stores </h5></td></tr></table></td></tr><tr class="text-left"><td class="pl-3 pb-1"><strong># Referencia:</strong> reference_number</td></tr><tr class="text-left"><tr class="text-left"><td class="pl-3 pb-1"><strong>Sociedad:</strong> stores</td></tr><tr class="text-left"><td class="pl-3 pb-1"><strong>Proveedor:</strong> supplier</td></tr></tr><td valign="top" class="m-td" style="font-size:0pt; line-height:0pt; text-align:left" bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" class="border" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%"><tr><td bgcolor="#FFFFFF" height="30" class="border" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td></tr></table></td><td valign="top" class="m-td" style="font-size:0pt; line-height:0pt; text-align:left" bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" class="border" style="font-size:0pt; line-height:0pt; text-align:center; width:80%; min-width:80%"><tr><td bgcolor="#FFFFFF" height="20" class="border" style="font-size:0pt; line-height:0pt; text-align:center; width:80%; min-width:80%">&nbsp;</td></tr></table></td><tr class="text-left"><br></table></td></tr></table></div></td></tr></table></body></html>')  
GO
DROP PROCEDURE IF EXISTS  [BUDGET].[SP_NOTIFICACION_PROVEEDOR]
GO
CREATE PROCEDURE [BUDGET].[SP_NOTIFICACION_PROVEEDOR](
@reference_number varchar(300),
@supplier varchar(300),
@stores varchar(300)
)
AS
BEGIN

	DECLARE @C_BODY_EMAIL NVARCHAR(MAX)
	SELECT @C_BODY_EMAIL=DESCRIPCION FROM BUDGET.PARAMETROS
			SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'reference_number',@reference_number );

			SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'supplier', @supplier);

			SELECT @C_BODY_EMAIL = REPLACE(@C_BODY_EMAIL, 'stores', @stores );
			
	EXEC msdb.dbo.sp_send_dbmail @profile_name = 'BudgetNotifications',
											 @recipients ='anyucardenas.24@gmail.com',
											 @subject = 'Proveedor no existe en la sociedad asignada',
											 @body = @C_BODY_EMAIL,
											 @body_format = 'html';

END
GO 
DROP PROCEDURE IF EXISTS [BUDGET].[SP_ALBCOMPRACAB_GUARDAR]
GO
CREATE PROCEDURE [BUDGET].[SP_ALBCOMPRACAB_GUARDAR]
(
		 @FECHA DATETIME,  
		 @NUMPEDIDO VARCHAR(60),
		 @TOTALBRUTO DECIMAL(18,5),
		 @TOTALIMPUESTOS DECIMAL(18,5), 
		 @TOTALNETO DECIMAL(18,5),
		 @PROVEEDOR VARCHAR(300),
		 @ISOMONEDA VARCHAR(3),
		 @SOCIEDAD VARCHAR(300),
		 @NOMBREPROVEEDOR VARCHAR(300)

		 
)
AS
BEGIN
	IF NOT EXISTS ( SELECT SUALBARAN FROM ALBCOMPRACAB WHERE SUALBARAN = CONVERT(VARCHAR,@NUMPEDIDO) )
	BEGIN
	DECLARE @FECHABASE DATETIME = CONVERT(DATE, '1899-12-30'),
	@TIPODOC INT,
	@SERIE NVARCHAR(4), 
	@NUMALBARAN INT,
	@CODPROVEEDOR INT,
	@SUPEDIDO NVARCHAR(15),
	@CODMONEDA INT,
	@TIPOCAMBIO FLOAT=1
	
	
	--OBTENER EL CODIGO DEL PROVEEDOR
	SELECT @CODPROVEEDOR=CODPROVEEDOR FROM PROVEEDORES WHERE LOWER(REPLACE(NIF20,'-','')) = LOWER(REPLACE(@PROVEEDOR,'-',''))
	IF  EXISTS ( SELECT CODPROVEEDOR FROM PROVEEDORES WHERE LOWER(REPLACE(NIF20,'-','')) = LOWER(REPLACE(@PROVEEDOR,'-','')))
	BEGIN
	--TIPO DE DOCUMENTO
	SET @TIPODOC=18;
	--OBETENER LA SERIE 
	SET @SERIE= (SELECT TOP 1 SERIE  FROM SERIES WHERE IDPARENT=0 AND NULLIF(CONTABILIDADB,'') IS NOT NULL);
	--OBTENER EL NUMERO DE ALBARAN CON EL QUE SE VA A CREAR
	SET @NUMALBARAN= (SELECT MAX(NUMALBARAN)+1 FROM ALBCOMPRACAB);
	--IGUAL EL PARAMETRO SUPEDIDO CON EL NUMERO DE PO
	SET @SUPEDIDO=@NUMPEDIDO;
	--OBTENER EL CODIGO DE LA MONEDA
	SET @CODMONEDA=(SELECT CODMONEDA FROM MONEDAS WHERE CODIGOISO=@ISOMONEDA);
	  IF @CODMONEDA=3
	   SET @TIPOCAMBIO =( Select top 1 (Cotizacion) From Cotizaciones Where CODMONEDA = 3 order by Fecha desc);
	  

 	--INSERTAR EL ENCABEZADO DE LA ORDEN DE COMPRA
	INSERT INTO ALBCOMPRACAB
		(NUMSERIE, NUMALBARAN, N, SUALBARAN, FACTURADO, NUMSERIEFAC, NUMFAC, NFAC, ESUNDEPOSITO, ESDEVOLUCION, CODPROVEEDOR, FECHAALBARAN, ENVIOPOR, PORTESPAG, DTOCOMERCIAL, 
			TOTDTOCOMERCIAL, DTOPP, TOTDTOPP, TOTALBRUTO, TOTALIMPUESTOS, TOTALNETO, SELECCIONADO, CODMONEDA, FACTORMONEDA, IVAINCLUIDO, TIPODOC, TIPODOCFAC, IDESTADO, HORA, 
			TRANSPORTE, NBULTOS, CODCLIENTE, CHEQUEADO, NORECIBIDO, FECHAALBARANVENTA, FECHACREACION)
	VALUES  
		(@SERIE, @NUMALBARAN, 'B', @SUPEDIDO, 'F', '', -1, 'B', 'F', 'F', @CODPROVEEDOR, CONVERT(DATE, @FECHA), '', 'T', 0, 
			0, 0, 0, ROUND ( @TOTALBRUTO , 5,1)  , ROUND ( @TOTALIMPUESTOS , 5,1)  , ROUND ( @TOTALNETO , 5,1), 'F', @CODMONEDA, @TIPOCAMBIO, 'F', @TIPODOC, -1, -1, @FECHA,
			0, 0, -1, 'F', 'T',  @FECHABASE, @FECHA)
	END
	--ELSE BEGIN
	--	--EXEC BUDGET.SP_NOTIFICACION_PROVEEDOR  @NUMPEDIDO,@NOMBREPROVEEDOR,@SOCIEDAD
	--END 

	END
	



End
GO
DROP PROCEDURE IF EXISTS [BUDGET].[SP_MARCAR_PAGADA]
GO
CREATE PROCEDURE [BUDGET].[SP_MARCAR_PAGADA](
@IDPEDIDO INT
)
AS
BEGIN
	UPDATE BUDGET.ORDENPEDIDO_DETALLE SET
	PAGADA=1,
	PROCESADO=1
	WHERE IDPEDIDO=@IDPEDIDO

END
GO
EXEC BUDGET.SP_ORDENCOMPRAS_PAGADAS
DROP PROCEDURE IF EXISTS [BUDGET].[SP_ORDENCOMPRAS_PAGADAS]
GO
CREATE PROCEDURE [BUDGET].[SP_ORDENCOMPRAS_PAGADAS]
AS
BEGIN
		SELECT DISTINCT IDPEDIDO, SUALBARAN as NUMPEDIDO,PROCESADO,PAGADA
	FROM BUDGET.ORDENPEDIDO_DETALLE OD
	INNER JOIN ALBCOMPRACAB AC ON OD.NUMPEDIDO COLLATE Latin1_General_CS_AI =AC.SUALBARAN COLLATE Latin1_General_CS_AI
	INNER JOIN FACTURASCOMPRA FC ON  AC.NUMFAC=FC.NUMFACTURA AND AC.NUMSERIEFAC=FC.NUMSERIE
	INNER JOIN TESORERIA T ON FC.NUMFACTURA=T.NUMERO AND FC.NUMSERIE=T.SERIE
	WHERE AC.FACTURADO='T'  AND T.ESTADO='S' and OD.PAGADA=0 and PROCESADO=0

END
GO
DROP PROCEDURE IF EXISTS BUDGET.SP_ORDEN_CHANGE_PAID
GO
CREATE PROCEDURE BUDGET.SP_ORDEN_CHANGE_PAID
(
  @NUMPEDIDO VARCHAR(20)
)
AS
BEGIN
	UPDATE  BUDGET.ORDENPEDIDO_DETALLE SET
	PAGADA=1
	WHERE NUMPEDIDO=@NUMPEDIDO

END
go

--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE PROVEEDORES
--***************************************************************************************************************************************************************************************************************************************
DROP PROCEDURE IF EXISTS [BUDGET].[SP_PROVEEDORES_INSERT]
GO
CREATE PROCEDURE [BUDGET].[SP_PROVEEDORES_INSERT] (
	@Supplier NVARCHAR(MAX)		
 ) 
 
AS 
BEGIN 
	DECLARE @CODPROVEEDOR int  =(SELECT MAX(CODPROVEEDOR)+1 FROM PROVEEDORES),--calculados
	        --@VERSION timestamp  =CONVERT (TIME, CURRENT_TIMESTAMP),--calculados
	        @IVANODEDUCIBLE bit  =0,
	        @CANTPORTESPAG dbo.DFLOAT0 =0,--0
	        @CUOTAIVADEDUCIBLE bit =0,--0,
	        @COMPRARSINIMPUESTOS dbo.NDBOOLEANF='F',--,--f
	        @COMPRARIVAINCLUIDO dbo.NDBOOLEANF ='F',--,--f
	        @DTOCOMERCIAL dbo.DFLOAT0 =0,--0
	        @FECHAMODIFICADO datetime =GETDATE(),
	        @FACTURARCONIMPUESTO int =4,--4,
	        @RECC bit  =0,--0
	        @BLOQUEADO nvarchar(1) ='F',--f
	        @TIPODOCIDENT int =5,--5,
	        @ESPROVDELGRUPO bit =0,--0,
	        @DESCATALOGADO dbo.NDBOOLEANF ='F'--f
	
	DECLARE @CODCONTABLE nvarchar(12) ,
			@NOMPROVEEDOR nvarchar(255) ,
			@NOMCOMERCIAL nvarchar(255) ,
			@CIF nvarchar(12) ,
			@NIF20 nvarchar(20) ,
			@DIRECCION1 nvarchar(255) ,
			@PROVINCIA nvarchar(100) ,
			@PAIS nvarchar(100) ,
			@PERSONACONTACTO nvarchar(255) ,
			@TELEFONO1 nvarchar(15) ,
			@TELEFONO2 nvarchar(15) ,
			@FAX nvarchar(15) ,
			@E_MAIL nvarchar(255) ,
			@NUMCUENTA nvarchar(10) ,
			@CODBANCO nvarchar(4) ,
			@NOMBREBANCO nvarchar(255) ,
			@DIRECCIONBANCO nvarchar(255) ,
			@CODCONTABLECOMPRA nvarchar(12) ,
			@CODIGOIBAN nvarchar(100) ,
			@PERSONAJURIDICA nvarchar(1),
			@GIRONEGOCIO varchar(150),
			@TIPOIDENTIFICACION nvarchar(150),
			@MONEDA nvarchar(150),
			@CODIGOSWIFT nvarchar(150),
			@CODIGOABA nvarchar(150), 
			@POSICION nvarchar(150),
			@EMAILCONTACTO nvarchar(150),
			@CELULARCONTACTO nvarchar(150),
			@LISTANEGRA BIT,
			@FORMAPAGO nvarchar(350),
			@GIRO varchar(150)

	Select @CODCONTABLE=P.CODCONTABLE,
		   @NOMPROVEEDOR=P.NOMPROVEEDOR,
		   @NOMCOMERCIAL=P.NOMCOMERCIAL,
		   @CIF=P.CIF,
		   @NIF20=P.NIF20,
		   @DIRECCION1=P.DIRECCION1,
		   @PROVINCIA=P.PROVINCIA,
		   @PAIS=P.PAIS,
		   @PERSONACONTACTO=P.PERSONACONTACTO,
		   @TELEFONO1=P.TELEFONO1,
		   @TELEFONO2=P.TELEFONO2,
		   @FAX=P.FAX,
		   @E_MAIL=P.E_MAIL,
		   @NUMCUENTA=P.NUMCUENTA,
		   @CODBANCO=P.CODBANCO,
		   @NOMBREBANCO=P.NOMBREBANCO,
		   @DIRECCIONBANCO=P.DIRECCIONBANCO,
		   @CODCONTABLECOMPRA=P.CODCONTABLECOMPRA,
		   @CODIGOIBAN=P.CODIGOIBAN,
		   @PERSONAJURIDICA=P.PERSONAJURIDICA,
		   @GIRONEGOCIO =P.GIRONEGOCIO,
		   @TIPOIDENTIFICACION =P.TIPOIDENTIFICACION,
		   @MONEDA =P.MONEDA,
		   @CODIGOSWIFT =P.CODIGOSWIFT,
		   @CODIGOABA= P.CODIGOABA, 
		   @POSICION = P.POSICION,
		   @EMAILCONTACTO =P.EMAILCONTACTO,
		   @CELULARCONTACTO =P.CELULARCONTACTO,
		   @LISTANEGRA =P.LISTANEGRA,
		   @FORMAPAGO=P.FORMAPAGO
			From OPENJSON (@Supplier) WITH ( 
			CODCONTABLE nvarchar(12) ,
			NOMPROVEEDOR nvarchar(255) ,
			NOMCOMERCIAL nvarchar(255) ,
			CIF nvarchar(12) ,
			NIF20 nvarchar(20) ,
			DIRECCION1 nvarchar(255) ,
			PROVINCIA nvarchar(100) ,
			PAIS nvarchar(100) ,
			PERSONACONTACTO nvarchar(255) ,
			TELEFONO1 nvarchar(15) ,
			TELEFONO2 nvarchar(15) ,
			FAX nvarchar(15) ,
			E_MAIL nvarchar(255) ,
			NUMCUENTA nvarchar(10) ,
			CODBANCO nvarchar(4) ,
			NOMBREBANCO nvarchar(255) ,
			DIRECCIONBANCO nvarchar(255) ,
			CODCONTABLECOMPRA nvarchar(12) ,
			CODIGOIBAN nvarchar(100) ,
			PERSONAJURIDICA nvarchar(1),
		    GIRONEGOCIO nvarchar(150),
		    TIPOIDENTIFICACION nvarchar(150),
		    MONEDA nvarchar(150),
		    CODIGOSWIFT nvarchar(150),
		    CODIGOABA nvarchar(150), 
		    POSICION nvarchar(150),
		    EMAILCONTACTO nvarchar(150),
		    CELULARCONTACTO nvarchar(150),
		    LISTANEGRA BIT,
			FORMAPAGO nvarchar(350)
			) as P
 drop table if exists #tempProveedorBudget

 	Select* into #tempProveedorBudget
			From OPENJSON (@Supplier) WITH ( 
			CODCONTABLE nvarchar(12) ,
			NOMPROVEEDOR nvarchar(255) ,
			NOMCOMERCIAL nvarchar(255) ,
			CIF nvarchar(12) ,
			NIF20 nvarchar(20) ,
			DIRECCION1 nvarchar(255) ,
			PROVINCIA nvarchar(100) ,
			PAIS nvarchar(100) ,
			PERSONACONTACTO nvarchar(255) ,
			TELEFONO1 nvarchar(15) ,
			TELEFONO2 nvarchar(15) ,
			FAX nvarchar(15) ,
			E_MAIL nvarchar(255) ,
			NUMCUENTA nvarchar(10) ,
			CODBANCO nvarchar(4) ,
			NOMBREBANCO nvarchar(255) ,
			DIRECCIONBANCO nvarchar(255) ,
			CODCONTABLECOMPRA nvarchar(12) ,
			CODIGOIBAN nvarchar(100) ,
			PERSONAJURIDICA nvarchar(1),
		    GIRONEGOCIO nvarchar(150),
		    TIPOIDENTIFICACION nvarchar(150),
		    MONEDA nvarchar(150),
		    CODIGOSWIFT nvarchar(150),
		    CODIGOABA nvarchar(150), 
		    POSICION nvarchar(150),
		    EMAILCONTACTO nvarchar(150),
		    CELULARCONTACTO nvarchar(150),
		    LISTANEGRA BIT,
			FORMAPAGO nvarchar(350)
			) as P

      IF EXISTS(SELECT CODPROVEEDOR FROM PROVEEDORES WHERE NIF20 = @NIF20) 
      BEGIN 
            UPDATE [dbo].[PROVEEDORES] WITH (ROWLOCK) 
            SET      [CODCONTABLE] = @CODCONTABLE, 
                     [NOMPROVEEDOR] = @NOMPROVEEDOR, 
                     [NOMCOMERCIAL] = @NOMCOMERCIAL, 
                     [CIF] = @CIF, 
                     [NIF20] = @NIF20, 
                     [DIRECCION1] = @DIRECCION1, 
                     [PROVINCIA] = @PROVINCIA, 
                     [PAIS] = @PAIS, 
                     [PERSONACONTACTO] = @PERSONACONTACTO, 
                     [TELEFONO1] = @TELEFONO1, 
                     [TELEFONO2] = @TELEFONO2, 
                     [FAX] = @FAX,
                     [E_MAIL] = @E_MAIL, 
                     [NUMCUENTA] = @NUMCUENTA, 
                     [CODBANCO] = @CODBANCO, 
                     [NOMBREBANCO] = @NOMBREBANCO, 
                     [DIRECCIONBANCO] = @DIRECCIONBANCO, 
                     [CODCONTABLECOMPRA] = @CODCONTABLECOMPRA, 
                     [CODIGOIBAN] = @CODIGOIBAN, 
                     [PERSONAJURIDICA]=@PERSONAJURIDICA,
					 [CODSWIFT]=@CODIGOSWIFT
					 
                     
           WHERE 
            ( [NIF20] = @NIF20) 


      END 
      ELSE 
      BEGIN 
	     
          INSERT INTO [dbo].[PROVEEDORES] WITH (ROWLOCK)   ( 
           CODPROVEEDOR,--calculados
           CODCONTABLE,
		   NOMPROVEEDOR,
		   NOMCOMERCIAL,
		   CIF,
		   NIF20,
		   DIRECCION1,
		   PROVINCIA,
		   PAIS,
		   PERSONACONTACTO,
		   TELEFONO1,
		   TELEFONO2,
		   FAX,
		   E_MAIL,
		   NUMCUENTA,
		   CODBANCO,
		   NOMBREBANCO,
		   DIRECCIONBANCO,
		   CODCONTABLECOMPRA,
		   CODIGOIBAN,
		   PERSONAJURIDICA,
		   --VERSION,--calculados
		   IVANODEDUCIBLE,--0
		   CANTPORTESPAG,--0
		   CUOTAIVADEDUCIBLE,--0,
		   COMPRARSINIMPUESTOS,--f
		   COMPRARIVAINCLUIDO,--f
		   DTOCOMERCIAL,--0
		   FECHAMODIFICADO,
		   FACTURARCONIMPUESTO,--4,
		   RECC,--0
		   BLOQUEADO,--f
		   TIPODOCIDENT,--5,
		   ESPROVDELGRUPO,--0,
		   DESCATALOGADO,
		   CODSWIFT--f
      ) 
      VALUES ( 
           @CODPROVEEDOR,--calculados
           @CODCONTABLE,
		   @NOMPROVEEDOR,
		   @NOMCOMERCIAL,
		   @CIF,
		   @NIF20,
		   @DIRECCION1,
		   @PROVINCIA,
		   @PAIS,
		   @PERSONACONTACTO,
		   @TELEFONO1,
		   @TELEFONO2,
		   @FAX,
		   @E_MAIL,
		   @NUMCUENTA,
		   @CODBANCO,
		   @NOMBREBANCO,
		   @DIRECCIONBANCO,
		   @CODCONTABLECOMPRA,
		   @CODIGOIBAN,
		   @PERSONAJURIDICA,
		   --@VERSION,--calculados
		   @IVANODEDUCIBLE,--0
		   @CANTPORTESPAG,--0
		   @CUOTAIVADEDUCIBLE,--0,
		   @COMPRARSINIMPUESTOS,--f
		   @COMPRARIVAINCLUIDO,--f
		   @DTOCOMERCIAL,--0
		   @FECHAMODIFICADO,
		   @FACTURARCONIMPUESTO,--4,
		   @RECC,--0
		   @BLOQUEADO,--f
		   @TIPODOCIDENT,--5,
		   @ESPROVDELGRUPO,--0,
		   @DESCATALOGADO,
		   @CODIGOSWIFT--f 
 
      ) 
      END 

	  DECLARE @VCOD_PROVEEDOR INT;

	  SELECT @VCOD_PROVEEDOR=CODPROVEEDOR FROM PROVEEDORES WHERE NIF20 = @NIF20;
	 

	  IF EXISTS(SELECT * FROM CONTACTOSPROVEEDORES WHERE CODPROVEEDOR=@VCOD_PROVEEDOR AND UPPER(NOMBRE)=UPPER(@PERSONACONTACTO))
	  BEGIN 
			UPDATE CONTACTOSPROVEEDORES SET 
			NOMBRE=@PERSONACONTACTO,
			TELEFONO=@CELULARCONTACTO,
			E_MAIL=@EMAILCONTACTO,
			MOBIL=@CELULARCONTACTO
			WHERE CODPROVEEDOR=@VCOD_PROVEEDOR AND UPPER(NOMBRE)=UPPER(@PERSONACONTACTO)
			
			select * from CONTACTOSPROVEEDORES
	  END

	  

	  ELSE 
	  BEGIN 
		INSERT INTO CONTACTOSPROVEEDORES(CARGO,NOMBRE,TELEFONO,E_MAIL,FACTURACION, TESORERIA, MOBIL) VALUES
										('.',@PERSONACONTACTO,@CELULARCONTACTO,@EMAILCONTACTO,0,0,@CELULARCONTACTO)
	  END;

	  IF EXISTS(SELECT * FROM PROVEEDORESCAMPOSLIBRES WHERE CODPROVEEDOR=@VCOD_PROVEEDOR)
	  BEGIN 
			UPDATE PROVEEDORESCAMPOSLIBRES SET 
				GiroNegocio=(select GiroNegocio from #tempProveedorBudget),
				CodigoAba=(select CODIGOABA from #tempProveedorBudget)
			WHERE CODPROVEEDOR= @VCOD_PROVEEDOR
	  END
	  ELSE 
	  BEGIN 
		INSERT INTO PROVEEDORESCAMPOSLIBRES(CODPROVEEDOR,GiroNegocio) VALUES
										(@VCOD_PROVEEDOR,@GIRONEGOCIO)
	  END;

	   DECLARE @VCODFORMAPAGO INT;

	 
	   SELECT @VCODFORMAPAGO=CODFORMAPAGO FROM FORMASPAGO WHERE UPPER(DESCRIPCION)=UPPER(@FORMAPAGO);

	  IF NOT  EXISTS(SELECT* FROM FPAGOPROVEEDOR WHERE CODPROVEEDOR=@VCOD_PROVEEDOR)
	  BEGIN 
	   print 'f'
	   INSERT INTO FPAGOPROVEEDOR (CODPROVEEDOR,TIPO,CODFORMAPAGO,CODDTOPP,DTOPP, CANTIDAD,SERIE) VALUES
	   (@VCOD_PROVEEDOR, 'Por Defecto',@VCODFORMAPAGO,2,0,0,'')
	   
	  END
	  ELSE
	  BEGIN
	  print 'f'
	  UPDATE FPAGOPROVEEDOR SET 
	  CODFORMAPAGO=@VCODFORMAPAGO
	  WHERE CODPROVEEDOR=@VCOD_PROVEEDOR
	  END;
	
END;
 
GO

--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE ALMECEN/CENTRO DE COSTOS
--***************************************************************************************************************************************************************************************************************************************
DROP TABLE IF EXISTS [BUDGET].[ALMACENESENVIADOSBUDGET]
GO
CREATE TABLE [BUDGET].[ALMACENESENVIADOSBUDGET](
	[CODALMACEN] [nvarchar](3) NOT NULL,
	[ENVIADO] [bit] NULL
) ON [PRIMARY]
GO
DROP Procedure IF EXISTS [BUDGET].[SP_ALMACEN_OBTENER]
GO
CREATE Procedure [BUDGET].[SP_ALMACEN_OBTENER]
(
@IdEmpresa varchar(20)
)
AS
BEGIN
	select A.CodAlmacen,NombreAlmacen as Descripcion,CentroCoste,E.ENVIADO Enviado_Budget, @IdEmpresa as IdEmpresa from almacen  A
	inner join BUDGET.ALMACENESENVIADOSBUDGET E ON A.CODALMACEN COLLATE Modern_Spanish_CI_AS=E.CODALMACEN
		where nullif(CENTROCOSTE,'') is not null AND E.ENVIADO=0
END
GO
DROP Procedure IF EXISTS [BUDGET].[SP_EstadoCentroCostos_Modificar]
GO
CREATE Procedure [BUDGET].[SP_EstadoCentroCostos_Modificar]
(

	@CodAlmacen varchar(3) 
)
As
Begin
	
	Update ALMACENESENVIADOSBUDGET set 
	ENVIADO=1
	Where CODALMACEN=@CodAlmacen
	
End
GO
DROP TRIGGER IF Exists [dbo].[TR_CENTROCOSTOS_BUDGET_CHANGE_SAVE]
GO
CREATE  TRIGGER [dbo].[TR_CENTROCOSTOS_BUDGET_CHANGE_SAVE] ON [dbo].[ALMACEN]
   AFTER INSERT
   AS
     DECLARE @SPID INT;
     BEGIN
         SET NOCOUNT ON;
         SELECT @SPID=SPID FROM CONTROLTRIGGERS WHERE SPID=@@SPID AND [TRIGGER]='TR_CENTROCOSTOS_CHANGE';
         IF (@SPID IS NULL)
         BEGIN
            INSERT INTO BUDGET.ALMACENESENVIADOSBUDGET (CODALMACEN, ENVIADO)
				 SELECT CODALMACEN,0 FROM inserted
         END;
         SET NOCOUNT OFF;
     END
GO
ALTER TABLE [dbo].[ALMACEN] ENABLE TRIGGER [TR_CENTROCOSTOS_BUDGET_CHANGE_SAVE]
GO
DROP TRIGGER IF Exists [dbo].[TR_CENTROCOSTOS_BUDGET_CHANGE]
GO
CREATE  TRIGGER [dbo].[TR_CENTROCOSTOS_BUDGET_CHANGE] ON [dbo].[ALMACEN]
   FOR UPDATE
   AS
     DECLARE @SPID INT;
     BEGIN
         SET NOCOUNT ON;
         SELECT @SPID=SPID FROM CONTROLTRIGGERS WHERE SPID=@@SPID AND [TRIGGER]='TR_CENTROCOSTOS_CHANGE';
         IF (@SPID IS NULL)
         BEGIN
            UPDATE BUDGET.ALMACENESENVIADOSBUDGET SET ENVIADO = 0 WHERE CODALMACEN COLLATE Modern_Spanish_CI_AS IN ( SELECT CODALMACEN FROM INSERTED )
         END;
         SET NOCOUNT OFF;
     END
GO
ALTER TABLE [dbo].[ALMACEN] ENABLE TRIGGER [TR_CENTROCOSTOS_BUDGET_CHANGE]
GO
--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE CUENTA CONTABLE
--***************************************************************************************************************************************************************************************************************************************
DROP Procedure IF Exists [BUDGET].[SP_CUENTACONTABLE_OBTENER]
GO
CREATE procedure [BUDGET].[SP_CUENTACONTABLE_OBTENER]
(
@IdEmpresa varchar(20)
)
AS
BEGIN
	select distinct codcontable, @IdEmpresa AS IdEmpresa from proveedores
END
GO


--***************************************************************************************************************************************************************************************************************************************
----------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE PRODUCTOS
--***************************************************************************************************************************************************************************************************************************************

DROP TABLE IF Exists [BUDGET].[ARTICULOSENVIADOSBUDGET]
GO
CREATE TABLE [BUDGET].[ARTICULOSENVIADOSBUDGET](
	[CODARTICULO] [int] NOT NULL,
	[ENVIADO] [bit] NULL
) ON [PRIMARY]
GO
DROP TRIGGER IF Exists [dbo].[TR_ARTICULOS_BUDGET_CHANGE]
GO
CREATE  TRIGGER [dbo].[TR_ARTICULOS_BUDGET_CHANGE] ON [dbo].[ARTICULOS]
   FOR UPDATE, INSERT
   AS
     DECLARE @SPID INT;
     BEGIN
         SET NOCOUNT ON;
         SELECT @SPID=SPID FROM CONTROLTRIGGERS WHERE SPID=@@SPID AND [TRIGGER]='TR_ARTICULOS_BUDGET_CHANGE';
         IF (@SPID IS NULL)
         BEGIN
            INSERT INTO BUDGET.ARTICULOSENVIADOSBUDGET (CODARTICULO,ENVIADO) 
			SELECT CODARTICULO,0 FROM INSERTED 
         END;
         SET NOCOUNT OFF;
     END
GO
ALTER TABLE [dbo].[ARTICULOS] ENABLE TRIGGER [TR_ARTICULOS_BUDGET_CHANGE]
GO
DROP Procedure IF Exists [BUDGET].[SP_ARTICULOSICG_OBTENER]
GO
CREATE procedure [BUDGET].[SP_ARTICULOSICG_OBTENER](
@IdEmpresa varchar(20) 
)
AS
BEGIN
SELECT A.CODARTICULO,A.DESCRIPCION, A.REFPROVEEDOR,AC.ENVIADO Enviado_Budget,@IdEmpresa AS IDEMPRESA  ,I.IVA AS IMPUESTO  
FROM ARTICULOS A
	INNER JOIN BUDGET.ARTICULOSENVIADOSBUDGET AC ON A.CODARTICULO=AC.CODARTICULO
	INNER JOIN IMPUESTOS I ON A.IMPUESTOCOMPRA=I.TIPOIVA
	WHERE A.TIPOARTICULO='G' AND AC.ENVIADO=0
END
GO
DROP Procedure IF Exists [BUDGET].[SP_EstadoProducts_Modificar]
GO
CREATE Procedure [BUDGET].[SP_EstadoProducts_Modificar]
(

	@CodArticulo int 
)
As
Begin
	
	Update ARTICULOSENVIADOSBUDGET set 
	ENVIADO=1
	Where CODARTICULO=@CodArticulo
	
End
GO
--***************************************************************************************************************************************************************************************************************************************
------------------------------------------------------------------------------------SCRIPTSD PARA SERVICIO DE SOCIEDADES
--***************************************************************************************************************************************************************************************************************************************
use general 
go
IF NOT EXISTS (SELECT schema_id FROM GENERAL.sys.schemas WHERE name = 'BUDGET')
	EXEC('Create Schema BUDGET')
GO
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_CATALOG='GENERAL' and table_name = 'EMPRESAS' AND table_schema = 'dbo' AND column_name = 'ENVIADO_BUDGET')  
ALTER TABLE GENERAL.DBO.EMPRESAS ADD  ENVIADO_BUDGET BIT
GO
DROP TRIGGER IF Exists [dbo].[tr_cambiarESTADO]
GO
CREATE TRIGGER [dbo].[tr_cambiarESTADO] ON [dbo].[EMPRESAS]
    AFTER INSERT,UPDATE
    AS
    BEGIN
      UPDATE EMPRESAS
      SET ENVIADO_BUDGET=0
      FROM inserted
      WHERE EMPRESAS.CODEMPRESA = inserted.CODEMPRESA;
    END
GO
ALTER TABLE [dbo].[EMPRESAS] ENABLE TRIGGER [tr_cambiarESTADO]
GO
DROP Procedure IF Exists BUDGET.SP_Sociedad_Consulta
GO
CREATE Procedure BUDGET.SP_Sociedad_Consulta
As
Begin
	select nombrecomercial AS Name,NOMBRECOMERCIAL as Description,CIF as Value_Identification, CODEMPRESA from GENERAL.DBO.EMPRESAS
	where nullif(CIF,'') is not null AND ENVIADO_BUDGET=0
End
GO
DROP PROCEDURE IF Exists BUDGET.SP_EstadoSociedades_Modificar
GO
CREATE Procedure BUDGET.SP_EstadoSociedades_Modificar
(

	@CodEmpresa int 
)
As
Begin
	
	Update EMPRESAS set 
	ENVIADO_BUDGET=1
	Where CODEMPRESA=@CodEmpresa 
	
End
GO
--*************************************************************************************************************************************************************
----**********************************************************************NO EJECUTAR EN PRODUCCION*****************************************************************
USE OLDNAVY_2
GO

--
select * from BUDGET.ALMACENESENVIADOSBUDGET
INSERT INTO BUDGET.ALMACENESENVIADOSBUDGET (CODALMACEN,ENVIADO)
SELECT CODALMACEN,0 AS 'Enviado' FROM ALMACEN A
	

INSERT INTO BUDGET.ARTICULOSENVIADOSBUDGET (CODARTICULO,ENVIADO)
SELECT CODARTICULO,0 AS 'Enviado' FROM ARTICULOS A
	WHERE A.TIPOARTICULO='G' 


