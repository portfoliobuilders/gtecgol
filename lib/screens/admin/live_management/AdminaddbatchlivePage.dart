import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gtec/models/admin_model.dart';
import 'package:gtec/provider/authprovider.dart';
import 'package:provider/provider.dart';

class AdminAddLiveToBatchPage extends StatefulWidget {
  final int courseId;
  final int batchId;

  const AdminAddLiveToBatchPage({
    super.key,
    required this.courseId,
    required this.batchId,
  });

  @override
  State<AdminAddLiveToBatchPage> createState() => _AdminAddLiveToBatchPageState();
}

class _AdminAddLiveToBatchPageState extends State<AdminAddLiveToBatchPage> {
  late Future<AdminLiveModel> liveDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future with the provider's fetchLiveAdmin method
    liveDataFuture = Provider.of<AdminAuthProvider>(context, listen: false)
        .fetchLiveAdmin(widget.batchId);
  }

  // Function to show the create live link dialog
  void _showCreateLiveLinkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateLiveLinkDialog(widget.courseId, widget.batchId);
      },
    ).then((_) {
      // After dialog closes, refresh live data to show newly created live link
      setState(() {
        liveDataFuture = Provider.of<AdminAuthProvider>(context, listen: false)
            .fetchLiveAdmin(widget.batchId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showCreateLiveLinkDialog, // Show dialog on button press
            ),
          ],
        ),
      ),
      body: Consumer<AdminAuthProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<AdminLiveModel>(
            future: liveDataFuture, // Use the future initialized in initState
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text('No live link available.'),
                );
              }

              // Successfully fetched live link data
              final liveLink = snapshot.data!;
              print('Live link: ${liveLink.liveLink}'); // Debugging

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Message: ${liveLink.message}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      if (liveLink.liveLink.isNotEmpty)
                        Text('Live Link: ${liveLink.liveLink}',
                            style: const TextStyle(fontSize: 16))
                      else
                        const Text(
                          'No live link provided.',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      Text(
                        'Start Time: ${DateFormat('MMM dd, yyyy HH:mm').format(liveLink.liveStartTime!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CreateLiveLinkDialog extends StatefulWidget {
  final int courseId;
  final int batchId;

  const CreateLiveLinkDialog(this.courseId, this.batchId, {super.key});

  @override
  _CreateLiveLinkDialogState createState() => _CreateLiveLinkDialogState();
}

class _CreateLiveLinkDialogState extends State<CreateLiveLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _liveLinkController = TextEditingController();
  DateTime? _liveStartTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Live Link'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _liveLinkController,
              decoration: InputDecoration(labelText: 'Live Link'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a live link';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      _liveStartTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text(_liveStartTime == null
                  ? 'Pick Live Start Time'
                  : 'Live Start Time: $_liveStartTime'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _liveStartTime != null) {
              try {
                // Call provider to create live link
                await context.read<AdminAuthProvider>().AdmincreateLivelinkprovider(
                      widget.courseId,
                      widget.batchId,
                      _liveLinkController.text,
                      _liveStartTime!,
                    );

                Navigator.of(context).pop(); // Close the dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
