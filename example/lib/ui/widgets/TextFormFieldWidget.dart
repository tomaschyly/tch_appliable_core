import 'dart:io';

import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration? inputDecoration;
  final TextCapitalization textCapitalization;
  final String? label;
  final int lines;
  final FormFieldValidator<String>? validator;

  /// TextFormFieldWidget initialization
  TextFormFieldWidget({
    Key? key,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputDecoration,
    this.textCapitalization = TextCapitalization.none,
    this.label,
    this.lines = 1,
    this.validator,
  }) : super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> with SingleTickerProviderStateMixin {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: theme.primaryColorDark,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    );
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    return AnimatedSize(
      vsync: this,
      duration: kThemeAnimationDuration,
      child: Container(
        width: 576,
        child: TextFormField(
          autofocus: widget.autofocus,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          minLines: widget.lines,
          maxLines: widget.lines,
          decoration: widget.inputDecoration ??
              InputDecoration(
                isDense: true,
                labelText: widget.label,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                enabledBorder: border,
                focusedBorder: border,
                errorBorder: errorBorder,
                focusedErrorBorder: errorBorder,
                errorStyle: TextStyle(color: Colors.red),
              ),
          validator: widget.validator,
          autocorrect: !Platform.isIOS, //TODO disabled for iOS as TMP solution until Flutter resolution
        ),
      ),
    );
  }
}
