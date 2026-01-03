import 'dart:developer';

class AmountValidator{

  static String? validateTokenAmount({required String? value, required int decimalPlaces, required double minAmount,}) {
    try{
      if (value == null || value.isEmpty) {
        return 'Enter an amount';
      }

      final amount = double.tryParse(value);
      if (amount == null) {
        return 'Invalid number';
      }

      if (amount < minAmount) {
        return 'Minimum amount is $minAmount';
      }

      final parts = value.split('.');
      if (parts.length == 2 && parts[1].length > decimalPlaces) {
        return 'Maximum $decimalPlaces decimal places allowed';
      }

      return null; // Valid
    }catch(e) {
      log("Error in validateTokenAmount: $e");
      return "Invalid amount";
    }
  }

  static String? validate(String? amount){
    try{
      if (amount == null || amount.isEmpty) {
        return 'Enter an amount';
      }

      final doubleValue = double.tryParse(amount);
      if (doubleValue == null) {
        return 'Invalid number';
      }

      if (doubleValue < 1) {
        return 'Enter an amount greater than or 1 USD';
      }
      // You can add more validation rules here if needed

      return null; // Valid
    }catch(e){
      log("Error in validate: $e");
      return "Invalid amount";
    }
  }
}