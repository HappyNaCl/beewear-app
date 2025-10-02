import 'package:beewear_app/domain/models/region.dart';
import 'package:beewear_app/ui/core/ui/top_bar.dart';
import 'package:beewear_app/ui/register/view_model/register_state.dart';
import 'package:beewear_app/ui/register/view_model/register_view_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  int activeStep = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(registerViewModelProvider.notifier).loadRegions(),
    );
  }

  Widget _getStep1(RegisterViewModel viewModel, RegisterState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(),
            ),
            onChanged: viewModel.setUsername,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 8) {
                return 'Username must be at least 8 characters long';
              }
              if (value.length > 20) {
                return 'Username must be at most 20 characters long';
              }
              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                return 'Username can only contain letters, numbers, and underscores';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: viewModel.setEmail,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: viewModel.setPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              if (value.length > 32) {
                return 'Password must be at most 32 characters long';
              }
              if (!RegExp(
                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
              ).hasMatch(value)) {
                return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: viewModel.setConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != state.password) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          FormField<Region>(
            validator: (value) {
              if (state.selectedRegion == null) {
                return "Please select a region";
              }
              return null;
            },
            builder: (field) => InputDecorator(
              decoration: InputDecoration(
                labelText: "Region",
                border: const OutlineInputBorder(),
                errorText: field.errorText,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<Region>(
                  value: state.selectedRegion,
                  isExpanded: true,
                  hint: const Text("Select a region"),
                  items: state.regions.map((region) {
                    return DropdownMenuItem(
                      value: region,
                      child: Text(region.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    viewModel.selectRegion(value!);
                    field.didChange(value);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() => activeStep = 1);
                  viewModel.createOtp();
                }
            },
            child: const Text('Continue')
          ),
        ],
      ),
    );
  }

  Widget _getStep2(RegisterViewModel viewModel, RegisterState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "A verification email has been sent.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Pinput(
          keyboardType: TextInputType.number,
          length: 6,
          showCursor: true,
          onCompleted: (value) {
            viewModel.setOtp(value);
            viewModel.register();
          },
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: handle email verification confirmation
          },
          child: const Text('I have verified'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(registerViewModelProvider.notifier);
    final state = ref.watch(registerViewModelProvider);

    ref.listen<RegisterState>(registerViewModelProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: const TopBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              EasyStepper(
                activeStep: activeStep,
                lineStyle: const LineStyle(lineLength: 100),
                onStepReached: (index) => setState(() => activeStep = index),
                stepShape: StepShape.circle,
                stepRadius: 24,
                finishedStepBorderColor: Colors.deepOrange,
                finishedStepTextColor: Colors.deepOrange,
                finishedStepBackgroundColor: Colors.deepOrange,
                activeStepIconColor: Colors.deepOrange,
                steps: const [
                  EasyStep(icon: Icon(Icons.person), title: 'Register'),
                  EasyStep(icon: Icon(Icons.email), title: 'Verify Email'),
                ],
              ),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (state.error != null)
                Center(child: Text('Error: ${state.error}'))
              else
                IndexedStack(
                  index: activeStep,
                  children: [
                    _getStep1(viewModel, state),
                    _getStep2(viewModel, state),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
