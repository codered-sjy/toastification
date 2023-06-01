// ignore_for_file: prefer_const_constructors

import 'package:example/src/core/views/widgets/bordered_container.dart';
import 'package:example/src/core/views/widgets/expandable_widget.dart';
import 'package:example/src/features/home/controllers/toast_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:toastification/toastification.dart';

class PreviewPanel extends StatelessWidget {
  const PreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: const Column(
          children: [
            ToastPreview(),
            SizedBox(height: 16),
            CodePreview(),
          ],
        ),
      ),
    );
  }
}

class ToastPreview extends ConsumerWidget {
  const ToastPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveWrapper.of(context).isSmallerThan(TABLET);

    final toastDetail = ref.watch(toastDetailControllerProvider);

    return SizedBox(
      height: isTablet ? 120 : 182,
      width: double.infinity,
      child: Material(
        shape: Theme.of(context).cardTheme.shape,
        color: Theme.of(context).cardTheme.color,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 32),
            child: FlatToastWidget(
              type: toastDetail.type ?? ToastificationType.info,
              title: toastDetail.title,
              description: toastDetail.description,
              backgroundColor: toastDetail.backgroundColor == null
                  ? null
                  : ToastHelper.createMaterialColor(
                      toastDetail.backgroundColor!,
                    ),
              foregroundColor: toastDetail.foregroundColor,
              icon: toastDetail.icon,
              borderRadius: toastDetail.borderRadius,
              elevation: toastDetail.elevation,
              onCloseTap: toastDetail.onCloseTap,
              showCloseButton: toastDetail.showCloseButton,
            ),
          ),
        ),
      ),
    );
  }
}

class CodePreview extends StatelessWidget {
  const CodePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveWrapper.of(context).isSmallerThan(TABLET);

    if (isTablet) {
      return const ExpandableCodePreview();
    }

    return const _RawCodePreview();
  }
}

class _RawCodePreview extends StatelessWidget {
  const _RawCodePreview();

  @override
  Widget build(BuildContext context) {
    return const BorderedContainer(
      height: 300,
      child: Text('Code Preview'),
    );
  }
}

class ExpandableCodePreview extends StatefulWidget {
  const ExpandableCodePreview({super.key});

  final bool initialExpanded = false;

  @override
  State<ExpandableCodePreview> createState() => _ExpandableCodePreviewState();
}

class _ExpandableCodePreviewState extends State<ExpandableCodePreview> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();

    isExpanded = widget.initialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpandableWidget(
      borderSide: BorderSide(color: theme.colorScheme.outline),
      expansionCallback: (isExpanded) {
        setState(() {
          this.isExpanded = !isExpanded;
        });
      },
      headerBuilder: (context, isExpanded) {
        return Container(
          height: 56,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Code Preview',
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.copy_all_rounded,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: _RawCodePreview(),
      ),
      isExpanded: isExpanded,
    );
  }
}
