import de.bezier.guido.*;
private static int NUM_ROWS = 5;
private static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

/*
to do:
adjust mine generation
winning and losing message
*/
void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);
  Interactive.make(this);
  buttons =  new MSButton[NUM_ROWS][NUM_COLS];
  for (int row = 0; row < NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++)
      buttons[row][col] = new MSButton(row, col);
  }
  while (mines.size() < 1)
    setMines();
}

public void setMines() {
  int r = (int)(Math.random()*NUM_ROWS);
  int c = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[r][c]))
    mines.add(buttons[r][c]);
}

public void draw() {
  background(0);
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon() {
  for (int i = 0; i < mines.size(); i++){
    if (!mines.get(i).isFlagged())
      return false;
  }
  return true;
}

public void displayLosingMessage() {
   textSize(128);
  fill(#AD262B);
  text("you did not lock in twin",200,200);
}

public void displayWinningMessage() {
  //for (int i = 0; i < mines.size(); i++){} turn mines green
  textSize(128);
  fill(#399DFF);
  text("you locked in twin",200,200);
}

public boolean isValid(int row, int col) {
  if (row < 0 || row > NUM_ROWS-1 || col < 0 || col > NUM_COLS-1)
    return false;
  return true;
}

public int countMines(int row, int col) {
  int numMines = 0;
  for (int i = row-1; i <= row+1; i++){
    for (int j = col-1; j <= col+1; j++){
      if (isValid(row, col) && !(i==row && j==col) && mines.contains(buttons[row][col]))
        numMines++;
      }
    }
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  private color myColor;
  public MSButton (int row, int col) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add(this); // register it with the manager
  }

  public void mousePressed() {
    clicked = true;
    if (mouseButton == RIGHT){
      clicked = false;
      flagged = !flagged;
    }
    else if (mines.contains(this))
      displayLosingMessage();
     else if (countMines(myRow, myCol) > 0)
       setLabel(countMines(myRow, myCol));
     else
       for (int i = myRow-1; i <= myRow+1; i++){
         for (int j = myCol-1; j <= myCol+1; j++){
           if (isValid(i,j) && !(myRow==i && myCol==j) && !buttons[i][j].clicked)
             buttons[i][j].mousePressed();
         }
       }
        
  }
  public void draw() {    
    if (flagged)
      fill(0);
    else if (clicked && mines.contains(this)) 
      fill(255, 0, 0);
    else if (clicked)
      fill(200);
    else 
      fill(100);
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged() {
    return flagged;
  }
}
