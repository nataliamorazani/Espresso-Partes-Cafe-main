import 'package:espresso_partes_cafe/components/app_drawer.dart';
import 'package:espresso_partes_cafe/components/floating_button.dart';
import 'package:espresso_partes_cafe/components/search_app_bar.dart';
import 'package:espresso_partes_cafe/models/product.dart';
import 'package:espresso_partes_cafe/screens/product_form_screen.dart';
import 'package:espresso_partes_cafe/services/db_product_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final bool isSelect;
  const ProductsScreen({
    Key? key,
    this.isSelect = false,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Product> _products = [];
  String? _search;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DbProductService>(context);
    _getCustomers(_search);
  }

  void _getCustomers(String? search) {
    _products.clear();
    final productService =
        Provider.of<DbProductService>(context, listen: false);
    if (search != null && search.isNotEmpty) {
      setState(() {
        _search = search;
        _products.addAll(productService.search(search));
      });
      return;
    }
    setState(() {
      _search = null;
      _products.addAll(productService.products);
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = "Itens";
    return Scaffold(
      appBar: SearchAppBar(
        onSubmit: _getCustomers,
        title: title,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nome",
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(.5),
                  ),
                ),
                Text(
                  "Estoque",
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(.5),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                final product = _products[index];
                return ProductSingle(
                  product: product,
                  isSelect: widget.isSelect,
                );
              },
            ),
          ),
        ],
      ),
      drawer: widget.isSelect
          ? null
          : const AppDrawer(
              currentRoute: AppRoutes.products,
              title: title,
            ),
      floatingActionButton: FloatingButton(onPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => const ProductFormScreen(),
          ),
        );
      }),
    );
  }
}

class ProductSingle extends StatelessWidget {
  const ProductSingle({
    super.key,
    required this.product,
    required this.isSelect,
  });

  final Product product;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    handlePress() {
      if (isSelect) {
        Navigator.of(context).pop(product);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => ProductFormScreen(product: product),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: TextButton(
        style: const ButtonStyle(
          alignment: Alignment.bottomLeft,
        ),
        onPressed: handlePress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7.0,
            vertical: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 20),
              Text(
                product.stock.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 19,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
