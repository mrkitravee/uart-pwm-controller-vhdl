  
// Example by Tom Igoe

import processing.serial.*;
String words[]={"0","0","0"};
int i = 1;
int X[] ={75,75,75};
Serial myPort;  // The serial port

void setup() {
  // List all the available serial ports
  size(600,400);
  printArray(Serial.list());
  print(Serial.list()[0]);
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
  
  
}

void draw() {
  while (myPort.available() > 0) {
   
   String inBuffer = myPort.readString();   
    if (inBuffer != null) {
      println(inBuffer);
    }
  }
  set_gui();
  condition();
}
void condition(){
  if ( mouseX>=75 && mouseX<=330 && mouseY>100 && mouseY<110 && (mouseButton == LEFT)) {
    i =0;
    X[i] = mouseX;
    words[i] = str(X[i]-75);
  } else if (mouseX>=75 && mouseX<=330 &&mouseY>200 && mouseY<210 &&(mouseButton == LEFT)) {
    i = 1;
    X[i] = mouseX;
     words[i] = str(X[i]-75);
  }else if (mouseX>=75 && mouseX<=330 &&mouseY>300 && mouseY<310 &&(mouseButton == LEFT)) {
    i=2;
    X[i] = mouseX;
    words[i] = str(X[i]-75);
  }
  
}
void mouseClicked() {
  if(mouseX>=450 && mouseX<=550 &&mouseY>80 && mouseY<130 &&(mouseButton == LEFT)){
    //myPort.write(words[1]+words[2]+words[3]);
    println("send");
    
     myPort.write(int(words[0]));
     myPort.write(int(words[1]));
     myPort.write(int(words[2]));
  }
}

void set_gui(){
  background(#FFC1F9);
  
  
  fill(int(words[0]),0,0);
  rect(75,100, 255, 10,10);
  fill(200,200,200);
  ellipse(X[0],105,20,20);
  fill(0,int(words[1]),0);
  rect(75,200, 255, 10,10);
  fill(200,200,200);
  ellipse(X[1],205,20,20);
  fill(0,0,int(words[2]));
  rect(75,300, 255, 10,10);
  fill(200,200,200);
  ellipse(X[2],305,20,20);
  fill(int(words[0]),int(words[1]),int(words[2]));
  rect(450,150, 100, 100,10);
  fill(200,200,200);
  
  rect(450,80, 100, 50,10);
  fill(0);
  text("CLICK", 470, 110);
  textSize(25);
  fill(0);
  text("SELECT R  G  B", 180, 40);
   textSize(20);
  text( "0", 50, 110);
  text( "255", 350, 110);
  text( "RED     "+words[0], 150, 70);
  text( "0", 50, 210);
  text( "255", 350, 210);
  text( "GREEN  "+words[1], 150, 170);
  text( "0", 50, 310);
  text( "255", 350, 310);
  text( "BLUE    "+words[2], 150, 270);
}