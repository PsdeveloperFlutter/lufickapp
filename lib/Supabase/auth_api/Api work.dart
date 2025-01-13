import 'package:supabase/supabase.dart';

class authapi{
  final SupabaseClient SupbaseClient;

  authapi(this.SupbaseClient);


  //This is for the Login Function
  Future<AuthResponse> lognin(String email, String password)async{
    final AuthResponse response=await SupbaseClient.auth.signInWithPassword(password: password, email: email);
    return response;
  }

   //This is for the Signup Function
  Future<AuthResponse> signup(String email, String password,String name)async{
   final AuthResponse response=await SupbaseClient.auth.signUp(
       email: email,
       password: password,
       data: {"name":name}
    );
    return response;
  }



}