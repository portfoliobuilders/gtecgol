import 'package:flutter/material.dart';
import 'package:gtec/screens/admin/live_management/AdminaddbatchlivePage.dart';

import 'package:provider/provider.dart';
import 'package:gtec/provider/authprovider.dart';

class AdminliveBatchScreen extends StatefulWidget {
  final int courseId;

  const AdminliveBatchScreen({super.key, required this.courseId});

  @override
  State<AdminliveBatchScreen> createState() => _AdminliveBatchScreenState();
}

class _AdminliveBatchScreenState extends State<AdminliveBatchScreen> {
  final TextEditingController _batchNameController = TextEditingController();
  bool isCreating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminAuthProvider>(context, listen: false)
          .AdminfetchBatchForCourseProvider(widget.courseId);
    });
  }

  @override
  void dispose() {
    _batchNameController.dispose();
    super.dispose();
  }


  

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminAuthProvider>(context);
    final batches = provider.courseBatches[widget.courseId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Batches'),
      ),
      body: SingleChildScrollView(
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
                          builder: (context) => AdminAddLiveToBatchPage(
                            courseId: widget.courseId,
                            batchId: batch.batchId                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 187, 234, 255),
                          width: 2,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
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
                      ),
                    ),
                  );
                },
              ),
            // Batch creation UI (TextField & Button)
           
          ],
        ),
      ),
    );
  }
}

