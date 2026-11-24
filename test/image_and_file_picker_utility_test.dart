import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart'
    show FilePickerUtil;

final class _Selection extends PlatformFile {
  _Selection(this.uri);

  @override
  final Uri uri;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Picker extends FilePickerPlatform {
  List<PlatformFile> selection = [];
  int singleCalls = 0;
  int multipleCalls = 0;
  FileType? selectedType;
  List<String>? extensions;
  int? quality;

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    singleCalls++;
    selectedType = type;
    extensions = allowedExtensions;
    quality = compressionQuality;
    return selection.firstOrNull;
  }

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    multipleCalls++;
    return selection;
  }
}

void main() {
  late _Picker picker;

  setUp(() {
    final previousPicker = FilePickerPlatform.instance;
    picker = _Picker();
    FilePickerPlatform.instance = picker;
    addTearDown(() => FilePickerPlatform.instance = previousPicker);
  });

  testWidgets('single selection forwards the filter and compression quality', (
    tester,
  ) async {
    await tester.pumpWidget(const SizedBox.shrink());
    final context = tester.element(find.byType(SizedBox));
    picker.selection = [_Selection(Uri.file('/tmp/example.pdf'))];

    final files = await FilePickerUtil().getFilePicker(
      context: context,
      fileType: FileType.custom,
      allowedExtensions: ['pdf'],
      compressionQuality: 75,
    );

    expect(files?.single.path, '/tmp/example.pdf');
    expect(picker.singleCalls, 1);
    expect(picker.multipleCalls, 0);
    expect(picker.selectedType, FileType.custom);
    expect(picker.extensions, ['pdf']);
    expect(picker.quality, 75);
  });

  testWidgets('multiple selection keeps local paths in user selection order', (
    tester,
  ) async {
    await tester.pumpWidget(const SizedBox.shrink());
    final context = tester.element(find.byType(SizedBox));
    picker.selection = [
      _Selection(Uri.file('/tmp/first.txt')),
      _Selection(Uri.parse('content://provider/nonlocal')),
      _Selection(Uri.file('/tmp/second.txt')),
    ];

    final files = await FilePickerUtil().getFilePicker(
      context: context,
      allowMultiple: true,
    );

    expect(files?.map((file) => file.path), [
      '/tmp/first.txt',
      '/tmp/second.txt',
    ]);
    expect(picker.multipleCalls, 1);
    expect(picker.singleCalls, 0);
  });

  testWidgets('canceled or nonlocal selections return null', (tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    final context = tester.element(find.byType(SizedBox));
    final utility = FilePickerUtil();

    expect(await utility.getFilePicker(context: context), isNull);
    expect(
      await utility.getFilePicker(context: context, allowMultiple: true),
      isNull,
    );
    picker.selection = [_Selection(Uri.parse('content://provider/nonlocal'))];
    expect(await utility.getFilePicker(context: context), isNull);
  });
}
