CREATE OR ALTER PROCEDURE sp_processar_carga_pagamento
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO tb_pagamento (
            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            payment_value
        )
        SELECT DISTINCT
            LTRIM(RTRIM(order_id)),
            TRY_CAST(payment_sequential AS INT),
            LTRIM(RTRIM(payment_type)),
            TRY_CAST(payment_installments AS INT),
            TRY_CAST(REPLACE(payment_value, ',', '.') AS DECIMAL(10,2))
        FROM stg_payments
        WHERE order_id IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM tb_pagamento p 
              WHERE p.order_id = LTRIM(RTRIM(order_id)) 
                AND p.payment_sequential = TRY_CAST(payment_sequential AS INT)
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