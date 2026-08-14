import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneCall(String? phone) async {
  final normalized = _normalize(phone);
  if (normalized == null) return;
  final uri = Uri(scheme: 'tel', path: normalized);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    await Clipboard.setData(ClipboardData(text: normalized));
  }
}

Future<void> launchSms(String? phone, {String? body}) async {
  final normalized = _normalize(phone);
  if (normalized == null) return;
  final uri = Uri(
    scheme: 'sms',
    path: normalized,
    queryParameters: body == null || body.isEmpty ? null : {'body': body},
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    await Clipboard.setData(ClipboardData(text: normalized));
  }
}

String? _normalize(String? phone) {
  if (phone == null) return null;
  final t = phone.trim();
  if (t.isEmpty) return null;
  return t;
}

Future<void> copyPhone(BuildContext context, String? phone, String copiedLabel) async {
  final normalized = _normalize(phone);
  if (normalized == null) return;
  await Clipboard.setData(ClipboardData(text: normalized));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(copiedLabel)));
  }
}
