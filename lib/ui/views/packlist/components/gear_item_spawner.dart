import 'package:app/middleware/models/packlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart'; 

import '../../../shared/form_fields/custom_text_form_field.dart';

// ignore: must_be_immutable
class GearItemSpawner extends StatelessWidget {

  TextEditingController titleController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  final bool isNew;
  final ValueChanged<bool> despawn;
  GearItem item;
  final List<GearItem> list;
  final List<Tuple2<String, GearItem>> removedItems;
  final List<Tuple2<String, GearItem>> updatedItems;
  final _formKey = GlobalKey<FormState>();
  final String category;

  GearItemSpawner(this.isNew, this.list,
      {this.despawn, this.item, this.removedItems, this.updatedItems, this.category}) {
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
    var texts = AppLocalizations.of(context);

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
              child: Text(isNew ? texts.addItem : texts.editItem,
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
                        texts.itemName,
                        null,
                        1,
                        1,
                        TextInputType.text,
                        EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                        controller: titleController,
                        validator: (value) {
                          if (value.isEmpty) return '';
                        },
                      )),
                  Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          null,
                          texts.weight,
                          null,
                          1,
                          1,
                          TextInputType.number,
                          EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                          inputFormatter: FilteringTextInputFormatter.digitsOnly,
                          controller: weightController,
                          validator: (value) {
                            if (value.isEmpty) return '';
                          },
                          )),
                  Expanded(
                      flex: 1,
                      child: CustomTextFormField(
                          null,
                          texts.amount,
                          null,
                          1,
                          1,
                          TextInputType.number,
                          EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                          controller: amountController,
                          inputFormatter: FilteringTextInputFormatter.digitsOnly,
                          validator: (value) {
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
                          texts.link,
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
                          texts.brand,
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
                        
                          else {
                            list[index] = item;
                            int indexForUpdated = updatedItems.indexOf(Tuple2(category, item));
                            if (indexForUpdated == -1)
                              updatedItems.add(Tuple2(category, item));
                            else 
                              updatedItems[indexForUpdated] = Tuple2(category, item);

                          }
                          despawn(false);

                        }}),
                  IconButton(
                      icon: Icon(Icons.delete_outline_rounded),
                      onPressed: () {
                        if (!isNew) {
                          list.remove(item);
                          removedItems.add(Tuple2(category, item));
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
