import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chips_input/chips_input.dart';

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: const <Widget>[
              ChipsFormInput(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipsFormInput extends StatelessWidget {
  const ChipsFormInput({super.key});

  Widget chipBuilder(
    BuildContext context,
    ChipsInputState state,
    String data,
  ) {
    return Chip(
      label: Text(data),
      onDeleted: () => state.deleteChip(data),
    );
  }

  Widget suggestionBuilder(BuildContext context, String data) {
    return ListTile(title: Text(data));
  }

  List<String> findSuggestions(String query) {
    return const <String>['eenie', 'meenie', 'miney', 'mo'];
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: 'chips',
      builder: (fieldState) {
        return ChipsInput<String>(
          chipBuilder: chipBuilder,
          suggestionBuilder: suggestionBuilder,
          findSuggestions: findSuggestions,
        );
      },
    );
  }
}
