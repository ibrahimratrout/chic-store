import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({ required this.sizes});
  final Map<dynamic,dynamic>? sizes;
  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String? selectedSize ;
  bool isExist = false;
  bool isFew = false;
  @override
  Widget build(BuildContext context) {
    List<String> keysList =[] ;
    List<String> valuesList =[] ;
    widget.sizes!.forEach((key, value) {
      keysList.add(key);
      valuesList.add(value);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
              widget.sizes!.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () => setState(() {
                      selectedSize=keysList[index];
                      if(valuesList[index]=="0"){
                        isExist = true;
                      }else isExist = false;
                      if(valuesList[index]=="5"){
                        isFew = true;
                      }else isFew = false;
                    }),
                    child: Ink(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: selectedSize == keysList[index]
                              ? Color(0xFF000000)
                              : Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(3)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          keysList[index],
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: selectedSize == keysList[index]
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        SizedBox(height: 10,),
        Visibility(
            visible: isFew,
            child: Text("* This size few left in stock",style: TextStyle(color: Colors.red,fontSize: 17),)
        ),
        Visibility(
            visible: isExist,
            child: Text("* This size is sold out",style: TextStyle(color: Colors.red,fontSize: 17),)
        ),
      ],
    );
  }
}