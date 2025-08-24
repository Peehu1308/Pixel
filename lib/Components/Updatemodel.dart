import 'package:supabase_flutter/supabase_flutter.dart';



class Updatemodel {
  final String heading;
  final String Update;
  final String? Image;

  Updatemodel({required this.heading, required this.Update,required this.Image});

  factory Updatemodel.fromJson(Map<String, dynamic> json) {
    return Updatemodel(
      heading: json['heading'] as String,
      Update: json['Update'] as String,
      Image: json['Image'] !=null && json['Image'].toString().isNotEmpty?
      json['Image']as String
      :null,
    );
  }
}

Future<List<Updatemodel>> fetchUpdate() async {
  final List<Map<String, dynamic>> response = await Supabase.instance.client
      .from('Updates')
      .select('heading,Update,Image')
      .order('created_at', ascending: false);

  return response.map((item) => Updatemodel.fromJson(item)).toList();
}
