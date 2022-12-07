import 'dart:developer';

import 'package:flutter/material.dart';
import 'sudoku_solver.dart';

class SudokuContent extends StatefulWidget {
  const SudokuContent({Key? key}) : super(key: key);

  @override
  State<SudokuContent> createState() => _SudokuContentState();

}

class _SudokuContentState extends State<SudokuContent> {

  var sudokuGrid = List.generate(9, (i) => List.filled(9, 0, growable: false), growable: false);

  // keep the track of the numbers input by the user. (for display purpose).
  var UserInputNumbers = List.generate(9, (i) => List.filled(9, false, growable: false), growable: false);

  // coordinates of the column selected.
  var rowSelected = -1;
  var colSelected = -1;

  // indexes of the number that are repeated.
  int invalidRow1 = -1;
  int invalidCol1 = -1;
  int invalidRow2 = -1;
  int invalidCol2 = -1;

  void solve(){
    Sudokusolver obj = Sudokusolver(sudokuGrid);
    setState(() {
      sudokuGrid = obj.solveSudoku();
      invalidRow1 = obj.invalidRow1;
      invalidRow2 = obj.invalidRow2;
      invalidCol1 = obj.invalidCol1;
      invalidCol2 = obj.invalidCol2;
    });

  }

  void resetSudoku(){
    setState(() {
      sudokuGrid = List.generate(9, (i) => List.filled(9, 0, growable: false), growable: false);
      UserInputNumbers = List.generate(9, (i) => List.filled(9, false, growable: false), growable: false);
      invalidRow1 = -1;
      invalidRow2 = -1;
      invalidCol1 = -1;
      invalidCol2 = -1;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku solver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(

          children: [
            SizedBox( height: 20,),

            // !-----------------------Sudoku-----------------------!
            SizedBox(
                width: 400,
                height: 400,
                child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                ), itemBuilder: (context,index){
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                            rowSelected = index ~/9;
                            colSelected = index%9;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: (invalidRow1 ==  index ~/9 && invalidCol1 == index%9) || (invalidRow2 ==  index ~/9 && invalidCol2 == index%9)
                                ? Colors.red[200] // show red colour for invalid boxes.
                                : Colors.white,

                            border: rowSelected ==  index ~/9 && colSelected == index%9
                                ? Border.all(color: Colors.red, width: 2) // show red border for selected box.
                                :  (index %9 == 2 || index%9 == 5)
                                   ? Border( right: const BorderSide( width: 1.5, color: Colors.blueAccent), bottom: BorderSide( width: (index ~/9 == 2 || index ~/9 == 5)  ? 1.5 : 0.5 , color: Colors.blueAccent),
                                              left : const BorderSide( width: 0.5, color: Colors.blueAccent), top: const BorderSide( width: 0.5, color: Colors.blueAccent))
                                   : (index ~/9 == 2 || index ~/9 == 5)
                                      ?  const Border( right: BorderSide( width: 0.5, color: Colors.blueAccent), bottom: BorderSide( width: 1.5, color: Colors.blueAccent),
                                                left : BorderSide( width: 0.5, color: Colors.blueAccent), top: BorderSide( width: 0.5, color: Colors.blueAccent))
                                      : Border.all(width: 0.5, color: Colors.blueAccent,),

                        ),
                        alignment: Alignment.center,

                        child: Text(
                            // Display number only if it is not zero.
                            '${sudokuGrid[ index ~/9 ][index%9] != 0 ? sudokuGrid[ index ~/9 ][index%9] : ' ' }',
                            style: TextStyle(
                              // show user input numbers in black and result number in blue.
                              // color: UserInputNumbers[ index ~/9 ][index%9]  ? Colors.black : Colors.blueAccent,
                              color: Colors.blueAccent,
                              fontWeight: UserInputNumbers[ index ~/9 ][index%9]  ? FontWeight.w900 : FontWeight.normal,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,

                        ),
                      )
                  );
                }, itemCount: 81)
            ),

            // !------------------Number Butttons-------------------!
            SizedBox(
              height: 200,
              width: 400,

              child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10

              ), itemBuilder: (context,index){

                return index + 1 == 10 // if index is 10 , then show delete button else show normal number button.
                  ? ElevatedButton.icon( // !---------Delete number button----------!
                    onPressed: () {
                      setState(() {
                        sudokuGrid[rowSelected][colSelected] = 0;
                        UserInputNumbers[rowSelected][colSelected] = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15),
                    ),
                    icon: Icon(Icons.delete),
                    label: Text(''),
                  )

                 : ElevatedButton( // !---------Normal number button----------!
                  onPressed: () {
                    setState(() {
                      sudokuGrid[rowSelected][colSelected] = index + 1;
                      UserInputNumbers[rowSelected][colSelected] = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                  ),
                  child: Text('${index + 1}') ,
                );
              }, itemCount: 10),
            ),

            // !----------------------Solve button-------------------!
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      solve();
                    },

                    child: Text('Solve'),

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                    ),
                  ),
                ),

                // !------------------------Reset button----------------!
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      resetSudoku();
                    },

                    child: Text('Reset'),

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                    ),
                  ),
                )
              ],

            ),

          ],
        ),
      ),
    );;
  }
}
