class DbTablesUtils {
  static const String myCompany = "my_company";
  static const String customers = "customers";
  static const String products = "products";
  static const String productsSell = "products_sell";
  static const String sales = "sales";
  static const String sellPaymentDate = "sell_payment_date";

  static const String createTableQueryMyCompany = '''
  CREATE TABLE IF NOT EXISTS $myCompany (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  company_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  cnpj TEXT NOT NULL,
  cpf TEXT NOT NULL,
  street TEXT NOT NULL,
  number INTEGER,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  complement TEXT NOT NULL,
  zip_code TEXT NOT NULL,
  neighborhood TEXT NOT NULL,
  pix_destination TEXT NOT NULL,
  pix_key TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
''';

  static const String createTableQueryCustomers = '''
  CREATE TABLE IF NOT EXISTS $customers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  cpf TEXT NOT NULL,
  cnpj TEXT NOT NULL,
  rg TEXT NOT NULL,
  state_registration TEXT NOT NULL,
  im TEXT NOT NULL,
  birth TEXT,
  requester TEXT NOT NULL,
  street TEXT NOT NULL,
  number INTEGER,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  complement TEXT NOT NULL,
  zip_code TEXT NOT NULL,
  neighborhood TEXT NOT NULL,
  longitude TEXT,
  latitude TEXT,
  is_juridic INTEGER NOT NULL,
  updatedAt TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
''';

  static const String createTableQueryProducts = '''
  CREATE TABLE IF NOT EXISTS $products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  stock INTEGER NOT NULL,
  product_type INTEGER NOT NULL,
  updatedAt TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
''';

  static const String createTableQueryProductSell = '''
  CREATE TABLE IF NOT EXISTS $productsSell (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  sell_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  amount INTEGER NOT NULL,
  product_type INTEGER NOT NULL,
  createdAt TEXT NOT NULL
)
''';

  static const String createTableQuerySales = '''
  CREATE TABLE IF NOT EXISTS $sales (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  customer_name TEXT NOT NULL,
  discount REAL NOT NULL,
  amount INTEGER NOT NULL,
  total_price REAL NOT NULL,
  payment_type INTEGER NOT NULL,
  payment_status INTEGER NOT NULL,
  observation TEXT NOT NULL,
  pix_destination TEXT NOT NULL,
  pix_key TEXT NOT NULL,
  payment_mode INTEGER NOT NULL,
  payment_method TEXT NOT NULL,
  payment_abould TEXT NOT NULL,
  sell_date TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
''';

  static const String createTableQuerySellPaymentDate = '''
  CREATE TABLE IF NOT EXISTS $sellPaymentDate (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sell_id INTEGER NOT NULL,
  installment_number INTEGER NOT NULL,
  createdAt TEXT NOT NULL
)
''';
}
