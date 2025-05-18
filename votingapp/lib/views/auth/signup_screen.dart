import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();
  final _pinController = TextEditingController();
  final _addressController = TextEditingController();

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? selectedGender;
  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF7575),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
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
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
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
                            child: _validatedFormField(
                              'First Name',
                              _firstNameController,
                              validator: _requiredValidator,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _validatedFormField(
                              'Middle Name',
                              _middleNameController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _validatedFormField(
                              'Last Name',
                              _lastNameController,
                              validator: _requiredValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _birthdayField(),
                      const SizedBox(height: 16),
                      _validatedFormField(
                        'Email Address',
                        _emailController,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 16),
                      _validatedFormField(
                        'Contact Number',
                        _contactController,
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 16),
                      _validatedFormField(
                        'Username',
                        _usernameController,
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 16),
                      _validatedFormField(
                        'Password',
                        _passwordController,
                        obscure: true,
                        validator: _passwordValidator,
                      ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Flexible(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  value: selectedRegion,
                                  hint: const Text('Region'),
                                  isExpanded: true,
                                  items:
                                      ['NCR', 'Region I', 'Region II']
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) =>
                                          setState(() => selectedRegion = val),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Please select a region'
                                              : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  value: selectedProvince,
                                  hint: const Text('Province'),
                                  isExpanded: true,
                                  items:
                                      ['Province 1', 'Province 2']
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) => setState(
                                        () => selectedProvince = val,
                                      ),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Please select a province'
                                              : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  value: selectedCity,
                                  hint: const Text('City'),
                                  isExpanded: true,
                                  items:
                                      ['City 1', 'City 2']
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) =>
                                          setState(() => selectedCity = val),
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Please select a city'
                                              : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _validatedFormField(
                        'Address (Barangay, Street, Postal Code)',
                        _addressController,
                        hint: 'Address (Barangay, Street, Postal Code)',
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 20),
                      _validatedFormField(
                        'Enter your PIN',
                        _pinController,
                        obscure: true,
                        validator: _pinValidator,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '*Please remember your PIN as you will need it to verify your vote',
                        style: TextStyle(
                          color: Color(0xFFEF7575),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
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
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Upload your Profile Picture',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
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
                              Icon(
                                Icons.perm_identity,
                                size: 48,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Upload your Voter's ID",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
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
                          onPressed: isLoading ? null : _handleSignup,
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
      ),
    );
  }

  Widget _validatedFormField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
    String? hint,
  }) {
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
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint ?? label,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
          const Text(
            'Birthday',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: selectedDay,
                hint: const Text('Day'),
                isExpanded: true,
                items:
                    List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'))
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => selectedDay = val),
                validator:
                    (value) => value == null ? 'Please select day' : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: selectedMonth,
                hint: const Text('Month'),
                isExpanded: true,
                items:
                    List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'))
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => selectedMonth = val),
                validator:
                    (value) => value == null ? 'Please select month' : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: selectedYear,
                hint: const Text('Year'),
                isExpanded: true,
                items:
                    List.generate(
                          100,
                          (i) => (DateTime.now().year - i).toString(),
                        )
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => selectedYear = val),
                validator:
                    (value) => value == null ? 'Please select year' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    return (value == null || value.trim().isEmpty)
        ? 'This field is required'
        : null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _pinValidator(String? value) {
    if (value == null || value.length != 4 || int.tryParse(value) == null) {
      return 'Enter a valid 4-digit PIN';
    }
    return null;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDay == null ||
          selectedMonth == null ||
          selectedYear == null) {
        _showSnackBar('Please select your complete birthday');
        return;
      }

      if (selectedRegion == null ||
          selectedProvince == null ||
          selectedCity == null) {
        _showSnackBar('Please select your complete address');
        return;
      }

      setState(() => isLoading = true);

      try {
        // Parse birthday
        final birthday = DateTime(
          int.parse(selectedYear!),
          int.parse(selectedMonth!),
          int.parse(selectedDay!),
        );

        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          data: {
            'first_name': _firstNameController.text,
            'middle_name': _middleNameController.text,
            'last_name': _lastNameController.text,
            'username': _usernameController.text,
            'contact': _contactController.text,
            'pin': _pinController.text,
            'address': _addressController.text,
            'region': selectedRegion,
            'province': selectedProvince,
            'city': selectedCity,
            'birthday': birthday.toIso8601String(),
          },
        );

        if (response.user != null) {
          Navigator.of(context).push(
            NoAnimationMaterialPageRoute(builder: (_) => const SuccessScreen()),
          );
        } else {
          _showSnackBar('Signup failed. Try again.');
        }
      } catch (e) {
        _showSnackBar('Error: ${e.toString()}');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }
}
