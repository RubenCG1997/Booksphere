import 'package:booksphere/view/widgets/button_google.dart';
import 'package:booksphere/view/widgets/dividing_last_line.dart';
import 'package:booksphere/view/widgets/dividing_lines.dart';
import 'package:booksphere/view/widgets/emailfield.dart';
import 'package:booksphere/view/widgets/image_app.dart';
import 'package:booksphere/view/widgets/name_app.dart';
import 'package:booksphere/view/widgets/passwordfield.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:booksphere/view/widgets/smarttextbutton.dart';
import 'package:booksphere/view/widgets/title_header.dart';
import 'package:booksphere/view/widgets/userfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controller/user_controller.dart';
import '../core/color.dart';
import '../core/styles.dart';
import '../model/subsciption_type.dart';

/// Widget principal que representa la pantalla de registro de usuario.
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

/// Estado asociado a [Register], maneja los controladores de texto
/// para email, contraseña y nombre de usuario.
class _RegisterState extends State<Register> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: AppColor.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [NameApp(), ImageApp()],
                      ),
                      const SizedBox(height: 10),
                      TitleHeader(title: loc.registerTitle),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width,
                        child: DividingLines(title: loc.accessDirect),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(width: size.width, child: ButtonGoogle()),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: size.width,
                        child: DividingLines(title: loc.registerHere),
                      ),
                      SizedBox(
                        width: size.width,
                        child: StepperRegister(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          usernameController: _usernameController,
                        ),
                      ),
                      DividingLastLine(),
                      SmartTextbutton(
                        title: loc.alreadyRegistered,
                        onPressed: () => context.go('/Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget que implementa un Stepper para el registro de usuarios
/// con dos pasos: registro de datos y elección del plan.
class StepperRegister extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;

  const StepperRegister({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
  });

  @override
  State<StepperRegister> createState() => _StepperRegisterState();


}

/// Estado que controla el stepper, validaciones, y registro final.
class _StepperRegisterState extends State<StepperRegister> {
  int _currentStep = 0;
  SubcriptionType _subscription = SubcriptionType.MONTHLY;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return Stepper(
      physics: NeverScrollableScrollPhysics(),
      controlsBuilder: (BuildContext context, ControlsDetails controls) {
        return Row(
          children: [
            if (_currentStep == 0)
              Expanded(
                child: SizedBox(
                  width: size.width,
                  child: SmartButton(
                    title: loc.stepChoosePlan,
                    onPressed: controls.onStepContinue,
                  ),
                ),
              ),
            if (_currentStep == 1)
              Expanded(
                child: SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SmartButton(
                        title: loc.accept,
                        onPressed: () async {
                          if (await UserController().createWithEmail(
                            context,
                            widget.emailController.text.trim(),
                            widget.passwordController.text.trim(),
                            widget.usernameController.text.trim(),
                            _subscription.toString(),
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loc.successfulRegister),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                            User? user = FirebaseAuth.instance.currentUser;
                            widget.emailController.clear();
                            widget.passwordController.clear();
                            widget.usernameController.clear();
                            context.go('/home', extra: user!.uid);
                          } else {
                            setState(() {
                              _currentStep = 0;
                              widget.emailController.clear();
                            });
                          }
                        },
                      ),
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: Text(loc.cancel, style: Styles.customHintTextStyle),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      currentStep: _currentStep,
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_currentStep <= 0) {
          if (widget.usernameController.text.trim().isNotEmpty &&
              widget.emailController.text.trim().isNotEmpty &&
              widget.passwordController.text.trim().isNotEmpty) {
            if (widget.usernameController.text.length < 3 ||
                widget.passwordController.text.length < 6 ||
                !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(widget.emailController.text)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.reviewFields),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 1),
                ),
              );
            } else {
              setState(() {
                _currentStep += 1;
              });
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.fillAllFields),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
      },
      steps: [
        Step(
          title: Text(loc.registerTitle, style: Styles.customTitleHeaderTextStyle),
          content: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Userfield(controller: widget.usernameController),
                const SizedBox(height: 10),
                Emailfield(controller: widget.emailController),
                const SizedBox(height: 10),
                PasswordField(controller: widget.passwordController),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        Step(
          title: Text(loc.choosePlan, style: Styles.customTitleHeaderTextStyle),
          content: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: Styles.customBoxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: size.width,
                          height: 40,
                          child: FloatingActionButton.extended(
                            backgroundColor:
                            _subscription == SubcriptionType.MONTHLY ||
                                _subscription == SubcriptionType.SEMI_ANNUAL ||
                                _subscription == SubcriptionType.YEARLY
                                ? AppColor.smartButtonColor
                                : AppColor.disableColor,
                            shape: Styles.customButtonShape,
                            onPressed: () {
                              setState(() {
                                if (_subscription == SubcriptionType.MONTHLY) {
                                  _subscription = SubcriptionType.MONTHLY;
                                }
                              });
                            },
                            label: Text(loc.premiumPlan, style: Styles.customSmartButtonTextStyle),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.bookReading, style: Styles.customHintTextStyle),
                            Text(loc.accessToCatalog, style: Styles.customTextFieldStyle),
                            const SizedBox(height: 10),
                            Text(loc.achievementSystem, style: Styles.customHintTextStyle),
                            Text(loc.earnBadges, style: Styles.customTextFieldStyle),
                            const SizedBox(height: 10),
                            Text(loc.freePlan, style: Styles.customHintTextStyle),
                            Text(loc.freePlanBenefits, style: Styles.customTextFieldStyle),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: FloatingActionButton.extended(
                                    onPressed: () {
                                      if (_subscription != SubcriptionType.MONTHLY) {
                                        setState(() {
                                          _subscription = SubcriptionType.MONTHLY;
                                        });
                                      }
                                    },
                                    backgroundColor: _subscription == SubcriptionType.MONTHLY
                                        ? AppColor.smartButtonColor
                                        : AppColor.disableColor,
                                    label: Text(loc.month, style: Styles.customTitleHeaderTextStyle),
                                    shape: Styles.customButtonShape,
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: FloatingActionButton.extended(
                                    onPressed: () {
                                      if (_subscription != SubcriptionType.SEMI_ANNUAL) {
                                        setState(() {
                                          _subscription = SubcriptionType.SEMI_ANNUAL;
                                        });
                                      }
                                    },
                                    backgroundColor: _subscription == SubcriptionType.SEMI_ANNUAL
                                        ? AppColor.smartButtonColor
                                        : AppColor.disableColor,
                                    label: Text(loc.semiAnnual, style: Styles.customTitleHeaderTextStyle),
                                    shape: Styles.customButtonShape,
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  height: 50,
                                  child: FloatingActionButton.extended(
                                    onPressed: () {
                                      if (_subscription != SubcriptionType.YEARLY) {
                                        setState(() {
                                          _subscription = SubcriptionType.YEARLY;
                                        });
                                      }
                                    },
                                    backgroundColor: _subscription == SubcriptionType.YEARLY
                                        ? AppColor.smartButtonColor
                                        : AppColor.disableColor,
                                    label: Text(loc.year, style: Styles.customTitleHeaderTextStyle),
                                    shape: Styles.customButtonShape,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: Styles.customBoxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: size.width,
                          height: 40,
                          child: FloatingActionButton.extended(
                            shape: Styles.customButtonShape,
                            onPressed: () {
                              if (_subscription != SubcriptionType.FREE) {
                                setState(() {
                                  _subscription = SubcriptionType.FREE;
                                });
                              }
                            },
                            backgroundColor: _subscription == SubcriptionType.FREE
                                ? AppColor.smartButtonColor
                                : AppColor.disableColor,
                            label: Text(loc.freePlan, style: Styles.customTitleHeaderTextStyle),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.socialEnvironment, style: Styles.customHintTextStyle),
                            Text(loc.followAndShare, style: Styles.customTextFieldStyle),
                            const SizedBox(height: 10),
                            Text(loc.personalLibrary, style: Styles.customHintTextStyle),
                            Text(loc.organizeBooks, style: Styles.customTextFieldStyle),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
