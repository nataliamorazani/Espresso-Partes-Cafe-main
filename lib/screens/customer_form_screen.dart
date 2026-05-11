import 'package:espresso_partes_cafe/components/callback.dart';
import 'package:espresso_partes_cafe/components/custom_elevated_button.dart';
import 'package:espresso_partes_cafe/components/custom_input.dart';
import 'package:espresso_partes_cafe/components/custom_input_mask.dart';
import 'package:espresso_partes_cafe/components/location_input.dart';
import 'package:espresso_partes_cafe/models/customer.dart';
import 'package:espresso_partes_cafe/services/db_customer_service.dart';
import 'package:espresso_partes_cafe/utils/address_by_cep_util.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:espresso_partes_cafe/utils/validator_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;
  const CustomerFormScreen({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _controllerStreet = TextEditingController();
  final TextEditingController _controllerNeighborhood = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final TextEditingController _controllerState = TextEditingController();
  final TextEditingController _controllerBirthDate = TextEditingController();
  bool _isEdit = false;
  DateTime? _selectedDate;

  final Map<String, Object> _formData = {
    "name": "",
    "requester": "",
    "cpf": "",
    "cnpj": "",
    "rg": "",
    "stateRegistration": "",
    "im": "",
    "birth": "",
    "zipCode": "",
    "email": "",
    "number": "",
    "complement": "",
    "phone": "",
    "longitude": "",
    "latitude": "",
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final customer = widget.customer;

    if (customer != null) {
      _isEdit = true;
      _controllerStreet.text = customer.addressData.street;
      _controllerNeighborhood.text = customer.addressData.neighborhood;
      _controllerCity.text = customer.addressData.city;
      _controllerState.text = customer.addressData.state;
      _controllerBirthDate.text = customer.birth == null
          ? ""
          : FormaterUtil.formatDate(customer.birth!);
      _formData['id'] = customer.id;
      _formData['name'] = customer.name;
      _formData['email'] = customer.email;
      _formData['phone'] = customer.phone;
      _formData['cnpj'] = customer.cnpj;
      _formData['cpf'] = customer.cpf;
      _formData['rg'] = customer.rg;
      _formData['requester'] = customer.requester;
      _formData['stateRegistration'] = customer.stateRegistration;
      _formData['im'] = customer.im;
      _formData['zipCode'] = customer.addressData.zipCode;
      _formData['number'] = customer.addressData.number ?? "";
      _formData['complement'] = customer.addressData.complement;
      _formData['longitude'] = customer.addressData.longitude ?? "";
      _formData['latitude'] = customer.addressData.latitude ?? "";
    }
  }

  void _submitForm(context, bool isJuridc) async {
    if (isJuridc) {
      final isValid = _formKey2.currentState?.validate() ?? false;
      if (!isValid) return;

      _formKey2.currentState?.save();
    } else {
      final isValid = _formKey1.currentState?.validate() ?? false;
      if (!isValid) return;

      _formKey1.currentState?.save();
    }

    try {
      await Provider.of<DbCustomerService>(context, listen: false).addOrUpdate(
        id: int.tryParse(_formData['id'].toString()),
        name: _formData["name"].toString(),
        email: _formData["email"].toString(),
        phone: _formData["phone"].toString(),
        cpf: _formData["cpf"].toString(),
        cnpj: _formData["cnpj"].toString(),
        rg: _formData["rg"].toString(),
        birth: _selectedDate,
        requester: _formData["requester"].toString(),
        stateRegistration: _formData["stateRegistration"].toString(),
        im: _formData["im"].toString(),
        street: _controllerStreet.text,
        number: int.tryParse(_formData["number"].toString()),
        city: _controllerCity.text,
        state: _controllerState.text,
        complement: _formData["complement"].toString(),
        zipCode: _formData["zipCode"].toString(),
        neighborhood: _controllerNeighborhood.text,
        isJuridic: isJuridc,
        longitude: double.tryParse(_formData["longitude"].toString()),
        latitude: double.tryParse(_formData["latitude"].toString()),
      );
      Navigator.of(context).pop();
    } catch (error) {
      Callback.snackBar(
        context,
        title: error.toString(),
      );
    }
  }

  _handleSelectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _controllerBirthDate.text = FormaterUtil.formatDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isEdit) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Editar Cliente"),
        ),
        body: !widget.customer!.isJuridic
            ? Form(
                key: _formKey1,
                child: InputList(
                  formData: _formData,
                  controllerStreet: _controllerStreet,
                  controllerNeighborhood: _controllerNeighborhood,
                  controllerCity: _controllerCity,
                  controllerState: _controllerState,
                  submitForm: _submitForm,
                  isJuridic: false,
                  controllerBirthDate: _controllerBirthDate,
                  handleSelectDate: _handleSelectDate,
                  selectedDate: _selectedDate,
                ),
              )
            : Form(
                key: _formKey2,
                child: InputList(
                  formData: _formData,
                  controllerStreet: _controllerStreet,
                  controllerNeighborhood: _controllerNeighborhood,
                  controllerCity: _controllerCity,
                  controllerState: _controllerState,
                  submitForm: _submitForm,
                  isJuridic: true,
                  controllerBirthDate: _controllerBirthDate,
                  handleSelectDate: _handleSelectDate,
                  selectedDate: _selectedDate,
                ),
              ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Novo Cliente"),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            tabs: <Widget>[
              Tab(
                text: "PESSOA FÍSICA",
              ),
              Tab(
                text: "PESSOA JURÍDICA",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Form(
              key: _formKey1,
              child: InputList(
                formData: _formData,
                controllerStreet: _controllerStreet,
                controllerNeighborhood: _controllerNeighborhood,
                controllerCity: _controllerCity,
                controllerState: _controllerState,
                submitForm: _submitForm,
                isJuridic: false,
                controllerBirthDate: _controllerBirthDate,
                handleSelectDate: _handleSelectDate,
                selectedDate: _selectedDate,
              ),
            ),
            Form(
              key: _formKey2,
              child: InputList(
                formData: _formData,
                controllerStreet: _controllerStreet,
                controllerNeighborhood: _controllerNeighborhood,
                controllerCity: _controllerCity,
                controllerState: _controllerState,
                submitForm: _submitForm,
                isJuridic: true,
                controllerBirthDate: _controllerBirthDate,
                handleSelectDate: _handleSelectDate,
                selectedDate: _selectedDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputList extends StatelessWidget {
  const InputList({
    super.key,
    required this.formData,
    required this.controllerStreet,
    required this.controllerNeighborhood,
    required this.controllerCity,
    required this.controllerState,
    required this.submitForm,
    required this.isJuridic,
    required this.controllerBirthDate,
    required this.handleSelectDate,
    required this.selectedDate,
  });

  final Map<String, Object> formData;
  final TextEditingController controllerStreet;
  final TextEditingController controllerNeighborhood;
  final TextEditingController controllerCity;
  final TextEditingController controllerState;
  final Function(BuildContext, bool) submitForm;
  final TextEditingController controllerBirthDate;
  final Function(DateTime) handleSelectDate;
  final DateTime? selectedDate;
  final bool isJuridic;
  Future<void> _onCepChanged(String cep) async {
    try {
      final String? valid = ValidatorUtil.validateCEP(cep);

      if (valid == null) {
        final address = await AddressByCepUtil.getAddressFromCEP(cep);
        if (address != null) {
          if (address.street != "") {
            controllerStreet.text = address.street;
          }
          if (address.neighborhood != "") {
            controllerNeighborhood.text = address.neighborhood;
          }
          if (address.city != "") {
            controllerCity.text = address.city;
          }
          if (address.state != "") {
            controllerState.text = address.state;
          }
        }
      }
    } catch (error) {}
  }

  Widget juridc() {
    return Column(
      children: [
        CustomInput(
          formData: formData,
          label: "Razão social",
          objectKey: "name",
          requiredField: true,
        ),
        CustomInput(
          formData: formData,
          label: "Solicitante",
          objectKey: "requester",
          requiredField: true,
        ),
        CustomInput(
          formData: formData,
          label: "Email",
          objectKey: "email",
          keyboardType: TextInputType.emailAddress,
          validator: ValidatorUtil.validateEmail,
        ),
        CustomInput(
          formData: formData,
          label: "Telefone",
          objectKey: "phone",
          keyboardType: TextInputType.phone,
        ),
        CustomInputMask(
          formData: formData,
          label: "CNPJ",
          objectKey: "cnpj",
          maskType: MaskTypes.cnpj,
          validator: ValidatorUtil.validateCNPJ,
        ),
        CustomInput(
          formData: formData,
          label: "IE",
          objectKey: "stateRegistration",
          keyboardType: TextInputType.number,
        ),
        CustomInput(
          formData: formData,
          label: "IM",
          objectKey: "im",
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget fisicPersona() {
    return Column(
      children: [
        CustomInput(
          formData: formData,
          label: "Nome do cliente",
          objectKey: "name",
          requiredField: true,
        ),
        CustomInput(
          formData: formData,
          label: "Email",
          objectKey: "email",
          keyboardType: TextInputType.emailAddress,
          validator: ValidatorUtil.validateEmail,
        ),
        CustomInput(
          formData: formData,
          label: "Telefone",
          objectKey: "phone",
          keyboardType: TextInputType.phone,
        ),
        // SizedBox(
        //   width: double.infinity,
        //   height: 60,
        //   child: Stack(
        //     fit: StackFit.expand,
        //     children: [
        //       CustomInput(
        //         controller: controllerBirthDate,
        //         label: "Nacimento",
        //         readOnly: true,
        //         keyboardType: TextInputType.datetime,
        //       ),
        //       AdaptativeDatePicker(
        //         onDateChanged: handleSelectDate,
        //         selectedDate: selectedDate,
        //         initialEntryMode: DatePickerEntryMode.input,
        //       ),
        //     ],
        //   ),
        // ),
        CustomInputMask(
          formData: formData,
          label: "CPF",
          objectKey: "cpf",
          maskType: MaskTypes.cpf,
          validator: ValidatorUtil.validateCPF,
        ),
        CustomInputMask(
          formData: formData,
          label: "RG",
          objectKey: "rg",
          maskType: MaskTypes.rg,
          validator: ValidatorUtil.validateRG,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: 0.0,
        bottom: 40.0,
        left: 0.0,
        right: 0.0,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              if (isJuridic) juridc() else fisicPersona(),
              CustomInputMask(
                formData: formData,
                label: "CEP",
                objectKey: "zipCode",
                maskType: MaskTypes.cep,
                validator: ValidatorUtil.validateCEP,
                onChanged: _onCepChanged,
              ),
              CustomInput(
                label: "Endereço",
                objectKey: "street",
                controller: controllerStreet,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomInput(
                      label: "Bairro",
                      objectKey: "neighborhood",
                      controller: controllerNeighborhood,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomInputMask(
                      formData: formData,
                      label: "Numero",
                      objectKey: "number",
                      keyboardType: TextInputType.number,
                      maskType: MaskTypes.interage,
                    ),
                  ),
                ],
              ),
              CustomInput(
                formData: formData,
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
                      objectKey: "city",
                      controller: controllerCity,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomInput(
                      label: "Estado",
                      objectKey: "state",
                      controller: controllerState,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        LocationInput(
          (LatLng latLang) {
            formData["longitude"] = latLang.longitude;
            formData["latitude"] = latLang.latitude;
          },
          latLngSelected: formData["latitude"] == ""
              ? null
              : LatLng(
                  double.tryParse(formData["latitude"].toString()) ?? 0.0,
                  double.tryParse(formData["longitude"].toString()) ?? 0.0,
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
            alignment: AlignmentDirectional.centerEnd,
            child: CustomElevatedButton(
              onPressed: () => submitForm(context, isJuridic),
              text: 'Salvar',
            ),
          ),
        ),
      ],
    );
  }
}
