import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsi1_b2/ass_func.dart';
import 'package:responsi1_b2/assignment.dart';
import 'package:responsi1_b2/success_dialog.dart';
import 'package:responsi1_b2/ui/assignment_form.dart';
import 'package:responsi1_b2/ui/assignment_page.dart';
import 'package:responsi1_b2/warning_dialog.dart';

// ignore: must_be_immutable
class AssignmentDetail extends StatefulWidget {
  Assignment? assignment;

  AssignmentDetail({Key? key, this.assignment}) : super(key: key);

  @override
  _AssignmentDetailState createState() => _AssignmentDetailState();
}

class _AssignmentDetailState extends State<AssignmentDetail> {
  String getFormattedDeadline() {
    try {
      final deadlineDateTime = DateTime.parse(widget.assignment!.deadline!);
      return "Deadline: ${DateFormat('dd MMMM yyyy').format(deadlineDateTime)}";
    } catch (e) {
      return "Deadline: Unsupported Date Format";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0), // Adjust the left padding as needed
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the left
          children: [
            Text(
              "Title: ${widget.assignment!.title}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Description: ${widget.assignment!.description}",
              style: const TextStyle(fontSize: 18.0),
            ),
            if (widget.assignment!.deadline != null)
              Text(
                getFormattedDeadline(),
                style: const TextStyle(fontSize: 18.0),
              )
            else
              const Text(
                "No deadline specified",
                style: TextStyle(fontSize: 18.0),
              ),
            Text(
              "Created at: ${widget.assignment!.created_at}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Updated at: ${widget.assignment!.updated_at}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Center(child: _tombolHapusEdit())
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskForm(
                  assignment: widget.assignment!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        //tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            Bloc.deleteAssignment(id: widget.assignment!.id!).then(
                (value) => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TaskPage()))
                    }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
            });
          },
        ),
        //tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
