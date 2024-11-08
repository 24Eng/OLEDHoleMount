/*
This code uses the thread library from Ryan Colyer. Big thank you, Ryan.
https://github.com/rcolyer/threads-scad

Code in this file is the intellectual property of Brian McEvoy
http://www.24hourengineer.com/
*/

use <\threads-scad-master\threads.scad>
/*
ScrewThread(outer_diam, height, pitch=0, tooth_angle=30, tolerance=0.4, tip_height=0, tooth_height=0, tip_min_fract=0);
ScrewHole(outer_diam, height, position=[0,0,0], rotation=[0,0,0], pitch=0, tooth_angle=30, tolerance=0.4, tooth_height=0){
*/


// User-programmable dimensions
lidThickness = 2;
mountThickness = 2;
mountSlop = 0.25;
channelThickness = 3;
nutThickness = 5;
channelDiameter = 12;
channelLength = 15;
channelVerticalOffset = 10;
threadTolerance = 0.4;
threadPitch = 2;
boardRiserHeight = 4.5;
riserDonut = 0.75;
antiRotationPegDiameter = 3;
antiRotationPegHeight = 5;
largeDimension = 40;

/* Real-life measurements
This type of medium screen has ovular mounting holes
https://photos.app.goo.gl/RcXvKxrSdv2ERaiL7
*/
horizontalDistanceBetweenMountingHoles = 25.5;
verticalDistanceBetweenMountingHoles = 28;
PCBDiagonal = 47;
OLEDPanelWidth = 35;
OLEDPanelHeight = 20;
OLEDPanelThickness = 1.6;
boltDiameter = 2;
boltHeadDiameter = 4;
boltHeadThickness = 2;
PCBThickness = 1.2;
OLEDPanelCenterOffset = 2;

// Calculated parameters
boltRadius = boltDiameter/2;
boltHeadRadius = boltHeadDiameter/2;
channelRadius = channelDiameter/2;
calculatedMountDiameter = sqrt(verticalDistanceBetweenMountingHoles^2 + horizontalDistanceBetweenMountingHoles^2) + boltDiameter + mountThickness*2;
calculatedMountRadius = calculatedMountDiameter/2;
totalLidThickness = mountThickness + boardRiserHeight + PCBThickness + OLEDPanelThickness + lidThickness;
echo(str("Hole diameter to drill: ", channelDiameter + mountThickness*2, " millimeters."));
antiRotationPegRadius = antiRotationPegDiameter/2;
//pegOffset = -(-channelVerticalOffset - verticalDistanceBetweenMountingHoles/2);
pegOffset = 20;
echo(str("Peg offset: ", pegOffset, " millimeters"));
mountRadius = max(calculatedMountRadius, (PCBDiagonal/2));
echo(str("mountRadius: ", mountRadius, " millimeters"));
//lidOuterRadis = lidInnerRadius + mountThickness;

// Program parameters
$fn = 60;

// Visibility bits
lidBit = 0;
mountBit = 1;
nutBit = 1;
holePositionBit = 0;
cutawayView = 1;

/*
/(<-_o_->)\ /(<-_o_->)\ /(<-_o_->)\ /(<-_o_->)\ /(<-_o_->)\ /(<-_o_->)\ /(<-_o_->)\
\(<-_o_->)/ \(<-_o_->)/ \(<-_o_->)/ \(<-_o_->)/ \(<-_o_->)/ \(<-_o_->)/ \(<-_o_->)/ 
*/

if(lidBit){
    translate([0,-channelVerticalOffset,lidThickness * 8]){
        rotate([0,0,0]){
            color("MediumTurquoise"){
                screenLid();
            }
        }
    }
}

if(mountBit){
    difference(){
        translate([0,0,0]){
            rotate([0,0,0]){
                color("SteelBlue"){
                    mountFace();
                    translate([0,0,0]){
                        threadedChannel();
                    }
                }
            }
        }
        if(cutawayView){
            translate([0,0,-largeDimension/2]){
                cube([largeDimension, largeDimension, largeDimension], center = false);
            }
        }
    }
}

if(nutBit){
    difference(){
        translate([0,0, -channelLength - mountThickness *4 + (cutawayView*15.4)]){
            rotate([0,0,0]){
                color("PaleVioletRed"){
                    ScrewHole(channelDiameter + mountThickness*2, nutThickness, position=[0,0,-nutThickness/2], rotation=[0,0,0], tolerance=threadTolerance, pitch = threadPitch){
                        $fn = 6;
                        cylinder(nutThickness, channelRadius + mountThickness*3, channelRadius + mountThickness*3, center=true);
                    }
                }
            }
        }
        if(cutawayView){
            translate([0,0,-largeDimension/2]){
                cube([largeDimension, largeDimension, largeDimension], center = false);
            }
        }
    }
}

if(holePositionBit){
    translate([0,0,-channelLength - mountThickness*2]){
        rotate([0,0,0]){
            color("PowderBlue"){
                holeTool();
            }
        }
    }
}


/*
/([-▼-])\ /([-▼-])\ /([-▼-])\ /([-▼-])\ /([-▼-])\ /([-▼-])\ /([-▼-])\ /([-▼-])\
\([-▲-])/ \([-▲-])/ \([-▲-])/ \([-▲-])/ \([-▲-])/ \([-▲-])/ \([-▲-])/ \([-▲-])/
*/

