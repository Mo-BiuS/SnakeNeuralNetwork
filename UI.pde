int UI_NumberALive;

int UI_BestScore = 0;
int UI_BestGenScore = 0;
int UI_BestALiveScore = 0;
float UI_MoyenneScore = 0;
float UI_MoyenneScoreMinus1 = 0;

int UI_BestPerf;
int UI_BestGenPerf;
int UI_BestAlivePerf;
float UI_MoyennePerf;
float UI_MoyennePerfMinus1 = 0;

int UI_Eg0;
int UI_Inf5;
int UI_Inf10;
int UI_Inf20;
int UI_Inf40;
int UI_Sup40;

final int GEN_SCORE_TRACE_MAX = 10;
ArrayList<Integer>[] lastGenScore = new ArrayList[GEN_SCORE_TRACE_MAX];

public void drawStats(){
  getStats();
  fill(0);
  rect(0,1024,1024,192);
  rect(1024,0,1024,1024+192);
  
  fill(255,0,0);text("Generation     : "+neuralBox.generation,20,1024+16);fill(255);
  text("Number of step : "+neuralBox.totalNumberOfStep,20,1024+48);
  text("Alive : "+UI_NumberALive,20,1024+80);
  text("Total : "+neuralBox.N_SIMULATION,20,1024+112);
  
  text("Best perf       : "+UI_BestPerf,320,1024+16);
  text("Best gen perf   : "+UI_BestGenPerf,320,1024+48);
  text("Best alive perf : "+UI_BestAlivePerf,320,1024+80);
  text("Moyenne perf    : "+UI_MoyennePerf,320,1024+112);
  text("Moyenne perf-1  : "+UI_MoyennePerfMinus1,320,1024+144);
  
  
  fill(255,0,0);text("Best score       : "+UI_BestScore,680,1024+16);fill(255);
  text("Best gen score   : "+UI_BestGenScore,680,1024+48);
  text("Best alive score : "+UI_BestALiveScore,680,1024+80);
  text("Moyenne score    : "+UI_MoyenneScore,680,1024+112);
  text("Moyenne score-1  : "+UI_MoyenneScoreMinus1,680,1024+144);
  
  text("Score = 0   : "+UI_Eg0,1024+8,1024+16);
  text("Score 1-5   : "+UI_Inf5,1024+8,1024+48);
  text("Score 5-10  : "+UI_Inf10,1024+8,1024+80);
  text("Score 10-20 : "+UI_Inf20,1024+8,1024+112);
  text("Score 20-40 : "+UI_Inf40,1024+8,1024+144);
  text("Score > 40  : "+UI_Sup40,1024+8,1024+176);
  
  lastGenScore[0] = neuralBox.getCurrentScoreArrayList();
  drawGraph();
}

public void endOfGen(){
  for(int i = GEN_SCORE_TRACE_MAX-1; i > 0; i--)lastGenScore[i] = lastGenScore[i-1];
  lastGenScore[0] = null;
  
  UI_MoyenneScoreMinus1 = UI_MoyenneScore;
  UI_MoyennePerfMinus1 = UI_MoyennePerf;
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
    
    UI_MoyennePerf += neuralBox.nn[i].game.getPerformanceWithoutMalus();
    UI_MoyenneScore += score;
    
    
    if(score == 0)UI_Eg0++;
    else if(score <= 5)UI_Inf5++;
    else if(score <= 10)UI_Inf10++;
    else if(score <= 20)UI_Inf20++;
    else if(score <= 40)UI_Inf40++;
    else UI_Sup40++;
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

final int graphPosX = 1024+64+32;
final int graphPosY = 64;
final int graphSizeX = 1024-128;
final int graphSizeY = 1024-128;

public void drawGraph(){
  pushStyle();
  
  strokeWeight(2);
  stroke(255);
  line(graphPosX,graphPosY+graphSizeY,graphPosX+graphSizeX,graphPosY+graphSizeY);
  line(graphPosX,graphPosY+graphSizeY,graphPosX,graphPosY);
  
  int graphRangeX = getGraphRangeX();
  int graphRangeY = getGraphRangeY();
  //x
  textAlign(CENTER,CENTER);
  text(0,graphPosX, graphPosY+graphSizeY+16);
  text(graphRangeX,graphPosX+graphSizeX, graphPosY+graphSizeY+16);
  //y
  textAlign(RIGHT,CENTER);
  text(0,graphPosX-16, graphPosY+graphSizeY);
  text(graphRangeY,graphPosX-16, graphPosY);
  
  //points
  for(int j = GEN_SCORE_TRACE_MAX-1; j >= 0; j--){
    if(lastGenScore[j] != null){
      if(j == 0) stroke(255,0,0);
      else stroke(255-j*20);
      for(int i = 0; i < lastGenScore[j].size()-1;i++){
        line(graphPosX+i*(graphSizeX/graphRangeX),
        graphPosY+graphSizeY-float(lastGenScore[j].get(i))/graphRangeY*graphSizeY,
        graphPosX+(i+1)*(graphSizeX/graphRangeX),
        graphPosY+graphSizeY-float(lastGenScore[j].get(i+1))/graphRangeY*graphSizeY);
      }
    }
  }
  popStyle();
}
public int getGraphRangeY(){
  /*int rep = 0;
  for(int i = 0; i < GEN_SCORE_TRACE_MAX; i++){
    if(lastGenScore[i] != null){
      for(int j = 0; j < lastGenScore[i].size(); j++){
        if(rep < lastGenScore[i].get(j))rep = lastGenScore[i].get(j);
      }
    }
  }
  return rep;*/
  return neuralBox.N_SIMULATION;
}
public int getGraphRangeX(){
  int rep = 0;
  for(int i = 0; i < GEN_SCORE_TRACE_MAX; i++){
    if(lastGenScore[i] != null){
      if(rep < lastGenScore[i].size())rep = lastGenScore[i].size();
    }
  }
  return rep-1;
  
}
