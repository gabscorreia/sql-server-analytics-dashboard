CREATE OR ALTER PROCEDURE sp_processar_carga_vendedor
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO tb_vendedor (
            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        )
        SELECT DISTINCT
            LTRIM(RTRIM(seller_id)),
            LTRIM(RTRIM(seller_zip_code_prefix)),
            LTRIM(RTRIM(seller_city)),
            UPPER(LTRIM(RTRIM(seller_state)))
        FROM stg_sellers
        WHERE seller_id IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM tb_vendedor v WHERE v.seller_id = LTRIM(RTRIM(seller_id))
          );

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