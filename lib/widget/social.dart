import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  final String name;
  final String name2;

  const Social({super.key,required this.name,required this.name2});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 51,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(width: 20,),
              Image.asset(
                "assets/facebook.png",
                height: 18,
                width: 17.89,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10,),
              Text(
                name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        SizedBox(width: 25,),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 51,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                SizedBox(width: 20,),
                Image.asset(
                  "assets/google.png",
                  height: 18,
                  width: 17.89,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10,),
                Text(
                  name2,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ],
            )),
      ]
      ),
    );
  }
}
