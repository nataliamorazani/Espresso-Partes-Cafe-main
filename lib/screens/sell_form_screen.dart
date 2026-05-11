import 'package:espresso_partes_cafe/components/adaptative_date_picker.dart';
import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/custom_input.dart';
import 'package:espresso_partes_cafe/components/edit_product_to_sell.dart';
import 'package:espresso_partes_cafe/components/floating_button.dart';
import 'package:espresso_partes_cafe/components/input_select.dart';
import 'package:espresso_partes_cafe/data/payment_coditions.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/models/product.dart';
import 'package:espresso_partes_cafe/models/product_to_sell_edited.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/screens/customers_screen.dart';
import 'package:espresso_partes_cafe/screens/products_screen.dart';
import 'package:espresso_partes_cafe/services/db_my_company_service.dart';
import 'package:espresso_partes_cafe/services/db_product_service.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellFormScreen extends StatefulWidget {
  final Sell? sell;
  final Future<void> Function({required int sellId}) generatePdf;

  const SellFormScreen(
    this.sell, {
    required this.generatePdf,
    Key? key,
  }) : super(key: key);

  @override
  State<SellFormScreen> createState() => _SellFormScreenState();
}

class _SellFormScreenState extends State<SellFormScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerObservation = TextEditingController();
  final TextEditingController _controllerNamePix = TextEditingController();
  final TextEditingController _controllerKeyPix = TextEditingController();
  final TextEditingController _controllerAbout = TextEditingController();
  final TextEditingController _controllerOthersMethod = TextEditingController();
  late TextEditingController _controllerDate;
  late TextEditingController _controllerDatePayment;
  late TextEditingController _controllerDiscount;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDatePayment = DateTime.now();
  int? _selectedCustomerId;
  String? _selectedCustomerName;
  final List<ProductToSell> _products = [];
  int _paymentType = 0;
  PaymentMode _paymentModeSelected = PaymentMode.pix;

  _updatePaymentType(int index) {
    setState(() {
      _paymentType = index;
    });
  }

  _updatePaymentMode(PaymentMode paymentMoseSelected) {
    setState(() {
      _paymentModeSelected = paymentMoseSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    Sell? sell = widget.sell;

    _controllerDiscount =
        TextEditingController(text: FormaterUtil.toReal(sell?.discount ?? 0.0));
    if (sell != null) {
      _selectedDate = sell.sellDate;
      _selectedDatePayment = sell.paymentDate;
      _selectedCustomerId = sell.customerId;
      _selectedCustomerName = sell.customerName;
      _products.addAll(sell.products);
      _paymentType = sell.paymentType;
      _controllerObservation.text = sell.observation;
      _controllerAbout.text = sell.paymentAbould;
      _controllerOthersMethod.text = sell.paymentMethod;
      _controllerNamePix.text = sell.pixDestination;
      _controllerKeyPix.text = sell.pixKey;
      _paymentModeSelected = sell.paymentMode;
      _controllerName.text = sell.customerName;
    } else {
      final MyCompany myCompany =
          Provider.of<DbMyCompanyService>(context, listen: false).companyData;
      _controllerNamePix.text = myCompany.pixDestination;
      _controllerKeyPix.text = myCompany.pixKey;
    }

    _controllerDate = TextEditingController(
      text: FormaterUtil.formatDate(_selectedDate),
    );
    _controllerDatePayment = TextEditingController(
      text: FormaterUtil.formatDate(_selectedDatePayment),
    );
  }

  Future<void> _selectCustomer() async {
    final Customer? selectedCustomer = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const CustomersScreen(isSelect: true),
      ),
    );

    if (selectedCustomer != null) {
      setState(() {
        final String customerName = selectedCustomer.name;
        _controllerName.text = customerName;
        _selectedCustomerId = selectedCustomer.id;
        _selectedCustomerName = customerName;
      });
    }
  }

  Future<void> _selectProduct() async {
    final Product? selectedProduct = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const ProductsScreen(isSelect: true),
      ),
    );
    if (selectedProduct != null) {
      ProductToSell? productEdited = await showModalBottomSheet<ProductToSell>(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => EditProductToSell(
          product: selectedProduct,
        ),
      );
      if (productEdited != null) {
        bool edited = false;
        for (final product in _products) {
          if (productEdited.productId == product.productId) {
            edited = true;
            Callback.snackBar(context, title: "Item já adicionado");
          }
        }
        if (!edited) {
          setState(() {
            _products.add(productEdited);
          });
        }
      }
    }
  }

  _handleSelectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _controllerDate.text = FormaterUtil.formatDate(date);
    });
  }

  _handleSelectDatePayment(DateTime date) {
    setState(() {
      _selectedDatePayment = date;
      _controllerDatePayment.text = FormaterUtil.formatDate(date);
    });
  }

  _removeOneProduct(ProductToSell product) async {
    final productService =
        Provider.of<DbProductService>(context, listen: false);
    setState(() {
      _products.removeWhere((element) {
        if (element.name == product.name) {
          if (product.id != null) {
            try {
              Provider.of<DbSalesService>(context, listen: false)
                  .deleteProductSellById(product.id!);

              productService.updateAmountProduct(
                productId: product.productId,
                amount: product.amount,
                plus: true,
              );

              return true;
            } catch (error) {
              Callback.snackBar(context, title: error.toString());
            }
          }
          return true;
        }
        return false;
      });
      productService.loadData();
    });
  }

  _handleSave([bool send = true]) async {
    try {
      if (_selectedCustomerId == null) {
        throw "Selecione um cliente";
      }

      if (_products.isEmpty) {
        throw "Selecione um Item";
      }
      final navigatorContext = Navigator.of(context);
      final productService =
          Provider.of<DbProductService>(context, listen: false);
      final salesService = Provider.of<DbSalesService>(context, listen: false);
      final sellId = await salesService.addOrUpdate(
        id: widget.sell?.id,
        customerId: _selectedCustomerId!,
        customerName: _selectedCustomerName!,
        discount: FormaterUtil.toDouble(_controllerDiscount.text),
        amount: _products.length,
        totalPrice: _total(),
        paymentType: _paymentType,
        paymentStatus: widget.sell?.paymentStatus ?? 0,
        sellDate: _selectedDate,
        products: _products,
        paymentMode: _paymentModeSelected,
        observation: _controllerObservation.text,
        pixDestination: _controllerNamePix.text,
        pixKey: _controllerKeyPix.text,
        paymentMethod: _controllerOthersMethod.text,
        paymentAbould: _controllerAbout.text,
        paymentDate: _selectedDatePayment,
      );

      for (final ProductToSell product in _products) {
        if (product.id == null) {
          await productService.updateAmountProduct(
            productId: product.productId,
            amount: product.amount,
          );
        }
      }
      productService.loadData();
      if (send) {
        widget.generatePdf(sellId: sellId);
      }

      await navigatorContext.pushReplacementNamed(AppRoutes.sales);
    } catch (error) {
      Callback.snackBar(context, title: error.toString());
    }
  }

  double _totalValue() {
    double value = 0;
    for (final ProductToSell product in _products) {
      value += product.total;
    }
    return value;
  }

  double _total() {
    return _totalValue() - FormaterUtil.toDouble(_controllerDiscount.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomInput(
                              controller: _controllerName,
                              label: "Nome do cliente",
                              objectKey: "name",
                              readOnly: true,
                            ),
                            InkWell(onTap: _selectCustomer),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomInput(
                              controller: _controllerDate,
                              label: "Data da venda",
                              objectKey: "date",
                              readOnly: true,
                              keyboardType: TextInputType.datetime,
                            ),
                            AdaptativeDatePicker(
                              onDateChanged: _handleSelectDate,
                              selectedDate: _selectedDate,
                            ),
                          ],
                        ),
                      ),
                      CustomInput(
                        controller: _controllerDiscount,
                        label: "Desconto",
                        objectKey: "discount",
                        isMoney: true,
                        keyboardType: TextInputType.number,
                        onChanged: (String text) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 5.0,
                        ),
                        child: Text(
                          "Itens (${_products.length})",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: _products.map((product) {
                          return _ProductSell(
                            product: product,
                            removeOneProduct: _removeOneProduct,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // const SizedBox(height: 200),
        ],
      ),
      floatingActionButton: FloatingButton(
        onPress: _selectProduct,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: FinisheSell(
        handleSave: _handleSave,
        products: _products,
        discount: FormaterUtil.toDouble(_controllerDiscount.text),
        updatePaymentType: _updatePaymentType,
        paymentType: _paymentType,
        total: _total,
        totalValue: _totalValue,
        controllerObservation: _controllerObservation,
        paymentMoseSelected: _paymentModeSelected,
        updatePaymentMode: _updatePaymentMode,
        controllerAboutTiket: _controllerAbout,
        controllerNamePix: _controllerNamePix,
        controllerKeyPix: _controllerKeyPix,
        controllerOthersMethod: _controllerOthersMethod,
        controllerDatePayment: _controllerDatePayment,
        handleSelectDatePayment: _handleSelectDatePayment,
        selectedDatePayment: _selectedDatePayment,
      ),
    );
  }
}

