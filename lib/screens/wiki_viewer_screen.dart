/// Wiki görüntüleyici ekranı
/// 
/// Wiki içeriğini tam sayfa olarak gösterir.
/// Markdown ve HTML formatındaki içeriği render eder.
/// 
/// @author Alpay Bilgiç
library;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Wiki görüntüleyici ekranı widget'ı
/// Wiki içeriğini HTML veya Markdown formatında tam sayfa gösterir
class WikiViewerScreen extends StatelessWidget {
  final String wikiContent;
  final String? wikiTitle;

  const WikiViewerScreen({
    super.key,
    required this.wikiContent,
    this.wikiTitle,
  });

  /// Check if content is HTML or Markdown
  bool _isHtml(String content) {
    // Check if content contains HTML tags
    return content.trim().startsWith('<') || 
           RegExp(r'<[a-z][\s\S]*>', caseSensitive: false).hasMatch(content);
  }

  @override
  Widget build(BuildContext context) {
    // Check if content is HTML or Markdown
    final isHtml = _isHtml(wikiContent);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(wikiTitle ?? 'Wiki'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Kapat',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isHtml ? Html(
            data: wikiContent,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(16),
                lineHeight: LineHeight(1.6),
              ),
              "h1": Style(
                fontSize: FontSize(28),
                fontWeight: FontWeight.bold,
                margin: Margins.only(bottom: 16),
              ),
              "h2": Style(
                fontSize: FontSize(24),
                fontWeight: FontWeight.bold,
                margin: Margins.only(bottom: 12),
              ),
              "h3": Style(
                fontSize: FontSize(20),
                fontWeight: FontWeight.bold,
                margin: Margins.only(bottom: 10),
              ),
              "h4": Style(
                fontSize: FontSize(18),
                fontWeight: FontWeight.bold,
                margin: Margins.only(bottom: 8),
              ),
              "p": Style(
                margin: Margins.only(bottom: 12),
              ),
              "code": Style(
                fontSize: FontSize(14),
                fontFamily: 'monospace',
                backgroundColor: Colors.grey.shade200,
                padding: HtmlPaddings.all(2),
              ),
              "pre": Style(
                backgroundColor: Colors.grey.shade200,
                padding: HtmlPaddings.all(12),
                margin: Margins.only(bottom: 12),
              ),
              "a": Style(
                color: Colors.blue,
                textDecoration: TextDecoration.underline,
              ),
              "blockquote": Style(
                padding: HtmlPaddings.only(left: 12),
                margin: Margins.only(left: 0, bottom: 12),
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
                backgroundColor: Colors.grey.shade100,
              ),
              "ul": Style(
                margin: Margins.only(bottom: 12),
              ),
              "ol": Style(
                margin: Margins.only(bottom: 12),
              ),
              "li": Style(
                margin: Margins.only(bottom: 4),
              ),
              "table": Style(
                border: Border.all(color: Colors.grey.shade300),
                margin: Margins.only(bottom: 12),
              ),
              "th": Style(
                fontWeight: FontWeight.bold,
                padding: HtmlPaddings.all(8),
                backgroundColor: Colors.grey.shade100,
              ),
              "td": Style(
                padding: HtmlPaddings.all(8),
              ),
            },
          ) : Markdown(
            data: wikiContent,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 16, height: 1.6),
              h1: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.4),
              h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
              h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4),
              h4: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
              code: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                backgroundColor: Colors.grey.shade200,
              ),
              codeblockDecoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              codeblockPadding: const EdgeInsets.all(12),
              blockquote: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
              blockquoteDecoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  left: BorderSide(color: Colors.blue, width: 4),
                ),
              ),
              blockquotePadding: const EdgeInsets.all(12),
              listBullet: const TextStyle(color: Colors.blue),
              a: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              tableHead: const TextStyle(fontWeight: FontWeight.bold),
              tableBody: const TextStyle(fontSize: 14),
              tableBorder: TableBorder.all(color: Colors.grey.shade300),
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
            ),
            onTapLink: (text, href, title) {
              debugPrint('Link tapped: $href');
            },
          ),
        ),
      ),
    );
  }
}
