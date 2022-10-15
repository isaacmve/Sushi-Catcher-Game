//SoundFile file;
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim       minim;
AudioPlayer jingle;
AudioPlayer hit;

PImage scene,drop,leaf,player,drop2,leaf2,startscreen;                   // Variables to store information about images

int drop_x,drop_y,drop_count;          // Variables to store (x,y) position of drop
int leaf_x,leaf_y,leaf_count;          // Variables to store (x,y) position of leaf
int target1_x,target1_y,target1_count;          // Variables to store (x,y) position of drop
int target2_x,target2_y,target2_count;          // Variables to store (x,y) position of drop


float frame=0;                           // Start on frame 0 of the sprite sheet
int   player_x=400;                      // Start player in middle of screen
int   direction=0;
int score=0,lives=3;                   // Set initial score and number of lives
int quit_flag=0;                       // This is set to 1 when game is over
int screensizex,screensizey,stage;

void setup()                           // Entry point (start of program), runs once
{
  stage = 1;
  screensizex = round(width*0.90);
  screensizey = round(height*0.90);

  startscreen = loadImage("background.png");
  image(startscreen, 0,0, 800,600);
  
    size(800,600,P2D);
    
      // Load a soundfile from the data folder of the sketch and play it back in a loop
  minim = new Minim(this);
  jingle = minim.loadFile("music.wav");   // load the music file into memory
  jingle.loop();                          //  play the file on a loop 
  

    
  scene = loadImage("Background.bmp"); 

  drop = loadImage("Target.png");        // load image of rain drop into the GPU
  
  leaf = loadImage("Target.png");        // load image of leaf into the GPU
  
  drop2 = loadImage("Target.png");        // load image of rain drop into the GPU
  
  leaf2 = loadImage("Target.png");        // load image of leaf into the GPU


  player = loadImage("Running.png");    // load sprite sheet for player

  
  float radius=random(125);            // Chose leaf starting position
  float angle=random(3*PI);            // Random position inside circle
  leaf_x=584+(int)(radius*cos(angle)); // of radius 128 centered on (584,216)
  leaf_y=216+(int)(radius*sin(angle));

  textureMode(NORMAL);                 // Scale texture Top right (0,0) to (1,1)
  blendMode(BLEND);                    // States how to mix a new image with the one behind it 
  noStroke();                          // Do not draw a line around objects
  
  drop_x=166+(int)random(600);         // Choose drop starting position
  drop_y=90;
  
}

void draw() 
{
  if (stage==1){
    textAlign(CENTER);
 text("Sushi Catcher", 400, 280);   
 text("Press any ket to start", 400, 300); 
  text("Catch as much sushi as possible while controlling the plate with the mouse", 400, 320); 
  if (keyPressed == true)
   stage = 2;
 }
  
  if(stage==2) {
  background(scene);                 // Clear screen to the background image, scene
 
  
  pushMatrix();                      // Store current location of origin (0,0)
  translate(drop_x,drop_y);          // Change origin (0,0) for drawing to (drop_x,drop_y) 

  beginShape();                      // Open graphics pipeline
  rotate((float)frameCount/10);
  texture(drop);                     // Tell GPU to use drop to texture the polygon
  vertex( -20,  -20,   0,   0);      // Load vertex data (x,y) and (U,V) texture data into GPU 
  vertex(20,   -20,  1,   0);        // Square centred on (0,0) of width 40 and height 40
  vertex(20, 20,  1,  1);            // Textured with an image of a drop
  vertex( -20, 20,   0,  1);
  endShape(CLOSE);            // Tell GPU you have loaded shape into memory.
  popMatrix();                       // Recover origin(0,0)means top left hand corner again.
  
    float left =frame/16;
  float right=(frame+1)/16;
  
    if(direction==1)                  // Swap left and right UV values
  {                                 // to reverse direction sprite is facing
    float temp=left;
    left=right;
    right=temp;
  }

  
  pushMatrix();                      // Draw player
  translate(player_x,500);              
  texture(player);
  image(player, 0, 0, width/7, height/7);
  endShape(CLOSE);
  popMatrix();               // Restore origin (top left 0,0)

  
    pushMatrix();  // Draw leaf
  translate(leaf_x,leaf_y);  
  rotate((float)frameCount/10);
  beginShape();  // Draw Leaf
  texture(leaf);
  vertex( -20,  -20,   0,   0); 
  vertex(20,   -20,  1,   0);
  vertex(20, 20,  1,  1);
  vertex( -20, 20,   0,  1);
  endShape(CLOSE);
  popMatrix();
  
    leaf_y+=1;        // Make leaf "move" down the screen
  if(leaf_y>600)
  {
    float radius=random(500);     // Chose leaf starting position
    float angle=random(4*PI);
  minim = new Minim(this);
  jingle = minim.loadFile("hit.wav");   // load the music file into memory
  jingle.play();   
  
    leaf_x=584+(int)(radius*cos(angle));
    leaf_y=216+(int)(radius*sin(angle));
    lives--;        // lost a life

  }
  

  // image(direction, mouseX, mouseY);
  
   
    // Move player
      if (mouseX > pmouseX) {
       direction=1;          // Set direction to the right
       player_x = mouseX;          // Increase X position move right
     frame++;              // Every step advance the frame
       if(frame>16) frame=0; // If frame is 16 reset it to 0
  }
    else if (mouseX < pmouseX) {
       direction=0;          // Set direction to the left
       player_x=mouseX;          // Decrease X position move left
       frame++;
      if(frame>16) frame=0;
  }
    
   



    drop_y+=2;       // Make "drop" move down the screen (two pixels at a time)
  if(drop_y>600)   // If y value is entering the grass line
  {
    drop_x=166+(int)random(100); // Restart the drop again in the cloud. 
    drop_y=90;
    lives--;        // lost a life
      minim = new Minim(this);
  jingle = minim.loadFile("hit.wav");   // load the music file into memory
  jingle.play();   
  
  
  }
  if ((drop_y>478)&&(drop_y<600))     // If drop is on same level as player 
  {
    if(abs((drop_x+5)-(player_x+82))<25) // And drop is near player
    {
      drop_count++;                  // Increase drop count by one (caught)
      
      drop_x=166+(int)random(600);   // Restart a new drop in the cloud 
      drop_y=90;
    }
  }
  
  if ((leaf_y>498)&&(leaf_y<600))  // If leaf is on same level as player
  {

    if(abs((leaf_x+5)-(player_x+82))<25) // And leaf is near player
    {
      leaf_count++;                // Increase leaf count by one (caught)
      
  float radius=random(125);            // Chose leaf starting position
  float angle=random(5*PI);   
     leaf_x=584+(int)(radius*cos(angle));
     leaf_y=216+(int)(radius*sin(angle));
    }
  }
  
  score = leaf_count + drop_count;
 
  textSize(18);                  // Display score information on the screen
 
  fill(0,0,0);
  text("Score:" +score, 620, 20); 
  
  fill(0,0,0);
  text("Lives:"+lives, 700, 20); 
  

  
  // Scoring and game logic
  if (lives<1) text("Game over", 500, 300);  // Score of 0 display game over

  score++;
  
  
  if(quit_flag==1)                // Wait five seconds before exiting
  {
   delay(5000);
   exit();
  }
  
  if (lives<1)   // All lives lost so game over but  
  {              // return to draw one more time to
    quit_flag=1; // allow "Game Over to be displayed.
  }

  // Screen only drawn by graphics card at this point
  // not immediately after they are entered into GPU pipeline
}
}