class FinisheSell extends StatelessWidget {
  final Function([bool]) handleSave;
  final List<ProductToSell> products;
  final double discount;
  final Function(int) updatePaymentType;
  final int paymentType;
  final double Function() totalValue;
  final double Function() total;
  final TextEditingController controllerObservation;
  final TextEditingController controllerNamePix;
  final TextEditingController controllerKeyPix;
  final TextEditingController controllerAboutTiket;
  final TextEditingController controllerOthersMethod;
  final PaymentMode paymentMoseSelected;
  final Function(PaymentMode) updatePaymentMode;
  final TextEditingController controllerDatePayment;
  final Function(DateTime) handleSelectDatePayment;
  final DateTime selectedDatePayment;
  const FinisheSell({
    super.key,
    required this.handleSave,
    required this.products,
    required this.discount,
    required this.updatePaymentType,
    required this.updatePaymentMode,
    required this.paymentType,
    required this.totalValue,
    required this.total,
    required this.controllerObservation,
    required this.paymentMoseSelected,
    required this.controllerAboutTiket,
    required this.controllerNamePix,
    required this.controllerKeyPix,
    required this.controllerOthersMethod,
    required this.controllerDatePayment,
    required this.handleSelectDatePayment,
    required this.selectedDatePayment,
  });

