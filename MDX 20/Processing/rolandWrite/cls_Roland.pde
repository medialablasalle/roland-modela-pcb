class Roland {
  Serial myPort;  
  int x, y, z, step;
  int z_at_material_surface;
  int prevX, prevY;

  Roland(Serial port) {
    this.myPort = port;
    this.prevX = this.prevY = this.x = this.y = this.z = 0;
    this.step = 1;
  }

  void initialize() {
    this.myPort.write("IN;!MC0;");
    println("IN;!MC0;");
  }

  void drillHole(int depth) {
    int start_z = this.z;
    int end_z = this.z - depth;
    setMotorMode(1);
    while (this.z > end_z) {
      moveXYZ(this.x, this.y, this.z);
      this.z -= 3;
      delay(1000);
    }
    setMotorMode(0);
    initialize();
    moveXYZ(this.x, this.y, start_z);
  }

  // x, y movement - might be redundant (See moveXYZ())
  void moveTo(int x, int y) {
    this.x = x;
    this.y = y;
    this.myPort.write("PA"+this.x+","+this.y+";");
    println("PA"+this.x+","+this.y+";");
  }

  void setZAtMaterialSurface() {
    this.z_at_material_surface = this.z;
    println("Set z_at_material_surface to " + this.z_at_material_surface);
  }

  void goToMaterialSurface() {
    println("going to material surface");
    moveXYZ(100, 100, z_at_material_surface);
  }

  void wait(int millis) {
    this.myPort.write("W"+millis+";");
    println("W"+millis+";");
    //delay(millis);
  }

  void setMotorMode(int mode) {
    String command = "!MC"+mode+";";
    this.myPort.write(command);
    println(command);
  }

  // doesnt seem to work - needs testing
  void setZ(int z) {
    this.z = z;
    this.myPort.write("!ZM"+this.z+";");
    println("!ZM"+this.z+";");
  }

  void setZRange(int z1, int z2) {
    this.myPort.write("!PZ" + z1 + "," + z2+";");
    println("!PZ" + z1 + "," + z2+";");
  }

  void moveXYZ(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.myPort.write("Z" + this.x + ","  + this.y + "," + this.z+";");
    println("Z" + this.x + ","  + this.y + "," + this.z+";");
  }

  void sendRMLFile(String path) {
    String lines[] = loadStrings(path);
    //println(lines.length);

    for (int i = 0; i < lines.length; i++) {
      roland_port.write(lines[i]);
      int distance = 200;
      if (lines[i].charAt(0) == 'Z') {
        int[] values = int(split(lines[i].substring(1), ','));
        this.x = values[0];
        this.y = values[1];
        distance = int(dist(this.x, this.y, this.prevX, this.prevY));
        println("Distance : " + distance);
      }


      println("line : " + (i+1) + "/" + lines.length);
      //println(lines[i]);
      // need to replace the below delay() with something smarter
      if (distance < 200) {
        delay(distance*10);
      } else {
        delay(2000);
      }
      this.prevX = this.x;
      this.prevY = this.y;
    }
  }
}