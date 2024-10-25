int UI_NumberALive;

int UI_BestScore = 0;
int UI_BestGenScore = 0;
int UI_BestALiveScore = 0;
float UI_MoyenneScore = 0;

int UI_BestPerf;
int UI_BestGenPerf;
int UI_BestAlivePerf;
float UI_MoyennePerf;

int UI_Eg0;
int UI_Inf5;
int UI_Inf10;
int UI_Inf20;
int UI_Inf40;
int UI_Sup40;


public void drawStats(){
  getStats();
  fill(0);
  rect(0,1024,1024,128);
  rect(1024,0,256,1024+128);
  fill(255);
  
  text("Generation     : "+neuralBox.generation,20,1024+16);
  text("Number of step : "+neuralBox.totalNumberOfStep,20,1024+48);
  text("Alive : "+UI_NumberALive,20,1024+80);
  text("Total : "+neuralBox.N_SIMULATION,20,1024+112);
  
  text("Best perf       : "+UI_BestPerf,320,1024+16);
  text("Best gen perf   : "+UI_BestGenPerf,320,1024+48);
  text("Best alive perf : "+UI_BestAlivePerf,320,1024+80);
  text("Moyenne perf    : "+UI_MoyennePerf,320,1024+112);
  
  
  text("Best score       : "+UI_BestScore,680,1024+16);
  text("Best gen score   : "+UI_BestGenScore,680,1024+48);
  text("Best alive score : "+UI_BestALiveScore,680,1024+80);
  text("Moyenne score    : "+UI_MoyenneScore,680,1024+112);
  
  text("Score = 0   : "+UI_Eg0,1024+8,16);
  text("Score 1-5   : "+UI_Inf5,1024+8,48);
  text("Score 5-10  : "+UI_Inf10,1024+8,80);
  text("Score 10-20 : "+UI_Inf20,1024+8,112);
  text("Score 20-40 : "+UI_Inf40,1024+8,144);
  text("Score > 40  : "+UI_Sup40,1024+8,176);
}

public void getStats(){
  UI_NumberALive = 0;
  
  UI_BestGenScore = 0;
  UI_BestALiveScore = 0;
  
  UI_BestGenPerf = 0;
  UI_BestAlivePerf = 0;
  
  UI_MoyennePerf = 0;
  UI_MoyenneScore = 0;
  
  UI_Eg0=0;
  UI_Inf5=0;
  UI_Inf10=0;
  UI_Inf20=0;
  UI_Inf40=0;
  UI_Sup40=0;
    
  
  for(int i = 0; i < neuralBox.N_SIMULATION; i++){
    var score = neuralBox.nn[i].game.snakeSize-3 ;
    if(neuralBox.nn[i].game.lossType == 0){
      UI_NumberALive++;

      if(neuralBox.nn[i].game.getPerformance() > UI_BestScore)UI_BestAlivePerf = neuralBox.nn[i].game.getPerformance();
      if(score > UI_BestALiveScore)UI_BestALiveScore = score;
    }
    if(score> UI_BestGenScore)UI_BestGenScore = score;
    if(score > UI_BestScore)UI_BestScore = score;
    if(neuralBox.nn[i].game.getPerformanceWithoutMalus() > UI_BestGenPerf)UI_BestGenPerf = neuralBox.nn[i].game.getPerformanceWithoutMalus();
    if(neuralBox.nn[i].game.getPerformance() > UI_BestPerf)UI_BestPerf = neuralBox.nn[i].game.getPerformance();
    
    if(score == 0)UI_Eg0++;
    else if(score <= 5)UI_Inf5++;
    else if(score <= 10)UI_Inf10++;
    else if(score <= 20)UI_Inf20++;
    else if(score <= 40)UI_Inf40++;
    else UI_Sup40++;
    
    UI_MoyennePerf += neuralBox.nn[i].game.getPerformanceWithoutMalus();
    UI_MoyenneScore += score;
  }
  UI_MoyennePerf = float(int((UI_MoyennePerf/neuralBox.N_SIMULATION)*100))/100;
  UI_MoyenneScore = float(int((UI_MoyenneScore/neuralBox.N_SIMULATION)*100))/100;
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
