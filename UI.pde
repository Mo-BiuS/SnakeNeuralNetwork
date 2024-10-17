int UI_NumberALive;
int UI_BestScore = 0;
int UI_BestALiveScore = 0;
float UI_BestPerf;

public void drawStats(){
  getStats();
  fill(0);
  rect(0,1024,1024,64);
  fill(255);
  text("Alive : "+UI_NumberALive,20,1024+32);
  fill(255);
  text("Best perf : "+UI_BestPerf,180,1024+32);
  fill(255);
  text("Number of step : "+neuralBox.totalNumberOfStep,400,1024+32);
  fill(255);
  text("Best score : "+UI_BestScore,640,1024+16);
  fill(255);
  text("Best alive score : "+UI_BestALiveScore,640,1024+48);
  fill(255);
  text("Generation : "+neuralBox.generation,840,1024+32);
}

public void getStats(){
  UI_NumberALive = 0;
  UI_BestALiveScore = 0;
  boolean bestScoreInit = false;
  
  for(int i = 0; i < neuralBox.N_SIMULATION; i++){
    if(neuralBox.nn[i].game.lossType == 0){
      UI_NumberALive++;
      if(!bestScoreInit){
        UI_BestPerf = neuralBox.nn[i].game.getPerformance();
        bestScoreInit = true;
      }
      else if(neuralBox.nn[i].game.getPerformance() > UI_BestScore)UI_BestPerf = neuralBox.nn[i].game.getPerformance();
      if(neuralBox.nn[i].game.snakeSize-3 > UI_BestALiveScore)UI_BestALiveScore = neuralBox.nn[i].game.snakeSize-3;
    }
    if(neuralBox.nn[i].game.snakeSize-3 > UI_BestScore)UI_BestScore = neuralBox.nn[i].game.snakeSize-3;
  }
}

public void drawMap(){
  if(fade) {
    fill(255, 5);
    rect(0, 0, SIZE_X, SIZE_Y);
  } else {
    background(255);
  }
  drawStats();
}
