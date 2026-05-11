import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/data/payment_coditions.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:espresso_partes_cafe/screens/sell_screen.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellItem extends StatelessWidget {
  final Sell sell;
  const SellItem(
    this.sell, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    updatePaymentStatus() async {
      await Provider.of<DbSalesService>(context, listen: false)
          .updatePaymentStatus(
        id: sell.id,
        paymentStatus: sell.paymentStatus + 1,
      );
    }

    final bool payed = sell.paymentStatus - 1 == sell.paymentType;
    final bool isInstallment = sell.paymentType > 0;
    final bool inPayment = sell.paymentStatus > 0;

    return Dismissible(
      key: Key(sell.id.toString()),
      background: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isInstallment
                      ? "Receber Parcela ${sell.paymentStatus + 1}"
                      : "Receber",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 33,
                ),
              ],
            ),
          ),
        ),
      ),
      direction: payed ? DismissDirection.none : DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final bool res = await Callback.confirm(
          context: context,
          content: isInstallment
              ? "Marcar Parcela ${sell.paymentStatus + 1} como recebida?"
              : "Marcar como recebida?",
        );
        if (res) {
          updatePaymentStatus();
        }
        return false;
      },
      child: Card(
        margin: const EdgeInsets.all(.3),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => SellScreen(sell.id),
              ),
            );
          },
          title: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sell.customerName),
                Text(
                  FormaterUtil.formatDate(sell.sellDate),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      sell.paymentType == 0
                          ? paymentConditions[sell.paymentType]
                          : "${paymentConditions[sell.paymentType].replaceAll("Parcelado em ", "")} ${FormaterUtil.toReal(sell.installmentPrice)}",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 20,
                    ),
                    child: Opacity(
                      opacity: payed
                          ? 1
                          : isInstallment && inPayment
                              ? .6
                              : .4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: .7,
                              color: sell.isOutOfTime
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          inPayment
                              ? "Recebida ${sell.paymentType > 0 ? "${sell.paymentStatus}/${sell.paymentType + 1}" : ""}"
                              : "Pendente",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: sell.isOutOfTime
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                FormaterUtil.toReal(sell.finalPrice),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
