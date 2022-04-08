import 'package:dashboard/models/business/employee_tip.dart';
import 'package:dashboard/resources/helpers/currency.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final EmployeeTip _employeeTip;

  const TipCard({required EmployeeTip employeeTip, Key? key})
    : _employeeTip = employeeTip,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text4(text: "${_employeeTip.firstName} ${_employeeTip.lastName}", context: context),
        trailing: Text4(text: Currency.create(cents: _employeeTip.total), context: context),
      ),
    );
  }
}