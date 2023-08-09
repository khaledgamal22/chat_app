import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({required String email,required String password})async{
    emit(LoginLoading());
    try{
      UserCredential user= await FirebaseAuth.instance
    .signInWithEmailAndPassword(email: email, password: password);
    emit(LoginSuccess());
    }on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        emit(LoginFailre(errorMessage: 'this user is not found'));
      }
      else if(e.code=='wrong-password'){
        emit(LoginFailre(errorMessage: 'wrong password'));
      }
    }catch(e){
      emit(LoginFailre(errorMessage: 'something went wrong'));
    }
  }
}
