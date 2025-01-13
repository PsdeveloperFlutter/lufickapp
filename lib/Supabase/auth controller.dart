import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_api/Api work.dart';


class auth extends GetxController{

   late authapi authapis;
  RxBool loginloading=false.obs;
  RxBool signuploading=false.obs;


  void onInit()async{
    authapis=authapi(SupabaseController.supabase);
    super.onInit();
  }

//* Login method
void lognin(String email, String password)async{
    loginloading.value = true;
    final response = await authapis.lognin(email, password);
    loginloading.value = false;
    log(response.user!.email.toString()+" "+response.user!.id.toString()+response.user!.appMetadata.toString());
}

  void signup(String email, String password,String name)async {
    signuploading.value = true;
    final response = await authapis.signup(email, password,name);
    signuploading.value = false;
   log(response.user!.email.toString()+" "+response.user!.id.toString()+response.user!.appMetadata.toString());
  }


}


class SupabaseController extends GetxService {
  void onInit()async{
    await Supabase.initialize(url:"https://getiekpsyhtsvntotcpx.supabase.co", anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdldGlla3BzeWh0c3ZudG90Y3B4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY2OTk3OTEsImV4cCI6MjA1MjI3NTc5MX0.LmVgroP0YCLXm3cgUXB6vtsuuY1_tJhn9dop5PDZUZE");
    super.onInit();

  }
  //*Supbase instance
  static final SupabaseClient supabase = Supabase.instance.client;
}











