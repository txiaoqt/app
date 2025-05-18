import 'package:flutter/material.dart';
import 'success_screen.dart';

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => Duration.zero;
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? selectedGender;
  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF7575),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Transform.rotate(
                  angle: -0.12,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            const TextSpan(text: 'Phil'),
                            TextSpan(
                              text: 'V',
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const TextSpan(text: 'te'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _formField('First Name'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _formField('Last Name'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _formField('M. Name'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _birthdayField(),
                    const SizedBox(height: 16),
                    _formField('Email Address'),
                    const SizedBox(height: 16),
                    _formField('Contact Number'),
                    const SizedBox(height: 16),
                    _formField('Username'),
                    const SizedBox(height: 16),
                    _formField('Password', obscure: true),
                    const SizedBox(height: 16),
                    
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
    
                          const SizedBox(width: 12),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: (selectedRegion != null && ['NCR', 'Region I', 'Region II'].contains(selectedRegion)) ? selectedRegion : null,
                                hint: const Text('Region'),
                                isExpanded: true,
                                items: ['NCR', 'Region I', 'Region II']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (val) => setState(() => selectedRegion = val),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: (selectedProvince != null && ['Province 1', 'Province 2'].contains(selectedProvince)) ? selectedProvince : null,
                                hint: const Text('Province'),
                                isExpanded: true,
                                items: ['Province 1', 'Province 2']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (val) => setState(() => selectedProvince = val),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: (selectedCity != null && ['City 1', 'City 2'].contains(selectedCity)) ? selectedCity : null,
                                hint: const Text('City'),
                                isExpanded: true,
                                items: ['City 1', 'City 2']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (val) => setState(() => selectedCity = val),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _formField('Address (Barangay, Street, Postal Code)', hint: 'Address (Barangay, Street, Postal Code)'),
                    const SizedBox(height: 20),
                    _formField('Enter your PIN', obscure: true),
                    const SizedBox(height: 8),
                    const Text(
                      '*Please remember your PIN as you will need it to verify your vote',
                      style: TextStyle(color: Color(0xFFEF7575), fontWeight: FontWeight.w500, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {}, // TODO: Implement profile picture upload
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate, size: 48, color: Colors.black54),
                            SizedBox(height: 8),
                            Text('Upload your Profile Picture', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {}, // TODO: Implement voter's ID upload
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.perm_identity, size: 48, color: Colors.black54),
                            SizedBox(height: 8),
                            Text("Upload your Voter's ID", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEF7575),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            NoAnimationMaterialPageRoute(builder: (context) => const SuccessScreen()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formField(String label, {bool obscure = false, String? hint}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint ?? label,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _birthdayField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Birthday', style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(width: 12),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedDay,
                hint: const Text('Day'),
                isExpanded: true,
                items: List.generate(31, (i) => (i+1).toString().padLeft(2, '0'))
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedDay = val),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedMonth,
                hint: const Text('Month'),
                isExpanded: true,
                items: List.generate(12, (i) => (i+1).toString().padLeft(2, '0'))
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedMonth = val),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedYear,
                hint: const Text('Year'),
                isExpanded: true,
                items: List.generate(100, (i) => (DateTime.now().year - i).toString())
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedYear = val),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 