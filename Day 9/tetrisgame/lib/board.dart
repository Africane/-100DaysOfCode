import 'dart:async';
import 'dart:math';
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

  // current score
  int currentScore = 0;

  @override
  void initState() {
    super.initState();

    // start the game when the app starts
    startGame();
  }

  void startGame() {
      currentPiece.initializePiece();

      // frame refresh rate
      Duration frameRate = const Duration(milliseconds: 600);
      gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          // clear lines
          clearLines();

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
    if (row >= colLength || col < 0 || col >= rowLength) {
      return true;
    }

    // check if the new position is already occupied by a landed piece
    if (row >= 0 && gameBoard[row][col] != null) {
      return true;  // Collision detected with a landed piece
    }
  }

  // if no collisions are detected, return false
  return false;
}

  void checkLanding() {
  // if going down is occupied
  if (checkCollision(Direction.down)) {
    // mark position as occupied on the game board
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;
      if (row >= 0 && col >= 0) {
        gameBoard[row][col] = currentPiece.type;
      }
    }

    // once landed, create the new piece and reset its position
    createNewPiece();
  }
}

void createNewPiece() {
  // create a random object to generate random tetromino types
  Random rand = Random();

  // create a new piece with a random type
  Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
  currentPiece = Piece(type: randomType);

  // initialize the piece at the top of the board
  currentPiece.initializePiece();

  // Check if the new piece immediately collides (game over condition)
  if (checkCollision(Direction.down)) {
    // handle game over (e.g., stop the timer)
    print("Game Over");
  }
}

// move piece left button
void moveLeft() {
  // make sure the move is valid before we move there
  if (!checkCollision(Direction.left)) {
    setState(() {
      currentPiece.movingPiece(Direction.left);
    });
  }
}

// move piece right button
void moveRight() {
  // make sure the move is valid before we move there
  if (!checkCollision(Direction.right)) {
    setState(() {
      currentPiece.movingPiece(Direction.right);
    });
  }
}

// rotate piece button
void rotatePiece() {
  setState(() {
    currentPiece.rotatePiece();
  });
}

// clear complete lines
void clearLines() {
  // step 1: loop through each row of the game board from bottom to top
  for (int row = colLength - 1; row >= 0; row--) {
    // step 2: Initialize a variable to track if the row is full
    bool rowIsFull = true;

    // step 3: check if the row is full (all columns in the row are filled with pieces)
    for (int col = 0; col < rowLength; col++) {
      // if there's an empty column, set rowIsFull to false and break the loop
      if (gameBoard[row][col] == null) {
        rowIsFull = false;
        break;
      }
    }

    // step 4: if the row is full, clear the row and shift rows down
    if (rowIsFull) {
      // step 5: move all rows above the cleared row down by one position
      for (int r = row; r > 0; r--) {
        // copy the above row to the current row
        gameBoard[r] = List.from(gameBoard[r - 1]);

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        // step 7: Increase the score
        currentScore++;
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          // game grid
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength), 
              itemBuilder: (context, index) {
            
                // get row and column of each index
                int row = (index / rowLength).floor();
                int col = index % rowLength;
            
                // current piece
                if (currentPiece.position.contains(index)) {
                    return Pixel(
                    color: Colors.yellow,
                    child: index,
                  );
                }
                  
                  // landed pieces
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(color:  tetrominoColors[tetrominoType], child: '');
                  }
            
                  // blank pixel
                  else {
                  return Pixel(
                    color: Colors.grey[900],
                    child: index,
                );
                }
              },
            ),
          ),

          // Score count
          Text(
            'Score: $currentScore',
            style: const TextStyle(color: Colors.white),
          ),

          // Game controls
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // left button
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white, 
                  icon: const Icon(Icons.arrow_back_ios),
                ),

                // rotate button
                IconButton(
                  onPressed: rotatePiece, 
                  color: Colors.white,
                  icon: const Icon(Icons.rotate_right),
                ),
            
                // right button
                IconButton(
                  onPressed: moveRight, 
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),            
              ],
            ),
          )
        ],
      ),
    );
  }
}