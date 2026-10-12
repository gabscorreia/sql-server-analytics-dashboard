CREATE PROCEDURE sp_processar_carga_orders
AS
BEGIN
    SET NOCOUNT ON;

    
    CREATE TABLE #stg_orders (
        order_id VARCHAR(50),
        customer_id VARCHAR(50),
        order_status VARCHAR(50),
        order_purchase_timestamp VARCHAR(50),
        order_approved_at VARCHAR(50),
        order_delivered_carrier_date VARCHAR(50),
        order_delivered_customer_date VARCHAR(50),
        order_estimated_delivery_date VARCHAR(50)
    );

   
    BEGIN TRY
        BEGIN TRANSACTION;

        
        INSERT INTO tb_pedido (
            order_id,
            customer_id,
            order_status,
            purchase_timestamp,
            approved_at,
            delivered_carrier_date,
            delivered_customer_date,
            estimated_delivery_date,
            lead_time_dias
        )
        SELECT 
            LTRIM(RTRIM(order_id)),
            LTRIM(RTRIM(customer_id)),
            LOWER(LTRIM(RTRIM(order_status))),
            TRY_CAST(order_purchase_timestamp AS DATETIME),
            TRY_CAST(order_approved_at AS DATETIME),
            TRY_CAST(order_delivered_carrier_date AS DATETIME),
            TRY_CAST(order_delivered_customer_date AS DATETIME),
            TRY_CAST(order_estimated_delivery_date AS DATETIME),
            -- Cálculo automatizado de Lead Time estimado vs realizado
            DATEDIFF(day, TRY_CAST(order_purchase_timestamp AS DATETIME), TRY_CAST(order_delivered_customer_date AS DATETIME))
        FROM #stg_orders
        WHERE order_id IS NOT NULL 
          AND order_status IS NOT NULL;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH;

END;
