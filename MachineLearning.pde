abstract class Node {
  ArrayList<Node> nodeConnect = new ArrayList<>();
  ArrayList<Float> nodeWeight = new ArrayList<>();
  float threshold;
  float value;
  
  public abstract float calcWeight();
}

class startNode extends Node {

  public float calcWeight() {
    return value;
  }
}

class MidNode extends Node {
  float threshold;

  MidNode() {
    threshold = random(0.8f,1);
  }

  public float calcWeight() {
    float totalWeight = 0;
    for (int i = 0; i < nodeConnect.size(); i++) {
      totalWeight += nodeConnect.get(i).calcWeight() * nodeWeight.get(i);
    }
    
    return sigmoid(totalWeight - threshold);
  }

  public float sigmoid(float x) {
    //return x;
    return 1 / (1 + (float)Math.exp(-x));
  }
}


//======================================================

class NeuralNetwork implements Comparable{
  
  Node end_up    = new MidNode();
  Node end_right = new MidNode();
  Node end_down  = new MidNode();
  Node end_left  = new MidNode();
  Node end[] = {end_up,end_right,end_down,end_left};
  
  Node start_isFruitUp = new startNode();
  Node start_isFruitRight = new startNode();
  Node start_isFruitDown = new startNode();
  Node start_isFruitLeft = new startNode();
  
  Node start_snakeUp = new startNode();
  Node start_snakeRight = new startNode();
  Node start_fruitDown = new startNode();
  Node start_fruitLeft = new startNode();
  
  Node start_size = new startNode();
  Node start[] = {start_size,start_snakeUp,start_snakeRight,start_fruitDown,start_fruitLeft,start_isFruitUp,start_isFruitRight,start_isFruitDown,start_isFruitLeft};
  
  Game game;
  
  NeuralNetwork(){
    Node[] mid = addNode(16,end);
    //mid = addNode(16,mid);
    connectToStart(start,mid);
  }
  
  public Node[] addNode(int nNode, Node[] target){
    Node[] newNode = new Node[nNode];
    
    for(int i = 0; i < nNode; i++){
      newNode[i] = new MidNode();
      newNode[i].threshold = random(1);
      for(int j = 0; j < target.length; j++){
        target[j].nodeConnect.add(newNode[i]);
        target[j].nodeWeight.add(random(.4f));
      }
    }
    
    return newNode;
  }
  public void connectToStart(Node[] start, Node[] target){
    for(int i = 0; i < target.length; i++){
      for(int j = 0; j < start.length; j++){
        target[i].nodeConnect.add(start[j]);
        target[i].nodeWeight.add(random(.4f));
      }
    }
  }
  
  public void drw(){game.drw();}
  public void run(){
    start_isFruitUp.value = (game.snakeY > game.fruitY) ? 1 : 0;
    start_isFruitRight.value = (game.snakeX < game.fruitX) ? 1 : 0;
    start_isFruitDown.value = (game.snakeY < game.fruitY) ? 1 : 0;
    start_isFruitLeft.value = (game.snakeX > game.fruitX) ? 1 : 0;
    
    int x = game.snakeX;
    int y = game.snakeY;
    start_snakeUp.value = (y-1 == -1 || game.board[y-1][x] > 0) ? 1 :(game.board[y-1][x] == -1) ? -1 : 0;
    start_snakeRight.value = (x+1 == BOARD_X || game.board[y][x+1] > 0) ? 1 : (game.board[y][x+1] == -1) ? -1 : 0;
    start_fruitDown.value = (y+1 == BOARD_Y || game.board[y+1][x] > 0) ? 1 : (game.board[y+1][x] == -1) ? -1 : 0;
    start_fruitLeft.value = (x-1 == -1 || game.board[y][x-1] > 0) ? 1 : (game.board[y][x-1] == -1) ? -1 : 0;
    
    start_size.value = game.snakeSize;
    
    float up = end_up.calcWeight();
    float right = end_right.calcWeight();
    float down = end_down.calcWeight();
    float left = end_left.calcWeight();
    if(up > right && up > down && up > left)game.changeDirection(0);
    else if(right > down && right > left)game.changeDirection(1);
    else if(down > left)game.changeDirection(2);
    else game.changeDirection(3);
    
    game.run();
  }
  
  public void genVariant(NeuralNetwork ref){
    for(int i = 0; i < end.length; i++){
      genNodeVariant(end[i],ref.end[i]);
    }
  }
  public void genNodeVariant(Node me, Node ref){
    me.threshold = ref.threshold+random(-0.1f,0.1f);
    for(int i = 0; i < me.nodeConnect.size(); i++){
      genNodeVariant(me.nodeConnect.get(i),ref.nodeConnect.get(i));
      me.nodeWeight.set(i,ref.nodeWeight.get(i)+random(-0.1f,0.1f));
    }
  }
  
  public int compareTo(Object o){
    if(o instanceof NeuralNetwork) {
      NeuralNetwork neuro = (NeuralNetwork) o;
      return neuro.game.getPerformance() - game.getPerformance();
    }
    return 0;
  }
}
