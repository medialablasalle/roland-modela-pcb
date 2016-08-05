String filename = "data/boom.rml";

import processing.serial.*;

Roland roland;
Serial roland_port;

int val = 0;
void setup() 
{
  size(800, 600);
  String ports = Serial.list()[7];
  //println(ports);
  noStroke();

  roland_port = new Serial(this, ports, 9600);

  roland = new Roland(roland_port);


  roland.initialize();
  roland.setZRange(-1120, 0);
}

void draw() {
  background(222, 184, 135); 
  pushMatrix();
  translate(0, height);
  //rotate(PI);
  scale(1, -1);
  ellipse(roland.x/10, roland.y/10, 10, 10);
  popMatrix();
}

void exit() {
}


void mouseClicked() {
  roland.moveXYZ(mouseX*10, (height - mouseY)*10, roland.z);
}

void keyPressed() {
  switch(key) {
  case ' ':
    roland.step = (roland.step == 1)?100:1;
    break;
  case '8':
    roland.z += roland.step;
    break;
  case '2':
    roland.z -= roland.step;
    break;
  case 'z':
  case 'Z':
    roland.setZAtMaterialSurface();
    println(toMM(roland.z_at_material_surface) + " mm");
    break;
  case 'd':
  case 'D':
    println("drilling hole");
    roland.drillHole(150);
    println("drilled hole");
    break;
  case '0':
    roland.setMotorMode(0);
    println("motor off");
    break;
  case 'i':
  case 'I':
    roland.initialize();
    println("initialize");
    break;
  case '1':roland.setMotorMode(1);
    println("motor on");
    break;

  case 't':
  case 'T':
    roland.goToMaterialSurface();
    break;
  }

  switch(keyCode) {
  case UP: 
    roland.y+=roland.step;
    break;
  case DOWN: 
    roland.y-=roland.step;
    break;
  case LEFT:
    roland.x-=roland.step;
    break;
  case RIGHT:
    roland.x+=roland.step;
    break;
  case ENTER:
    roland.sendRMLFile(filename);
    break;
  }

  roland.moveXYZ(roland.x, roland.y, roland.z);
}

float toMM(int milli_inch) {
  return 0.0254 * milli_inch;
}