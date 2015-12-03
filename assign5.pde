PImage bg1;
PImage bg2;
PImage hp;
PImage fighter;
PImage enemy;
PImage treasure;
PImage start1;
PImage start2;
PImage end1;
PImage end2;
PImage shooting;
int width=640;
int height=480;
int bg,t;
float enemy1,enemy2;
int tr1,tr2;
float blood;
int fx,fy;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

float speed =5;

final int GAME_START = 1;
final int GAME_RUN = 2;
final int GAME_LOSE = 3;
int gameState;

final int array_1 = 1;
final int array_2 = 2;
final int array_3 = 3;
int enemyState;

int enemyTeam1Y = 300;
int enemyTeam2Posy = 300;
int enemyTeam3Posy = 270;
int posTeam1X = -480;
int posTeam2X = -480;
int posTeam3X = -480;
boolean enemyTeam1 = true;
boolean enemyTeam2 = false;
boolean enemyTeam3 = false;
boolean[] deadOrNotT1 = {false,false,false,false,false};
boolean[] deadOrNotT2 = {false,false,false,false,false};
boolean[] deadOrNotT3 = {false,false,false,false,false,false,false,false};
boolean[] shootOrNotT1 = {false,false,false,false,false};

PImage[] flames = new PImage[5];
int flameCounter = 0;
int picIndex = 0;
int fireX = -800;//flame
float fireY = -800;//flame
int timeE1 = 0;
int timeE2 = 0;
int timeE3 = 0;
int shootX = -200;
int shootY = -200;

int [] bX = {-100,-120,-140,-160,-180};
float [] bY = {-100,-100,-100,-100,100};
boolean canShoot = true;
int bx = -800;
int by = -800;
boolean shootBullet = true;

