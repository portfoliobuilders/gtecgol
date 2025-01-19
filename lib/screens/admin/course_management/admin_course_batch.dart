import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtec/models/admin_model.dart';
import 'package:gtec/screens/admin/course_management/admin_module_add.dart';
import 'package:provider/provider.dart';
import 'package:gtec/provider/authprovider.dart';

class AdminCourseBatchScreen extends StatefulWidget {
  final int courseId;

  const AdminCourseBatchScreen({super.key, required this.courseId});

  @override
  State<AdminCourseBatchScreen> createState() => _AdminCourseBatchScreenState();
}

class _AdminCourseBatchScreenState extends State<AdminCourseBatchScreen> {
  final TextEditingController _batchNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminAuthProvider>(context, listen: false)
          .AdminfetchBatchForCourseProvider(widget.courseId);
    });
  }

void _showEditModuleDialog(BuildContext context, AdminCourseBatch module) {
  final TextEditingController editTitleController =
      TextEditingController(text: module.batchName);
  bool isUpdating = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Edit Batch',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(16),
            content: SizedBox(
              width: 600, // Set the desired width
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: editTitleController,
                      decoration: InputDecoration(
                        labelText: 'Batch Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a batch name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: isUpdating
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              if (editTitleController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Batch name cannot be empty.'),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                isUpdating = true;
                              });

                              try {
                                final provider =
                                    Provider.of<AdminAuthProvider>(context,
                                        listen: false);

                                await provider.AdminUpdatebatchprovider(
                                  widget.courseId,
                                  module.batchId,
                                  editTitleController.text.trim(),
                                );

                                Navigator.of(context).pop();

                                await provider.AdminfetchBatchForCourseProvider(
                                    widget.courseId);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Batch updated successfully!'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error updating batch: ${e.toString()}'),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isUpdating = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue, // Sky blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}



  void _showCreateBatchDialog(BuildContext context) {
    _batchNameController.clear();
    bool isCreating = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Text(
                    'Create Batch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              
              contentPadding: const EdgeInsets.all(16),
              content: SizedBox(
                width: 600, // Set the desired width
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [ 
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                      SelectionContainer.disabled(
                        child: TextFormField(
                          controller: _batchNameController,
                          decoration: InputDecoration(
                            labelText: 'Batch Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                width: 1, // Reduced border width
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a batch name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: isCreating
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Space between buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isCreating
                            ? null
                            : () async {
                                if (_batchNameController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Batch name cannot be empty.'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isCreating = true;
                                });

                                try {
                                  final provider =
                                      Provider.of<AdminAuthProvider>(
                                    context,
                                    listen: false,
                                  );

                                  await provider.AdmincreateBatchprovider(
                                    _batchNameController.text.trim(),
                                    widget.courseId,
                                  );

                                  Navigator.of(context).pop();

                                  await provider
                                      .AdminfetchBatchForCourseProvider(
                                    widget.courseId,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Batch created successfully!'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error creating batch: ${e.toString()}'),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    isCreating = false;
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue, // Sky blue color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: isCreating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Create',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.blue,  // Set the color of the AppBar
      title: const Text('Batches', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
        onPressed: () {
          Navigator.pop(context); // Pop the current screen from the navigation stack
        },
      ),
    ),
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(
                  'BATCHES',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showCreateBatchDialog(context),
                  child: const Text('Create Batch',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(),
            SizedBox(height: 16),
            Consumer<AdminAuthProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final batches = provider.courseBatches[widget.courseId] ?? [];
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (batches.isEmpty)
                          const Text('No batches available.')
                        else
                          ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: batches.length,
  itemBuilder: (context, index) {
    final batch = batches[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminModuleAddScreen(
              courseId: widget.courseId,
              batchId: batch.batchId,
              courseName: 'Course Name', // Add the appropriate course name here
            ),
          ),
        );
      },
      child: Card(
         // Adds shadow for a card effect
        color: const Color.fromARGB(255, 255, 255, 255), // Light sky blue color for the card background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          side: BorderSide(
            color: const Color.fromARGB(255, 187, 234, 255), // Light blue border color
            width: 2, // Border width
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16), // Adds padding inside the ListTile
          title: Row(
            children: [
              // Custom number indicator (could be an index or any number you choose)
              Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200, // Light blue circle background
                  shape: BoxShape.circle, // Circular shape
                ),
                child: Text(
                  (index + 1).toString(), // Display index as number
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10), // Space between the number and batch name
              // Batch Name
              Text(
                batch.batchName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          subtitle: null, // Removed the subtitle (Batch ID)
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Button with Material Effect and Black Icon
              IconButton(
                icon: Icon(Icons.edit_note, color: Colors.black),
                onPressed: () {
                  _showEditModuleDialog(context, batch);
                },
                splashColor: Colors.blueAccent.withOpacity(0.3),
                highlightColor: Colors.blueAccent.withOpacity(0.1),
                padding: const EdgeInsets.all(12),
              ),
              SizedBox(width: 8), // Spacing between buttons
              // Delete Button with Material Effect and Black Icon
              IconButton(
                icon: Icon(Icons.delete_sweep_outlined, color: Colors.black),
                onPressed: () async {
                  final confirm = await _confirmDelete(context);
                  if (confirm) {
                    await _deleteBatch(provider, batch.batchId);
                  }
                },
                splashColor: Colors.redAccent.withOpacity(0.3),
                highlightColor: Colors.redAccent.withOpacity(0.1),
                padding: const EdgeInsets.all(12),
              ),
            ],
          ),
        ),
      ),
    );
  },
)



                      ],
                    ),
                  ),
                );
              },
            ),
          ]),
        );
      }),
    ));
  }

  Future<void> _deleteBatch(AdminAuthProvider provider, int batchId) async {
    provider.isLoading = true;

    try {
      await provider.AdmindeleteBatchprovider(widget.courseId, batchId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Batch deleted successfully!')),
      );

      await provider.AdminfetchBatchForCourseProvider(widget.courseId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete batch: $error')),
      );
    } finally {
      provider.isLoading = false;
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Batch'),
              content:
                  const Text('Are you sure you want to delete this batch?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  void dispose() {
    _batchNameController.dispose();
    super.dispose();
  }
}
