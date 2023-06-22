import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_api_repo_app/constants/app_ic.dart';
import 'package:github_api_repo_app/screens/search_screen/bloc/search_block.dart';

import '../../../themes/app_colors.dart';
import '../../../constants/strings.dart';
import '../bloc/history_case.dart';
import '../bloc/search_events.dart';
import '../bloc/search_state.dart';

class GitSearchField extends StatefulWidget {
  const GitSearchField({super.key});

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
        _focusNode.hasFocus
            ? BlocProvider.of<SearchBloc>(context).add(SearchInputEvent())
            : {};
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
    final bloc = BlocProvider.of<SearchBloc>(context);
    return TextFormField(
      showCursor: true,
      readOnly: false,
      keyboardType: TextInputType.text,
      enableInteractiveSelection: true,
      focusNode: _focusNode,
      controller: _inputController,
      decoration: InputDecoration(
        prefixIcon: InkWell(
          onTap: () {
            if (bloc.state.currState != SearchState.loading) {
              SearchHistoryCase().save(_inputController.text);
              bloc.add(SearchLoadingEvent(searchString: _inputController.text));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(AppIc.search),
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            _inputController.clear();
            bloc.add(SearchClearEvent());
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
