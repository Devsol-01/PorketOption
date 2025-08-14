import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String apiKey = dotenv.env['AVNU_API_KEY']!;
}
