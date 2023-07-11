import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:orbital_appllergy/service/AuthService.dart';
import 'package:orbital_appllergy/service/FirestoreService.dart';

class LogSymptoms extends StatefulWidget {
  const LogSymptoms({super.key});

  @override
  State<LogSymptoms> createState() => _LogSymptomsState();
}

class _LogSymptomsState extends State<LogSymptoms> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _precautionsController = TextEditingController();
  final FireStoreService _fireStoreService = FireStoreService();
  final AuthService _authService = AuthService();
  DateTime selectedDate = DateTime.now();

  //Dispose the controller when its no longer needed to avoid memory leak.
  @override
  void dispose() {
    _titleController.dispose();
    _symptomsController.dispose();
    _precautionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Symptoms'),
        centerTitle: true,
        backgroundColor: Colors.red[300],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Image(
                height: 200,
                image: AssetImage('assets/SickBoy.png'),
              ),
              const SizedBox(height: 10),
              Text(
                'Date of occurrence: '
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                ),
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1920),
                    lastDate: DateTime(2030),
                  );
                  if (newDate == null) return;
                  setState(() {
                    selectedDate = newDate;
                  });
                },
                child: const Text(
                  'Select Date',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 10),
              _CustomTextField(
                labelText: 'Enter title here',
                textController: _titleController,
              ),
              const SizedBox(height: 20),
              _CustomTextField(
                labelText: 'Enter symptoms here',
                textController: _symptomsController,
              ),
              const SizedBox(height: 20),
              _CustomTextField(
                labelText: 'Precautions required',
                textController: _precautionsController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                ),
                onPressed: () {
                  try {
                    _fireStoreService.logAllergySymptoms(
                      _authService.user!.uid,
                      _titleController.text,
                      _symptomsController.text,
                      selectedDate,
                      _precautionsController.text,
                    );
                    _buildAlertDialog(
                      context: context,
                      dialogType: DialogType.success,
                      title: 'Good news!',
                      desc: 'Successfully logged symptoms!',
                    ).show();
                  } catch (e) {
                    _buildAlertDialog(
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Oh No!',
                      desc: 'An error occurred! Please try again!',
                    ).show();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _CustomTextField extends StatelessWidget {

  final TextEditingController textController;
  final String labelText;

  const _CustomTextField({required this.labelText, required this.textController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: textController,
        maxLines: null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5.5),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.red),
          filled: true,
          fillColor: Colors.red[50],
          suffixIcon: IconButton(
            onPressed: () {
              textController.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}

AwesomeDialog _buildAlertDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String title,
  required String desc,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    title: title,
    desc: desc,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 2,
    ),
    width: 280,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    animType: AnimType.bottomSlide,
    showCloseIcon: true,
  );
}


