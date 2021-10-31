import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nullp/layout/cubit/cubit.dart';
import 'package:nullp/layout/cubit/state.dart';
import 'package:nullp/models/user.dart';
import 'package:nullp/modules/chat_details/chat_Details.dart';
import 'package:nullp/shared/components.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state){
          return ConditionalBuilder(
            condition:SocialCubit.get(context).users.length > 0,
            builder:(context)=>ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder:  (context, index) =>buildChatItem(SocialCubit.get(context).users[index], context),
              separatorBuilder:  (context, index) => myDivider(),
              itemCount: SocialCubit.get(context).users.length,),
            fallback: (context) => Center(child: CircularProgressIndicator()),

          );
        });
  }
  Widget buildChatItem(SocialUserModel model,context)=> InkWell(
    onTap: () {
      navigateTo(
        context,
        ChatDetailsScreen(
          userModel: model,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              'https://image.freepik.com/free-photo/surprised-happy-girl-pointing-left-recommend-product-advertisement-make-okay-gesture_176420-20191.jpg',
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            'Mohamed Taha',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}