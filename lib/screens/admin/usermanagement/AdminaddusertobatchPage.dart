import 'package:flutter/material.dart';
import 'package:gtec/models/admin_model.dart';
import 'package:gtec/provider/authprovider.dart';
import 'package:provider/provider.dart';

class AdminaddusertobatchPage extends StatefulWidget {
  const AdminaddusertobatchPage(
      {super.key, required this.courseId, required this.batchId});

  final int courseId;
  final int batchId;

  @override
  _AdminaddusertobatchPageState createState() =>
      _AdminaddusertobatchPageState();
}

class _AdminaddusertobatchPageState extends State<AdminaddusertobatchPage> {
  @override
  void initState() {
    super.initState();

    // Fetch users data when the screen initializes
    Future.microtask(() {
      final provider = Provider.of<AdminAuthProvider>(context, listen: false);
      provider.AdminfetchallusersProvider();
    });
  }

  void _assignUser(int userId) async {
    final provider = Provider.of<AdminAuthProvider>(context, listen: false);

    try {
      await provider.assignUserToBatchProvider(
        courseId: widget.courseId,
        batchId: widget.batchId,
        userId: userId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User assigned to batch successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign user: $e')),
      );
    }
  }

  void _deleteUser(int userId) async {
    final provider = Provider.of<AdminAuthProvider>(context, listen: false);

    try {
      await provider.AdmindeleteUserFromBatchprovider(
        courseId: widget.courseId,
        batchId: widget.batchId,
        userId: userId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted from batch successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('All Users'),
            const Spacer(),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(),
          // Section to display all users
          Expanded(
            child: provider.users == null
                ? const Center(child: CircularProgressIndicator())
                : provider.users!.isEmpty
                    ? const Center(child: Text('No users found.'))
                    : ListView.builder(
                        itemCount: provider.users!.length,
                        itemBuilder: (context, index) {
                          final user = provider.users![index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(user.name[0].toUpperCase()),
                              ),
                              title: Text(user.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: ${user.email}'),
                                  Text('Phone: ${user.phoneNumber}'),
                                  Text('Role: ${user.role}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _assignUser(user.userId),
                                    child: const Text('Add to Batch'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _deleteUser(user.userId),
                                    child: const Text('Delete from Batch'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// Define the blue theme globally
final ThemeData blueTheme = ThemeData(
  primarySwatch: Colors.blue,
  hintColor: Colors.blueAccent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    elevation: 4,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.blue.shade50,
);
