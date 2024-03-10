import processing.serial.*;

Serial controllerPort;

final float ANGLE_STEP = 5;
float angle = -90;

int xValue = -300;
int yValue = 0;

PVector position;
PVector velocity;

int startTime;

boolean isHit = false;

final String MOVE_RIGHT = "right";
final String MOVE_LEFT = "left";
final String HIT = "hit";

void setup() {
  printArray(Serial.list());
  
  controllerPort = new Serial(this, Serial.list()[2], 9600);
  
  controllerPort.bufferUntil('\n');
  
  size(800, 1000);
  strokeWeight(4);
  
  position = new PVector(0, 0);
  
  startTime = -2501;
}

void draw() {
  background(255);
  
  translate(width / 2, height / 2);
  rotate(radians(angle));
  
  isHit = (millis() - startTime <= 2500);
  
  if(isHit){
    xValue = 0;
    position.add(velocity);
    
    if ((position.x > width/2) || (position.x < -width/2))
      velocity.x *= -1;
  }
  else{
    xValue = -300;
    position = new PVector(0,0);
  }
  
  line(xValue, yValue, 0, 0);
  ellipse(position.x, position.y, 60, 60);
}

void serialEvent(Serial controllerPort) {
  String command = controllerPort.readStringUntil('\n');
  command = trim(command);
  command = command.replace("\r", "");
  
  if(command.equalsIgnoreCase(MOVE_RIGHT)){
    angle -= ANGLE_STEP;
  }
  
  if(command.equalsIgnoreCase(MOVE_LEFT)){
    angle += ANGLE_STEP;
  }
  
  if(command.equalsIgnoreCase(HIT)){
    startTime = millis();
    velocity = new PVector(random(1, 100), 0);
  }
}
