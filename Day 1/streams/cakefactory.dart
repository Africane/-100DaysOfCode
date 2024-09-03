// this code demos the use of streams in dart

// analogy used is => A customer goes to a Chocolate Cake Factory. Customer gives order to an order taker, who walks
// into the factory and gives the order to the Order Inspector. The order inspector then forwards the order to the 
// baker, who checks the order to ensure that the type of cake ordered can be made at this factory. The baker upon
// confirming the type order bakes the cake if it is of type 'chocolate' or sends an 'order error' if the cake type
// is not of chocolate.

import 'dart:async';

class Cake{}

class CakeOrder{
  String type;
  CakeOrder(this.type);
}

void main() {
  final controller = StreamController();  // creating a stream controller gives me access to a sink and a stream 
  final order = CakeOrder('chocolate'); // order delivered by the customer

  // the baker receives the order from the order taker, and checks whether the order type is permissible
  final baker = StreamTransformer.fromHandlers(
    handleData: (cakeType, sink) {
      if (cakeType == 'chocolate') {
        sink.add(Cake());
      } else {
        sink.addError('I can\'t bake that type of cake!');
      }
    },
  );

  controller.sink.add(order); // order given to the order taker from the customer
  controller.stream
    .map((order) => order.type)
    .transform(baker)
    .listen(
      (cake) => print('Here\'s your cake: $cake'),
      onError: (err) => print(err)
    ); 
}