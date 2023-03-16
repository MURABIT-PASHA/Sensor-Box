import 'package:flutter/material.dart';

class SaveSensorScreen extends StatefulWidget {
  const SaveSensorScreen({Key? key}) : super(key: key);

  @override
  State<SaveSensorScreen> createState() => _SaveSensorScreenState();
}

class _SaveSensorScreenState extends State<SaveSensorScreen> {
  late List<bool> iconStatus;
  late List<String> selectedSensorNames;
  @override
  void initState() {
    selectedSensorNames = ["Accelerometer","Magnetometer","Gyroscope","User Accelerometer"];
    iconStatus = [false,false,false,false];
    //TODO: Make selectedList item dynamic in order to do that get all available sensors
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(top: 10, left: 5, right: 5,),
        child: Column(
          children: [
            Container(
              width: width,
              height: height - 70,
              child: ListView.builder(
                itemCount: 4,
                //TODO: Convert list view to list view builder and set counter to selected list
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.save, color: iconStatus[index] ? Colors.green: Colors.red,),
                    title: Text(selectedSensorNames[index], style: TextStyle(color: Colors.white),),
                    onTap: (){
                      setState(() {
                        iconStatus[index] = !iconStatus[index];
                      });
                    },);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              width: width,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                    onPressed: (){
                  //TODO: Start save process
                }, child: Text('Save')))
          ],
        ),
      ),
    );
  }
}
