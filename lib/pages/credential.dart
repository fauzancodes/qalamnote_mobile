import 'package:flutter/material.dart';
import 'package:qalamnote_mobile/controllers/credential.dart';

class CredentialPage extends StatefulWidget {
  final String userId;
  
  const CredentialPage({super.key, required this.userId});

  @override
  State<CredentialPage> createState() => CredentialPageState();
}
