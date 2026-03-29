import 'package:example/model/sembast_record.dart';
import 'package:example/model/dataTasks/save_sembast_record_data_task.dart';
import 'package:example/ui/screens/abstract_app_screen.dart';
import 'package:example/ui/widgets/text_form_field_widget.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSembastRecordScreen extends AbstractAppScreen {
  static const String route = '/mdpsembast/record';

  const MDPSembastRecordScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSembastRecordScreenState();
}

class _MDPSembastRecordScreenState extends AbstractAppScreenState<MDPSembastRecordScreen> {
  final GlobalKey<_BodyWidgetState> _bodyKey = GlobalKey();

  /// State initialization
  @override
  void initState() {
    super.initState();
    options = AppScreenStateOptions.basic(
      screenName: MDPSembastRecordScreen.route,
      title: tt('mdpsembastrecord.screen.title'),
    );

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
  const _BodyWidget({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
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
                const SizedBox(height: 16),
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
      ),
    );
  }

  /// Validate and save Record to database, then back to list
  Future<void> _save(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final SembastRecord record = SembastRecord.fromJson(<String, dynamic>{
        SembastRecord.colName: _nameController.text,
        SembastRecord.colDescription: _descriptionController.text,
        SembastRecord.colCreated: now.millisecondsSinceEpoch,
      });

      final SaveSembastRecordDataTask result = await MainDataProvider.instance!.executeDataTask<SaveSembastRecordDataTask>(
        SaveSembastRecordDataTask(
          data: record,
        ),
      );

      if (!context.mounted) return;

      if (result.result?.id != null) {
        popNotDisposedV2(context, mounted);
      }
    }
  }
}
