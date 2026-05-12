import 'dart:io';
import 'package:espresso_partes_cafe/components/sell_pdf.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/models/sell.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

class PdfUtils {
  static Future<void> createAndSharePdf({
    required Sell sell,
    required MyCompany myCompany,
    required Customer customer,
  }) async {
    final pdf = pw.Document();

    try {
      print(myCompany.createdAt);
      final image = pw.MemoryImage(
        File(myCompany.createdAt).readAsBytesSync(),
      );

      //     final image = pw.MemoryImage(
      //   (await rootBundle.load('assets/images/logotipo.jpg'))
      //       .buffer
      //       .asUint8List(),
      // );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return SellPdf.pdfPage(
              context,
              image: image,
              sell: sell,
              myCompany: myCompany,
              customer: customer,
            );
          },
        ),
      );

      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/venda-${sell.id}.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(path)],
        subject: "espresso partes café",
      );
    } on PathNotFoundException catch (_) {
      throw "Imagem da Logo Não Encontrada";
    } catch (error) {
      throw "Erro inesperado";
    }
    // await Future.delayed(const Duration(minutes: 5));
    // Exclua o arquivo após compartilhá-lo
    // await file.delete();
  }
}
