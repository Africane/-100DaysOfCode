// In this dart game, the objective is to click the button at least once every second. You lose
// if you are slow. This is also implemented with the use of streams.

import 'dart:html';

void main() {
  final Element? button = querySelector('button');

  button!.onClick
    .timeout(
      Duration(seconds: 1),
      onTimeout: (sink) => sink.addError('Too Slow!')
    )
    .listen(
      (event) {},
      onError: (err) => print(err)
    );
}