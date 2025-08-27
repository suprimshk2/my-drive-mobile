import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFieldMaskings {
  static final MaskTextInputFormatter phoneNumberMasking =
      MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
}
