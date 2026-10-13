CREATE OR ALTER PROCEDURE sp_processar_carga_item_pedido
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO tb_item_pedido (
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value
        )
        SELECT DISTINCT
            LTRIM(RTRIM(order_id)),
            TRY_CAST(order_item_id AS INT),
            LTRIM(RTRIM(product_id)),
            LTRIM(RTRIM(seller_id)),
            TRY_CAST(shipping_limit_date AS DATETIME2),
            TRY_CAST(REPLACE(price, ',', '.') AS DECIMAL(10,2)),
            TRY_CAST(REPLACE(freight_value, ',', '.') AS DECIMAL(10,2))
        FROM stg_items
        WHERE order_id IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM tb_item_pedido i 
              WHERE i.order_id = LTRIM(RTRIM(order_id)) 
                AND i.order_item_id = TRY_CAST(order_item_id AS INT)
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