  List<String> paymentConditionsBuilder() {
    if (products.isEmpty && total() < 0) {
      return paymentConditions;
    }
    final List<String> newList = [];
    for (int i = 0; i < paymentConditions.length; i++) {
      if (i > 0) {
        newList.add(
          "${paymentConditions[i].replaceAll("Parcelado em ", "")} de ${FormaterUtil.toReal((total() / (i + 1)).toDouble())}",
        );
      } else {
        newList.add(paymentConditions[i]);
      }
    }

    return newList;
  }

  @override
  Widget build(BuildContext context) {
    final List<PaymentMode> paymentModes = [
      PaymentMode.pix,
      PaymentMode.ticket,
      PaymentMode.others,
    ];

    Widget paymentInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InputSelect(
                data: paymentConditionsBuilder(),
                label: "Condiçãoes de pagamento",
                onChanged: updatePaymentType,
                selectedIndex: paymentType,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                width: double.infinity,
                height: 66,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // CustomInput(
                    //   controller: controllerDatePayment,
                    //   label: "Data de pagamento",
                    //   objectKey: "date",
                    //   readOnly: true,
                    //   keyboardType: TextInputType.datetime,
                    // ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InputSelect(
                        data: [controllerDatePayment.text],
                        label: "Data de pagamento",
                        onChanged: (int _) {},
                        selectedIndex: 0,
                      ),
                    ),

