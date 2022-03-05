import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 4;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  mines = new ArrayList<MSButton>();
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  for (int i = 0; i < NUM_MINES; i++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)   
      if (!buttons[r][c].isFlagged() && !buttons[r][c].isClicked())
        return false;
  return true;
}
public void displayLosingMessage()
{
  fill(255, 0, 0);
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");
  buttons[10][9].setLabel(" ");
  buttons[10][10].setLabel("L");
  buttons[10][11].setLabel("O");
  buttons[10][12].setLabel("S");
  buttons[10][13].setLabel("E");
}
public void displayWinningMessage()
{
  buttons[10][6].setLabel("Y");
  buttons[10][7].setLabel("O");
  buttons[10][8].setLabel("U");
  buttons[10][9].setLabel(" ");
  buttons[10][10].setLabel("W");
  buttons[10][11].setLabel("I");
  buttons[10][12].setLabel("N");
  buttons[10][13].setLabel("!");
}
public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
  {
    return true;
  } else
  {
    return false;
  }
}
public int countMines(int row, int col)
{
  int numBombs = 0;
  if (isValid(row-1, col) == true && mines.contains(buttons[row-1][col]))
  {
    numBombs++;
  }
  if (isValid(row+1, col) == true && mines.contains(buttons[row+1][col]))
  {
    numBombs++;
  }
  if (isValid(row, col-1) == true && mines.contains(buttons[row][col-1]))
  {
    numBombs++;
  }
  if (isValid(row, col+1) == true && mines.contains(buttons[row][col+1]))
  {
    numBombs++;
  }
  if (isValid(row-1, col+1) == true && mines.contains(buttons[row-1][col+1]))
  {
    numBombs++;
  }
  if (isValid(row-1, col-1) == true && mines.contains(buttons[row-1][col-1]))
  {
    numBombs++;
  }
  if (isValid(row+1, col+1) == true && mines.contains(buttons[row+1][col+1]))
  {
    numBombs++;
  }
  if (isValid(row+1, col-1) == true && mines.contains(buttons[row+1][col-1]))
  {
    numBombs++;
  }
  return numBombs;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public boolean isClicked() {
    return clicked;
  }
  public void mousePressed () 
  {
    clicked = true;
    if (keyPressed == true || mousePressed && (mouseButton == RIGHT))
    {
      if (flagged == false)
      {
        flagged = true;
      } else if (flagged == true)
      {
        clicked = false;
        flagged =  false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel("" + countMines(myRow, myCol));
    } else {
      if (isValid(myRow, myCol - 1)  && buttons[myRow][myCol-1].isClicked() == false)
        buttons[myRow][myCol-1].mousePressed();
      if (isValid(myRow, myCol + 1) && buttons[myRow][myCol+1].isClicked() == false)
        buttons[myRow][myCol+1].mousePressed();
      if (isValid(myRow - 1, myCol - 1) && buttons[myRow - 1][myCol-1].isClicked() == false)
        buttons[myRow - 1][myCol - 1].mousePressed();
      if (isValid(myRow - 1, myCol) && buttons[myRow - 1][myCol].isClicked() == false)
        buttons[myRow - 1][myCol].mousePressed();
      if (isValid(myRow - 1, myCol + 1) && buttons[myRow - 1][myCol+1].isClicked() == false)
        buttons[myRow - 1][myCol + 1].mousePressed();
      if (isValid(myRow + 1, myCol - 1) && buttons[myRow + 1][myCol - 1].isClicked() == false)
        buttons[myRow + 1][myCol - 1].mousePressed();
      if (isValid(myRow + 1, myCol) && buttons[myRow + 1][myCol].isClicked() == false)
        buttons[myRow + 1][myCol].mousePressed();
      if (isValid(myRow + 1, myCol + 1) && buttons[myRow + 1][myCol + 1].isClicked() == false)
        buttons[myRow + 1][myCol + 1].mousePressed();
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
