import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tetrisgame/piece.dart';
import 'package:tetrisgame/pixel.dart';
import 'package:tetrisgame/values.dart';

/// Game Board
/// 
/// This is a 2x2 grid with null representing an empty state
/// A non empty state will have the color to represent the landed pieces

// create a game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  @override
  void initState() {
    super.initState();

    // start the game when the app starts
    startGame();
  }

  void startGame() {
      currentPiece.initializePiece();

      // frame refresh rate
      Duration frameRate = const Duration(microseconds: 800);
      gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          // check landing
          checkLanding();

          // move current piece down
          currentPiece.movingPiece(Direction.down);
        });
      }
    );
  }

  // check for collision in a future position
  // return true if there is a collision
  // return false if there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of each position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and column based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low, or too far to the left or right)
      if ( row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }

    // if no collisions are detected, return false
    return false;
  }

  void checkLanding() {
    // if going down is occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the game board
      for (int i = 0;i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, create the new piece
      createNewPiece();
    }
  }

  void createNewPiece() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        itemCount: rowLength * colLength,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rowLength), 
        itemBuilder: (context, index) {
          if (currentPiece.position.contains(index)) {
              return Pixel(
              color: Colors.yellow,
              child: index,
            );
          } else {
            return Pixel(
              color: Colors.grey[900],
              child: index,
          );
          }
        },
      ),
    );
  }
}