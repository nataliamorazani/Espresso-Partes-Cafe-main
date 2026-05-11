import 'package:espresso_partes_cafe/screens/company_data_screen.dart';
import 'package:espresso_partes_cafe/screens/customer_data_screen.dart';
import 'package:espresso_partes_cafe/screens/customer_sales_screen.dart';
import 'package:espresso_partes_cafe/screens/customers_screen.dart';
import 'package:espresso_partes_cafe/screens/home_screen.dart';
import 'package:espresso_partes_cafe/screens/product_form_screen.dart';
import 'package:espresso_partes_cafe/screens/products_screen.dart';
import 'package:espresso_partes_cafe/screens/sales_screen.dart';
import 'package:espresso_partes_cafe/screens/settings_screen.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/services/db_my_company_service.dart';
import 'package:espresso_partes_cafe/services/db_product_service.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:espresso_partes_cafe/utils/theme_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DbMyCompanyService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DbCustomerService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DbProductService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DbSalesService(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Espresso Partes Café',
        theme: ThemeUtil.mainTheme(),
        home: const HomeScreen(),
        routes: {
          AppRoutes.customers: (ctx) => const CustomersScreen(),
          AppRoutes.products: (ctx) => const ProductsScreen(),
          AppRoutes.productForm: (ctx) => const ProductFormScreen(),
          AppRoutes.sales: (ctx) => const SalesScreen(),
          AppRoutes.settings: (ctx) => const SettingsScreen(),
          AppRoutes.companyData: (ctx) => const CompanyDataScreen(),
          AppRoutes.customerData: (ctx) => const CustomerDataScreen(),
          AppRoutes.customerHistory: (ctx) => const CustomerSalesScreen(),
        },
        // traduzir calendario para portugues
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
      ),
    );
  }
}
