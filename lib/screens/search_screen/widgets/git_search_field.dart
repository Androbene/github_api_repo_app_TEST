import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_api_repo_app/utils/logging.dart';

import '../../../themes/app_colors.dart';
import '../../../constants/strings.dart';

class GitSearchField extends StatefulWidget {
  final Function onFocusedCallback;
  final Function(String) onSearchCallback;

  const GitSearchField({
    super.key,
    required this.onFocusedCallback,
    required this.onSearchCallback,
  });

  @override
  GitSearchFieldState createState() => GitSearchFieldState();
}

class GitSearchFieldState extends State<GitSearchField> {
  final FocusNode _focusNode = FocusNode();
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? {widget.onFocusedCallback()} : {};
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
      focusNode: _focusNode,
      controller: _inputController,
      decoration: InputDecoration(
        prefixIcon: InkWell(
          onTap: () => widget.onSearchCallback(_inputController.text),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(
              'assets/icons/ic_search.svg',
            ),
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            _inputController.clear();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(
              'assets/icons/ic_close.svg',
            ),
          ),
        ),
        labelText: _focusNode.hasFocus ? "" : Strings.search,
        fillColor: _focusNode.hasFocus ? AppColors.secondary : AppColors.layer1,
        filled: true,
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorderOnFocus(),
        // disabledBorder: _buildBorderOnFocus(),
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
