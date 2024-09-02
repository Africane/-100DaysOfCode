// this is a word guessing game that employs the use of streams to implement the game. The user
// has 4 chances to make a guess and find correct a word that has been hidden in the code.

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
