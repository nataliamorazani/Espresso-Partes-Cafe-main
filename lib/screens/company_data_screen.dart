import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/custom_elevated_button.dart';
import 'package:espresso_partes_cafe/components/custom_input.dart';
import 'package:espresso_partes_cafe/components/custom_input_mask.dart';
import 'package:espresso_partes_cafe/models/my_company.dart';
import 'package:espresso_partes_cafe/services/db_my_company_service.dart';
import 'package:espresso_partes_cafe/utils/address_by_cep_util.dart';
import 'package:espresso_partes_cafe/utils/validator_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyDataScreen extends StatefulWidget {
  const CompanyDataScreen({Key? key}) : super(key: key);

  @override
  State<CompanyDataScreen> createState() => _CompanyDataScreenState();
}

class _CompanyDataScreenState extends State<CompanyDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerStreet = TextEditingController();
  final TextEditingController _controllerNeighborhood = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final TextEditingController _controllerState = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();

  Map<String, Object> _formData = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<DbMyCompanyService>(context);
    final MyCompany data = provider.companyData;
    _controllerStreet.text = data.address.street;
    _controllerNeighborhood.text = data.address.neighborhood;
    _controllerCity.text = data.address.city;
    _controllerState.text = data.address.state;
    _controllerUsername.text = data.username;
    _controllerCpf.text = data.cpf;

    _formData = {
      "companyName": data.companyName,
      "cnpj": data.cnpj,
      "zipCode": data.address.zipCode,
      "email": data.email,
      "number": data.address.number ?? "",
      "complement": data.address.complement,
      "phone": data.phone,
      "pixDestination": data.pixDestination,
      "pixKey": data.pixKey,
    };
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    try {
      await Provider.of<DbMyCompanyService>(context, listen: false)
          .updateCompanyData(
        username: _controllerUsername.text,
        companyName: _formData["companyName"].toString(),
        phone: _formData["phone"] as String,
        email: _formData["email"] as String,
        cnpj: _formData["cnpj"] as String,
        cpf: _controllerCpf.text,
        number: int.tryParse(_formData["number"].toString()),
        street: _controllerStreet.text,
        city: _controllerCity.text,
        state: _controllerState.text,
        complement: _formData["complement"].toString(),
        zipCode: _formData["zipCode"] as String,
        neighborhood: _controllerNeighborhood.text,
        pixDestination: _formData["pixDestination"] as String,
        pixKey: _formData["pixKey"] as String,
      );

      Navigator.of(context).pop();
    } catch (error) {
      Callback.snackBar(context);
    }
  }

  Future<void> _onCepChanged(String cep) async {
    try {
      final String? valid = ValidatorUtil.validateCEP(cep);

      if (valid == null) {
        final address = await AddressByCepUtil.getAddressFromCEP(cep);
        if (address != null) {
          if (address.street != "") {
            _controllerStreet.text = address.street;
          }
          if (address.neighborhood != "") {
            _controllerNeighborhood.text = address.neighborhood;
          }
          if (address.city != "") {
            _controllerCity.text = address.city;
          }
          if (address.state != "") {
            _controllerState.text = address.state;
          }
        }
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Empresa"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(
            top: 15.0,
            bottom: 40.0,
            left: 15.0,
            right: 15.0,
          ),
          children: [
            CustomInput(
              controller: _controllerUsername,
              label: "Nome do Responsavel",
            ),
            CustomInputMask(
              controller: _controllerCpf,
              label: "CPF",
              maskType: MaskTypes.cpf,
              validator: ValidatorUtil.validateCPF,
            ),
            CustomInput(
              formData: _formData,
              label: "Destinatário Pix",
              objectKey: "pixDestination",
            ),
            CustomInput(
              formData: _formData,
              label: "Chave Pix",
              objectKey: "pixKey",
            ),
            CustomInput(
              formData: _formData,
              label: "Nome da Empresa",
              objectKey: "companyName",
              requiredField: true,
            ),
            CustomInputMask(
              formData: _formData,
              label: "CNPJ",
              objectKey: "cnpj",
              requiredField: true,
              maskType: MaskTypes.cnpj,
              validator: ValidatorUtil.validateCNPJ,
            ),
            CustomInput(
              formData: _formData,
              label: "Email",
              objectKey: "email",
              requiredField: true,
              keyboardType: TextInputType.emailAddress,
              validator: ValidatorUtil.validateEmail,
            ),
            CustomInput(
              formData: _formData,
              label: "Telefone",
              objectKey: "phone",
              requiredField: true,
              keyboardType: TextInputType.phone,
            ),
            CustomInputMask(
              formData: _formData,
              label: "CEP",
              objectKey: "zipCode",
              requiredField: true,
              maskType: MaskTypes.cep,
              validator: ValidatorUtil.validateCEP,
              onChanged: _onCepChanged,
            ),
            CustomInput(
              label: "Endereço",
              requiredField: true,
              controller: _controllerStreet,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomInput(
                    label: "Bairro",
                    controller: _controllerNeighborhood,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomInputMask(
                    formData: _formData,
                    label: "Numero",
                    objectKey: "number",
                    keyboardType: TextInputType.number,
                    maskType: MaskTypes.interage,
                  ),
                ),
              ],
            ),
            CustomInput(
              formData: _formData,
              label: "Complemento",
              objectKey: "complement",
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomInput(
                    label: "Cidade",
                    requiredField: true,
                    controller: _controllerCity,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomInput(
                    label: "Estado",
                    requiredField: true,
                    controller: _controllerState,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              alignment: AlignmentDirectional.centerEnd,
              child: CustomElevatedButton(
                onPressed: _submitForm,
                text: 'Salvar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
