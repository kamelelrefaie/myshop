import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product_screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFoucs = FocusNode();
  final descriptionFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: "", title: '', description: '', price: -1, imageUrl: '');
  var initValues = {
    "price": '',
    "title": '',
    "description": '',
    "imageUrl": '',
  };

  @override
  void initState() {
    _imageUrlFocus.addListener(() {
      if (!_imageUrlFocus.hasFocus) setState(() {});
    });
    super.initState();
  }

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments == null
          ? "NULL"
          : ModalRoute.of(context)!.settings.arguments as String;

      if (productId != "NULL") {
        print("product id == ${productId}");
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          "price": _editedProduct.price.toString(),
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "imageUrl": '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocus.dispose();
    priceFoucs.dispose();
    descriptionFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  var isLoading = false;

  void _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (isValid == null) return;
    if (!isValid) return;
    _form.currentState?.save();
    if (_editedProduct.id.isEmpty) {
      setState(() {
        isLoading = true;
      });


      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("error happening"),
              content: Text("something went wrong"),
              actions: [
                FloatingActionButton(
                    child: Text("okay"),
                    onPressed: () {
                      return Navigator.of(context).pop();
                    })
              ],
            );
          },
        );
      }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues["title"],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please enter valid title";
                        }
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            id: "",
                            title: newValue.toString(),
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceFoucs);
                      },
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      initialValue: initValues["price"],
                      validator: (value) {
                        if (double.tryParse(value!) == null) {
                          return "not valid price";
                        }
                        if (double.parse(value) <= 0) {
                          return "enter number bigger than 0";
                        }
                        if (value.isEmpty) {
                          return "please enter valid title";
                        }
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            id: "",
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProduct.imageUrl);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(descriptionFocus);
                      },
                      keyboardType: TextInputType.number,
                      focusNode: priceFoucs,
                      decoration: InputDecoration(
                        labelText: "price",
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                        initialValue: initValues["description"],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter valid title";
                          }
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              id: "",
                              title: _editedProduct.title,
                              description: newValue.toString(),
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl);
                        },
                        keyboardType: TextInputType.multiline,
                        focusNode: descriptionFocus,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Description",
                        )),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter Url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        Expanded(
                            child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter valid title";
                            }
                          },
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue.toString());
                          },
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocus,
                          controller: _imageUrlController,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {
                            _saveForm();
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
