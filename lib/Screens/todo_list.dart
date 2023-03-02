// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_2/Screens/adding_page.dart';
import 'package:flutter_api_2/Services/todo_services.dart';
import 'package:http/http.dart' as http;

import '../Utils/snackBar_helpers.dart';
import '../widgets/card.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  //to show indicator when loading
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text(
              'Create Todo',
              style: Theme.of(context).textTheme.headline2,
            )),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return TodoCard(
                    index: index,
                    item: item,
                    navtoEdit: navigateToEditPage,
                    deleteById: deleteById,
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigatToAddPage, label: Text('Add task')),
    );
  }

// edit button page routing
  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTask(todo: item));

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  // added future keyword for automatically reload the list

  Future<void> navigatToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddTask());

    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);

    if (isSuccess) {
      // remove from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showError(context, message: 'Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showError(context, message: 'Failed to fetch');
    }
    setState(() {
      isLoading = false;
    });
  }
}
