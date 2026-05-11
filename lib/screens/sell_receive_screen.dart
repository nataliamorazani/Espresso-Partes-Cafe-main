import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/data/payment_coditions.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellReceiveScreen extends StatelessWidget {
  final Sell sell;
  const SellReceiveScreen(this.sell, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 15.0, bottom: 50.0),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rouwTextContent(
                context,
                name: "Condiçãoes de pagamento",
                content: paymentConditions[sell.paymentType],
              ),
              const Divider(),
              const SizedBox(height: 15),
              rouwTextContent(
                context,
                name: "Data da Emissão",
                content: FormaterUtil.formatDate(sell.sellDate),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const Divider(height: 0),
        Column(
          children: sell.installments
              .map((val) => instalmentCard(context, val))
              .toList(),
        ),
      ],
    );
  }

  Container instalmentCard(
    BuildContext context,
    Installment installments,
  ) {
    updatePaymentStatus() async {
      await Provider.of<DbSalesService>(context, listen: false)
          .updatePaymentStatus(
        id: sell.id,
        paymentStatus: sell.paymentStatus + 1,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rouwTextContent(
                context,
                name: "Parcela",
                content: installments.number.toString(),
              ),
              rouwTextContent(
                context,
                name: "Valor",
                content: FormaterUtil.toReal(installments.price),
              ),
              rouwTextContent(
                context,
                name: "Vencimento",
                content: FormaterUtil.formatDate(installments.invoiceDueDate),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            constraints: const BoxConstraints(minHeight: 40, minWidth: 220),
            child: installments.payed
                ? Text(
                    "RECEBIDA: ${installments.payedDate != null ? FormaterUtil.formatDate(installments.payedDate!) : ""}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                : ElevatedButton(
                    onPressed: sell.paymentStatus + 1 == installments.number
                        ? () async {
                            final bool res = await Callback.confirm(
                                context: context,
                                content:
                                    "Marcar Parcela ${installments.number.toString()} como recebida?");
                            if (res) {
                              updatePaymentStatus();
                            }
                          }
                        : null,
                    child: const Text(
                      "RECEBER PARCELA",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Column rouwTextContent(
    BuildContext context, {
    required String name,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
          ),
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }
}
