import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add this import for Firebase Storage
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  EditProductPage({required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String imageUrl = '';
  File? _image;

  @override
  void initState() {
    super.initState();
    loadProductData();
  }

  Future<void> loadProductData() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productSnapshot.exists) {
        Map<String, dynamic> productData =
            productSnapshot.data() as Map<String, dynamic>;
        _nameController.text = productData['name'];
        _priceController.text = productData['price'].toString();
        _descriptionController.text = productData['description'];
        imageUrl = productData['image'];
      }
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> uploadImage() async {
    if (_image != null) {
      try {
        String fileName =
            'products/${widget.productId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = uploadedImageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  Future<void> saveProductChanges() async {
    try {
      if (_formKey.currentState!.validate()) {
        await uploadImage(); // Upload image if selected
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .update({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'image': imageUrl,
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving product changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving product changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _image == null
                  ? imageUrl.isEmpty
                      ? Text('No image selected')
                      : Image.network(imageUrl, height: 150)
                  : Image.file(_image!, height: 150),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: saveProductChanges,
              //   child: Text('Save Changes'),
              // ),
              GestureDetector(
                onTap: saveProductChanges,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 23, 143, 241),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
