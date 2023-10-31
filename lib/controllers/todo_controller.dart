import 'dart:convert';
import 'package:flutter/cupertino.dart';
//import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/custom_snackbar.dart';
import 'package:todo_app/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import '../models/todo.dart';
import '../models/user.dart';
import '../utils/baseurl.dart';

class TodoController extends GetxController {
  List<Todo> todos = [];
  List<Todo> filteredTodo = [];

  late TextEditingController titleController, descriptionController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fatchMyTodos();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    descriptionController.dispose();
  }

  fatchMyTodos() async {
    var usr = await SharedPrefs().getUser();
    User users = User.fromJson(json.decode(usr));
    var response = await http.post(Uri.parse("${baseurl}todo.php"), body: {
      //This users.id come from fatchMyTodos(){} functions (User users)
      "users_id": users.id,
    });
    // this line response.body comes from avobe l var response = await http.get (Uri....)
    var res = await json.decode(response.body);
    if (res["success"]) {
      todos = AllTodo.fromJson(res).todo!;
      filteredTodo = AllTodo.fromJson(res).todo!;

      update();
    } else {
      customSnakbar("Error", "Failed to fetch todos", "error");
    }
  }

  search(String val) {
    if (val.isEmpty) {
      filteredTodo = todos;
      update();
      return;
    }
    // here we first convert the the in lowercase
    // then compare with the titel of the todo list
    filteredTodo = todos.where((todo) {
      return todo.title!.toLowerCase().contains(val.toLowerCase());
    }).toList();

    update();
  }

  addTodo() async {
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));
    var response = await http.post(Uri.parse("${baseurl}add_todo.php"), body: {
      "users_id": user.id,
      "title": titleController.text,
      "description": descriptionController.text,
    });
    var res = await json.decode(response.body);
    if (res['success']) {
      customSnakbar("Success", res["message"], "success");
      titleController.text = "";
      descriptionController.text = "";
      fatchMyTodos();
    } else {
      customSnakbar("Error", res["message"], "error");
    }
    update();
  }

  editTodo(id) async {
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));
    var response = await http.post(Uri.parse("${baseurl}edit_todo.php"), body: {
      "id": id,
      "users_id": user.id,
      "title": titleController.text,
      "description": descriptionController.text,
    });
    var res = await json.decode(response.body);
    if (res['success']) {
      customSnakbar("Success", res["message"], "success");
      titleController.text = "";
      descriptionController.text = "";
      fatchMyTodos();
    } else {
      customSnakbar("Error", res["message"], "error");
    }
    update();
  }

  deleteTodo(id) async {
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));
    var response =
        await http.post(Uri.parse("${baseurl}delete_data.php"), body: {
      "id": id,
      "users_id": user.id,
    });
    var res = await json.decode(response.body);
    if (res['success']) {
      customSnakbar("Success", res["message"], "success");
      fatchMyTodos();
    } else {
      customSnakbar("Error", res["message"], "error");
    }
    update();
  }
}