void setup () 
{
  size(640,480) ;  // must use this size.
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  hp = loadImage("img/hp.png");
  fighter = loadImage("img/fighter.png");
  enemy = loadImage("img/enemy.png");
  treasure = loadImage("img/treasure.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  shooting = loadImage("img/shoot.png");
  for(int i=1;i<6;i++){
   flames[i-1]=loadImage("img/flame"+i+".png"); 
  }
  
  //hp
  blood=40;
  
  //enemy
  enemy2=floor(random(60,440));
  
  //treasure
  tr1=floor(random(100,500));
  tr2=floor(random(60,400));
  
  //fighter
  fx=580;
  fy=240;
  
  gameState = GAME_START;
  enemyState= array_1;
  
}

void draw () 
{
  switch(gameState){
    case GAME_START:
    
      image(start1,0,0);
      if(mouseX>200 && mouseX<450){
        if(mouseY>380 && mouseY<420){
          if(mousePressed){
          gameState=2;
      }else{
        image(start2,0,0);
          }
        }
      }
      break;
    
    case GAME_RUN:
    
      //background
      image(bg2,bg,0);
      image(bg1,bg-640,0);
      image(bg2,bg-1280,0);
      bg++;
      bg%=1280;
    
      
      
      /*if(fy < enemy2){
      enemy2 = enemy2 - 3;
      }
      
      if(fy > enemy2){
      enemy2 = enemy2 + 3;
      }
      
      if(fx<=enemy1+50 && fx>=enemy1-50 &&
         fy<=enemy2+50 && fy>=enemy2-50){ //crush
          blood -= 40;
          enemy1 = 0;
          enemy2 = floor(random(60,440));
          if(blood <= 0){
          gameState = 3;
          }
        
      }*/
  
      //hp
      fill(#FF0000);
      rect(20,15,blood,15);
      image(hp,10,10);
  
      //fighter
      image(fighter,fx,fy);
      
  
      //treasure
      image(treasure,tr1,tr2);
      
      if(fx<=tr1+50 && fx>=tr1-50
      && fy<=tr2+50 && fy>=tr2-50){  //get
        blood += 20;
        if(blood>=200){
          blood=200;
        }
        tr1=floor(random(100,500));
        tr2=floor(random(60,400));
      }
      
      //translate(t,0);
      //t+=5;
      
      
      if(enemyTeam1 == true)
    {
        int[] enemyTeam1Xs = {0,1,2,3,4};
        int unitX1 = 70;
        
        for (int i = 0; i < 5; i++)
        {        
            int xPos = enemyTeam1Xs[i]*unitX1+posTeam1X;
            int yPos = enemyTeam1Y;
    
            if(deadOrNotT1[i] == false)
            {
                image(enemy, xPos, yPos);
            
                //detect fighter to enemy's distance
                int enemyDistX = fx-xPos;
                int enemyDistY = fy-yPos;        
                int team1Distance = (int)sqrt(enemyDistX*enemyDistX+enemyDistY*enemyDistY);
                        
                if(team1Distance <= enemy.width*0.5f+fighter.width*0.5f)
                { 
                    deadOrNotT1[i] = true;
                    blood = blood-20;                        
                        
                    //flame pic position
                    fireX = xPos;
                    fireY = yPos;
                 }                 
            }
                
            if(timeE1 % 120 == 0)
            {
                fireX = -800;
                fireY = -800;
            }
                 
            timeE1++;              
        }
        
        if(posTeam1X > width) {
            posTeam1X = -480;
            enemyTeam1Y = floor(random(60,420));
                 
            for( int j = 0 ; j < 5 ; j++) {
                deadOrNotT1[j] = false;
            }
                 
            enemyTeam2 = true;
            enemyTeam1 = false;
        }
            
            
        //bullet meet enemyT1 
        for(int b = 0 ; b < bX.length; b++)
        {
            for(int e = 0 ; e < enemyTeam1Xs.length ; e++){
                if(deadOrNotT1[e] == false){
                int xPos = enemyTeam1Xs[e]*unitX1+posTeam1X;
                int yPos = enemyTeam1Y;
                float dx = bX[b]-xPos;
                float dy = bY[b]-yPos;
                float dist = sqrt( dx*dx + dy*dy );
                           
                    if( dist < shooting.width*0.5+enemy.width*0.5)
                    {
                       deadOrNotT1[e] = true;
                       fireX = xPos;
                       fireY = yPos;
                       bY[b] = -200;
                    }
                             
                    if( bX[b] <= 10)
                    {
                       bY[b] = -800;
                    }
                }
            }
        }
          posTeam1X+=5;
    }

    //enemy team2
      if(enemyTeam2 == true)
      {
        int[] enemyTeam2X = {0,1,2,3,4};
        float[] enemyTeam2Y = {0,-0.5,-1,-1.5,-2};
        int unitX2 = 70;
    
        for(int i = 0;i < 5; i++){          
            int xPos = enemyTeam2X[i]*unitX2+posTeam2X;
            float yPos = enemyTeam2Y[i]*unitX2+enemyTeam2Posy;
            
            if(deadOrNotT2[i] == false){
                      image(enemy, xPos, yPos);
                                
          //detect fighter to enemy's distance
          int enemyDistX = fx-xPos;
          float enemyDistY = fy-yPos;            
          int enemyTeam2Dist = (int)sqrt(enemyDistX*enemyDistX+enemyDistY*enemyDistY);
                
          if(enemyTeam2Dist <= enemy.width*0.5f+fighter.width*0.5f){
          deadOrNotT2[i] = true;
          blood = blood-20;
          //flame pic position
           fireX = xPos;
           fireY = yPos;
             }
           }
             
            if(timeE2 % 120 == 0){
                fireX = -800;
                fireY = -800;
            }
            timeE2++;
        }
        
            if(posTeam2X > width)
            {
                posTeam2X = -480;
                enemyTeam2Posy = floor(random(140,410));
                
                for( int j = 0 ; j < 5 ; j++)
                {
                     deadOrNotT2[j] = false;
                }
                
                enemyTeam3 = true;
                enemyTeam2 = false;
            }
            
             //bullet meet enemyT2
               for(int b = 0 ; b < bX.length; b++)
               {
                   for(int e = 0 ; e < enemyTeam2X.length ; e++)
                   {
                   
                       int xPos = enemyTeam2X[e]*unitX2+posTeam2X;
                       float yPos = enemyTeam2Y[e]*unitX2+enemyTeam2Posy; 
                       
                       float dx = bX[b]-xPos;
                       float dy = bY[b]-yPos;
                       float dist = sqrt( dx*dx + dy*dy );
                   
                       if( dist < shooting.width*0.5+enemy.width*0.5){
                           deadOrNotT2[e] = true;
                           fireX = xPos;
                           fireY = yPos;
                           bY[b] = -200;
                       }
                  }
               }              
            
        posTeam2X+=5;
      }
      
      //enemy team3
      if(enemyTeam3 == true){
       int[] enemyTeam3X = {0,1,2,1,0,-1,-2,-1};
       int[] enemyTeam3Y = {-2,-1,0,1,2,1,0,-1};    
       int unitX3 = 70;
       
         for(int i = 0;i < 8;i++)
         {
             int xPos = enemyTeam3X[i]*unitX3+posTeam3X;
             int yPos = enemyTeam3Y[i]*unitX3+enemyTeam3Posy;
           
             if(deadOrNotT3[i] == false)
             {
                image(enemy, xPos, yPos);
              
                int enemyDistX = fx-xPos;
                float enemyDistY = fy-yPos;
              
                int enemyTeam3Dist = (int)sqrt(enemyDistX*enemyDistX+enemyDistY*enemyDistY);
              
                if(enemyTeam3Dist <= enemy.width*0.5f+fighter.width*0.5f)
                {  
                    image(enemy,xPos+1000,yPos+1000);
                    deadOrNotT3[i] = true;
                    blood = blood-20;
                    //flame pic
                    fireX = xPos;
                    fireY = yPos;
                 }
             }
             
                if(timeE3 % 120 == 0)
                {
                    fireX = -800;
                    fireY = -800;
                }
                    timeE3++;
              
                if( posTeam3X > width*1.5)
                {
                    posTeam3X = -480;
                    enemyTeam3Posy = floor(random(140,270));
                
                    for( int j = 0 ; j < 8 ; j++)
                    {
                        deadOrNotT3[j] = false;
                    }          
                    enemyTeam1 = true;
                    enemyTeam3 = false;
               }
         }
                //bullet meet enemyT3
                 for(int b = 0 ; b < bX.length; b++){
                     for(int e = 0 ; e < enemyTeam3X.length ; e++){
                   
                     int xPos = enemyTeam3X[e]*unitX3+posTeam3X;
                     int yPos = enemyTeam3Y[e]*unitX3+enemyTeam3Posy;
                   
                     float dx = bX[b]-xPos;
                     float dy = bY[b]-yPos;
                     float dist = sqrt( dx*dx + dy*dy );
                   
                     if( dist < shooting.width*0.5+enemy.width*0.5){
                         deadOrNotT3[e] = true;
                         fx = xPos;
                         fy = yPos;
                         bY[b] = -200;
                     }
                  }
               }
         
               posTeam3X+=5;   
      }
    
    //shoot bullets
    for(int i = 0;i < 5;i++)
    {
        image(shooting,bX[i],bY[i]); 
        bX[i]-=10;
    }
      
    if(keyPressed && key == ' ')
    {
       if(canShoot == true )
       {
          for(int i = 0; i < 5; i++)
          {
              if(bX[i] < 0)
              {  
               bX[i] = fx;
               bY[i] = fy;
               canShoot = false;                              
               break;
              }
          }
      }            
    }   
    else
    { 
        canShoot = true;
    }    
  
      //fighter moving
       if (upPressed) {
         fy -= speed;
       }
       if (downPressed) {
         fy += speed;
       }
       if (leftPressed) {
         fx -= speed;
       }
       if (rightPressed) {
         fx += speed;
       }
   
       //fighter boundary detection
       if (fx > width-50) {
         fx = width-50;
       }
       if (fx < 0) {
         fx = 0;
       }
       if (fy > height-50) {
         fy = height-50;
       }
       if (fy < 0) {
         fy = 0;
       }
       break;
     
     case GAME_LOSE:
     
       image(end1,0,0);
       if(mouseX>200 && mouseX<450){
        if(mouseY>300 && mouseY<340){
          if(mousePressed){
            gameState=2;
            blood = 40;
            fx=width-50;
            fy=height/2;
        }else{
          image(end2,0,0);
            }
          }
        }
       break;
    
  }
    
}

void keyPressed() {
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}
