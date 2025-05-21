import 'package:flutter/material.dart';
import 'success_screen.dart';
import '../../supabase/auth/authCalls.dart';

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

  final Map<String, List<String>> regions = {
    'NCR': ['Metro Manila'],
    'Region I': ['Ilocos Norte', 'Ilocos Sur', 'La Union', 'Pangasinan'],
    'Region II': ['Cagayan', 'Isabela', 'Batanes'],
  };

  final Map<String, List<String>> provinces = {
    'Metro Manila': [
      'Manila',
      'Quezon City',
      'Makati',
      'Caloocan',
      'Pasay',
      'Pasig',
      'Marikina',
      'Mandaluyong',
    ],
    'Ilocos Norte': ['Laoag', 'Batac', 'San Nicolas', 'Bangui', 'Solsona'],
    'Ilocos Sur': ['Vigan City', 'Candon', 'Santa', 'Cervantes', 'Candon'],
    'La Union': ['San Fernando'],
    'Pangasinan': ['Alaminos', 'San Manuel', 'Sison', 'Lingayen', 'Umingan'],
    'Cagayan': [
      'Tuguegarao',
      'Aparri',
      'Abulug',
      'Alcala',
      'Buguey',
      'Calayan',
    ],
    'Isabela': ['Ilagan', 'Cauayan', 'Echague', 'Maconacon', 'Benito Soliven'],
    'Batanes': ['Basco', 'Uyugan', 'Mahatao', 'Ivana'],
  };

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
                      // Gender Dropdown (NEW LOCATION)
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            hint: const Text('Select Gender'),
                            isExpanded: true,
                            items:
                                ['Male', 'Female', 'Other']
                                    .map(
                                      (gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text(gender),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedGender = val;
                              });
                            },
                          ),
                        ),
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

                      // Cascading Region > Province > City dropdowns
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
                            Flexible(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedRegion,
                                  hint: const Text('Region'),
                                  isExpanded: true,
                                  items:
                                      regions.keys
                                          .map(
                                            (region) => DropdownMenuItem(
                                              value: region,
                                              child: Text(region),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedRegion = val;
                                      selectedProvince = null;
                                      selectedCity = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedProvince,
                                  hint: const Text('Province'),
                                  isExpanded: true,
                                  items:
                                      selectedRegion == null
                                          ? []
                                          : regions[selectedRegion!]!
                                              .map(
                                                (prov) => DropdownMenuItem(
                                                  value: prov,
                                                  child: Text(prov),
                                                ),
                                              )
                                              .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedProvince = val;
                                      selectedCity = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCity,
                                  hint: const Text('City'),
                                  isExpanded: true,
                                  items:
                                      selectedProvince == null
                                          ? []
                                          : provinces[selectedProvince!]!
                                              .map(
                                                (city) => DropdownMenuItem(
                                                  value: city,
                                                  child: Text(city),
                                                ),
                                              )
                                              .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedCity = val;
                                    });
                                  },
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
      // Age validation
      if (selectedDay != null &&
          selectedMonth != null &&
          selectedYear != null) {
        final birthDate = DateTime(
          int.parse(selectedYear!),
          int.parse(selectedMonth!),
          int.parse(selectedDay!),
        );
        final now = DateTime.now();
        final age =
            now.year -
            birthDate.year -
            ((now.month < birthDate.month ||
                    (now.month == birthDate.month && now.day < birthDate.day))
                ? 1
                : 0);
        if (age < 18) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You must be at least 18 years old to sign up.'),
            ),
          );
          return;
        }
      }

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

      if (selectedGender == null) {
        _showSnackBar('Please select your gender');
        return;
      }

      setState(() => isLoading = true);

      try {
        final birthday = DateTime(
          int.parse(selectedYear!),
          int.parse(selectedMonth!),
          int.parse(selectedDay!),
        );

        final userMetadata = {
          'first_name': _firstNameController.text,
          'middle_name': _middleNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'username': _usernameController.text,
          'contact': _contactController.text,
          'pin': _pinController.text,
          'address': _addressController.text,
          'region': selectedRegion,
          'province': selectedProvince,
          'city': selectedCity,
          'gender': selectedGender,
          'birthday': birthday.toIso8601String(),
        };

        final authService = SupabaseAuthService();

        final response = await authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          metadata: userMetadata,
        );

        if (response.user != null) {
          await authService.insertVoterDetails(
            userId: response.user!.id,
            voterData: userMetadata,
          );

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
