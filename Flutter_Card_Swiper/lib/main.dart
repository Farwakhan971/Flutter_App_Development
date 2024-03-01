import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'Models/ItemsModel.dart';
import 'Views/ItemCard.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    ),
  );
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Example> {
  late CardSwiperController controller = CardSwiperController();
  late final List<ItemsModel> candidates;
  late final List<Widget> cards;

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
    candidates = [
      ItemsModel(
        name: 'Margherita Pizza',
        Price: 120,
        description:
        'Indulge in the classic flavors of Italy with our Margherita pizza. This traditional favorite features a thin, crispy crust topped with tangy tomato sauce, creamy mozzarella cheese, and fresh basil leaves',
        image: AssetImage(
            'Assets/Pizza.jpg'),
      ),
      ItemsModel(
        name: 'Classic Cheeseburger',
        Price: 99,
        description:
        'A juicy beef patty topped with melted cheese, lettuce, tomato, onion, pickles, and special sauce on a toasted bun.',
        image: AssetImage(
            'Assets/Burger.jpg'),
      ),
      ItemsModel(
        name: 'Delicious Cake',
        Price: 80,
        description:
        'Indulge your sweet tooth with our delicious cake. Moist layers of cake filled with creamy frosting and topped with decadent chocolate ganache.',
        image: AssetImage(
            'Assets/cake.jpg'),
      ),
    ];

    cards = candidates.map((candidate) =>
        ItemCard(
          name: candidate.name,
          Price: candidate.Price,
          description: candidate.description,
          image: candidate.image,
        )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CardSwiper(
                  controller: controller,
                  cardsCount: cards.length,
                  onSwipe: _onSwipe,
                  onUndo: _onUndo,
                  numberOfCardsDisplayed: 3,
                  backCardOffset: const Offset(40, 40),
                  cardBuilder: (
                      context,
                      index,
                      horizontalThresholdPercentage,
                      verticalThresholdPercentage,
                      ) {
                    return cards[index];
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: controller.undo,
                  child: const Icon(Icons.rotate_left),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    debugPrint(
        'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top');
    return true;
  }

  bool _onUndo(
      int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    debugPrint('The card $currentIndex was undo from the ${direction.name}');
    return true;
  }
}
