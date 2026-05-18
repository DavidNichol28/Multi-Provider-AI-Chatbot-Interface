import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget navBarTitleWidget;
  final List<Widget> navBarWidgets;
  final Color backgroundColor;

  final String initialSubNavTitle;
  final ValueChanged<String>? subNavTitleOnSave;

  const CustomNavBar({
    super.key,
    required this.navBarTitleWidget,
    required this.navBarWidgets,
    required this.backgroundColor,
    required this.initialSubNavTitle,
    this.subNavTitleOnSave,
  });

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      child: navBarTitleWidget,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: navBarWidgets,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SubNavTitleEditor(
                initialTitle: initialSubNavTitle,
                onSave: subNavTitleOnSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubNavTitleEditor extends StatefulWidget {
  final String initialTitle;
  final ValueChanged<String>? onSave;

  const _SubNavTitleEditor({
    required this.initialTitle,
    this.onSave,
  });

  @override
  State<_SubNavTitleEditor> createState() =>
      _SubNavTitleEditorState();
}

class _SubNavTitleEditorState extends State<_SubNavTitleEditor> {
  late TextEditingController _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void didUpdateWidget(covariant _SubNavTitleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTitle != widget.initialTitle && !_editing) {
      _controller.text = widget.initialTitle;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      _editing = false;
    });

    widget.onSave?.call(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: _editing
            ? Row(
                key: const ValueKey('editing'),
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _save(),
                    ),
                  ),
                  IconButton(
                    onPressed: _save,
                    icon: const Icon(Icons.check, color: Colors.white),
                  ),
                ],
              )
            : InkWell(
                key: const ValueKey('viewing'),
                onTap: () {
                  setState(() {
                    _editing = true;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _controller.text,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
