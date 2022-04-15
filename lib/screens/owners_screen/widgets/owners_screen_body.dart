import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:dashboard/screens/owners_screen/widgets/owner_form/owner_form.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class OwnersScreenBody extends StatelessWidget {
  final OwnerRepository _ownerRepository;
  final List<OwnerAccount> _initialOwners;

  const OwnersScreenBody({
    required OwnerRepository ownerRepository,
    required List<OwnerAccount> initialOwners,
    Key? key
  })
    : _ownerRepository = ownerRepository,
      _initialOwners = initialOwners,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 0 : SizeConfig.getWidth(10),
          right: ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? 0 : SizeConfig.getWidth(10),
        ),
        child: BlocBuilder<OwnersScreenBloc, OwnersScreenState>(
          builder: (context, state) {
            if (state.formVisible) {
              return OwnerForm(ownerRepository: _ownerRepository, ownerAccount: state.editingAccount);
            }
            return Column(
              children: [
                SizedBox(height: SizeConfig.getHeight(3)),
                _title(context: context, state: state),
                SizedBox(height: SizeConfig.getHeight(5)),
                Stack(
                  children: [
                    _ownersList(state: state, context: context),
                    _newOwnerButton(context: context),
                  ],
                )
              ],
            );
          }
        )
      ),
    );
  }

  Widget _title({required BuildContext context, required OwnersScreenState state}) {
    return Column(
      children: [
        BoldText3(text: 'Current Owners', context: context),
        Text4(text: "Only those who own 25% or more.", context: context),
        SizedBox(height: SizeConfig.getHeight(2)),
        if (!state.owners.any((owner) => owner.primary) && state.owners.isNotEmpty)
          Text4(text: "An Account Controller is Required!", context: context, color: Theme.of(context).colorScheme.warning),
      ],
    );
  }
  
  Widget _ownersList({required OwnersScreenState state, required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      width: MediaQuery.of(context).size.width,  
      child: ListView.builder(
        itemCount: state.owners.isNotEmpty ? state.owners.length + 1 : state.owners.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == state.owners.length && state.owners.isNotEmpty) {
            return _saveButton(context: context, state: state);
          }
          return Card(
            key: Key("ownerCard-$index"),
            elevation: 5,
            child: ListTile(
              title: BoldText5(text: "${state.owners[index].firstName} ${state.owners[index].lastName}", context: context),
              subtitle: state.owners[index].primary 
                ? Text4(text: "Account Controller", context: context)
                : Container(),
              leading: ResponsiveWrapper.of(context).isSmallerThan(TABLET) ? null : Icon(Icons.account_circle, size: state.owners[index].primary ? 56 : 46),
              trailing: state.isSubmitting 
                ? const CircularProgressIndicator()
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: Key("editOwnerButton-$index"),
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.callToAction,
                      onPressed: () => _showOwnerForm(context: context, ownerAccount: state.owners[index]),
                    ),
                    IconButton(
                      key: Key("deleteOwnerButton-$index"),
                      icon: const Icon(Icons.cancel),
                      color: Theme.of(context).colorScheme.danger,
                      onPressed: () => _deleteButtonPressed(context: context, ownerAccount: state.owners[index]),
                    ),
                  ],
                ),
            ),
          );
        }
      )
    );
  }

  Widget _newOwnerButton({required BuildContext context}) {
    return Positioned(
      bottom: SizeConfig.getHeight(25),
      right: SizeConfig.getHeight(4),
      child: FloatingActionButton(
        key: const Key("newOwnerButtonKey"),
        backgroundColor: Theme.of(context).colorScheme.callToAction,
        child: const Icon(Icons.add),
        onPressed: () => _showOwnerForm(context: context, ownerAccount: null),
      ),
    );
  }

  void _deleteButtonPressed({required BuildContext context, required OwnerAccount ownerAccount}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        key: const Key("deleteOwnerDialogKey"),
        title: Text("Remove ${ownerAccount.firstName} as owner?"),
        content: Text('This will remove ${ownerAccount.firstName} as an owner!'),
        actions: [
          TextButton(
            key: const Key("cancelDeleteOwnerButtonKey"),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.callToAction)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            key: const Key("confirmDeleteOwnerButtonKey"),
            child: Text('Confirm', style: TextStyle(color: Theme.of(context).colorScheme.danger)),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    ).then((removeOwner) {
      if (removeOwner) {
        BlocProvider.of<OwnersScreenBloc>(context).add(OwnerRemoved(owner: ownerAccount));
      }
    });
  }

  Widget _saveButton({required BuildContext context, required OwnersScreenState state}) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.getHeight(5)),
      child: ElevatedButton(
        key: const Key("saveButtonKey"),
        onPressed: _buttonEnabled(state: state) 
          ? () => _finishButtonPressed(context: context) 
          : null,
        child: _buttonChild(context: context),
      ),
    );
  }
  
  Widget _buttonChild({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }
  
  bool _buttonEnabled({required OwnersScreenState state}) {
    return state.owners.any((owner) => owner.primary) && 
      state.owners != _initialOwners;
  }
  
  void _showOwnerForm({required BuildContext context, OwnerAccount? ownerAccount}) {
    BlocProvider.of<OwnersScreenBloc>(context).add(ShowForm(account: ownerAccount));
  }

  void _finishButtonPressed({required BuildContext context}) {
    ToastMessage(
      context: context,
      message: "Owners Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop(true));
  }
}