import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AiCompany { google, anthropic,  }

extension AiCompanyExtension on AiCompany {
  String get url {
    switch (this) {
      case AiCompany.google:
        return 'https://generativelanguage.googleapis.com/v1beta/models';
      case AiCompany.anthropic:
        return 'https://api.anthropic.com/v1/messages';
    }
  }

  Map<String, String> headers(String? key) {
    switch (this) {
      case AiCompany.google:
        return {'Content-Type': 'application/json'};
      case AiCompany.anthropic:
        return {
          'x-api-key': key ?? '',
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        };
    }
  }

  String get displayName {
    switch (this) {
      case AiCompany.google:
        return 'Google';
      case AiCompany.anthropic:
        return 'Anthropic';
    }
  }
}
