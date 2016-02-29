// All dimensions in mm

$fn = 32;

driveWheelWidth = 12;
driveWheelDiameter = 40;      // Diameter of the drive wheel
driveWheelTeeth = 12;         // Number of teeth on the drive wheel

treadWidth = 20;              // Width of the treads
toothDiameter = 5;            // Diameter of the tooth on the link
pinDiameter = 4;
linkLength = 20;              // Length of a link
linkThickness = 3;            // Thinkness of the tread bit of the link

plateOversize = 2;
plateWidth = toothDiameter + plateOversize; 
plateThickness = (treadWidth-driveWheelWidth)/2-1;

hubDiameter = 6;              // Diameter of the center shaft on wheel
rimThickness = 3;             // Thickness of the rim not including teeth
spokeThickness = 3;           // Thickness of the spokes

//plateBase();
linkBase();
//driveWheelBase();
//testLinksAroundWheel();

module plateBase() {
  plateThickness = (treadWidth-driveWheelWidth)/2-1;
  toothSeperation = 2 * sin(360/driveWheelTeeth/2) *  driveWheelDiameter/2;
  s = plateWidth+1;
  
  difference() {
    union() {
      translate([0, -plateWidth/2, 0])
        cube([toothSeperation, plateWidth, plateThickness]);
      cylinder(plateThickness, d=plateWidth);
      translate([toothSeperation, 0, 0])
        cylinder(plateThickness, d=plateWidth);
    }
    
    translate([-s/2, -s/2, 0])
      cube([s, s, plateThickness/2]);
    translate([toothSeperation-s/2, -s/2, plateThickness/2])
      cube([s, s, plateThickness/2]);
    cylinder(plateThickness, d=pinDiameter);
  }
  translate([toothSeperation, 0, 0])
    cylinder(plateThickness, d=pinDiameter+0.5);
}

module linkBase(rot=0) {
  rotate([0,0,rot]) {
    translate([0, 0, plateThickness])
      cylinder(treadWidth - 2*plateThickness, d=toothDiameter);
    translate([0, 0, 0])
      plateBase();
    translate([0, 0, treadWidth])
      mirror([0, 0, 1])
        plateBase();
  }
}

module driveWheelBase() {
  r = driveWheelDiameter / 2;
  w = driveWheelWidth;
  difference() {
    // Blank
    cylinder(w, r=r);
    // Teeth
    for (n = [0 : driveWheelTeeth - 1]) {
      deg = 360 / driveWheelTeeth * n;
      translate([r*cos(deg), r*sin(deg), 0])
        cylinder(w, d=toothDiameter+1);
    }
    // Center cutouts
    cylinder(w/2-spokeThickness/2, r=r-toothDiameter/2-spokeThickness/2);
    translate([0, 0, w/2+spokeThickness/2]) 
      cylinder(w/2-spokeThickness/2, r=r-toothDiameter/2-spokeThickness/2);
    // Spoke holes
    spokeCenter = (r-toothDiameter/2-rimThickness+hubDiameter/2)/2;
    spokeRadius = 0.8*(spokeCenter - hubDiameter/2);
    for (n = [0 : 3]) {
      deg = 360 / 4 * n;
      translate([spokeCenter*cos(deg), spokeCenter*sin(deg), 0])
        cylinder(w, r=spokeRadius);
    }
  }
  // Hub
  cylinder(w/2+spokeThickness/2+1, d=hubDiameter);
}

module testLinksAroundWheel() {
  translate([0, 0, -driveWheelWidth/2]) 
    color("blue") 
      driveWheelBase();
  
  r = driveWheelDiameter / 2;
  for (n = [0 : driveWheelTeeth - 1]) {
      deg = 360 / driveWheelTeeth * n;
      translate([r*cos(deg), r*sin(deg), -treadWidth/2])
        linkBase(deg+90+360/driveWheelWidth/2);
    }
  
}
 