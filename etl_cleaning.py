import pandas as pd
import unicodedata
import pyodbc

# =============================================================
# 1. CATEGORY
# =============================================================
df_category = pd.read_csv('D:/archive/product_category_name_translation.csv')

print("--- CATEGORY ---")
print(df_category.shape)
print(df_category.dtypes)
print(df_category.isnull().sum())
print(df_category.duplicated().sum())

df_category.to_csv(
    'D:/archive/clean/olist_category_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 2. CUSTOMERS
# zip_code_prefix loaded as str to preserve leading zeros
# =============================================================
df_customers = pd.read_csv(
    'D:/archive/olist_customers_dataset.csv',
    dtype={'customer_zip_code_prefix': str}
)

print("--- CUSTOMERS ---")
print(df_customers.shape)
print(df_customers.dtypes)
print(df_customers.isnull().sum())
print(df_customers.duplicated().sum())

df_customers.to_csv(
    'D:/archive/clean/olist_customers_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 3. GEOLOCATION
# - Removed 261,831 duplicate rows
# - Cleaned city names: removed comma-separated values,
#   normalized accents and casing
# - zip_code_prefix loaded as str to preserve leading zeros
# =============================================================
df_geolocation = pd.read_csv(
    'D:/archive/olist_geolocation_dataset.csv',
    dtype={'geolocation_zip_code_prefix': str}
)

print("--- GEOLOCATION ---")
print(df_geolocation.shape)
print(df_geolocation.dtypes)
print(df_geolocation.isnull().sum())
print(df_geolocation.duplicated().sum())

# Remove duplicates
df_geolocation = df_geolocation.drop_duplicates()

# Fix comma-separated city names
df_geolocation['geolocation_city'] = df_geolocation['geolocation_city'].str.split(',').str[0]

# Normalize city names: lowercase, strip accents
def normalizar(texto):
    if pd.isna(texto):
        return texto
    texto = texto.lower().strip()
    texto = unicodedata.normalize('NFKD', texto)
    texto = ''.join(c for c in texto if not unicodedata.combining(c))
    return texto

df_geolocation['geolocation_city'] = df_geolocation['geolocation_city'].apply(normalizar)

# Fix known bad values
df_geolocation['geolocation_city'] = df_geolocation['geolocation_city'].replace({
    'saopaulo': 'sao paulo',
    'sp': 'sao paulo',
    'sa£o paulo': 'sao paulo'
})

df_geolocation.to_csv(
    'D:/archive/clean/olist_geolocation_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 4. SELLERS
# zip_code_prefix loaded as str to preserve leading zeros
# Fixed comma-separated city names
# =============================================================
df_sellers = pd.read_csv(
    'D:/archive/olist_sellers_dataset.csv',
    dtype={'seller_zip_code_prefix': str}
)

print("--- SELLERS ---")
print(df_sellers.shape)
print(df_sellers.dtypes)
print(df_sellers.isnull().sum())
print(df_sellers.duplicated().sum())

df_sellers['seller_city'] = df_sellers['seller_city'].str.split(',').str[0]

df_sellers.to_csv(
    'D:/archive/clean/olist_sellers_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 5. PRODUCTS
# - Filled missing product_category_name with 'unknown'
# - Kept numeric nulls as NULL (no invented values)
# - Converted numeric columns to Int64 (supports nulls)
# =============================================================
df_products = pd.read_csv('D:/archive/olist_products_dataset.csv')

print("--- PRODUCTS ---")
print(df_products.shape)
print(df_products.dtypes)
print(df_products.isnull().sum())
print(df_products.duplicated().sum())

df_products['product_category_name'] = df_products['product_category_name'].fillna('unknown')

cols_int = ['product_name_lenght', 'product_description_lenght',
            'product_photos_qty', 'product_weight_g',
            'product_length_cm', 'product_height_cm', 'product_width_cm']

df_products[cols_int] = df_products[cols_int].astype('Int64')

df_products.to_csv(
    'D:/archive/clean/olist_products_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 6. ORDERS
# - Date columns converted to datetime
# - Null dates kept as NULL (valid: cancelled/pending orders)
# =============================================================
df_orders = pd.read_csv('D:/archive/olist_orders_dataset.csv')

print("--- ORDERS ---")
print(df_orders.shape)
print(df_orders.dtypes)
print(df_orders.isnull().sum())
print(df_orders.duplicated().sum())

df_orders['order_purchase_timestamp'] = pd.to_datetime(df_orders['order_purchase_timestamp'])
df_orders['order_estimated_delivery_date'] = pd.to_datetime(df_orders['order_estimated_delivery_date'])
df_orders['order_approved_at'] = pd.to_datetime(df_orders['order_approved_at'], errors='coerce')
df_orders['order_delivered_carrier_date'] = pd.to_datetime(df_orders['order_delivered_carrier_date'], errors='coerce')
df_orders['order_delivered_customer_date'] = pd.to_datetime(df_orders['order_delivered_customer_date'], errors='coerce')

df_orders.to_csv(
    'D:/archive/clean/olist_orders_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 7. ORDER ITEMS
# - shipping_limit_date converted to datetime
# =============================================================
df_order_items = pd.read_csv('D:/archive/olist_order_items_dataset.csv')

print("--- ORDER ITEMS ---")
print(df_order_items.shape)
print(df_order_items.dtypes)
print(df_order_items.isnull().sum())
print(df_order_items.duplicated().sum())

df_order_items['shipping_limit_date'] = pd.to_datetime(df_order_items['shipping_limit_date'])

df_order_items.to_csv(
    'D:/archive/clean/olist_order_items_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 8. ORDER PAYMENTS
# =============================================================
df_order_payments = pd.read_csv('D:/archive/olist_order_payments_dataset.csv')

print("--- ORDER PAYMENTS ---")
print(df_order_payments.shape)
print(df_order_payments.dtypes)
print(df_order_payments.isnull().sum())
print(df_order_payments.duplicated().sum())

df_order_payments.to_csv(
    'D:/archive/clean/olist_order_payments_clean.csv',
    index=False,
    quoting=0,
    lineterminator='\r\n'
)

# =============================================================
# 9. REVIEWS
# - Removed newlines from comment fields
# - Date columns formatted as string for SQL Server compatibility
# - Loaded directly to SQL Server via pyodbc (BULK INSERT failed
#   due to special characters in Portuguese text)
# =============================================================
df_reviews = pd.read_csv('D:/archive/olist_order_reviews_dataset.csv')

print("--- REVIEWS ---")
print(df_reviews.shape)
print(df_reviews.dtypes)
print(df_reviews.isnull().sum())
print(df_reviews.duplicated().sum())

df_reviews['review_comment_title'] = df_reviews['review_comment_title'].str.replace('\n', ' ', regex=False).str.replace('\r', ' ', regex=False)
df_reviews['review_comment_message'] = df_reviews['review_comment_message'].str.replace('\n', ' ', regex=False).str.replace('\r', ' ', regex=False)

df_reviews['review_creation_date'] = pd.to_datetime(df_reviews['review_creation_date'])
df_reviews['review_answer_timestamp'] = pd.to_datetime(df_reviews['review_answer_timestamp'])

df_reviews['review_creation_date'] = df_reviews['review_creation_date'].dt.strftime('%Y-%m-%d %H:%M:%S')
df_reviews['review_answer_timestamp'] = df_reviews['review_answer_timestamp'].dt.strftime('%Y-%m-%d %H:%M:%S')

# Load reviews directly to SQL Server
conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=.;'
    'DATABASE=olist_ecommerce;'
    'Trusted_Connection=yes;'
)

cursor = conn.cursor()

for _, row in df_reviews.iterrows():
    cursor.execute("""
        INSERT INTO reviews VALUES (?, ?, ?, ?, ?, ?, ?)
    """,
    row['review_id'],
    row['order_id'],
    row['review_score'],
    row['review_comment_title'] if pd.notna(row['review_comment_title']) else None,
    row['review_comment_message'] if pd.notna(row['review_comment_message']) else None,
    row['review_creation_date'],
    row['review_answer_timestamp']
    )

conn.commit()
cursor.close()
conn.close()
print("Reviews loaded successfully!")

print("=== ETL PIPELINE COMPLETED ===")
