import 'dart:io';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/admin/admin%20services/admin_repo.dart';
import 'package:amazon/shared/widgets/helper_button.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:amazon/shared/widgets/pickimages.dart';
import 'package:amazon/shared/widgets/snackbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  static const routeName = 'add-product';
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceController.dispose();
    _productController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
  }

  List<String> prodCat = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];
  String category = 'Mobiles';
  List<File> img = [];
  void selectImg() async {
    var res = await pickImages();
    setState(() {
      img = res;
    });
  }

  final adminService = AdminRepo();

  void addProd() async {
    if (_key.currentState!.validate() && img.isNotEmpty) {
      await adminService
          .sellProduct(
              name: _productController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              quantity: double.parse(_quantityController.text),
              category: _categoryController.text,
              images: img)
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Text(
              "Add Product",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          )),
      body: SingleChildScrollView(
        child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(15),
                      dashPattern: [10, 4],
                      strokeCap: StrokeCap.round,
                      child: img.isNotEmpty
                          ? CarouselSlider(
                              items: img.map((i) {
                                return Builder(builder: (context) {
                                  return Image.file(
                                    i,
                                    fit: BoxFit.cover,
                                  );
                                });
                              }).toList(),
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  height: 200,
                                  autoPlay: false),
                            )
                          : GestureDetector(
                              onTap: selectImg,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder),
                                    Text(
                                      "Select Product Images",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade500),
                                    )
                                  ],
                                ),
                              ),
                            )),
                  HelperTextField(
                    htxt: 'Product Name',
                    controller: _productController,
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val == null) {
                        return 'Enter Product Name';
                      }
                      return null;
                    },
                  ),
                  HelperTextField(
                    htxt: 'Description',
                    controller: _descriptionController,
                    keyboardType: TextInputType.name,
                    maxLines: 5,
                    validator: (val) {
                      if (val == null) {
                        return 'Enter Prouct Description';
                      }
                      return null;
                    },
                  ),
                  HelperTextField(
                    htxt: 'Price',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null) {
                        return 'Enter Product Price';
                      }
                      return null;
                    },
                  ),
                  HelperTextField(
                    htxt: 'Category',
                    controller: _categoryController,
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val == null) {
                        return 'Enter Product Category';
                      }
                      return null;
                    },
                  ),
                  HelperTextField(
                    htxt: 'Quantity',
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null) {
                        return 'Enter Product Quantity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                        items: prodCat.map((String i) {
                          return DropdownMenuItem(value: i, child: Text(i));
                        }).toList(),
                        value: category,
                        onChanged: (String? val) {
                          setState(() {
                            category = val!;
                          });
                        }),
                  ),
                  HelperButton(
                      name: "Post",
                      onTap: () {
                        addProd();

                        showSnackbar(
                            context: context, content: 'Posted Successfully');
                      })
                ],
              ),
            )),
      ),
    );
  }
}
