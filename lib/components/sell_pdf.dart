import 'package:espresso_partes_cafe/data/payment_coditions.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:espresso_partes_cafe/models/sell.dart';

class SellPdf {
  const SellPdf();

  static List<pw.Widget> pdfPage(pw.Context context,
      {required pw.MemoryImage image,
      required Sell sell,
      required MyCompany myCompany,
      required Customer customer,
      required}) {
    return [
      pw.SizedBox(
        height: 15,
      ),
      HeaderPdf.build(
        context,
        id: sell.id,
        sellDate: sell.sellDate,
      ),
      pw.Divider(
        thickness: 1,
        height: 25,
      ),
      BannerPdf.build(context, image, myCompany),
      pw.Divider(
        thickness: 1,
        height: 25,
      ),
      CustomerInfoPdf.build(context, customer),
      ProductsPdf.build(context, sell),
      PaymentPdf.build(context, sell),
    ];
  }
}

class PaymentPdf {
  static pw.Widget build(pw.Context context, Sell sell) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(
                "Condição de pagamento: ",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                ),
              ),
              pw.Text(
                paymentConditions[sell.paymentType],
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                  color: PdfColor.fromHex("#800a01"),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 7),
          pw.SizedBox(height: 15),
          pw.Row(
            children: [
              pw.SizedBox(
                width: 80,
                child: pw.Text(
                  "Nº",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
              pw.SizedBox(width: 15),
              pw.SizedBox(
                width: 120,
                child: pw.Text(
                  "Vencimento",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
              pw.SizedBox(width: 15),
              pw.SizedBox(
                width: 120,
                child: pw.Text(
                  "Valor (R\$)",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 7),
          pw.Column(
            children: sell.installments
                .map(
                  (val) => rowInstallment(val),
                )
                .toList(),
          ),
          pw.Divider(
            thickness: 1,
            // color: PdfColor.black87,
            height: 25,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(
                "Forma de pagamento: ",
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
              pw.Text(
                sell.paymentModeString,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (sell.paymentMode == PaymentMode.pix &&
                  sell.pixDestination.trim() != "")
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Destinatário: ",
                        style: const pw.TextStyle(
                          fontSize: 9,
                        ),
                      ),
                      pw.Text(
                        sell.pixDestination,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              if (sell.paymentMode == PaymentMode.pix &&
                  sell.pixKey.trim() != "")
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Chave: ",
                        style: const pw.TextStyle(
                          fontSize: 9,
                        ),
                      ),
                      pw.Text(
                        sell.pixKey,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              if (sell.paymentMode != PaymentMode.pix)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        sell.paymentAbould,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#6e6d6d"),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(
            thickness: 1,
            height: 25,
          ),
          pw.Text(
            "Informações complementares:",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            sell.observation,
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Container rowInstallment(Installment installment) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              "${installment.number}º",
              style: pw.TextStyle(
                color: PdfColor.fromHex("#6e6d6d"),
                fontSize: 9,
              ),
            ),
          ),
          pw.SizedBox(width: 15),
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              FormaterUtil.formatDate(installment.invoiceDueDate),
              style: pw.TextStyle(
                color: PdfColor.fromHex("#6e6d6d"),
                fontSize: 9,
              ),
            ),
          ),
          pw.SizedBox(width: 15),
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              FormaterUtil.toReal(installment.price, false),
              style: pw.TextStyle(
                color: PdfColor.fromHex("#6e6d6d"),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsPdf {
  const ProductsPdf();

  static pw.Widget build(
    pw.Context context,
    Sell sell,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        children: [
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: .3,
              ),
              color: PdfColor.fromHex("#f2f7f7"),
            ),
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    "Qt.",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "Produto/Serviço",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "Detalhe do item",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    "Valor unitário",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    "Subtotal",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.Column(
            children: [
              pw.Column(
                children: sell.products
                    .map(
                      (product) => pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              width: .5,
                              color: PdfColors.grey100,
                            ),
                          ),
                        ),
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 7.0),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                product.amount.toString(),
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                product.name,
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                "",
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                FormaterUtil.toReal(product.price, false),
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(
                                FormaterUtil.toReal(product.total, false),
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              pw.Divider(
                height: 0,
              ),
            ],
          ),
          if (sell.discount > 0)
            pw.Container(
              decoration: pw.BoxDecoration(
                border: const pw.Border(
                  bottom: pw.BorderSide(
                    width: .3,
                  ),
                ),
                color: PdfColor.fromHex("#f2f7f7"),
              ),
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Desconto:",
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#6e6d6d"),
                      fontSize: 9,
                    ),
                  ),
                  pw.SizedBox(width: 50),
                  pw.Text(
                    FormaterUtil.toReal(sell.discount, false),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: const pw.Border(
                bottom: pw.BorderSide(
                  width: .3,
                ),
              ),
              color: PdfColor.fromHex("#f2f7f7"),
            ),
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "Total:",
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#6e6d6d"),
                    fontSize: 9,
                  ),
                ),
                pw.SizedBox(width: 50),
                pw.Text(
                  FormaterUtil.toReal(sell.parcialPrice, false),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "Valor líquido:",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
                pw.SizedBox(width: 50),
                pw.Text(
                  FormaterUtil.toReal(sell.finalPrice, false),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
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

class CustomerInfoPdf {
  const CustomerInfoPdf();

  static pw.Widget build(
    pw.Context context,
    Customer customer,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: .3,
          ),
          color: PdfColor.fromHex("#ffffff")),
      padding: const pw.EdgeInsets.all(15.0),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  customer.name.toUpperCase(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(
                      customer.isJuridic
                          ? "CNPJ: ${customer.cnpj}"
                          : customer.cpf != ""
                              ? "CPF: ${customer.cpf}"
                              : customer.rg != ""
                                  ? "RG: ${customer.rg}"
                                  : "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#6e6d6d"),
                        fontSize: 9,
                      ),
                    ),
                    pw.SizedBox(width: 30),
                    pw.Text(
                      customer.stateRegistration != ""
                          ? "IE: ${customer.stateRegistration}"
                          : customer.im != ""
                              ? "IM: ${customer.im}"
                              : "",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex("#6e6d6d"),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
                  child: pw.Text(
                    customer.addressStringPdf,
                    style: const pw.TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ),
                if (customer.isJuridic)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
                    child: pw.Text(
                      "Solicitante: ${customer.requester}",
                      style: const pw.TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  customer.phone,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  customer.email,
                  style: const pw.TextStyle(
                    fontSize: 9,
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

class BannerPdf {
  const BannerPdf();

  static pw.Widget build(
    pw.Context context,
    pw.MemoryImage image,
    MyCompany myCompany,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                height: 80,
                width: 80,
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      width: 1,
                    ),
                    color: PdfColor.fromHex("#ffffff")),
                margin: const pw.EdgeInsets.only(right: 10),
                child: pw.Center(
                  child: pw.Image(
                    image,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      myCompany.companyName.toUpperCase(),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(
                      myCompany.addressString,
                      style: const pw.TextStyle(
                        fontSize: 9,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
                      child: pw.Text(
                        myCompany.username.toUpperCase(),
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#6e6d6d"),
                          fontSize: 9,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
                      child: pw.Text(
                        "CNPJ: ${myCompany.cnpj}",
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#6e6d6d"),
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(
                myCompany.phone,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                myCompany.email,
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderPdf {
  const HeaderPdf();

  static pw.Widget build(
    pw.Context context, {
    required int id,
    required DateTime sellDate,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          FormaterUtil.formatDate(sellDate),
          style: pw.TextStyle(
            color: PdfColor.fromHex("#6e6d6d"),
            fontSize: 11,
          ),
        ),
        pw.Row(
          children: [
            pw.Text(
              "Ordem de serviço: ",
              style: pw.TextStyle(
                color: PdfColor.fromHex("#6e6d6d"),
                fontSize: 11,
              ),
            ),
            pw.Text(
              id.toString(),
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
