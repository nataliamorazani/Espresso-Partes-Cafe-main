import 'package:espresso_partes_cafe/components/app_drawer.dart';
import 'package:espresso_partes_cafe/components/floating_button.dart';
import 'package:espresso_partes_cafe/components/search_app_bar.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/screens/customer_form_screen.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatefulWidget {
  final bool isSelect;
  const CustomersScreen({
    Key? key,
    this.isSelect = false,
  }) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Customer> _customers = [];
  String? _search;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DbCustomerService>(context);
    _getCustomers(_search);
  }

  void _getCustomers(String? search) {
    final customerService =
        Provider.of<DbCustomerService>(context, listen: false);
    if (search != null && search.isNotEmpty) {
      setState(() {
        _search = search;
        _customers = customerService.search(search);
      });
      return;
    }
    setState(() {
      _search = null;
      _customers = customerService.customers;
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = "Clientes";
    return Scaffold(
      appBar: SearchAppBar(
        onSubmit: _getCustomers,
        title: title,
      ),
      body: Builder(builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: _customers.length,
          itemBuilder: (ctx, index) {
            final customer = _customers[index];
            return SellItem(
              customer: customer,
              isSelect: widget.isSelect,
            );
          },
        );
      }),
      drawer: widget.isSelect
          ? null
          : const AppDrawer(
              currentRoute: AppRoutes.customers,
              title: title,
            ),
      floatingActionButton: FloatingButton(onPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => const CustomerFormScreen(),
          ),
        );
      }),
    );
  }
}

class SellItem extends StatelessWidget {
  final bool isSelect;
  final Customer customer;
  const SellItem({
    super.key,
    required this.customer,
    this.isSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    handlePress() {
      if (isSelect) {
        Navigator.of(context).pop(customer);
      } else {
        Navigator.of(context).pushNamed(
          AppRoutes.customerData,
          arguments: customer.id,
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
            vertical: 15.0,
          ),
          child: Text(
            customer.name.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
