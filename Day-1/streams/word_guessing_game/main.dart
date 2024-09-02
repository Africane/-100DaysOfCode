import 'dart:html';

void main() {
  final Element? button = querySelector('button');
  final InputElement? input = querySelector('input') as InputElement?;

  if (button != null && input != null) {
    Stream<Event> buttonClickStream = button.onClick;

    buttonClickStream
      .take(4)
      .where((event) => input.value == 'banana')
      .listen(
        (event) => print('You got it!'),
        onDone: () => print('Nope, bad guesses!')
      );
  }
}
