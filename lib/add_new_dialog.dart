import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite/db/my_database.dart';
import 'package:sqlite/model/task_model.dart';
import 'package:sqlite/utils.dart';

class AddNewDialog extends StatefulWidget {
  const AddNewDialog({super.key});

  @override
  State<AddNewDialog> createState() => _AddNewDialogState();
}

class _AddNewDialogState extends State<AddNewDialog> {
  MyDatabase myDatabase = MyDatabase.instance;
  var dateController = TextEditingController();
  var titleController = TextEditingController();
  var quantityController = TextEditingController();
  var priceController = TextEditingController();
  String quantityType = Utils.weightList[0];

  String selectedMonth = DateFormat.MMMM().format(DateTime.now());


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Add New', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100)
                    );
                    if (newDate == null) return;
                    setState(() {
                      dateController.text = DateFormat('dd-MM-yyyy').format(newDate);
                      selectedMonth = DateFormat.MMMM().format(newDate);
                    });
                  },
                  child: TextFormField(
                    controller: dateController,
                    enabled: false,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.name,
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_month, color: Colors.grey,),
                      hintText: 'Select Date',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: titleController,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Title',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Quantity',
                        ),
                        controller: quantityController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            iconEnabledColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            dropdownColor: Theme.of(context).primaryColor,
                            value: quantityType,
                            items: Utils.weightList
                                .map((String value) => DropdownMenuItem(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  Text(value),
                                ],
                              ),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                quantityType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text('₹ '),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Price',
                        ),
                        controller: priceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if(dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select Date')));
                    } else if(titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter Title')));
                    } else if(quantityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter Quantity')));
                    } else if(quantityType == Utils.weightList[0]) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select Unit')));
                    } else if(priceController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter Price')));
                    } else {
                      TaskModel model = TaskModel(
                          date: dateController.text,
                          month: selectedMonth,
                          title: titleController.text.trim().toUpperCase(),
                          quantity: '${quantityController.text} $quantityType',
                          price: double.parse(priceController.text)
                      );
                      myDatabase.create(model);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('SAVE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
