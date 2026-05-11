class ValidatorUtil {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do email
    String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Por favor, insira um email válido.';
    }

    return null;
  }

  static String? validateCPF(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do CPF
    String cpfRegex = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
    if (!RegExp(cpfRegex).hasMatch(value)) {
      return 'Por favor, insira um CPF válido.';
    }

    return null;
  }

  static String? validateRG(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do CPF
    String cpfRegex = r'^\d{2}\.\d{3}\.\d{3}-\d{1}$';
    if (!RegExp(cpfRegex).hasMatch(value)) {
      return 'Por favor, insira um CPF válido.';
    }

    return null;
  }

  static String? validateCNPJ(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do CNPJ
    String cnpjRegex = r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$';
    if (!RegExp(cnpjRegex).hasMatch(value)) {
      return 'Por favor, insira um CNPJ válido.';
    }

    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do número de telefone
    String phoneRegex = r'^\(\d{2}\) \d{4,5}-\d{4}$';
    if (!RegExp(phoneRegex).hasMatch(value)) {
      return 'Por favor, insira um número de telefone válido.';
    }

    return null;
  }

  static String? validateCEP(String value) {
    if (value.isEmpty) {
      return null;
    }

    // Expressão regular para verificar o formato do CEP
    String cepRegex = r'^\d{5}-\d{3}$';
    if (!RegExp(cepRegex).hasMatch(value)) {
      return 'Por favor, insira um CEP válido.';
    }

    return null;
  }
}