                    AdaptativeDatePicker(
                      onDateChanged: handleSelectDatePayment,
                      selectedDate: selectedDatePayment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Text(
          "Forma de pagemento",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 5),
        Row(
          children: paymentModes
              .map(
                (val) => Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Opacity(
                    opacity: paymentMoseSelected == val ? 1.0 : .5,
                    child: SizedBox(
                      width: 90,
                      child: ElevatedButton(
                        onPressed: () => updatePaymentMode(val),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (val == PaymentMode.pix)
                              const Padding(
                                padding: EdgeInsets.only(right: 7),
                                child: Icon(Icons.pix),
                              ),
                            Text(
                              val == PaymentMode.pix
                                  ? "Pix"
                                  : val == PaymentMode.ticket
                                      ? "Boleto"
                                      : "Outro",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (paymentMoseSelected == PaymentMode.pix)
          CustomInput(
            label: "Destinatário Pix",
            controller: controllerNamePix,
          ),
        if (paymentMoseSelected == PaymentMode.pix)
          CustomInput(
            label: "Chave Pix",
            controller: controllerKeyPix,
          ),
        if (paymentMoseSelected == PaymentMode.others)
          CustomInput(
            label: "Forma de pagamento",
            controller: controllerOthersMethod,
          ),
        if (paymentMoseSelected != PaymentMode.pix)
          CustomInput(
            label: paymentMoseSelected == PaymentMode.ticket
                ? "Sobre o boleto"
                : "Sobre a forma de pagamento",
            controller: controllerAboutTiket,
            keyboardType: TextInputType.multiline,
          ),
        CustomInput(
          label: "Observções",
          controller: controllerObservation,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Theme.of(context).colorScheme.tertiary,
          )
        ],
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      width: double.infinity,
      height: 400,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 23),
                ListTile(
                  title: const TrailingText(text: "Valor Total"),
                  trailing:
                      TrailingText(text: FormaterUtil.toReal(totalValue())),
                ),
                const Divider(color: Colors.white, height: 0),
                ListTile(
                  title: const TrailingText(text: "Desconto"),
                  trailing: TrailingText(text: FormaterUtil.toReal(discount)),
                ),
                const Divider(color: Colors.white, height: 0),
                ListTile(
                  title: const TrailingText(
                    text: "Total liquido",
                    isBold: true,
                  ),
                  trailing: TrailingText(
                    text: FormaterUtil.toReal(total()),
                    isBold: true,
                  ),
                ),
                const Divider(color: Colors.white, height: 0),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 5.0,
                  ),
                  child: paymentInfo,
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: handleSave,
                  child: const Text(
                    "SALVAR E ENVIAR",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                TextButton(
                  onPressed: () => handleSave(false),
                  child: const Text(
                    "SALVAR",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSell extends StatelessWidget {
  final ProductToSell product;
  final Function(ProductToSell) removeOneProduct;
  const _ProductSell({
    required this.product,
    required this.removeOneProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.name),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Remover",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.highlight_remove,
                  color: Colors.white,
                  size: 33,
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) => removeOneProduct(product),
      confirmDismiss: (direction) async {
        if (product.id == null) return true;
        return Callback.confirm(
          context: context,
          content: "O Item sera apagado permanentemente.",
        );
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.only(bottom: 2),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15.0),
          title: Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Qtd: ${product.amount.toString()}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
                  fontSize: 15,
                ),
              ),
            ],
          ),
          trailing: TrailingText(text: FormaterUtil.toReal(product.price)),
        ),
      ),
    );
  }
}

class TrailingText extends StatelessWidget {
  final String text;
  final bool isBold;
  const TrailingText({
    super.key,
    this.isBold = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isBold
          ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              )
          : Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(.6),
                fontWeight: FontWeight.w400,
              ),
    );
  }
}
