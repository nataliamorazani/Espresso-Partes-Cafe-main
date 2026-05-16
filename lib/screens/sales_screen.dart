import 'package:espresso_partes_cafe/components/app_drawer.dart';
import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/floating_button.dart';
import 'package:espresso_partes_cafe/components/search_app_bar.dart';
import 'package:espresso_partes_cafe/data/months_of_year.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/components/sell_item.dart';
import 'package:espresso_partes_cafe/screens/sell_screen.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List<Sell> _sales = [];
  String? _search;
  int _selectedMonth = 0; //0 é o mes atual
  DateTime _pikedDate = DateTime.now();
  bool _loading = false;
  final DateTime _now = DateTime.now();

  _changeMonthFilter(bool plus) async {
    try {
      setState(() {
        _loading = true;
        if (plus) {
          _selectedMonth = _selectedMonth + 1;
        } else {
          _selectedMonth = _selectedMonth - 1;
        }
      });
      final saleService = Provider.of<DbSalesService>(context, listen: false);
      DateTime newPickedDate;
      if (_selectedMonth < 0) {
        newPickedDate = FormaterUtil.addMonthsFromDate(
            DateTime(_now.year, _now.month, 15), _selectedMonth.abs());
      } else {
        newPickedDate = FormaterUtil.subtractMonthsFromDate(
            DateTime(_now.year, _now.month, 15), _selectedMonth);
      }
      setState(() {
        _pikedDate = newPickedDate;
      });
      await saleService.updatePickedDate(newPickedDate, _selectedMonth);
    } catch (error) {
      Callback.snackBar(context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final saleService = Provider.of<DbSalesService>(context);
    _pikedDate = saleService.picketDate;
    _selectedMonth = saleService.selectedMonth;
    _getSales(_search);
  }

  void _getSales(String? search) {
    try {
      _sales.clear();
      final salesService = Provider.of<DbSalesService>(context, listen: false);
      if (search != null && search.isNotEmpty) {
        setState(() {
          _search = search;
          _sales.addAll(salesService.search(search));
        });
        return;
      }
      setState(() {
        _search = null;
        _sales.addAll(salesService.sales);
      });
    } catch (error) {
      Callback.snackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = "Ordem de Serviço";
    return Scaffold(
      appBar: SearchAppBar(
        onSubmit: _getSales,
        title: title,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _changeMonthFilter(true);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 33,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "${monthsOfYear[_pikedDate.month - 1]} ${_pikedDate.year}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _changeMonthFilter(false);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 33,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: _sales.length,
                    itemBuilder: (ctx, index) {
                      Sell sell = _sales[index];
                      return SellItem(sell);
                    },
                  ),
          ),
        ],
      ),
      drawer: const AppDrawer(
        currentRoute: AppRoutes.sales,
        title: title,
      ),
      floatingActionButton: FloatingButton(onPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => const SellScreen(null),
          ),
        );
      }),
    );
  }
}
