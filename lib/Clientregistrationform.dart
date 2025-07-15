import 'package:flutter/material.dart';
import 'servicesregistration.dart';

class ClientRegistrationForm extends StatefulWidget {
  const ClientRegistrationForm({super.key});

  @override
  State<ClientRegistrationForm> createState() => _ClientRegistrationFormState();
}

class _ClientRegistrationFormState extends State<ClientRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool agreeToTerms = false;
  String selectedSkinType = 'Normal';
  bool obscurePassword = true;

  final List<String> skinTypes = [
    'Normal',
    'Dry',
    'Oily',
    'Combination',
    'Sensitive',
    'Not sure',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // ✅ allow body to adjust when keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 70), // Increased bottom padding further
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Client Registration',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Sign up to book treatments and manage your appointments at DERMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepCircle('1', true),
                    const Text('  Personal Info  >  ', style: TextStyle(color: Colors.pink, fontSize: 10)),
                    _buildStepCircle('2', false),
                    const Text('  Select Services  >  ', style: TextStyle(color: Colors.black26, fontSize: 10)),
                    _buildStepCircle('3', false),
                    const Text('  Confirm', style: TextStyle(color: Colors.black26, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Please provide your personal details to get started', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('First Name *')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField('Last Name *')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextField('Email Address *'),
                    const SizedBox(height: 10),
                    _buildTextField('Phone Number *'),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        hintText: 'Password must be at least 8 characters',
                        filled: true,
                        fillColor: Colors.pink.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Enter at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField('Date of birth (dd/mm/yy)'),
                    const SizedBox(height: 20),
                    const Text('Skin Type *', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skinTypes.map((type) {
                        final selected = selectedSkinType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => selectedSkinType = type);
                          },
                          selectedColor: Colors.pink,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: agreeToTerms,
                          activeColor: Colors.pink,
                          onChanged: (value) {
                            setState(() {
                              agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(color: Colors.pink),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(color: Colors.pink),
                                ),
                                TextSpan(text: ' *'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate() && agreeToTerms) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ServicesRegistrationPage()),
                            );
                          }
                        },
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        label: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70), // Increased bottom spacing further
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(String number, bool isActive) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: isActive ? Colors.pink : Colors.grey[300],
      child: Text(
        number,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.pink.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
