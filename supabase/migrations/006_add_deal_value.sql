-- Sprint 6: Revenue y Monetización
-- Agrega monto de venta y moneda al cliente

ALTER TABLE clients ADD COLUMN deal_value NUMERIC(12,2);
ALTER TABLE clients ADD COLUMN currency   TEXT DEFAULT 'ARS';
