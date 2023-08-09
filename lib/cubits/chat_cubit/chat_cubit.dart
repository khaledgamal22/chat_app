import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:scholar_chat/models/message.dart';
import '../../constants.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList=[];

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  void sendMessage({required String message,required String email}){
    messages.add({
      kMessage:message,
      kCreatedAt:DateTime.now(),
      'id':email
    });
  }
  void getMessage(){
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      
      messagesList.clear();
      for(var doc in event.docs){
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
     });
  }
}
