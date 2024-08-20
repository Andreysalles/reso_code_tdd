import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../bloc/number_trivia_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_controls.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (context) => getIt.get<NumberTriviaBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin:const  EdgeInsets.only(bottom: 10),
                  child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const Center(
                          child: MessageDisplay(
                            message: 'Start searching!',
                          ),
                        );
                      } else if (state is Loading) {
                        return const Center(
                          child: LoadingWidget(),
                        );
                      } else if (state is Loaded) {
                        return TriviaDisplay(numberTrivia: state.trivia);
                      } else if (state is Error) {
                        return Center(
                          child: MessageDisplay(
                            message: state.message,
                          ),
                        );
                      } else {
                        return const Center(
                          child: MessageDisplay(
                            message: 'Unknown state',
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const TriviaControls(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
