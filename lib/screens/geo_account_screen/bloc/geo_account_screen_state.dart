part of 'geo_account_screen_bloc.dart';

@immutable
class GeoAccountScreenState extends Equatable {
  final LatLng initialLocation;
  final LatLng currentLocation;
  final double initialRadius;
  final double radius;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final CustomAnimationControl errorButtonControl;

  GeoAccountScreenState({
    required this.initialLocation,
    required this.currentLocation,
    required this.initialRadius,
    required this.radius,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.errorMessage,
    required this.errorButtonControl
  });

  factory GeoAccountScreenState.initial({required Location location}) {
    return GeoAccountScreenState(
      initialLocation: LatLng(location.lat, location.lng),
      currentLocation: LatLng(location.lat, location.lng),
      initialRadius: location.radius.toDouble(),
      radius: location.radius.toDouble(),
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: '',
      errorButtonControl: CustomAnimationControl.stop,
    );
  }

  GeoAccountScreenState update({
    LatLng? currentLocation,
    double? radius,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return _copyWith(
      currentLocation: currentLocation,
      radius: radius,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      isFailure: isFailure,
      errorMessage: errorMessage,
      errorButtonControl: errorButtonControl,
    );
  }
  
  GeoAccountScreenState _copyWith({
    LatLng? currentLocation,
    double? radius,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    CustomAnimationControl? errorButtonControl
  }) {
    return GeoAccountScreenState(
      initialLocation: this.initialLocation,
      currentLocation: currentLocation ?? this.currentLocation,
      initialRadius: this.initialRadius,
      radius: radius ?? this.radius,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      errorButtonControl: errorButtonControl ?? this.errorButtonControl,
    );
  }

  @override
  List<Object?> get props => [
    initialLocation,
    currentLocation,
    initialRadius,
    radius,
    isSubmitting,
    isSuccess,
    isFailure,
    errorMessage,
    errorButtonControl
  ];
  
  @override
  String toString() {
    return '''GeoAccountScreenState {
      initialLocation: $initialLocation,
      currentLocation: $currentLocation,
      initialRadius: $initialRadius,
      radius: $radius,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      errorMessage: $errorMessage,
      errorButtonControl: $errorButtonControl,
    }''';
  }
}
