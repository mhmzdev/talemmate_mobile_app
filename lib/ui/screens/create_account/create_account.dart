import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/services/logging/app_log.dart';
import 'package:taleemmate/ui/widgets/core/buttons/app_back_button.dart';
import 'package:taleemmate/ui/widgets/core/header/stack_center.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/design/full_screen_loader/full_screen_loader.dart';
import 'package:taleemmate/ui/widgets/design/misc/terms_condition_privacy_policy.dart';
import 'package:taleemmate/ui/widgets/forms/forms.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/ui/widgets/headless/scroll_column_expandable.dart';
import 'package:taleemmate/utils/flash.dart';

part 'static/_form_data.dart';
part 'static/_form_keys.dart';

part '_state.dart';
part 'listeners/_register.dart';

part 'widgets/_tagline.dart';
part 'widgets/_password_strength.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
    final state = _ScreenState.s(context);

    return Screen(
      formKey: state.formKey,
      initialFormValue: _FormData.initialValues(),
      keyboardHandler: true,
      padding: Space.a.t20,
      resizeToAvoidBottomInset: true,
      overlayBuilders: const [_RegisterListener()],
      child: SafeArea(
        child: ScrollColumnExpandable(
          crossAxisAlignment: .stretch,
          children: [
            StackCenter(
              onLeft: const AppBackButton(),
              center: Text(
                '01 / 03',
                style: AppText.l1b
                    .cl(AppTheme.c.subText)
                    .copyWith(
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
              ),
            ),
            Space.y.t32,
            Text(
              'CREATE ACCOUNT',
              style: AppText.l1b
                  .cl(AppTheme.c.subText)
                  .copyWith(letterSpacing: 1.5),
            ),
            Space.y.t08,
            Text('Let\'s set you up.', style: AppText.h1),
            Text(
              'We\'ll calibrate your study plan after this. Takes about a minute.',
              style: AppText.b1.cl(AppTheme.c.subText),
            ),
            Space.y.t28,
            AppFormTextInput(
              name: _FormKeys.fullName,
              heading: 'Full Name',
              placeholder: 'Your name',
              textInputAction: TextInputAction.next,
              validators: FormBuilderValidators.required(),
            ),
            Space.y.t16,
            AppFormTextInput(
              name: _FormKeys.email,
              heading: 'Email',
              placeholder: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validators: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            Space.y.t16,
            AppFormTextInput(
              name: _FormKeys.password,
              heading: 'Password',
              placeholder: '••••••••',
              obscureText: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (v) => state.onPasswordChanged(v),
              validators: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8),
              ]),
            ),
            Space.y.t08,
            const _PasswordStrength(),
            Space.y.t16,
            AppFormTextInput(
              name: _FormKeys.confirm,
              heading: 'Confirm Password',
              placeholder: '••••••••',
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validators: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                (value) {
                  final formKey = state.formKey.currentState;
                  final pw =
                      formKey?.fields[_FormKeys.password]?.value as String?;
                  return value != pw ? 'Passwords do not match.' : null;
                },
              ]),
            ),
            Space.y.t24,
            FormBuilderField<bool>(
              name: _FormKeys.termsAccepted,
              validator: (value) => value != true
                  ? 'Please accept the Terms and Privacy Policy.'
                  : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TermsAndPrivacyWidget(
                    initialValue: field.value ?? false,
                    onChanged: field.didChange,
                  ),
                  if (field.hasError) ...[
                    Space.y.t04,
                    Text(
                      field.errorText!,
                      style: AppText.b2.cl(AppTheme.c.error),
                    ),
                  ],
                ],
              ),
            ),
            Space.y.t24,
            AppButton(
              label: 'Create account',
              onTap: () => state.submit(context),
              mainAxisSize: MainAxisSize.max,
              size: .large,
            ),
            Space.y.t24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppText.b2.cl(AppTheme.c.subText),
                ),
                AppTouch(
                  onTap: () => AppRoutes.login.pushReplace(context),
                  hasSplash: false,
                  child: Text(
                    'Login',
                    style: AppText.b2
                        .copyWith(decoration: TextDecoration.underline)
                        .w(6),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const _Tagline(),
          ],
        ),
      ),
    );
  }
}
