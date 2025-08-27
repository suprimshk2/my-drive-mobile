import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'optimized_bottom_sheet.dart';

class OptimizedBottomSheetExamples {
  // Example 1: Basic bottom sheet with title and content
  static void showBasicExample(BuildContext context) {
    OptimizedBottomSheet.show(
      context: context,
      title: 'Basic Example',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'This is a basic bottom sheet example.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          const SizedBox(height: Dimens.spacing_large),
          TextWidget(
            text: 'It includes a title, content area, and close button.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ],
      ),
    );
  }

  // Example 2: Bottom sheet with custom header
  static void showCustomHeaderExample(BuildContext context) {
    OptimizedBottomSheet.show(
      context: context,
      header: Row(
        children: [
          Icon(Icons.info, color: Colors.blue[600]),
          const SizedBox(width: Dimens.spacing_8),
          TextWidget(
            text: 'Custom Header',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.blue[600]),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'This example shows a custom header with an icon.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          const SizedBox(height: Dimens.spacing_large),
          TextWidget(
            text: 'You can customize the header with any widget.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ],
      ),
    );
  }

  // Example 3: Bottom sheet with footer
  static void showFooterExample(BuildContext context) {
    OptimizedBottomSheet.show(
      context: context,
      title: 'Footer Example',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'This bottom sheet has a footer with action buttons.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          const SizedBox(height: Dimens.spacing_large),
          TextWidget(
            text:
                'The footer is separated from the content and stays at the bottom.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: Dimens.spacing_large),
          Expanded(
            child: RoundedFilledButtonWidget(
              context: context,
              label: 'Confirm',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action confirmed!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Example 4: Scrollable content
  static void showScrollableExample(BuildContext context) {
    OptimizedBottomSheet.show(
      context: context,
      title: 'Scrollable Content',
      maxHeight: 400,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          20,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: Dimens.spacing_large),
            child: TextWidget(
              text:
                  'Item ${index + 1}: This is a long text that demonstrates scrollable content in the bottom sheet.',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
        ),
      ),
    );
  }

  // Example 5: Custom styling
  static void showCustomStylingExample(BuildContext context) {
    OptimizedBottomSheet.show(
      context: context,
      title: 'Custom Styling',
      backgroundColor: Colors.grey[100],
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Dimens.radius_large),
      ),
      padding: const EdgeInsets.all(Dimens.spacing_extra_large),
      content: Container(
        padding: const EdgeInsets.all(Dimens.spacing_large),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.radius_default),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: 'This example shows custom styling:',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            const SizedBox(height: Dimens.spacing_large),
            TextWidget(
              text:
                  '• Custom background color\n• Custom border radius\n• Custom padding\n• Content with shadow',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ],
        ),
      ),
    );
  }

  // Example 6: Non-dismissible bottom sheet
  static void showNonDismissibleExample(BuildContext context) {
    OptimizedBottomSheet.show(
      context: context,
      title: 'Non-Dismissible',
      isDismissible: false,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'This bottom sheet cannot be dismissed by tapping outside.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          const SizedBox(height: Dimens.spacing_large),
          TextWidget(
            text: 'You must use the close button to dismiss it.',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ],
      ),
      footer: RoundedFilledButtonWidget(
        context: context,
        label: 'Close',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Example 7: Ride details with optimized bottom sheet
  static void showRideDetailsExample(BuildContext context) {
    RideDetailsBottomSheet.show(
      context: context,
      distance: '2.5 km',
      duration: '8 mins',
      estimatedFare: 150.0,
      canBookRide: true,
      isLoading: false,
      onBookRide: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride booked successfully!')),
        );
      },
    );
  }

  // Example 8: Location options
  static void showLocationOptionsExample(BuildContext context) {
    LocationOptionsBottomSheet.show(
      context: context,
      onSaveLocation: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location saved!')),
        );
      },
      onShare: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location shared!')),
        );
      },
      onRemove: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location removed!')),
        );
      },
    );
  }

  // Example 9: Form bottom sheet
  static void showFormExample(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    OptimizedBottomSheet.show(
      context: context,
      title: 'Contact Form',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: Dimens.spacing_large),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: Dimens.spacing_large),
          Expanded(
            child: RoundedFilledButtonWidget(
              context: context,
              label: 'Submit',
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Form submitted: ${nameController.text}'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Example 10: List bottom sheet
  static void showListExample(BuildContext context) {
    final List<String> items = [
      'Option 1',
      'Option 2',
      'Option 3',
      'Option 4',
      'Option 5',
    ];

    OptimizedBottomSheet.show(
      context: context,
      title: 'Select Option',
      content: Column(
        children: items
            .map((item) => ListTile(
                  title: Text(item),
                  onTap: () {
                    Navigator.pop(context, item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: $item')),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}

// Widget to demonstrate all examples
class BottomSheetExamplesWidget extends StatelessWidget {
  const BottomSheetExamplesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Sheet Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.spacing_large),
        children: [
          _buildExampleButton(
            context,
            'Basic Example',
            'Simple bottom sheet with title and content',
            () => OptimizedBottomSheetExamples.showBasicExample(context),
          ),
          _buildExampleButton(
            context,
            'Custom Header',
            'Bottom sheet with custom header widget',
            () => OptimizedBottomSheetExamples.showCustomHeaderExample(context),
          ),
          _buildExampleButton(
            context,
            'Footer Example',
            'Bottom sheet with footer and action buttons',
            () => OptimizedBottomSheetExamples.showFooterExample(context),
          ),
          _buildExampleButton(
            context,
            'Scrollable Content',
            'Bottom sheet with scrollable content',
            () => OptimizedBottomSheetExamples.showScrollableExample(context),
          ),
          _buildExampleButton(
            context,
            'Custom Styling',
            'Bottom sheet with custom colors and styling',
            () =>
                OptimizedBottomSheetExamples.showCustomStylingExample(context),
          ),
          _buildExampleButton(
            context,
            'Non-Dismissible',
            'Bottom sheet that cannot be dismissed by tapping outside',
            () =>
                OptimizedBottomSheetExamples.showNonDismissibleExample(context),
          ),
          _buildExampleButton(
            context,
            'Ride Details',
            'Specialized ride details bottom sheet',
            () => OptimizedBottomSheetExamples.showRideDetailsExample(context),
          ),
          _buildExampleButton(
            context,
            'Location Options',
            'Specialized location options bottom sheet',
            () => OptimizedBottomSheetExamples.showLocationOptionsExample(
                context),
          ),
          _buildExampleButton(
            context,
            'Form Example',
            'Bottom sheet with form inputs',
            () => OptimizedBottomSheetExamples.showFormExample(context),
          ),
          _buildExampleButton(
            context,
            'List Example',
            'Bottom sheet with selectable list items',
            () => OptimizedBottomSheetExamples.showListExample(context),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton(
    BuildContext context,
    String title,
    String description,
    VoidCallback onPressed,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: Dimens.spacing_large),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}
