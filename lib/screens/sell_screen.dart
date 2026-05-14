import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/screens/sell_form_screen.dart';
import 'package:espresso_partes_cafe/screens/sell_receive_screen.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/services/db_my_company_service.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/pdf_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellScreen extends StatefulWidget {
  final int? id;
  const SellScreen(
    this.id, {
    Key? key,
  }) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  Sell? _sell;
  bool _isEdit = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (widget.id != null) {
      final salesService = Provider.of<DbSalesService>(context);
      Sell? sell = await salesService.getById(widget.id!);
      if (mounted) {
        setState(() {
          _sell = sell;
          _isEdit = sell != null;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    remove() async {
      final navigatorContext = Navigator.of(context);
      await Provider.of<DbSalesService>(context, listen: false)
          .deleteById(widget.id!);
      navigatorContext.pop();
    }

    Future<void> generatePdf({
      required int sellId,
    }) async {
      try {
        final salesService =
            Provider.of<DbSalesService>(context, listen: false);
        final myCompanyService =
            Provider.of<DbMyCompanyService>(context, listen: false);
        final customerService =
            Provider.of<DbCustomerService>(context, listen: false);
        Sell? sell = await salesService.getById(sellId);
        if (sell != null) {
          final MyCompany myCompany = myCompanyService.companyData;
          final Customer? customer = customerService.getById(sell.customerId);
          if (customer == null) {
            throw "Cliente não existe! Selecione outro.";
          }

          await PdfUtils.createAndSharePdf(
            sell: sell,
            myCompany: myCompany,
            customer: customer,
          );
        } else {
          throw "Venda não cadastrada";
        }
      } catch (error) {
        Callback.snackBar(context, title: error.toString());
      }
    }

    if (!_isEdit) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Vender"),
        ),
        body: SellFormScreen(
          _sell,
          generatePdf: generatePdf,
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? "Pedido: ${_sell?.id}" : "Vender"),
          actions: [
            if (_isEdit)
              IconButton(
                onPressed: () => generatePdf(sellId: _sell!.id),
                icon: const Icon(
                  Icons.share,
                  size: 30,
                ),
              ),
            if (_isEdit) const SizedBox(width: 10),
            if (_isEdit)
              IconButton(
                onPressed: () async {
                  bool res = await Callback.confirm(
                    context: context,
                    content: "Excluir Venda?",
                  );
                  if (res) {
                    remove();
                  }
                },
                icon: const Icon(
                  Icons.delete_forever,
                  size: 33,
                ),
              ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            tabs: <Widget>[
              Tab(
                text: "EDITAR",
              ),
              Tab(
                text: "RECEBER",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SellFormScreen(
              _sell,
              generatePdf: generatePdf,
            ),
            SellReceiveScreen(_sell!),
          ],
        ),
      ),
    );
  }
}
