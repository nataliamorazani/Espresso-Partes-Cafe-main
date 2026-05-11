import 'dart:io';

import 'package:espresso_partes_cafe/components/app_drawer.dart';
import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/image_input.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/services/db_my_company_service.dart';
import 'package:espresso_partes_cafe/services/db_product_service.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:espresso_partes_cafe/utils/db_backup_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyData =
        Provider.of<DbMyCompanyService>(context, listen: false).companyData;
    handlePressCompany(route) {
      Navigator.of(context).pushNamed(route);
    }

    handleBackup() async {
      try {
        await DbBackupUtil.fazerBackup();
        Callback.snackBar(context, title: "Backup criado", error: false);
      } catch (error) {
        Callback.snackBar(context, title: error.toString());
      }
    }

    reloadData() {
      Provider.of<DbMyCompanyService>(context, listen: false).loadCompanyData();
      Provider.of<DbCustomerService>(context, listen: false).loadData();
      Provider.of<DbProductService>(context, listen: false).loadData();
      Provider.of<DbSalesService>(context, listen: false).loadData();
    }

    handleRestoureBackup() async {
      try {
        final String backupFilePath =
            await DbBackupUtil.selectFileToRestoreBackup();

        final bool res = await Callback.confirm(
          context: context,
          content:
              "Todos os dados armazenados serão substituidos. \nDeseja continuar com a restauração?",
          confirmText: "Continuar",
        );
        if (res) {
          await DbBackupUtil.restaurarBackup(backupFilePath);
          reloadData();
          Callback.snackBar(
            context,
            title: "Backup restaurado com sucesso!",
            error: false,
          );
        } else {
          Callback.snackBar(context, title: "Restaurar Backup cancelado!");
        }
      } catch (error) {
        Callback.snackBar(context, title: error.toString());
      }
    }

    onSelectImage(File file) {
      try {
        Provider.of<DbMyCompanyService>(context, listen: false)
            .updateCompanyLogo(file.path);
        reloadData();
      } catch (error) {
        Callback.snackBar(context, title: "Erro ao salvar");
      }
    }

    const title = "Configurações";

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: ListView(
        children: [
          ImageInput(
            onSelectImage,
            selectedImage: companyData.createdAt,
          ),
          const Divider(height: 0),
          SettingsButton(
            icon: Icons.domain_add_outlined,
            text: "Dados da empresa",
            onPressed: () => handlePressCompany(AppRoutes.companyData),
          ),
          SettingsButton(
            icon: Icons.backup_outlined,
            text: "Fazer Backup",
            onPressed: () => handleBackup(),
          ),
          SettingsButton(
            icon: Icons.cloud_download_outlined,
            text: "Restaurar Backup",
            onPressed: () => handleRestoureBackup(),
          ),
        ],
      ),
      drawer: const AppDrawer(
        currentRoute: AppRoutes.settings,
        title: title,
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final IconData icon;
  const SettingsButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      height: 60,
      child: TextButton.icon(
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(left: 15),
          ),
        ),
        icon: Icon(
          icon,
          size: 30,
          color: Theme.of(context).colorScheme.tertiary.withOpacity(.8),
        ),
        onPressed: onPressed,
        label: Text(
          text,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(.7),
          ),
        ),
      ),
    );
  }
}
