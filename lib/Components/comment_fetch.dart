import 'package:flutter/material.dart';
import 'package:pixel/Check/data.dart';
import 'package:pixel/Components/comment_model.dart';
import 'package:pixel/utils/encrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<CommentModel>> fetchComments() async {
  final crypto = CryptoHelper();

  final List<Map<String, dynamic>> response = await Supabase.instance.client
      .from('Comments')
      .select('Username,comment,created_at,email,image,Users!inner(Email,Image)')
      .order('created_at', ascending: false);

  return response.map((item) {
    final data = item as Map<String, dynamic>;

    // Always run through safeDecrypt
    data['Username'] = crypto.safeDecrypt(data['Username'] as String?);


    return CommentModel.fromJson(data);
  }).toList();
}


