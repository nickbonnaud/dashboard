import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/screens/onboard_screen/bloc/onboard_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardBody extends StatelessWidget {
  
  const OnboardBody({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key("scrollKey"),
      child: Padding(
        padding: EdgeInsets.only(left: SizeConfig.getWidth(5), right: SizeConfig.getWidth(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoldText3(text: "Account Setup", context: context),
            SizedBox(height: SizeConfig.getHeight(5)),
            _stepper()
          ],
        ),
      ),
    );
  }

  Widget _stepper() {
    return BlocBuilder<OnboardBloc, int>(
      builder: (context, currentStep) {
        return Stepper(
          currentStep: currentStep,
          steps: [
            Step(
              title: _title(context: context, title: 'Profile', currentStep: currentStep, stepIndex: 0),
              content: Text3(
                text: currentStep > 0
                  ? "Profile Complete"
                  : "First, let's setup your Profile!", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 0,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 0)
            ),
            Step(
              title: _title(context: context, title: 'Logos', currentStep: currentStep, stepIndex: 1),
              content: Text3(
                text: currentStep > 1
                  ? "Logos Complete"
                  : "Ensure customers recognize your brand.", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 1,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 1)
            ),
            Step(
              title: _title(context: context, title: 'Business Details', currentStep: currentStep, stepIndex: 2),
              content: Text3(
                text: currentStep > 2
                  ? "Details Complete"
                  : "Some basic details about your business entity.", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 2,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 2)
            ),
            Step(
              title: _title(context: context, title: 'Owners', currentStep: currentStep, stepIndex: 3),
              content: Text3(
                text: currentStep > 3
                  ? "Owners Complete"
                  : "Info about who owns your business.", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 3,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 3)
            ),
            Step(
              title: _title(context: context, title: 'Banking', currentStep: currentStep, stepIndex: 4),
              content: Text4(
                text: currentStep > 4
                  ? "Banking Complete"
                  : "Let's setup where ${Constants.appName} sends your payments!", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 4,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 4)
            ),
            Step(
              title: _title(context: context, title: 'Location', currentStep: currentStep, stepIndex: 5),
              content: Text4(
                text: currentStep > 5
                  ? "Location Complete"
                  : "Next, let's ensure your location is correct.", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 5,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 5)
            ),
            Step(
              title: _title(context: context, title: 'Point of Sale', currentStep: currentStep, stepIndex: 6),
              content: Text4(
                text: currentStep > 6
                  ? "POS Complete"
                  : "Connect your POS system to ${Constants.appName}!", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 6,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 6)
            ),
            Step(
              title: _title(context: context, title: 'Hours', currentStep: currentStep, stepIndex: 7),
              content: Text4(
                text: "Lastly, set your operating hours.", 
                context: context,
                color: Theme.of(context).colorScheme.onPrimarySubdued,
              ),
              isActive: currentStep == 7,
              state: _setCurrentStepState(currentStep: currentStep, stepIndex: 7)
            ),
          ],
          controlsBuilder: (context, details) {
            return TextButton(
              onPressed: () => _buttonPressed(context: context, currentStep: currentStep),
              child: BoldText5(text: _buttonText(currentStep: currentStep), context: context, color: Theme.of(context).colorScheme.callToAction),
            );
          },
        );
      }
    );
  }

  Widget _title({required BuildContext context, required String title, required int currentStep, required int stepIndex}) {
    return BoldText5(
      text: title,
      context: context,
      color: currentStep == stepIndex
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onPrimaryDisabled
    );
  }

  String _buttonText({required int currentStep}) {
    String buttonText;
    switch (currentStep) {
      case 0:
        buttonText = "Get Started";
        break;
      case 1:
        buttonText = "Add Logos";
        break;
      case 2:
        buttonText = "Add Details";
        break;
      case 3:
        buttonText = "Add Owners";
        break;
      case 4:
        buttonText = "Setup Account";
        break;
      case 5:
        buttonText = "Review Location";
        break;
      case 6:
        buttonText = "Connect POS";
        break;
      case 7:
        buttonText = "Set Hours";
        break;
      default:
        buttonText = "Get Started";
    }
    return buttonText;
  }

  StepState _setCurrentStepState({required int currentStep, required int stepIndex}) {
    if (currentStep > stepIndex) {
      return StepState.complete;
    } else if (currentStep == stepIndex) {
      return StepState.editing;
    }
    return StepState.indexed;
  }

  void _buttonPressed({required BuildContext context, required int currentStep}) {
    switch (currentStep) {
      case 0:
        _showScreen(context: context, routeName: Routes.onboardProfile);
        break;
      case 1:
        _showScreen(context: context, routeName: Routes.onboardPhotos);
        break;
      case 2:
        _showScreen(context: context, routeName: Routes.onboardBusinessAccount);
        break;
      case 3:
        _showScreen(context: context, routeName: Routes.onboardOwners);
        break;
      case 4:
        _showScreen(context: context, routeName: Routes.onboardBank);
        break;
      case 5:
        _showScreen(context: context, routeName: Routes.onboardLocation);
        break;
      case 6:
        // _showScreen(context: context, routeName: Routes.onboardPos);
        break;
      case 7:
        _showScreen(context: context, routeName: Routes.onboardHours);
        break;
    }
  }

  void _showScreen({required BuildContext context, required String routeName}) {
    Navigator.of(context).pushNamed(routeName)
      .then((_) => BlocProvider.of<OnboardBloc>(context).add(OnboardEvent.next));
  }
}