import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/ui/painters/painters.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';
import 'package:taleemmate/ui/widgets/core/button/button.dart';
import 'package:taleemmate/ui/widgets/design/full_screen_loader/full_screen_loader.dart';
import 'package:taleemmate/ui/widgets/forms/forms.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';
import 'package:taleemmate/utils/flash.dart';

part 'static/_form_data.dart';
part 'static/_form_keys.dart';

part '_state.dart';
part 'listeners/_login.dart';

part 'widgets/_divider.dart';
part 'widgets/_tagline.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
    final screenState = _ScreenState.s(context);

    return Screen(
      formKey: screenState.formKey,
      initialFormValue: _FormData.initialValues(),
      keyboardHandler: true,
      padding: Space.a.t20,
      overlayBuilders: const [_LoginListener()],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                CustomPaint(
                  painter: const AppIconPainter(radius: 4.0),
                  size: AppIconPainter.size(32),
                ),
                Space.x.t08,
                Text('TaleemMate', style: AppText.h3),
              ],
            ),
            Space.y.t32,
            Text(
              'SIGN IN',
              style: AppText.l1b
                  .cl(AppTheme.c.subText)
                  .copyWith(letterSpacing: 1.5),
            ),
            Space.y.t08,
            Text('Welcome back', style: AppText.h1),
            Text(
              'Pick up where you left off — your library, plan, and tutor are waiting.',
              style: AppText.b1.cl(AppTheme.c.subText),
            ),
            Space.y.t32,
            AppFormTextInput(
              name: _FormKeys.email,
              heading: 'Email',
              placeholder: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onFieldSubmitted: (_) => screenState.passwordFocus.requestFocus(),
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
              textInputAction: TextInputAction.done,
              focusNode: screenState.passwordFocus,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => screenState.submit(context),
              validators: FormBuilderValidators.required(),
            ),
            Space.y.t08,
            Align(
              alignment: Alignment.centerRight,
              child: AppTouch(
                onTap: () {},
                hasSplash: false,
                child: Text(
                  'Forgot password?',
                  style: AppText.b2.copyWith(
                    decoration: .underline,
                  ),
                ),
              ),
            ),
            Space.y.t24,
            AppButton(
              label: 'Login',
              onTap: () => screenState.submit(context),
              mainAxisSize: .max,
              size: .large,
            ),
            Space.y.t24,
            const _OrDivider(),
            Space.y.t24,
            Row(
              mainAxisAlignment: .center,
              children: [
                Text(
                  'New to TaleemMate? ',
                  style: AppText.b2.cl(AppTheme.c.subText),
                ),
                AppTouch(
                  onTap: () => AppRoutes.createAccount.push(context),
                  hasSplash: false,
                  child: Text(
                    'Create account',
                    style: AppText.b2
                        .copyWith(
                          decoration: .underline,
                        )
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
