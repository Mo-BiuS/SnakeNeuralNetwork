final int BOARD_X = 16;
final int BOARD_Y = 16;

class Game {
  int nAction = 0;
  int[][] board;
  boolean[][] heatMap;
  
  boolean debug = false;
  
  int fruitX;
  int fruitY;
  
  int snakeX = BOARD_X/2;
  int snakeY = BOARD_Y/2;
  int snakeSize = 3;
  int snakeColor;
  int snakeDirection = 2;
  int nextDirection = snakeDirection;
  int goodPoint = 0;
  
  int lossType = 0;
  final int LOST_WALL = 3;
  final int LOST_TAIL = 1;
  final int LOST_LOOP = 2;
  
  Game(){
    this.board = new int[BOARD_X][BOARD_Y];
    snakeColor = color(random(255),random(255),random(255));
    lossType = 0;
    
    genFruit();
  }
  
  public void drw(){
    int sizeX = SIZE_X/BOARD_X;
    int sizeY = SIZE_Y/BOARD_Y;
    for(int x = 0; x < BOARD_X; x++){
      for(int y = 0; y < BOARD_Y; y++){
        switch(board[x][y]){
          case -1:
            pushStyle();
            stroke(red(snakeColor), green(snakeColor), blue(snakeColor));
            strokeWeight(8);
            fill(0,0,0,0);
            rect(x*sizeX+4,y*sizeY+4,sizeX-8,sizeY-8);
            popStyle();
            break;
          case 0:
            break;
          default:
            fill(red(snakeColor), green(snakeColor), blue(snakeColor));
            rect(x*sizeX,y*sizeY,sizeX,sizeY);
            break;
        }
      }
    }
  }
  
  public void run(){
    if(lossType == 0){
      nAction += 1;
      snakeDirection = nextDirection;
      heatMap[snakeX][snakeY] = true;
      switch(snakeDirection){
        case 0:
          snakeY -= 1;
          if(fruitY < snakeY)goodPoint++;
          else goodPoint-=2;
          break;
        case 1:
          snakeX += 1;
          if(fruitX > snakeX)goodPoint++;
          else goodPoint-=2;
          break;
        case 2:
          snakeY += 1;
          if(fruitY > snakeY)goodPoint++;
          else goodPoint-=2;
          break;
        case 3:
          snakeX -= 1;
          if(fruitX < snakeX)goodPoint++;
          else goodPoint-=2;
          break;
      }
      if(snakeX >= 0 && snakeY >= 0 && snakeX < BOARD_X && snakeY < BOARD_Y){
        if(board[snakeX][snakeY] == -1){
          snakeSize += 1;
          genFruit();
        }
        else if(!debug && heatMap[snakeX][snakeY]){
           lossType = LOST_LOOP;
        }
        if(board[snakeX][snakeY] <= 0){
          board[snakeX][snakeY] = snakeSize;
          for(int x = 0; x < BOARD_X; x++){
            for(int y = 0; y < BOARD_Y; y++){
              if(board[x][y] > 0)board[x][y]-=1;
            }
          }
        }
        else lossType = LOST_TAIL;
      }
      else lossType = LOST_WALL;
    }
  }
  
  public void changeDirection(int nDirection){
    int v = nDirection - 2;
    if(v < 0)v+=4;
    if(v != snakeDirection) nextDirection = nDirection;
  }
  
  public void genFruit(){
    this.heatMap = new boolean[BOARD_X][BOARD_Y];
    
    board[fruitX][fruitY] = 0;
    
    int posX = PApplet.parseInt(random(BOARD_X));
    int posY = PApplet.parseInt(random(BOARD_Y));
    
    boolean desiredPos = false;
    while(!desiredPos){
      if(board[posX][posY] == 0){
        board[posX][posY] = -1;
        desiredPos = true;
        fruitX = posX;
        fruitY = posY;
      }
      else{
        posX = PApplet.parseInt(random(BOARD_X));
        posY = PApplet.parseInt(random(BOARD_Y));
      }
    }
  }
  
  public int getPerformance(){
    return nAction -lossType*500000+goodPoint*5;
  }
}
