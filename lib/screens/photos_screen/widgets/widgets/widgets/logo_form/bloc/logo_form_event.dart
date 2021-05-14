part of 'logo_form_bloc.dart';

abstract class LogoFormEvent extends Equatable {
  const LogoFormEvent();

  @override
  List<Object> get props => [];
}

class LogoPicked extends LogoFormEvent {
  final PickedFile logoFile;

  const LogoPicked({required this.logoFile});

  @override
  List<Object> get props => [logoFile];

  @override
  String toString() => "LogoPicked: { logoFile: $logoFile }";
}
