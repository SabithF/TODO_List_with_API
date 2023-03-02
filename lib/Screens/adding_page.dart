// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api_2/Services/todo_services.dart';
import 'package:http/http.dart' as http;

import '../Utils/snackBar_helpers.dart';

class AddTask extends StatefulWidget {
  final Map? todo;
  const AddTask({super.key, this.todo});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo2 = widget.todo;
    if (todo2 != null) {
      isEdit = true;

      // prefix the fields with the data when you press edit button
      final title = todo2['title'];
      final description = todo2['description'];
      titleController.text = title;
      descController.text = description;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Add Task'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit')),
        ],
      ),
    );
  }

// update data
  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You cant call update without todo data');
      return;
    }
    final id = todo['_id'];

    // Submit data to the Server
    final isSuceess = await TodoService.updateTodo(id, body);

    // show success/failed msg
    if (isSuceess) {
      // to show success message
      showSuccessMsg(context, message: 'Succesfully updated');
    } else {
      showError(context, message: 'Failed to update');
    }
    ;
  }

// tp submit data
  Future<void> submitData() async {
    // Get the data from the FORM
    // Seperate 'body' created to map the data

    // Submit data to the Server
    final isSuccess = await TodoService.createTodo(body);

    if (isSuccess) {
      // to clear the fields after submitting
      titleController.text = '';
      descController.text = '';

      // to show success message
      showSuccessMsg(context, message: 'Succesfully created');
    } else {
      showError(context, message: 'Creation failed');
    }
  }

  // creating a body variable to get the data from form and also to provide the body
  Map get body {
    final title = titleController.text;
    final description = descController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
