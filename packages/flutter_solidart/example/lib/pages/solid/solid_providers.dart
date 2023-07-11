import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

class NameProvider {
  const NameProvider(this.name);
  final String name;

  void dispose() {
    // put your dispose logic here
    // ignore: avoid_print
    print('dispose name provider');
  }
}

class NumberProvider {
  const NumberProvider(this.number);
  final int number;
}

// Using an Enum as a key for SolidProviders, you can use any type of Object, like int, string, etc.
enum ProviderId {
  firstNumber,
  secondNumber,
}

class SolidProvidersPage extends StatelessWidget {
  const SolidProvidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solid Providers'),
      ),
      body: Solid(
        providers: [
          SolidProvider<NameProvider>(
            create: () => const NameProvider('Ale'),
            // the dispose method is fired when the [Solid] widget above is removed from the widget tree.
            dispose: (provider) => provider.dispose(),
          ),
          SolidProvider<NumberProvider>(
            create: () => const NumberProvider(1),
            // Do not create the provider lazily, but immediately
            lazy: false,
            id: ProviderId.firstNumber,
          ),
          SolidProvider<NumberProvider>(
            create: () => const NumberProvider(100),
            // Do not create the provider lazily, but immediately
            lazy: false,
            id: ProviderId.secondNumber,
          ),
        ],
        child: const SomeChild(),
      ),
    );
  }
}

class SomeChild extends StatelessWidget {
  const SomeChild({super.key});

  Future<void> openDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Solid.value(
        elements: [
          context.getElement<NameProvider>(),
          context.getElement<NumberProvider>(ProviderId.firstNumber),
          context.getElement<NumberProvider>(ProviderId.secondNumber),
        ],
        child: Dialog(
          child: Builder(builder: (innerContext) {
            final nameProvider = innerContext.get<NameProvider>();
            final numberProvider1 =
                innerContext.get<NumberProvider>(ProviderId.firstNumber);
            final numberProvider2 =
                innerContext.get<NumberProvider>(ProviderId.secondNumber);
            return SizedBox.square(
              dimension: 100,
              child: Center(
                child: Text('''
name: ${nameProvider.name}
number1: ${numberProvider1.number}
number2: ${numberProvider2.number}
'''),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = context.get<NameProvider>();
    final numberProvider = context.get<NumberProvider>(ProviderId.firstNumber);
    final numberProvider2 =
        context.get<NumberProvider>(ProviderId.secondNumber);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('name: ${nameProvider.name}'),
          const SizedBox(height: 8),
          Text('number1: ${numberProvider.number}'),
          const SizedBox(height: 8),
          Text('number2: ${numberProvider2.number}'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => openDialog(context),
            child: const Text('Open dialog'),
          ),
        ],
      ),
    );
  }
}