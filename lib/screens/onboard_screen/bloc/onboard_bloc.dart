import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/status.dart';

enum OnboardEvent {next, prev}


class OnboardBloc extends Bloc<OnboardEvent, int> {
  
  OnboardBloc({required Status accountStatus}) 
    : super(_setInitialStep(accountStatus: accountStatus));

  @override
  Stream<int> mapEventToState(OnboardEvent event) async* {
    if (event == OnboardEvent.next) {
      yield state + 1;
    } else if (event == OnboardEvent.prev) {
      yield state - 1;
    }
  }

  static int _setInitialStep({required Status accountStatus}) {
    int step;
    switch (accountStatus.code) {
      case 100:
        step = 0;
        break;
      case 101:
        step = 1;
        break;
      case 102:
        step = 2;
        break;
      case 103:
        step = 3;
        break;
      case 104:
        step = 4;
        break;
      case 105:
        step = 5;
        break;
      case 106:
        step = 6;
        break;
      case 107:
        step = 7;
        break;
      default:
        step = 0;
    }
    return step;
  }
}
