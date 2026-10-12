CREATE OR ALTER PROCEDURE sp_processar_carga_produto
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO tb_produto (
            product_id,
            product_category_name,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm
        )
        SELECT DISTINCT
            LTRIM(RTRIM(product_id)),
            LTRIM(RTRIM(product_category_name)),
            TRY_CAST(product_name_lenght AS INT),
            TRY_CAST(product_description_lenght AS INT),
            TRY_CAST(product_photos_qty AS INT),
            TRY_CAST(product_weight_g AS INT),
            TRY_CAST(product_length_cm AS INT),
            TRY_CAST(product_height_cm AS INT),
            TRY_CAST(product_width_cm AS INT)
        FROM stg_products
        WHERE product_id IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM tb_produto p WHERE p.product_id = LTRIM(RTRIM(product_id))
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