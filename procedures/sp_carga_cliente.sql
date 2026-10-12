CREATE OR ALTER PROCEDURE sp_processar_carga_cliente
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO tb_cliente (
            customer_id,
            customer_unique_id,
            customer_zip_code_prefix,
            customer_city,
            customer_state
        )
        SELECT DISTINCT
            LTRIM(RTRIM(customer_id)),
            LTRIM(RTRIM(customer_unique_id)),
            LTRIM(RTRIM(customer_zip_code_prefix)),
            LTRIM(RTRIM(customer_city)),
            UPPER(LTRIM(RTRIM(customer_state)))
        FROM stg_customers
        WHERE customer_id IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM tb_cliente c WHERE c.customer_id = LTRIM(RTRIM(customer_id))
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