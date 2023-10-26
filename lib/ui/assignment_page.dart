import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsi1_b2/ass_func.dart';
import 'package:responsi1_b2/assignment.dart';
import 'package:responsi1_b2/ui/assignment_detail.dart';
import 'package:responsi1_b2/ui/assignment_form.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment List'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(Icons.add, size: 26.0),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TaskForm()));
                },
              ))
        ],
      ),
      body: FutureBuilder<List>(
        future: Bloc.getAssignments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListAssignment(
                  list: snapshot.data,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ListAssignment extends StatelessWidget {
  final List? list;

  const ListAssignment({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemAssignment(
            assignment: list![i],
          );
        });
  }
}

class ItemAssignment extends StatelessWidget {
  final Assignment assignment;

  const ItemAssignment({Key? key, required this.assignment}) : super(key: key);

  String getFormattedDeadline() {
    try {
      final deadlineDateTime = DateTime.parse(assignment.deadline!);
      return "Deadline: ${DateFormat('dd MMMM yyyy').format(deadlineDateTime)}";
    } catch (e) {
      return "Deadline: Unsupported Date Format";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentDetail(
              assignment: assignment,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(assignment.title!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.description!.length > 20
                    ? '${assignment.description!.substring(0, 20)}...'
                    : assignment.description!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                getFormattedDeadline(), // Call the function here
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
