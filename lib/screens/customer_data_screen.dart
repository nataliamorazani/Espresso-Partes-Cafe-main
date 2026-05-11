import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/floating_button.dart';
import 'package:espresso_partes_cafe/components/location_input.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/screens/customer_form_screen.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class CustomerDataScreen extends StatelessWidget {
  const CustomerDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerId = ModalRoute.of(context)?.settings.arguments as int;
    final customerService = Provider.of<DbCustomerService>(context);
    final customer = customerService.getById(customerId);

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Cliente")),
        body: const Center(
          child: Text("Cliente não encontrado"),
        ),
      );
    }

    remove() async {
      await customerService.deleteById(customer.id);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cliente"),
        actions: [
          IconButton(
            onPressed: () async {
              bool res = await Callback.confirm(
                context: context,
                content: "Excluir Cliente?",
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
      ),
      body: CustomerData(customer),
      floatingActionButton: FloatingButton(
        onPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (ctx) => CustomerFormScreen(customer: customer),
            ),
          );
        },
        icon: Icons.edit,
        color: Colors.amber.shade800,
      ),
    );
  }
}

class CustomerData extends StatelessWidget {
  final Customer customer;
  const CustomerData(
    this.customer, {
    super.key,
  });

  _launchURL(context, urlString, [String? phoneNumber]) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (phoneNumber != null) {
        await FlutterClipboard.copy(phoneNumber);
        Callback.snackBar(context,
            title:
                'Número de telefone copiado para a área de transferência: $phoneNumber',
            error: false);
      } else {
        Callback.snackBar(context,
            title: 'Não é possivel redirecionar para url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget field(
        {required String text,
        bool isKey = false,
        String? navigate,
        bool isPhone = false}) {
      handleNavigate() {
        if (isPhone) {
          _launchURL(context, "tel:$navigate", navigate);
        } else {
          _launchURL(context, navigate);
        }
      }

      if (navigate == null) {
        return Padding(
          padding: EdgeInsets.only(bottom: isKey ? 4 : 0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isKey ? 16 : 19,
              color: isKey
                  ? Theme.of(context).colorScheme.tertiary.withOpacity(.5)
                  : navigate != null
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(bottom: isKey ? 4 : 0),
        child: InkWell(
          onTap: () => handleNavigate(),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    var juridc = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(
          text: "Razão social: ",
          isKey: true,
        ),
        field(text: customer.name),
        const Divider(),
        field(
          text: "Solicitante: ",
          isKey: true,
        ),
        field(text: customer.requester),
        const Divider(),
        field(
          text: "Email: ",
          isKey: true,
        ),
        field(
          text: customer.email,
          navigate: "mailto:${customer.email}",
        ),
        const Divider(),
        field(
          text: "Telefone: ",
          isKey: true,
        ),
        field(
          text: customer.phone,
          navigate: customer.phone
              .replaceAll("(", "")
              .replaceAll(")", "")
              .replaceAll(" ", "")
              .replaceAll("-", "")
              .trim(),
          isPhone: true,
        ),
        const Divider(),
        field(
          text: "CNPJ: ",
          isKey: true,
        ),
        field(text: customer.cnpj),
        const Divider(),
        field(
          text: "IE: ",
          isKey: true,
        ),
        field(text: customer.stateRegistration),
        const Divider(),
        field(
          text: "IM: ",
          isKey: true,
        ),
        field(text: customer.im),
        const Divider(),
        field(
          text: "Endereço: ",
          isKey: true,
        ),
        field(
          text: customer.addressString,
        ),
      ],
    );

    var fisicPersona = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(
          text: "Nome: ",
          isKey: true,
        ),
        field(text: customer.name),
        const Divider(),
        field(
          text: "Email: ",
          isKey: true,
        ),
        field(
          text: customer.email,
          navigate: "mailto:${customer.email}",
        ),
        const Divider(),
        field(
          text: "Telefone: ",
          isKey: true,
        ),
        field(
          text: customer.phone,
          navigate: customer.phone
              .replaceAll("(", "")
              .replaceAll(")", "")
              .replaceAll(" ", "")
              .replaceAll("-", "")
              .trim(),
          isPhone: true,
        ),
        // const Divider(),
        // field(
        //   text: "Nacimento: ",
        //   isKey: true,
        // ),
        // field(
        //     text: customer.birth != null
        //         ? FormaterUtil.formatDate(customer.birth!)
        //         : ""),
        const Divider(),
        field(
          text: "CPF: ",
          isKey: true,
        ),
        field(text: customer.cpf),
        const Divider(),
        field(
          text: "RG: ",
          isKey: true,
        ),
        field(text: customer.rg),
        const Divider(),
        field(
          text: "Endereço: ",
          isKey: true,
        ),
        field(
          text: customer.addressString,
        ),
      ],
    );

    return ListView(
      padding: const EdgeInsets.only(top: 10, bottom: 100),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: customer.isJuridic ? juridc : fisicPersona,
        ),
        const SizedBox(height: 15),
        LocationInput(
          (LatLng latLange) {},
          latLngSelected: customer.addressData.latitude == null
              ? null
              : LatLng(
                  double.tryParse(customer.addressData.latitude.toString()) ??
                      0,
                  double.tryParse(customer.addressData.longitude.toString()) ??
                      0,
                ),
          viewOnly: true,
        ),
        ListTile(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.customerHistory,
            arguments: customer.id,
          ),
          minVerticalPadding: 22,
          subtitle: field(
            text: "Histórico de Vendas",
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 35,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
