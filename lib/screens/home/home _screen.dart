import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/utils/shared_prefs.dart';
import 'package:todo_app/widgets/custom_button.dart';
import 'package:todo_app/widgets/custom_search.dart';
import 'package:todo_app/widgets/custom_textfield.dart';
import 'package:todo_app/widgets/loader.dart';

import '../../models/todo.dart';
import '../../routes.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        "TODO",
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 30,
          color: Color(0xff000000),
          fontWeight: FontWeight.w600,
        ),
      ),
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context, builder: (context)=> const Dialog(
              child: MainpulateTodo(),
            ));
          },
              icon: const FaIcon(FontAwesomeIcons.plus,
                color: Colors.black, )
          ),
          IconButton(onPressed: (){
            showDialog(
                context: context,
                builder: (context)=> AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))
                  ),
                  title: const Text("Logout?"),
                  content: const Text("Are you want to logout?"),
                  actions: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style:ElevatedButton.styleFrom(backgroundColor: Colors.green,),
                      child: const Text("Cencel"),),
                    ElevatedButton(
                        onPressed: () async {
                          await SharedPrefs().removeUser();
                          Get.offAllNamed(GetRoutes.login);
                        },
                        style:ElevatedButton.styleFrom(backgroundColor: Colors.red,),
                        child: const Text("Logout")),
                  ],
                ) );
          }, 
              icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket,
            color: Colors.black,
          ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GetBuilder<TodoController>(
          builder: (controller) {
            return Column(
              children: [
                CustomSearch(onChanged: (val){
                  controller.search(val);
                }),
                const SizedBox(height: 30,),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                  children: controller.filteredTodo.map(
                          (todo) => Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(onPressed: (context){
                            controller.titleController.text = todo.title!;
                            controller.descriptionController.text = todo.description!;
                            controller.update();
                            showDialog(context: context, builder: (context)=> Dialog(
                              child: MainpulateTodo(edit: true, id: todo.id!,),
                            ));
                          },
                            backgroundColor: const Color(0xff8394FF),
                            foregroundColor: Colors.white,
                            icon: FontAwesomeIcons.pencil,
                            label: "Edit",
                          ),
                          SlidableAction(onPressed: (context){
                            showDialog(
                                context: context,
                                builder:(context)=>AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                  title: const Text("Delete"),
                                  content: Text("Are you sure, you want to delete '${todo.title}' this todo"),

                                  actions: [
                                    ElevatedButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        style:ElevatedButton.styleFrom(backgroundColor: Colors.green,),
                                        child: const Text("Cencel"),),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await Get.showOverlay(
                                              asyncFunction: () => controller.deleteTodo(todo.id!),
                                              loadingWidget: const Loader());
                                          Navigator.pop(context);
                                        },
                                        style:ElevatedButton.styleFrom(backgroundColor: Colors.red,),
                                        child: const Text("Confirm")),
                                  ],
                                ));
                          },
                          backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: FontAwesomeIcons.trash,
                            label: "Delete",
                          )
                        ],
                      ),
                      child: TodoTile(
                        todo: todo
                      ),
                  )).toList(),
                  ),
                )
                )
              ],
            );
          }
        ),
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  const TodoTile({Key? key, required this.todo} ) : super(key: key);

  //this final Todo import from model file
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius:  BorderRadius.circular(14.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0,3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title!,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 21,
              color: Color(0xff000000),
              fontWeight:  FontWeight.w600,
            ),
            softWrap: false,
          ),
          const SizedBox(height: 10,),
          Text(
            todo.date!,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
              color: Color(0xff131212),
            ),
            softWrap: true,
          ),
          const SizedBox(height: 10,),
          Text(
            todo.description!,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
              color: Color(0xff131212),
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}


class MainpulateTodo extends StatelessWidget {
  const MainpulateTodo({Key? key,
    this.edit=false,
    this.id= ""
  }) : super(key: key);

  final bool edit;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoController>(
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15,),
            Text(

              "${edit?"Edit":"Add"} todo",
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 21,
                color: Color(0xff000000),
                fontWeight:  FontWeight.w600,
              ),
              softWrap: false,
            ),
            const SizedBox(height: 15,),
            CustomTextField(hint: "Title",
              controller: controller.titleController,),
            const SizedBox(height: 10,),
            CustomTextField(hint: "Description",
              maxLines: 10,
              controller: controller.descriptionController ,
              ),
            const SizedBox(height: 10,),
            CustomButton(label: edit?"Edit":"Add", onPressed:()async{
              if (!edit) {
                await Get.showOverlay(
                    asyncFunction: () => controller.addTodo(),
                    loadingWidget: const Loader());

              }
              else{
                await Get.showOverlay(
                    asyncFunction: () => controller.editTodo(id),
                    loadingWidget: const Loader());

              }
              Navigator.pop(context);
              }),
            const SizedBox(height: 15,),

          ],
        );
      }
    );
  }
}
