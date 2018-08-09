//Laptop Control Box 
//- Code written by Carl Gordon, 12/2/17
//Code listens to signals sent from an Arduino circuit over serial usb connection.

PImage BG;
PImage squares;
//app icons
PImage defaultIcon;

//6 SOFTWARE STATES
//TOOL ICONS
PImage PS, Sublime, Processing, Sip, Github, Arduino;
//BROWSER ICONS
PImage Firefox, Youtube, Stuff, Weather, Google;
//MEDIA ICONS
PImage Spotify, Series, Steam, Netflix;
//UTILITY ICONS
PImage Terminal, Calculator, LaunchPad, Launcher,volumePlus,volumeMinus;
//SOCIAL ICONS
PImage Messenger, Quora, Instructables, Gmail;
//LIFESTYLE ICONS
PImage Calendar, FocusMatrix, Stickies, Evernote;
//image push
float push0;
float push1;
float push2;
float push3;
float push4;
float push5;
float push6;
float push7;
float push8;

//softstate tells us which of the 6 states the software is currently in
String softstate;
int shuffle=0;

int toolshuffle=0;

int colDrive=0;
int[] myColors = { 1, 2, 3, 4, 5, 6 };
//
import processing.serial.*;

Serial myPort;  // Create object from Serial class
//val is the number recieved from the Arduino
//1= top left button
//2= top right button
//3= bottom left button
//4= bottom right button
//5= Side toggle button
//val is initialized as 0
int val=10;      // Data received from the serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int col, but, state;
//
void setup() {
  //frameRate(24);
  size(720, 540);
  background(0);

  //ARDUINO CONNECTION
  //My Laptop reads the Arduino on Serial.list()[5] but yours may be different
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  //Load all images
  BG = loadImage("BG2.jpg");
  //ICONS
  defaultIcon = loadImage("default_Icon.png");
  squares = loadImage("squares_9.png");
  //tools
  Sip = loadImage("sip_Icon.png");
  PS = loadImage("PS_Icon.png");
  Sublime = loadImage("sublime_Icon.png");
  Processing = loadImage("Processing_Icon.png");
  Github = loadImage("github_Icon.png");
  Arduino= loadImage("arduino_Icon.png");
  //media
  Spotify = loadImage("spotify_Icon.png");
  Series = loadImage("series_Icon.png");
  Steam = loadImage("steam_Icon.png");
  Netflix = loadImage("netflix_Icon.png");
  //browser
  Firefox = loadImage("firefox_Icon.png");
  Youtube=loadImage("youtube_Icon.png");
  Stuff=loadImage("stuff_Icon.png");
  Weather=loadImage("weather_Icon.png");
  Google=loadImage("google_Icon.png");
  //utility
  Terminal = loadImage("terminal_Icon.png");
  LaunchPad = loadImage("launchpad_Icon.png");
  Launcher = loadImage("launcher_Icon.png");
  Calculator = loadImage("calculator_Icon.png");
  volumePlus = loadImage("volumeplus_Icon.png");
  volumeMinus = loadImage("volumeminus_Icon.png");
  //social
  Quora=loadImage("quora_Icon.png");
  Gmail=loadImage("gmail_Icon.png");
  Messenger = loadImage("messenger_Icon.png");
  Instructables=loadImage("instructables_Icon.png");
  //lifestyle
  Evernote = loadImage("evernote_Icon.png");
  Calendar = loadImage("calendar_Icon.png");
  FocusMatrix = loadImage("focusmatrix_Icon.png");
  Stickies = loadImage("stickies_Icon.png");
}
void draw() {

  if ( myPort.available() > 0) {  // If data is available,
    int inByte = myPort.read();
    
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 2 ) {
      col = serialInArray[0];
      but = serialInArray[1];
      state = serialInArray[2];
      
      if (state == 1) {
        val = but;
      }
      else {
       val = 10;
      }

      // print the values (for debugging purposes only):
      println(col + "\t" + but + "\t" + state);
      // Reset serialCount:
      serialCount = 0;
    }
    
   // val = myPort.read();         // read it and store it in val
  }
  //Center all images
  imageMode(CENTER);
  rectMode(CENTER);

  //Place Background
  image(BG, mouseX, mouseY);
  //Place squares
  image(squares, width/2, height/2);

  //Icon placements
  //left column
  int col_X = 195;
  int col_Y1 = 105;
  int col_Y2 = 270;
  int col_Y3 = 435;
  //middle column
  int col2_X = 360;
  int col2_Y1 = 105;
  int col2_Y2 = 270;
  int col2_Y3 = 435;
  //right column
  int col3_X = 525;
  int col3_Y1 = 105;
  int col3_Y2 = 270;
  int col3_Y3 = 435;

  //SHUFFLE protocol - arduino
  //Increment shuffle by 1 everytime the side button is pressed
  if (val==4) {
    shuffle+=1;
  }
  //reset shuffle to 0 if it exceeds 5
  if (shuffle>1) {
    //reset shuffle
    shuffle=0;
  }
  colDrive = myColors [shuffle];

  if (push0>=10) {
    push0=0;
  }
  if (push1>=10) {
    push1=0;
  }
  if (push2>=10) {
    push2=0;
  }
  if (push3>=10) {
    push3=0;
  }
  if (push4>=10) {
    push4=0;
  }
  if (push5>=10) {
    push5=0;
  }
  if (push6>=10) {
    push6=0;
  }
  if (push7>=10) {
    push7=0;
  }
  if (push8>=10) {
    push8=0;
  }

  //push drive
  if (val==0) {
    push0+=10;
  }
  if (val==1) {
    push1+=10;
  }
  if (val==2) {
    push2+=10;
  }
  if (val==3) {
    push3+=10;
  }
  if (val==5) {
    push5+=10;
  }
  if (val==6) {
    push6+=10;
  }
  if (val==7) {
    push7+=10;
  }
  if (val==8) {
    push8+=10;
  }

  //state decoder
  if (colDrive==1) {
    softstate="Browser";
    //SOFTWARES SHOW Browser APPS

    //set 1 - Browser
    //left
    image(Google, col_X, col_Y1, 100+push0, 100+push0);
    image(Instructables, col_X, col_Y2, 100+push1, 100+push1);
    image(Gmail, col_X, col_Y3, 100+push2, 100+push2);
    
    //middle
    image(Youtube, col2_X, col2_Y1, 100+push3, 100+push3);
    
    image(Weather, col2_X, col2_Y3, 100+push5, 100+push5);
    
    //right
    image(Messenger, col3_X, col3_Y1, 100+push6, 100+push6);
    image(Quora, col3_X, col3_Y2, 100+push7, 100+push7);
    image(Github, col3_X, col3_Y3, 100+push8, 100+push8);
    //launch protocol - arduino
    if (val==0) {
      link("https://www.google.cz/");
    }
    if (val==1) {
      link("http://www.youtube.com/");
    }
    if (val==2) {
      link("https://www.facebook.com/messages/t/");
    }
    if (val==3) {
      link("https://www.instructables.com/");
    }
    if (val==5) {
      link("http://www.quora.com/");
    }
    if (val==6) {
      link("https://www.gmail.com/");
    }
    if (val==7) {
      //launch("/Applications/Weather Live Free.app");
      link("https://www.yr.no/place/Czech_Republic/South_Moravia/Brno/?spr=eng");
    }
    if (val==8) {
      link("http://www.github.com/");
    }

    //end Browser Apps
  }
  if (colDrive==2) {
    //SOFTWARES SHOW TOOL APPS
    softstate="Tools - Web Design";
    //set 2 - Web Design
    image(Google, col_X, col_Y1, 100+push0, 100+push0);
    
    image(Calculator, col2_X, col2_Y1, 100+push1, 100+push1);
    
    image(Netflix, col3_X, col3_Y1, 100+push2, 100+push2);
    
    //launch protocol - arduino
    if (val==0) {
      link("https://www.google.cz/");
    }
    if (val==1) {
      launch("C:/Windows/System32/calc.exe");
    }
    if (val==2) {
      link("https://www.netflix.com/cz/");
    }

    //end TOOL APPS
  }
  //
  //println(myColors[shuffle]);
  //println(softstate);
  val = 10;
  //saveFrame("Movie/frame-######.png");
}