module mountFace(){
    difference(){
        translate([0,-channelVerticalOffset,mountThickness/2]){
            // Flat face to place the screen
            cylinder(mountThickness, mountRadius - mountSlop, mountRadius - mountSlop, center=true);
            // Four board risers
            translate([horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2,mountThickness/2 + boardRiserHeight/2]){
                cylinder(boardRiserHeight, boltRadius+riserDonut, boltRadius+riserDonut, center=true);
            }
            translate([-horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2,mountThickness/2 + boardRiserHeight/2]){
                cylinder(boardRiserHeight, boltRadius+riserDonut, boltRadius+riserDonut, center=true);
            }
            translate([horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2,mountThickness/2 + boardRiserHeight/2]){
                cylinder(boardRiserHeight, boltRadius+riserDonut, boltRadius+riserDonut, center=true);
            }
            translate([-horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2,mountThickness/2 + boardRiserHeight/2]){
                cylinder(boardRiserHeight, boltRadius+riserDonut, boltRadius+riserDonut, center=true);
            }
        }
        // Four mounting holes
        translate([horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2-channelVerticalOffset,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
            translate([0,0,boltHeadThickness/2.01]){
                cylinder(boltHeadThickness, boltHeadRadius, boltRadius, center = true);
            }
        }
        translate([-horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2-channelVerticalOffset,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
            translate([0,0,boltHeadThickness/2.01]){
                cylinder(boltHeadThickness, boltHeadRadius, boltRadius, center = true);
            }
        }
        translate([horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2-channelVerticalOffset,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
            translate([0,0,boltHeadThickness/2.01]){
                cylinder(boltHeadThickness, boltHeadRadius, boltRadius, center = true);
            }
        }
        translate([-horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2-channelVerticalOffset,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
            translate([0,0,boltHeadThickness/2.01]){
                cylinder(boltHeadThickness, boltHeadRadius, boltRadius, center = true);
            }
        }
        // Channel hole
        translate([0,0,0]){
            cylinder(mountThickness*3, channelRadius, channelRadius, center = true);
        }
    }
    // Anti-rotation peg with rounded end
    translate([0, -pegOffset, -(antiRotationPegHeight - antiRotationPegRadius)/2]){
        cylinder(antiRotationPegHeight - antiRotationPegRadius, antiRotationPegRadius, antiRotationPegRadius, center=true);
    }
    translate([0, -pegOffset,-(antiRotationPegHeight + antiRotationPegRadius)/2]){
        sphere(antiRotationPegRadius);
    }
}

module threadedChannel(){
    rotate([180,0,0]){
        difference(){
            ScrewThread(channelDiameter + mountThickness*2, channelLength, tolerance=threadTolerance, pitch = threadPitch);
            cylinder(channelLength*3, channelRadius, channelRadius, center = true);
        }
    }
}

module screenLid(){
    difference(){
        if(1){
            cylinder(totalLidThickness, mountRadius + lidThickness, mountRadius + lidThickness, center=true);
        }
        // Four mounting holes
        translate([horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
        }
        translate([-horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
        }
        translate([horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
        }
        translate([-horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2,0]){
            cylinder(mountThickness*3 + boardRiserHeight*2, boltRadius, boltRadius, center = true);
        }
        // Inner cavity
        difference(){
            translate([0,0,-lidThickness/2]){
                cylinder(totalLidThickness - lidThickness + 0.001, mountRadius + 0, mountRadius + 0, center=true);
            }
            // Interior risers
            translate([horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2,(totalLidThickness/4 - OLEDPanelThickness*0)]){
                cylinder(OLEDPanelThickness, boltRadius+riserDonut, boltRadius+riserDonut, center = true);
            }
            translate([-horizontalDistanceBetweenMountingHoles/2,verticalDistanceBetweenMountingHoles/2,(totalLidThickness/4 - OLEDPanelThickness*0)]){
                cylinder(OLEDPanelThickness, boltRadius+riserDonut, boltRadius+riserDonut, center = true);
            }
            translate([horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2,(totalLidThickness/4 - OLEDPanelThickness*0)]){
                cylinder(OLEDPanelThickness, boltRadius+riserDonut, boltRadius+riserDonut, center = true);
            }
            translate([-horizontalDistanceBetweenMountingHoles/2,-verticalDistanceBetweenMountingHoles/2,(totalLidThickness/4 - OLEDPanelThickness*0)]){
                cylinder(OLEDPanelThickness, boltRadius+riserDonut, boltRadius+riserDonut, center = true);
            }
        }
        translate([-OLEDPanelWidth/2,-OLEDPanelHeight/2 + OLEDPanelCenterOffset,0]){
            cube([OLEDPanelWidth, OLEDPanelHeight, totalLidThickness*3]);
        }
    }
}

module holeTool(){
    translate([0,-pegOffset/2,0]){
        difference(){
            cube([mountThickness*4, pegOffset - mountThickness*0, mountThickness], center = true);
            translate([0,-pegOffset/2,0]){
                cylinder(mountThickness*2, mountThickness/2, mountThickness/2, center=true);
            }
            translate([0,pegOffset/2,0]){
                cylinder(mountThickness*2, mountThickness/2, mountThickness/2, center=true);
            }
        }
        translate([mountThickness/2, (pegOffset/2 - mountThickness*5),mountThickness/2]){
            rotate([0,0,90]){
                linear_extrude(height = 0.25){
                    text(str((channelDiameter + mountThickness*2), "mm"), mountThickness);
                }
            }
        }
        translate([mountThickness/2, -(pegOffset/2 - mountThickness*1) ,mountThickness/2]){
            rotate([0,0,90]){
                linear_extrude(height = 0.25){
                    text(str(antiRotationPegDiameter, "mm"), mountThickness);
                }
            }
        }
    }
    
}


