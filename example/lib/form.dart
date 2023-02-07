import 'dart:math';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const chars =
              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

          String newValue = String.fromCharCodes(
            Iterable.generate(
              4,
              (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
            ),
          );

          List<String> currentValues =
              _formKey.currentState?.instantValue['chips'] ?? <String>[];

          _formKey.currentState?.patchValue({
            'chips': [...currentValues, newValue],
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const ChipsFormInput(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: <Widget>[
                      Text(
                          'chips: ${_formKey.currentState?.instantValue['chips']}'),
                    ],
                  ),
                ),
                child: const Text('Show answer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipsFormInput extends StatefulWidget {
  const ChipsFormInput({super.key});

  @override
  State<ChipsFormInput> createState() => _ChipsFormInputState();
}

class _ChipsFormInputState extends State<ChipsFormInput> {
  final _chipsKey = GlobalKey<ChipsInputState<String>>();

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
    List<String> options = const <String>['eenie', 'meenie', 'miney', 'mo'];

    if (query.isEmpty) return options;

    return <String>{
      query,
      ...options.where((option) => option.contains(query)),
    }.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<String>>(
      name: 'chips',
      onChanged: (values) {
        if (values != _chipsKey.currentState?.chips) {
          if (values != null) {
            _chipsKey.currentState?.chips = values;
          }
        }
      },
      builder: (fieldState) {
        return ChipsInput<String>(
          key: _chipsKey,
          onChanged: fieldState.didChange,
          chipBuilder: chipBuilder,
          suggestionBuilder: suggestionBuilder,
          findSuggestions: findSuggestions,
        );
      },
    );
  }
}
