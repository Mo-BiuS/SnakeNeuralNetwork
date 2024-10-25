final int SIZE_X = 1024;
final int SIZE_Y = 1024;

boolean bestOf = false;
boolean fade = false;
boolean show = true;

NeuralBox neuralBox;
Game game = new Game();

public void setup(){
  size(2048,1024+192);
  noStroke();
  textFont(createFont("FSEX300.ttf",24));
  textSize(24);
  textAlign(LEFT,CENTER);
  
  neuralBox = new NeuralBox();
  
  game.debug = true;
}

public void draw(){
  drawMap();
  neuralBox.run();
  //game.run();
  //game.drw();
}

public void keyPressed() {
  switch(keyCode){
    case 32://espace
      show ^= true;
      break;
    case 37://←
      game.changeDirection(3);
      break;
    case 38://↑
      game.changeDirection(0);
      break;
    case 39://→
      game.changeDirection(1);
      break;
    case 40: //↓
      game.changeDirection(2);
      break;
    case 66: //b
      bestOf ^= true;
      break;
    case 70: //f
      fade ^= true;
      break;
    default:
      println(keyCode);
  }
}
