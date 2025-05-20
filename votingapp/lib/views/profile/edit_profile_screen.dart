import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool _isLoading = true;
  bool _isSaving = false;

  File? _selectedImage;
  String? _initialImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No user logged in')));
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data =
          await supabase
              .from('voters')
              .select('email, contact, image_url')
              .eq('email', user.email!)
              .maybeSingle();

      if (data == null) throw Exception('No profile data found');

      _emailController.text = data['email'] ?? user.email ?? '';
      _phoneController.text = data['contact'] ?? '';
      _initialImageUrl = data['image_url'];
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });

      final fileExt = p.extension(picked.path);
      final fileName =
          '${supabase.auth.currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = 'profile_pictures/$fileName';

      try {
        await supabase.storage
            .from('voter-profile-pictures')
            .upload(
              filePath,
              _selectedImage!,
              fileOptions: const FileOptions(upsert: true),
            );

        final publicUrl = supabase.storage
            .from('voter-profile-pictures')
            .getPublicUrl(filePath);

        if (publicUrl.isEmpty) {
          throw Exception('Failed to get public URL for uploaded image');
        }

        await supabase
            .from('voters')
            .update({'image_url': publicUrl})
            .eq('email', supabase.auth.currentUser!.email!);

        setState(() {
          _initialImageUrl = publicUrl;
          _selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      }
    }
  }

  Future<void> _updateUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No user logged in')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final contact = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      await supabase
          .from('voters')
          .update({'contact': contact})
          .eq('email', user.email!);

      if (password.isNotEmpty) {
        await supabase.auth.updateUser(UserAttributes(password: password));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Container(
                      color: const Color(0xFFEF7575),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Edit your Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundImage:
                              _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (_initialImageUrl?.isNotEmpty ?? false)
                                  ? NetworkImage(_initialImageUrl!)
                                  : const AssetImage('assets/images/hanni.jpg'),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.edit,
                              color: Color(0xFFEF7575),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Email cannot be changed here',
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          const Text(
                            'Contact Number',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Enter your contact number',
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Enter new password',
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 24,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFEF7575),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFEF7575),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF7575),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 2,
                              ),
                              onPressed: _isSaving ? null : _updateUserProfile,
                              child:
                                  _isSaving
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text(
                                        'Save',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
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
    );
  }
}
