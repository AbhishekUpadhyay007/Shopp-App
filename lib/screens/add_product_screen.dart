import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/products.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = './AddProductScreen';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _focusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedproduct = Product(
    id: null,
    title: '',
    imageUrl: '',
    description: '',
    price: 0,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedproduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedproduct.title,
          'description': _editedproduct.description,
          'price': _editedproduct.price.toString(),
          'imageUrl': _editedproduct.imageUrl,
        };

        _imageUrlController.text = _editedproduct.imageUrl;

        print("Price: ${_editedproduct.price}");
      }
    }
    _isInit = false;
  }

  void _updateImageUrl() {
    if (!_imageUrlNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _imageUrlController.dispose();
    _descriptionNode.dispose();
    _imageUrlNode.removeListener(_updateImageUrl);
  }

  Future<void> _saveForm() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedproduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedproduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text('Something went wrong!'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      } finally {}
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedproduct.id, _editedproduct);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      onSaved: (value) {
                        _editedproduct = Product(
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite,
                            title: value,
                            description: _editedproduct.description,
                            price: _editedproduct.price,
                            imageUrl: _editedproduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title field is empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _focusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionNode);
                        },
                        onSaved: (value) {
                          _editedproduct = Product(
                              id: _editedproduct.id,
                              isFavorite: _editedproduct.isFavorite,
                              title: _editedproduct.title,
                              description: _editedproduct.description,
                              price: double.parse(value),
                              imageUrl: _editedproduct.imageUrl);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price field is empty';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter a valid price';
                          }
                          return null;
                        }),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.newline,
                      maxLines: 3,
                      focusNode: _descriptionNode,
                      onSaved: (value) {
                        _editedproduct = Product(
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite,
                            title: _editedproduct.title,
                            description: value,
                            price: _editedproduct.price,
                            imageUrl: _editedproduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Description field is empty';
                        }
                        if (value.length < 10) {
                          return 'Description is short. Should be atleast 10.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 10, top: 10),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Empty url')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  )),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image url'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedproduct = Product(
                                  id: _editedproduct.id,
                                  isFavorite: _editedproduct.isFavorite,
                                  title: _editedproduct.title,
                                  description: _editedproduct.description,
                                  price: _editedproduct.price,
                                  imageUrl: value);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Image Url field is empty';
                              }
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'Url is not valid';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.jpg')) {
                                return 'Url is not ending with .jpeg/.png/.jpg';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        child: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: _saveForm,
        ),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      ),
    );
  }
}
