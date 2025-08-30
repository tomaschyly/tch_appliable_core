import 'package:example/model/SembastRecord.dart';
import 'package:example/model/dataTasks/SaveSembastRecordDataTask.dart';
import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:example/ui/widgets/TextFormFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSembastRecordScreen extends AbstractAppScreen {
  static const String ROUTE = "/mdpsembast/record";

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSembastRecordScreenState();
}

class _MDPSembastRecordScreenState extends AbstractAppScreenState<MDPSembastRecordScreen> {
  @override
  AbstractScreenOptions options = AppScreenStateOptions.basic(
    screenName: MDPSembastRecordScreen.ROUTE,
    title: tt('mdpsembastrecord.screen.title'),
  );

  final GlobalKey<_BodyWidgetState> _bodyKey = GlobalKey();

  /// State initialization
  @override
  void initState() {
    super.initState();

    options.appBarOptions = <AppBarOption>[
      AppBarOption(
        icon: Icon(
          Icons.check,
          color: Colors.black,
        ),
        onTap: (BuildContext context) {
          _bodyKey.currentState!._save(context);
        },
      ),
    ];
  }

  @override
  Widget extraLargeDesktopScreen(BuildContext context) => _BodyWidget(key: _bodyKey);

  @override
  Widget largeDesktopScreen(BuildContext context) => _BodyWidget(key: _bodyKey);

  @override
  Widget largePhoneScreen(BuildContext context) => _BodyWidget(key: _bodyKey);

  @override
  Widget smallDesktopScreen(BuildContext context) => _BodyWidget(key: _bodyKey);

  @override
  Widget smallPhoneScreen(BuildContext context) => _BodyWidget(key: _bodyKey);

  @override
  Widget tabletScreen(BuildContext context) => _BodyWidget(key: _bodyKey);
}

class _BodyWidget extends AbstractStatefulWidget {
  /// BodyWidget initialization
  _BodyWidget({Key? key}) : super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends AbstractStatefulWidgetState<_BodyWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  /// Manually dispose of resources
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormFieldWidget(
                  controller: _nameController,
                  autofocus: true,
                  focusNode: _nameFocus,
                  textCapitalization: TextCapitalization.words,
                  label: tt('mdpsembastrecord.screen.name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String text) {
                    _nameFocus.unfocus();

                    _descriptionFocus.requestFocus();
                  },
                  validator: (String? text) {
                    return text?.isEmpty == true ? tt('mdpsembastrecord.screen.name.error') : null;
                  },
                ),
                Container(height: 16),
                TextFormFieldWidget(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  textCapitalization: TextCapitalization.sentences,
                  label: tt('mdpsembastrecord.screen.description'),
                  lines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Validate and save Record to database, then back to list
  Future<void> _save(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final SembastRecord record = SembastRecord.fromJson(<String, dynamic>{
        SembastRecord.COL_NAME: _nameController.text,
        SembastRecord.COL_DESCRIPTION: _descriptionController.text,
        SembastRecord.COL_CREATED: now.millisecondsSinceEpoch,
      });

      final SaveSembastRecordDataTask result = await MainDataProvider.instance!.executeDataTask<SaveSembastRecordDataTask>(
        SaveSembastRecordDataTask(
          data: record,
        ),
      );

      if (result.result?.id != null) {
        popNotDisposed(context, mounted);
      }
    }
  }
}
