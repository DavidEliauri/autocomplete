import 'dart:async';

import 'package:autocomplete_app/data/providers/autocompete_api.dart';
import 'package:autocomplete_app/data/repositories/autocomplete_repo.dart';
import 'package:autocomplete_app/logic/cubit/autocomplete_cubit.dart';
import 'package:autocomplete_app/logic/observers/global_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(() {
    runApp(MyApp());
  }, blocObserver: GlobalBlocObserver());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AutocompleteApi _api;

  @override
  void initState() {
    super.initState();
    _api = AutocompleteApi();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AutocompleteRepo(_api),
      child: MaterialApp(
        title: 'Flutter Autocomplete',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Короче, текст заполняет'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocProvider(
        create: (c) => AutocompleteCubit(c.read()),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: const AutocompleteWidget(),
        ),
      ),
    );
  }
}

class AutocompleteWidget extends StatefulWidget {
  const AutocompleteWidget({Key? key}) : super(key: key);

  @override
  State<AutocompleteWidget> createState() => _AutocompleteWidgetState();
}

class _AutocompleteWidgetState extends State<AutocompleteWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textInput;
  late final AutocompleteCubit _autocompleteCubit;
  Timer? _debounce;

  AutocompleteState get state => _autocompleteCubit.state;

  @override
  void initState() {
    super.initState();
    _textInput = TextEditingController();
    _autocompleteCubit = context.read<AutocompleteCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        minLines: 1,
        maxLines: null,
        controller: _textInput,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
      ),
    );
  }

  void onChanged(final String query) {
    _autocompleteCubit.get(query);
    // if (_debounce?.isActive ?? false) _debounce?.cancel();
    // _debounce = Timer(const Duration(seconds: 5), () {
    //   _autocompleteCubit.get(query);
    // });
  }
}
