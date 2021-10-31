import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nullp/layout/social_layout.dart';
import 'package:nullp/modules/login/cubit/cubit.dart';
import 'package:nullp/modules/login/cubit/state.dart';
import 'package:nullp/modules/register/register.dart';
import 'package:nullp/shared/components.dart';
import 'package:nullp/shared/network/local/cacheHelper.dart';

class LoginScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

        create: (BuildContext context) =>SocialLoginCubit(),
        child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
          listener: (context,state){
            if (state is SocialLoginErrorState) {
              showToast(
                text: state.error,
                state: ToastStates.ERROR,
              );
            }
            if(state is SocialLoginSuccessState)
            {
              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value)
              {
                navigateAndFinish(
                  context,
                  SocialLayout(),
                );
              });
            }
          },
          builder: (context,state)
          {
            return Scaffold(
              appBar:AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style:Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Login now to communicate with your friends',
                            style:Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String value)
                              {
                                if(value.isEmpty)
                                {
                                  print('email can\'t be empty');
                                }
                              },
                              label: 'Email Address',
                              prefix: Icons.email_outlined),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String value)
                            {
                              if(value.isEmpty)
                              {
                                print('password can\'t be empty');
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix:SocialLoginCubit.get(context).suffix,
                            suffixPressed: () {
                              SocialLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            isPassword: SocialLoginCubit.get(context).isPassword,
                            onSubmit:(value) {
                              if(formKey.currentState!.validate()) {
                                // SocialLoginCubit.get(context).userLogin(
                                // email: emailController.text,
                                // password: passwordController.text,);
                              }
                            },

                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            condition: state is !SocialLoginLoadingState,
                            builder: (context)=>
                                defaultButton(
                                  function: (){
                                    if (formKey.currentState!.validate()) {
                                      //SocialLoginCubit.get(context).userLogin(
                                      // email: emailController.text,
                                      //password: passwordController.text);
                                    }
                                  },
                                  text: 'login',
                                  isUpperCase: true,
                                ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                              ),
                              defaultTextButton(
                                function: () {
                                  navigateTo(
                                    context,
                                    SocialRegisterScreen(),
                                  );
                                },
                                text: 'register',
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
          },

        )

    );
  }
}
