import 'dart:io';
import 'package:espresso_partes_cafe/utils/db_util.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';

class DbBackupUtil {
  static String backupFileName =
      'backup-${FormaterUtil.formatDate(DateTime.now()).replaceAll("/", "_")}-${DbUtil.dbName}';

  static Future<void> fazerBackup() async {
    try {
      // Obtenha o diretório de documentos para salvar o arquivo de backup
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String backupPath = join(documentsDirectory.path, backupFileName);

      // Obtenha o caminho do banco de dados original
      String databasePath = join(await getDatabasesPath(), DbUtil.dbName);

      // Copie o arquivo do banco de dados para o arquivo de backup
      await File(databasePath).copy(backupPath);

      await Share.shareXFiles(
        [XFile(backupPath)],
        subject: backupFileName,
      );
    } catch (e) {
      throw "Erro ao criar backup.";
    }
  }

  static Future<void> restaurarBackup(String backupFilePath) async {
    try {
      // Obtenha o caminho do banco de dados original
      String databasePath = join(await getDatabasesPath(), DbUtil.dbName);
      // Feche o banco de dados original, se estiver aberto
      await databaseFactory.deleteDatabase(databasePath);
      // Copie o arquivo de backup selecionado para o local original do banco de dados
      await File(backupFilePath).copy(databasePath);
    } catch (error) {
      throw "Erro ao restaurar backup.";
    }
  }

  static Future<String> selectFileToRestoreBackup() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      String backupFilePath = result.files.single.path!;
      // Verifique se o arquivo de backup existe e tem o padrão correto
      final List<String> parts = backupFilePath.split("/");
      final String fileName = parts[parts.length - 1];
      if (File(backupFilePath).existsSync() &&
          RegExp(r'^backup-\d{2}_\d{2}_\d{4}-espresso_partes_cafe\.db$')
              .hasMatch(fileName)) {
        return backupFilePath;
      } else {
        throw 'Arquivo de backup formato inválido. \nExemplo Valido: "$backupFileName"';
      }
    } else {
      throw "Seleção do arquivo cancelada.";
    }
  }
}
