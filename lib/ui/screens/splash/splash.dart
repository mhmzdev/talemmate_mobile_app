import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';

import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/forms/forms.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

part '_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Screen(
      keyboardHandler: true,
      padding: Space.a.t16,
      child: SafeArea(
        child: Column(
          // crossAxisAlignment: .stretch,
          children: [
            Space.y.t24,
            AppFormTextInput(
              name: 'name',
              heading: 'Email',
              subHeading: 'This is email subheading',
              placeholder: 'Enter your email....',
              helper: 'Verification will be needed',
              validators: FormBuilderValidators.email(),
            ),
            Space.y.t24,
            AppButton(
              label: 'Primary',
              onTap: () {},
              mainAxisSize: .max,
              // state: .disabled,
            ),
            Space.y.t12,
            AppButton(
              label: 'Creamy',
              onTap: () {},
              mainAxisSize: .max,
              style: .creamy,
              // state: .disabled,
            ),
            Space.y.t12,
            AppButton(
              label: 'Success',
              onTap: () {},
              mainAxisSize: .max,
              style: .success,
            ),
            Space.y.t12,
            AppButton(
              label: 'Error',
              onTap: () {},
              mainAxisSize: .max,
              style: .error,
            ),
            Space.y.t12,
          ],
        ),
      ),
    );
  }
}
