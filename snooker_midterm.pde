import processing.serial.*;

Serial controllerPort;

final float ANGLE_STEP_SLOW = 5;
final float ANGLE_STEP_MEDIUM = 10;
final float ANGLE_STEP_FAST = 15;

float angle = -90;

int xValue = -300;
int yValue = 0;

PVector position;
PVector velocity;

int startTime;

boolean isHit = false;

final String MOVE_RIGHT_SLOW = "right_slow";
final String MOVE_RIGHT_MEDIUM = "right_medium";
final String MOVE_RIGHT_FAST = "right_fast";

final String MOVE_LEFT_SLOW = "left_slow";
final String MOVE_LEFT_MEDIUM = "left_medium";
final String MOVE_LEFT_FAST = "left_fast";

final String HIT_SLOW = "hit_slow";
final String HIT_MEDIUM = "hit_medium";
final String HIT_FAST = "hit_fast";

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
  
  if(command.equalsIgnoreCase(MOVE_RIGHT_SLOW)){
    angle -= ANGLE_STEP_SLOW;
  }
  else if(command.equalsIgnoreCase(MOVE_RIGHT_MEDIUM)){
    angle -= ANGLE_STEP_MEDIUM;
  }
  else if(command.equalsIgnoreCase(MOVE_RIGHT_FAST)){
    angle -= ANGLE_STEP_FAST;
  }
  
  if(command.equalsIgnoreCase(MOVE_LEFT_SLOW)){
    angle += ANGLE_STEP_SLOW;
  }
  else if(command.equalsIgnoreCase(MOVE_LEFT_MEDIUM)){
    angle += ANGLE_STEP_MEDIUM;
  }
  else if(command.equalsIgnoreCase(MOVE_LEFT_FAST)){
    angle += ANGLE_STEP_FAST;
  }
  
  if(command.equalsIgnoreCase(HIT_SLOW)){
    startTime = millis();
    velocity = new PVector(33, 0);
  }
  else if(command.equalsIgnoreCase(HIT_MEDIUM)){
    startTime = millis();
    velocity = new PVector(66, 0);
  }
  else if(command.equalsIgnoreCase(HIT_FAST)){
    startTime = millis();
    velocity = new PVector(99, 0);
  }
}
