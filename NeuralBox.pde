
class NeuralBox{
  final int N_SIMULATION = 2048*2;
  final int N_SAMPLE = 128;
  final int KEEP_N_BEST = 16;
  int generation = 0;
  int totalNumberOfStep = 0;
  
  NeuralNetwork[] nn = new NeuralNetwork[N_SIMULATION];

  NeuralBox(){
    for(int i = 0; i < N_SIMULATION; i++){
      nn[i] = new NeuralNetwork();
      nn[i].game = new Game();
    }
  }
  
  public void run(){
    totalNumberOfStep++;
    
    boolean gameEnd = true;
    for(int i = 0; i < N_SIMULATION; i++){
      
      if(nn[i].game.lossType == 0){
        nn[i].run();
        gameEnd = false;
        if(show && (!bestOf || i < KEEP_N_BEST)) nn[i].drw();
      }
    }
    
    if(gameEnd){
      generation++;
      totalNumberOfStep = 0;
      genNewGenFromWinners(getWinners());
    }
  }
  
  public void genNewGenFromWinners(ArrayList<NeuralNetwork> winners){
    int j = 0;
    for(int i = 0; i < N_SIMULATION; i++){
      if(i < KEEP_N_BEST)nn[i] = winners.get(i);
      else{
        nn[i].genVariant(winners.get(j));
        nn[i].game = new Game();
        j++;
        if(j >= winners.size()) j = 0;
      }
    }
  }

  
  public ArrayList<NeuralNetwork> getWinners(){
    ArrayList<NeuralNetwork> winners = new ArrayList<>();
    
    for(int i = 0; i < N_SIMULATION; i++){
      winners.add(nn[i]);
      if(winners.size() > N_SAMPLE){
        winners.sort(null);
        winners.remove(winners.size()-1);
      }
    }
    
    return winners;
  }
  
}
