class Sudokusolver{

  late List<List<int>> sudokuGrid ;
  int invalidRow1 = -1;
  int invalidCol1 = -1;
  int invalidRow2 = -1;
  int invalidCol2 = -1;

  Sudokusolver(var sudokuGrid ){
    this.sudokuGrid = sudokuGrid;
  }

  bool isvalid(int row, int col, int ele ){

    for(int i =0 ; i < 9 ; i++){

      if(sudokuGrid[row][i] == ele) return false;
      if(sudokuGrid[i][col] == ele) return false;

      int BoxRow = 3*(row ~/3) + i ~/3;
      int BoxCol = 3*(col ~/3) + i%3;
      if(sudokuGrid[BoxRow][BoxCol] == ele) return false;

    }

    return true; // valid.
  }

  bool checkIfValidHelper(int row, int col, int ele ){

    for(int i =0 ; i < 9 ; i++){

        if(i != col && sudokuGrid[row][i] == ele){
          invalidRow1 = row;
          invalidCol1 = col;
          invalidRow2 = row;
          invalidCol2 = i;
          return false;
        }
        if(i != row && sudokuGrid[i][col] == ele){
          invalidRow1 = row;
          invalidCol1 = col;
          invalidRow2 = i;
          invalidCol2 = col;
          return false;
        }

        int BoxRow = 3*(row ~/3) + i ~/3;
        int BoxCol = 3*(col ~/3) + i%3;
        if( BoxRow != row && BoxCol != col && sudokuGrid[BoxRow][BoxCol] == ele){
          invalidRow1 = row;
          invalidCol1 = col;
          invalidRow2 = BoxRow;
          invalidCol2 = BoxCol;
          return false;
        }
    }
    return true; // valid.
  }

  // checks if the user has given valid sudoku as input or not.
  bool checkIfValid(){

    for(int i = 0 ; i < 9; i++ ){
      for(int j = 0 ; j < 9; j++){
        if( sudokuGrid[i][j] != 0){
            int ele = sudokuGrid[i][j];
            if(checkIfValidHelper(i, j, ele ) == false) return false;
        }
      }
    }

    return true; // valid
  }

  bool solve(int row, int col){
    if(row == 9) return true; // out of bound
    if(col == 9) return solve(row + 1, 0 ); // start from next row;
    if(sudokuGrid[row][col] !=  0) return solve(row , col + 1);

    for(int ele = 1 ; ele <= 9 ; ele++){

      if(isvalid(row, col, ele)){

      sudokuGrid[row][col] = ele;

      if(solve(row, col + 1)) return true;

      sudokuGrid[row][col] = 0;

      }
    }

    return false;
  }

  List<List<int>> solveSudoku(){

    if(checkIfValid() == true){
        // print("Valid input by user");
        solve(0, 0);
        // print("solved sudoku");
        return sudokuGrid;
    }
    else{
      // print("Invalid input by user");
      return sudokuGrid;
    }

  }

}