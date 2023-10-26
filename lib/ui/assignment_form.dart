import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsi1_b2/ass_func.dart';
import 'package:responsi1_b2/assignment.dart';
import 'package:responsi1_b2/ui/assignment_page.dart';
import 'package:responsi1_b2/warning_dialog.dart';


// ignore: must_be_immutable
class TaskForm extends StatefulWidget {
  Assignment? assignment;
  TaskForm({Key? key, this.assignment}) : super(key: key);
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Add Assignment";
  String tombolSubmit = "Save";
  final _titleTextboxController = TextEditingController();
  final _descriptionTextboxController = TextEditingController();
  final _deadlineTextboxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.assignment != null) {
      setState(() {
        judul = "Update Assignment";
        tombolSubmit = "Update";
        _titleTextboxController.text = widget.assignment!.title!;
        _descriptionTextboxController.text = widget.assignment!.description!;
        _deadlineTextboxController.text = widget.assignment!.deadline!;
      });
    } else {
      judul = "Add Assignment";
      tombolSubmit = "Save";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _titleTextField(),
                _descriptionTextField(),
                _deadlineTextField(),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Membuat Textbox Title
  Widget _titleTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Title"),
      keyboardType: TextInputType.text,
      controller: _titleTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Title harus diisi";
        }
        return null;
      },
    );
  }

  //Membuat Textbox Description
  Widget _descriptionTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Description"),
      keyboardType: TextInputType.text,
      controller: _descriptionTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Description harus diisi";
        }
        return null;
      },
    );
  }

//Membuat Textbox Deadline
  Widget _deadlineTextField() {
    return TextField(
                controller: _deadlineTextboxController,
                decoration: const InputDecoration( 
                   icon: Icon(Icons.calendar_today),
                   labelText: "Deadline"
                ),
                readOnly: true, 
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101)
                  );
                  
                  if(pickedDate != null ){
                      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                         _deadlineTextboxController.text = formattedDate; //set output date to TextField value. 
                      });
                  }else{
                      print("Date is not selected");
                  }
                },
             );
  }

  //Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
        child: Text(tombolSubmit),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.assignment != null) {
                //kondisi update produk
                ubah();
              } else {
                //kondisi tambah produk
                simpan();
              }
            }
          }
        });
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Assignment createProduk = Assignment(id: null);
    createProduk.title = _titleTextboxController.text;
    createProduk.description = _descriptionTextboxController.text;
    createProduk.deadline = _deadlineTextboxController.text;
    Bloc.addAssignment(assignment: createProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const TaskPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Assignment updateProduk = Assignment(id: widget.assignment!.id!);
    updateProduk.title = _titleTextboxController.text;
    updateProduk.description = _descriptionTextboxController.text;
    updateProduk.deadline = _deadlineTextboxController.text;
    Bloc.updateAssignment(assignment: updateProduk).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const TaskPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
