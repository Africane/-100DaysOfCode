import 'dart:async';
import 'dart:html';

void main() {
  final InputElement? input = querySelector('input') as InputElement?;
  final DivElement? div = querySelector('div') as DivElement?;

  final validator = StreamTransformer<String, String>.fromHandlers(
    handleData: (inputValue, sink) {
      if (inputValue.contains('@')) {
        sink.add(inputValue);
      } else {
        sink.addError('Enter a valid email!');
      }
    },
  );

  if (input != null && div != null) {
    input.onInput
      .map((event) => (event.target as InputElement).value)
      .transform(validator)
      .listen(
        (inputValue) {
          div.innerHtml = ''; // Clear any error message
          print('That email looks valid!');
        },
        onError: (err) {
          div.innerHtml = err; // Show the error message
        },
      );
  }
}
