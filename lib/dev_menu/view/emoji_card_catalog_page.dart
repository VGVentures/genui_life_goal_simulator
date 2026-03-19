import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// {@template emoji_card_catalog_page}
/// Catalog page showcasing [EmojiCard] default and selected variants.
/// {@endtemplate}
class EmojiCardCatalogPage extends StatefulWidget {
  /// {@macro emoji_card_catalog_page}
  const EmojiCardCatalogPage({super.key});

  @override
  State<EmojiCardCatalogPage> createState() => _EmojiCardCatalogPageState();
}

class _EmojiCardCatalogPageState extends State<EmojiCardCatalogPage> {
  final _selected = <int>{};

  void _toggle(int index) => setState(() {
    if (!_selected.remove(index)) _selected.add(index);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('EmojiCard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmojiCardLayout(
              cards: [
                EmojiCard(
                  emoji: '📊',
                  label: 'Fixed costs',
                  isSelected: _selected.contains(0),
                  onTap: () => _toggle(0),
                ),
                EmojiCard(
                  emoji: '💰',
                  label: '% of income',
                  isSelected: _selected.contains(1),
                  onTap: () => _toggle(1),
                ),
                EmojiCard(
                  emoji: '🤝',
                  label: 'Negotiable',
                  isSelected: _selected.contains(2),
                  onTap: () => _toggle(2),
                ),
                EmojiCard(
                  emoji: '💎',
                  label: 'Potential Savings',
                  isSelected: _selected.contains(3),
                  onTap: () => _toggle(3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
