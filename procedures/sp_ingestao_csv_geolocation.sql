IF OBJECT_ID('stg_geolocation', 'U') IS NOT NULL
    DROP TABLE stg_geolocation;
GO

CREATE TABLE stg_geolocation (
    geolocation_zip_code_prefix NVARCHAR(10),
    geolocation_lat NVARCHAR(50),
    geolocation_lng NVARCHAR(50),
    geolocation_city NVARCHAR(100),
    geolocation_state NVARCHAR(10)
);
GO


BULK INSERT stg_geolocation
FROM 'C:\Users\Cleidemar Pc\Documents\GitHub\sql-server-analytics-dashboard\datasets_Olist\olist_geolocation_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', -- Representação hexadecimal universal para quebras de linha (\n)
    CODEPAGE = '65001',
    TABLOCK
);
GO


CREATE OR ALTER PROCEDURE sp_processar_carga_geolocalizacao
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

       
        INSERT INTO tb_geolocalizacao (
            zip_code_prefix,
            latitude,
            longitude,
            city,
            state
        )
        SELECT DISTINCT 
            LTRIM(RTRIM(geolocation_zip_code_prefix)),
            TRY_CAST(REPLACE(geolocation_lat, ',', '.') AS DECIMAL(10, 8)),
            TRY_CAST(REPLACE(geolocation_lng, ',', '.') AS DECIMAL(11, 8)),
            LTRIM(RTRIM(geolocation_city)),
            UPPER(LTRIM(RTRIM(geolocation_state)))
        FROM stg_geolocation
        WHERE geolocation_zip_code_prefix IS NOT NULL;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH;
END;
GO


EXEC sp_processar_carga_geolocalizacao;
GO