part of 'logo_form_bloc.dart';

@immutable
class LogoFormState extends Equatable {
  final Photo initialLogo;
  final XFile? logoFile;

  const LogoFormState({required this.initialLogo, @required this.logoFile});

  factory LogoFormState.initial({required Photo logo}) {
    return LogoFormState(initialLogo: logo, logoFile: null);
  }

  LogoFormState update({required XFile logoFile}) {
    return LogoFormState(initialLogo: initialLogo, logoFile: logoFile);
  }
  
  @override
  List<Object?> get props => [initialLogo, logoFile];

  @override
  String toString() => 'LogoFormState: { initialLogo: $initialLogo, logoFile: $logoFile }';
}
