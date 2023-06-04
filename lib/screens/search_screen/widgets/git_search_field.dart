import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_api_repo_app/constants/app_ic.dart';

import '../../../themes/app_colors.dart';
import '../../../constants/strings.dart';

class GitSearchField extends StatefulWidget {
  final Function _onFocusedCallback;
  final Function(String) _onSearchCallback;
  final Function _onClearCallback;

  const GitSearchField({
    super.key,
    required Function onFocusedCallback,
    required dynamic Function(String) onSearchCallback,
    required Function onClearCallback,
  })  : _onClearCallback = onClearCallback,
        _onSearchCallback = onSearchCallback,
        _onFocusedCallback = onFocusedCallback;

  @override
  GitSearchFieldState createState() => GitSearchFieldState();
}

class GitSearchFieldState extends State<GitSearchField> {
  final FocusNode _focusNode = FocusNode();
  final _inputController = TextEditingController();

  bool get _isNotEmpty => _inputController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? {widget._onFocusedCallback()} : {};
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      showCursor: true,
      readOnly: false,
      keyboardType: TextInputType.text,
      enableInteractiveSelection: true,
      focusNode: _focusNode,
      controller: _inputController,
      decoration: InputDecoration(
        prefixIcon: InkWell(
          onTap: () => widget._onSearchCallback(_inputController.text),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(AppIc.search),
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            _inputController.clear();
            widget._onClearCallback();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(AppIc.clear),
          ),
        ),
        labelText: _focusNode.hasFocus || _isNotEmpty ? "" : Strings.search,
        fillColor: _focusNode.hasFocus ? AppColors.secondary : AppColors.layer1,
        filled: true,
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorderOnFocus(),
      ),
    );
  }

  OutlineInputBorder _buildBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          width: 0.0,
          color: AppColors.layer1,
        ),
      );

  OutlineInputBorder _buildBorderOnFocus() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          width: 2,
          color: AppColors.primary,
        ),
      );
}
