import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/admin/api/product_api/image_upload.dart';
import 'package:untitled/admin/api/product_api/product_api.dart';
import 'package:untitled/helper/colors.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/models/product_model.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const EditProduct({super.key, required this.data, required this.id});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  var _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  List<String> categories = [
    'Món Việt',
    'Bánh Việt',
    'Món Âu',
    'Bánh Âu'
  ];
  String? selectedCategory;
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  bool isLoading = false;
  bool? isAvailable;

  Future selectImageFromGallery() async{
    final XFile? pic = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = pic;
    });
  }

  Future selectImageFromCamera() async{
    final XFile? pic = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _file = pic;
    });
  }

  Future uploadImage() async{
    File? imageFile;
    if(_file == null) return;
    imageFile = File(_file!.path);
    setState(() {
      isLoading = true;
    });
    final destination = 'product_image/${_file!.name}';
    var task = FirebaseImageUploadApi.uploadImage(destination, imageFile);
    if(task == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final snapshot = await task.whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    final imagePath = await snapshot.ref.getDownloadURL();
    addProduct(imagePath);
  }

  addProduct(String imgUrl) async{
    ProductModel productModel = ProductModel(
        name: t1.text,
        description: t4.text,
        price: t2.text,
        shortDescription: t3.text,
        imgUrl: imgUrl,
        category: selectedCategory!,
        isAvailable: isAvailable!,
    );
    setState(() {
      isLoading = true;
    });
    await ProductApi().updateProduct(widget.id, productModel).then((value) {
      setState(() {
        isLoading = false;
      });
      getSnackBar('Cập nhật sản phẩm thành công', context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackBar(error.toString(), context);
    });
  }

  setValues(){
    t1.text = widget.data['name'];
    t2.text = widget.data['price'];
    t3.text = widget.data['shortDescription'];
    t4.text = widget.data['description'];
    setState(() {
      selectedCategory = widget.data['category'];
      isAvailable = widget.data['isAvailable'];
    });
  }

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: Text('Cập nhật sản phẩm'),
        actions: [
          IconButton(onPressed: () {
            setState(() {
              isAvailable = !isAvailable!;
            });
          }, icon: isAvailable!? Icon(
            Icons.toggle_on,
            size: 40,
          ): Icon(
            Icons.toggle_off,
            size: 40,
          ))
        ],
        flexibleSpace: Stack(
          alignment: Alignment.bottomCenter,
          children:[ Container(
            height: 250,
            color: Colors.red,
          ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  )
              ),
              height: 20,
            )
          ],
        ),
      ),
      body: isLoading?
      getLoading():
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getBoldText('Ảnh', Colors.black, 13),
              SizedBox(
                height: 3,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    )
                ),
                child: _file == null?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Image.network(widget.data['imgUrl'],),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getButton('Chỉnh sửa', Colors.yellow, () {
                          showBottomSheet();
                        }),
                      ],
                    )
                  ],
                ):
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Image.file(File(_file!.path)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          getButton('Chỉnh sửa', Colors.yellow, () {
                            showBottomSheet();
                          }),
                          getButton('Xóa', Colors.red, () {
                            setState(() {
                              _file = null;
                            });
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getBoldText('Tên sản phẩm', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: t1,
                      decoration: InputDecoration(
                        label: getNormalText('Tên sản phẩm', Colors.black, 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Bắt buộc nhập';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getBoldText('Giá', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: t2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: getNormalText('Giá', Colors.black, 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Bắt buộc nhập';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getBoldText('Mô tả ngắn', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: t3,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        label: getNormalText('Mô tả ngắn', Colors.black, 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Bắt buộc nhập';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getBoldText('Mô tả chi tiết', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: t4,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        label: getNormalText('Mô tả chi tiết', Colors.black, 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Bắt buộc nhập';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              getBoldText('Chọn danh mục', Colors.black, 13),
              SizedBox(
                height: 3,
              ),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  itemHeight: 60,
                  elevation: 0,
                  value: selectedCategory,
                  underline: Container(),
                  hint: getNormalText('Chọn danh mục', Colors.black, 14),
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: getNormalText(value, Colors.black, 14));
                  }).toList(), onChanged: (_) {
                  setState(() {
                    selectedCategory = _ as String;
                  });
                },),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: getButton('Cập nhật', MyColors.primaryColor, () {
                  if(_formKey.currentState!.validate()){
                    if(selectedCategory == null){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: getNormalText('Vui lòng chọn danh mục', Colors.white, 14)));
                      return;
                    }
                    _file == null? addProduct(widget.data['imgUrl']):
                    uploadImage();
                  }
                }),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showBottomSheet(){
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    selectImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(0.2)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 50,
                          color: MyColors.primaryColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        getBoldText('Máy ảnh', Colors.black, 16)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    selectImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(0.2)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: MyColors.primaryColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        getBoldText('Thư viện', Colors.black, 16)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },);
  }
}
