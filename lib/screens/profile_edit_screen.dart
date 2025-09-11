import 'package:flutter/material.dart';
import 'package:my_portfolio_app/providers/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:my_portfolio_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditProfileScreen extends StatelessWidget {
  final phoneFormatter = MaskTextInputFormatter(
    mask: '+62 ###-####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InputDecoration fieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
      ),
    );

    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: profileProvider.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _headerProfileImage(context, profileProvider),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: profileProvider.nameController,
                        decoration: fieldDecoration.copyWith(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            "Title is required";
                          }

                          if (value!.length < 3) {
                            return 'Name must be at least 3 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: profileProvider.phoneController,
                        decoration: fieldDecoration.copyWith(
                          labelText: 'Phone',
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneFormatter],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: profileProvider.addressController,
                        decoration: fieldDecoration.copyWith(
                          labelText: 'Address',
                        ),
                        autofillHints: [AutofillHints.addressCityAndState],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: profileProvider.professionController,
                        decoration: fieldDecoration.copyWith(
                          labelText: 'Profession',
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: profileProvider.bioController,
                        decoration: fieldDecoration.copyWith(labelText: 'Bio'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await profileProvider.updateProfile();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }

                        messenger.showSnackBar(
                          SnackBar(
                            content: Text("Profile updated successfully!"),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );

                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: profileProvider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Profile'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _headerProfileImage(
  BuildContext context,
  ProfileProvider profileProvider,
) {
  return Stack(
    children: [
      ClipOval(
        child: (profileProvider.profile!.photo!.isNotEmpty)
            ? Image.network(
                profileProvider.profile!.photo!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/img/logo-noimage.png",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
      ),
      Positioned(
        bottom: 1,
        right: 5,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: IconButton(
            onPressed: profileProvider.pickImage,
            icon: Icon(
              Icons.photo_camera,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            tooltip: 'Pick image',
          ),
        ),
      ),
    ],
  );
}
