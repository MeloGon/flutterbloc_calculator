import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorState());
  // Stream<String> retornaString() async* {
  //   yield 'Hola Mundo';
  // }

  @override
  Stream<CalculatorState> mapEventToState(
    CalculatorEvent event,
  ) async* {
    if (event is ResetAC) {
      // yield* no emitas el stream, emite el valor que ese stream emite
      yield* this._resetAc();
    } else if (event is AddNumber) {
      yield state.copyWith(
        mathResult: (state.mathResult == '0')
            ? event.number
            : state.mathResult + event.number,
      );
    } else if (event is ChangeNegativePositive) {
      yield state.copyWith(
          mathResult: state.mathResult.contains('-')
              ? state.mathResult.replaceFirst('-', '')
              : '-' + state.mathResult);
    } else if (event is DeleteLastEntry) {
      yield state.copyWith(
          mathResult: state.mathResult.length > 1
              ? state.mathResult.substring(0, state.mathResult.length - 1)
              : '0');
    } else if (event is OperationEntry) {
      yield state.copyWith(
          operation: event.operation,
          firstNumber: state.mathResult,
          mathResult: '0',
          secondNumber: '0');
    } else if (event is CalculateResult) {
      yield* this._calcularResultado();
    }
  }

  Stream<CalculatorState> _resetAc() async* {
    yield CalculatorState(
        firstNumber: '0',
        mathResult: '0',
        secondNumber: '0',
        operation: 'none');
  }

  Stream<CalculatorState> _calcularResultado() async* {
    final double num1 = double.parse(state.firstNumber);
    final double num2 = double.parse(state.mathResult);

    switch (state.operation) {
      case '+':
        yield state.copyWith(
            mathResult: '${num1 + num2}', secondNumber: state.mathResult);
        break;
      default:
        yield state;
    }
  }
}
