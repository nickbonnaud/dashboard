import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputFormatters {
  
  static MaskTextInputFormatter phone({String? initial}) {
    return MaskTextInputFormatter(
      mask: '(###) ###-####', 
      filter: { "#": RegExp(r'[0-9]') },
      initialText: initial
    );
  }

  static MaskTextInputFormatter ein({String? initial}) {
    return MaskTextInputFormatter(
      mask: '##-#######',
      filter: { "#": RegExp(r'[0-9]') },
      initialText: initial
    );
  }

  static MaskTextInputFormatter date() {
    return MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  }

  static MaskTextInputFormatter ssn() {
    return MaskTextInputFormatter(mask: '###-##-####', filter: { "#": RegExp(r'[0-9]') });
  }

  static MaskTextInputFormatter uuid() {
    return MaskTextInputFormatter(mask: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', filter: { "x": RegExp(r'[A-Za-z0-9]') });
  }

  static MaskTextInputFormatter routingNumber({String? initial}) {
    return MaskTextInputFormatter(
      mask: 'xxxxxxxxx',
      filter: { 'x': RegExp(r'[xX0-9]') },
      initialText: initial
    );
  }

  static MaskTextInputFormatter accountNumber({String? initial}) {
    return MaskTextInputFormatter(
      mask: 'xxxxxxxxxxxxxxxxx',
      filter: { 'x': RegExp(r'[xX0-9]') },
      initialText: initial
    );
  }

  static MaskTextInputFormatter setLengthDigits({required int numberDigits, String? initial}) {
    String mask = "";

    while (numberDigits > 0) {
      mask = mask + "#";
      numberDigits--;
    }
    return MaskTextInputFormatter(
      mask: mask, 
      filter: { '#': RegExp(r'[0-9]') },
      initialText: initial
    );
  }

  static MaskTextInputFormatter setLengthAlpha({required int numberAlpha, String? initial}) {
    String mask = "";

    while (numberAlpha > 0) {
      mask = mask + "A";
      numberAlpha--;
    }
    return MaskTextInputFormatter(
      mask: mask,
      filter: { 'A': RegExp(r'[A-Za-z]') },
      initialText: initial
    );
  }
}