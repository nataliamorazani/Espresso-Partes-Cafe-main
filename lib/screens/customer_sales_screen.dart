import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/search_app_bar.dart';
import 'package:espresso_partes_cafe/data/months_of_year.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/components/sell_item.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerSalesScreen extends StatefulWidget {
  const CustomerSalesScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSalesScreen> createState() => _CustomerSalesScreenState();
}

class _CustomerSalesScreenState extends State<CustomerSalesScreen> {
  final Map<String, List<Sell>> _sales = {};
  final List<Sell> _mainData = [];
  String? _search;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final customerId = ModalRoute.of(context)?.settings.arguments as int;
    Provider.of<DbSalesService>(context);
    _getSales(customerId);
  }

  Future<void> _getSales(int customerId) async {
    setState(() => _loading = true);
    try {
      _sales.clear();
      final salesService = Provider.of<DbSalesService>(context, listen: false);
      final List<Sell> sales = await salesService.getByCustomerId(customerId);
      setState(() {
        _mainData.addAll(sales);
      });
      filterSales(sales);
    } catch (error) {
      Callback.snackBar(context);
    } finally {
      setState(() => _loading = false);
    }
  }

  filterSales(List<Sell> sales) {
    _sales.clear();
    final Map<String, List<Sell>> salesByMonth = {};
    for (final sell in sales) {
      final String monthName =
          "${monthsOfYear[sell.sellDate.month - 1]} ${sell.sellDate.year}";
      if (salesByMonth[monthName] == null) {
        salesByMonth[monthName] = [];
      }
      salesByMonth[monthName]!.add(sell);
    }

    setState(() {
      _sales.addAll(salesByMonth);
    });
  }

  void _searchSales(String search) {
    setState(() {
      _search = search;
    });
    List<Sell> sales = _mainData
        .where((element) => element.id.toString().contains(_search ?? ""))
        .toList();
    filterSales(sales);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        onSubmit: _searchSales,
        title: "Histórico de vendas (${_mainData.length})",
        hintText: "Pesquisar por venda...",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _sales.length,
                    itemBuilder: (ctx, index) {
                      List<Sell> sales = _sales.values.elementAt(index);

                      return Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _sales.keys.elementAt(index),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(.4),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children:
                                sales.map((sell) => SellItem(sell)).toList(),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      // floatingActionButton: FloatingButton(onPress: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       fullscreenDialog: true,
      //       builder: (ctx) => const SellScreen(null),
      //     ),
      //   );
      // }),
    );
  }
}
