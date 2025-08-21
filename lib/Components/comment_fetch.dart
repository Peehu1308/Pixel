import 'package:flutter/material.dart';
import 'package:pixel/Check/data.dart';
import 'package:pixel/Components/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<CommentModel>> fetchComments() async {
  final List<Map<String, dynamic>> response = await Supabase.instance.client
      .from('Comments')
      .select('Username,comment,created_at,email,image,Users!inner(Email,Image)')
      .order('created_at', ascending: false);

  final List<dynamic> dataList = response as List<dynamic>;

  // Then convert each element to Map<String, dynamic> and parse it
  return dataList
      .map((item) => CommentModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

