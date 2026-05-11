import 'package:espresso_partes_cafe/models/product_to_sell_edited.dart';

enum PaymentMode {
  others,
  pix,
  ticket,
}

class Sell {
  final int id;
  final List<ProductToSell> products;
  final String customerName;
  final int customerId;
  final double discount;
  final int amount;
  final double totalPrice;
  final int paymentType; //numero de parcelas
  final int paymentStatus;
  final DateTime sellDate;

  final String observation;
  final String paymentAbould;
  final String pixDestination;
  final String paymentMethod;
  final PaymentMode paymentMode;
  final String pixKey;

  final DateTime paymentDate;
  final DateTime createdAt;
  final List<InstallmentPaymentDate> installmentPaymentDate;

  const Sell({
    required this.id,
    required this.products,
    required this.customerId,
    required this.customerName,
    required this.discount,
    required this.amount,
    required this.totalPrice,
    required this.paymentType,
    required this.paymentStatus,
    required this.sellDate,
    required this.observation,
    required this.pixDestination,
    required this.pixKey,
    required this.paymentMethod,
    required this.paymentMode,
    required this.paymentAbould,
    required this.paymentDate,
    required this.createdAt,
    required this.installmentPaymentDate,
  });

  double get finalPrice {
    double value = 0;

    for (final product in products) {
      value += (product.price * product.amount);
    }

    return value - discount;
  }

  String get paymentModeString {
    return paymentMode == PaymentMode.pix
        ? "Pix"
        : paymentMode == PaymentMode.ticket
            ? "Boleto"
            : paymentMethod.trim() == ""
                ? "Outro"
                : paymentMethod;
  }

  double get parcialPrice {
    return finalPrice + discount;
  }

  double get installmentPrice {
    return (finalPrice / (paymentType + 1)).toDouble();
  }

  bool get isOutOfTime {
    for (final installment in installments) {
      if (!installment.payed && installment.number == paymentStatus + 1) {
        final now = DateTime.now();

        if (installment.invoiceDueDate
            .isBefore(DateTime(now.year, now.month, now.day))) {
          return true;
        }
      }
    }
    return false;
  }

  List<Installment> get installments {
    List<Installment> list = [];
    double totalPrice = finalPrice;
    for (int i = 0; i <= paymentType; i++) {
      double installmentFinalPrice = installmentPrice;
      if (i == paymentType) {
        installmentFinalPrice = totalPrice;
      }
      totalPrice = totalPrice - installmentFinalPrice;
      DateTime? payedDate;

      for (final InstallmentPaymentDate element in installmentPaymentDate) {
        if (element.installmentNumber == i + 1) {
          payedDate = element.createdAt;
        }
      }

      list.add(Installment(
        number: i + 1,
        price: installmentFinalPrice,
        invoiceDueDate:
            DateTime(paymentDate.year, paymentDate.month + i, paymentDate.day),
        payed: paymentStatus - 1 >= i,
        payedDate: payedDate,
      ));
    }
    return list;
  }
}

class Installment {
  final int number;
  final double price;
  final bool payed;
  final DateTime? payedDate;
  final DateTime invoiceDueDate;
  const Installment({
    required this.number,
    required this.price,
    required this.invoiceDueDate,
    this.payed = false,
    this.payedDate,
  });
}

class InstallmentPaymentDate {
  final int id;
  final DateTime createdAt;
  final int installmentNumber;

  const InstallmentPaymentDate({
    required this.id,
    required this.createdAt,
    required this.installmentNumber,
  });
}
