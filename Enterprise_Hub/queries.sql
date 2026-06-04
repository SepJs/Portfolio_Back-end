-- ====================================================================
-- THE ENTERPRISE HIGH-VALUE RISK MATRIX (Advanced Analytics)
-- Description: Rank users by total revenue, calculate transaction percentage
-- shares using Window Functions, and correlate financial profiles with 
-- active security flags/failures to isolate high-value risky accounts.
-- ====================================================================

WITH UserFinancialSummary AS (
    -- Step 1: Aggregate all financial records per user and calculate metrics
    SELECT 
        o.user_id,
        COUNT(o.id) AS total_orders_placed,
        SUM(o.total_price) AS lifetime_value,
        AVG(o.total_price) AS average_order_value
    FROM orders o
    WHERE o.status = 'PAID'
    GROUP BY o.user_id
),
SecurityRiskProfiler AS (
    -- Step 2: Extract security red-flags and brute-force indicators per user
    SELECT 
        sl.user_id,
        COUNT(sl.id) AS security_incident_count
    FROM security_logs sl
    WHERE sl.action_type IN ('LOGIN_FAILED', 'MFA_BYPASS_ATTEMPT')
    GROUP BY sl.user_id
)

-- Step 3: Combine Financial Data with Security profiles and apply Window Functions
SELECT 
    u.id AS user_id,
    u.username,
    u.email,
    COALESCE(f.lifetime_value, 0.00) AS total_spent,
    
    -- Window Function 1: Rank users dynamically based on their total financial spending
    DENSE_RANK() OVER (ORDER BY COALESCE(f.lifetime_value, 0.00) DESC) AS customer_revenue_rank,
    
    -- Window Function 2: Calculate the percentage of this user's spending against the TOTAL school/store platform revenue
    ROUND(
        (COALESCE(f.lifetime_value, 0.00) / SUM(COALESCE(f.lifetime_value, 0.00)) OVER()) * 100, 
        2
    ) AS percentage_of_global_revenue,
    
    COALESCE(f.average_order_value, 0.00) AS avg_invoice_amount,
    COALESCE(s.security_incident_count, 0) AS raw_security_incidents,
    
    -- Conditional Flagging: Mark accounts that are high-value but have high security incidents
    CASE 
        WHEN f.lifetime_value > 200.00 AND s.security_incident_count > 3 THEN 'CRITICAL RISK / HIGH VALUE'
        WHEN s.security_incident_count > 0 THEN 'MONITOR COMPROMISE'
        ELSE 'SECURE / STABLE'
    END AS account_security_status

FROM users u
LEFT JOIN UserFinancialSummary f ON u.id = f.user_id
LEFT JOIN SecurityRiskProfiler s ON u.id = s.user_id
ORDER BY total_spent DESC;