import 'package:app/middleware/models/packlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_text_form_field.dart';

class GearItemSpawner extends StatelessWidget {
  // TODO : needs translation

  TextEditingController titleController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  final bool isNew;
  final ValueChanged<bool> despawn;
  GearItem item;
  final List<GearItem> list;
  final List<dynamic> removedItems;
  final _formKey = GlobalKey<FormState>();

  GearItemSpawner(this.isNew, this.list,
      {this.despawn, this.item, this.removedItems}) {
        if (item == null) {
          item = new GearItem();
        }
        titleController.text = item.title;
        if (item.amount != null)
          weightController.text = item.weight.toString();
        if (item.weight != null)
          amountController.text = item.amount.toString();

        linkController.text = item.url;
        brandController.text = item.brand;
      }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
              child: Text(isNew ? 'Add item' : 'Edit item',
                  style: Theme.of(context).textTheme.headline3),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 2,
                      child: CustomTextFormField(
                        null,
                        'Title',
                        null,
                        1,
                        1,
                        TextInputType.text,
                        EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                        controller: titleController,
                        validator: (String value) {
                          if (value.isEmpty) return '';
                        },
                      )),
                  Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          null,
                          'Weight',
                          null,
                          1,
                          1,
                          TextInputType.number,
                          EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                          inputFormatter: FilteringTextInputFormatter.digitsOnly,
                          controller: weightController,
                          validator: (String value) {
                            if (value.isEmpty) return '';
                          },
                          )),
                  Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          null,
                          'Amount',
                          null,
                          1,
                          1,
                          TextInputType.number,
                          EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                          controller: amountController,
                          inputFormatter: FilteringTextInputFormatter.digitsOnly,
                          validator: (String value) {
                            if (value.isEmpty) return '';
                          },
                          ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          null,
                          'Link',
                          null,
                          1,
                          1,
                          TextInputType.url,
                          EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                          controller: linkController)),
                  Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          null,
                          'Brand',
                          null,
                          1,
                          1,
                          TextInputType.text,
                          EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                          controller: brandController,
                          )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.done_rounded),
                      onPressed: () {

                        if (_formKey.currentState.validate()) {

                          item.title = titleController.text;
                          item.amount = int.tryParse(amountController.text) ?? 0;
                          item.weight = int.tryParse(weightController.text) ?? 0;
                          item.url = linkController.text;
                          item.brand = brandController.text;

                          if (!isNew) 
                            item.createdAt = Timestamp.now();

                          int index = list.indexOf(item);
                          if (index == -1) 
                            list.add(item);
                        
                          else 
                            list[index] = item;
                        
                          despawn(false);

                        }}),
                  IconButton(
                      icon: Icon(Icons.delete_outline_rounded),
                      onPressed: () {
                        if (!isNew) {
                          list.remove(item);
                          removedItems.add(item.createdAt);
                        }
                        despawn(false);
                      })
                ],
              ),
            ),
            Divider(thickness: 1)
          ],
        ),
      ),
    );
  }

  void dispose() {
    titleController = new TextEditingController();
    weightController = new TextEditingController();
    amountController = new TextEditingController();
    linkController = new TextEditingController();
    brandController = new TextEditingController();
  }
}
