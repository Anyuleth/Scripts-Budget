USE BUDGET
DROP TABLE CARGAARTICULOS
GO
CREATE TABLE CARGAARTICULOS(
NOMBRE	 varchar(300),
CATEGORIA				 varchar(300),
SUBCATEGORIA			 varchar(300),
TIPO					 varchar(300),
Budget					 varchar(300),
CuentaContable        	 varchar(300)
)
GO
BULK INSERT CARGAARTICULOS
FROM 'C:\ListaART.csv'
WITH (FIRSTROW = 2,
     CODEPAGE = '65001',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR='\n' );
GO
--DELETE FROM BUD_MTR_CATEGORY
INSERT INTO  BUD_MTR_CATEGORY (DESCRIPTION,ACTIVE)
select distinct CATEGORIA,1 from CARGAARTICULOS
GO
--SELECT * FROM BUD_MTR_SUBCATEGORY
INSERT INTO BUD_MTR_SUBCATEGORY(PK_BUD_MTR_CATEGORY,DESCRIPTION,ACTIVE)
select distinct CC.PK_BUD_MTR_CATEGORY, SUBCATEGORIA,1 from CARGAARTICULOS C
INNER JOIN BUD_MTR_CATEGORY CC ON  CC.DESCRIPTION=C.CATEGORIA
GO
--DELETE FROM BUD_MTR_TYPE
INSERT INTO BUD_MTR_TYPE(DESCRIPTION,ACTIVE)
select distinct TIPO,1 from CARGAARTICULOS
--INSERTAR ARTICULOS
INSERT INTO BUD_MTR_PRODUCT (CREATION_DATE,CREATION_USER,MODIFICATION_DATE,MODIFICATION_USER,NAME,ACTIVE,CODARTICULO,FK_BUD_MTR_CATEGORY,FK_BUD_MTR_SUBCATEGORY,FK_BUD_MTR_TYPE,FK_STATUS)
select '2021-07-28 09:04:09.390','Anyuleth Cort?s C?rdenas','2021-07-28 09:04:09.390','Anyuleth Cort?s C?rdenas',CONCAT(NOMBRE, ' - ', SUBCATEGORIA )  AS NME,1,20,
C.PK_BUD_MTR_CATEGORY,S.PK_BUD_MTR_SUBCATEGORY,T.PK_BUD_MTR_TYPE,1
from CARGAARTICULOS A
INNER JOIN BUD_MTR_CATEGORY C ON lower(A.CATEGORIA)=lower(C.DESCRIPTION)
INNER JOIN BUD_MTR_SUBCATEGORY S ON lower(A.SUBCATEGORIA)=lower(S.DESCRIPTION)
INNER JOIN BUD_MTR_TYPE T ON lower(A.TIPO)=lower(T.DESCRIPTION)

alter table BUD_MTR_PRODUCT drop column FK_GBL_CAT_CATALOG_PRODUCT_TYPE

alter table BUD_MTR_PRODUCT drop column FK_GBL_CAT_CATALOG_CATEGORY_TYPE

alter table BUD_MTR_PRODUCT drop column FK_BUD_MTR_ACCOUNT

alter table BUD_MTR_PRODUCT drop column CODE
CODE

select ,* from BUD_MTR_PRODUCT

select * from GLB_CAT_CATALOG 

select * from CARGAARTICULOS