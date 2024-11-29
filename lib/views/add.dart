import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class AddRefundPage extends StatefulWidget {
  @override
  _AddRefundPageState createState() => _AddRefundPageState();
}

class _AddRefundPageState extends State<AddRefundPage> {
  final _formKey = GlobalKey<FormState>();
  final _orderIdController = TextEditingController();
  final _detailsController = TextEditingController();
  final _reasonController = TextEditingController();
  final _totalController = TextEditingController();
  String? _selectedFileName;
  String? _pdfUrl;
  Uint8List? _selectedFileBytes;
  late DropzoneViewController _controller;

  @override
  void dispose() {
    _orderIdController.dispose();
    _detailsController.dispose();
    _reasonController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _addRefund() async {
    if (_formKey.currentState!.validate() && _pdfUrl != null) {
      await FirebaseFirestore.instance.collection('refunds').add({
        'orderId': _orderIdController.text,
        'details': _detailsController.text,
        'reason': _reasonController.text,
        'total': _totalController.text,
        'receipt': _pdfUrl,
      });
      Navigator.pop(context);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.bytes != null) {
      PlatformFile file = result.files.single;
      setState(() {
        _selectedFileName = file.name;
        _selectedFileBytes = file.bytes;
      });
      await _uploadFile(file.bytes!, file.name);
    }
  }

  Future<void> _uploadFile(Uint8List fileBytes, String fileName) async {
    final path = 'receipts/$fileName';
    final fileRef = FirebaseStorage.instance.ref().child(path);
    await fileRef.putData(fileBytes);
    final downloadUrl = await fileRef.getDownloadURL();
    setState(() {
      _pdfUrl = downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Refund'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _orderIdController,
                decoration: InputDecoration(labelText: 'Order ID' , filled: true , fillColor: Colors.white),
                style: TextStyle(color: Colors.black , fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an order ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Details' , filled: true , fillColor: Colors.white ),
                style: TextStyle(color: Colors.black , fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason' , filled: true , fillColor: Colors.white),
                style: TextStyle(color: Colors.black , fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalController,
                decoration: InputDecoration(labelText: 'Total' , filled: true , fillColor: Colors.white),
                style: TextStyle(color: Colors.black , fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a total amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _selectedFileName !=null ? Text(_selectedFileName.toString() , style: TextStyle(color: Colors.amber, fontSize: 18),):SizedBox(),
              SizedBox(height: 20),
              Container(
                height: 150,
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    DropzoneView(
                      onCreated: (controller) => this._controller = controller,
                      onDrop: (file) async {
                        final bytes = await _controller.getFileData(file);
                        setState(() {
                          _selectedFileName = file.name;
                          _selectedFileBytes = bytes;
                        });
                        await _uploadFile(bytes, file.name);
                      },
                    ),
                    Center(child: Text('Drag and drop a PDF file here')),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addRefund,
                child: Text('Add Refund'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
