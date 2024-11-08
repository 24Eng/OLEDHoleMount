# OLEDHoleMount
Parametric model for mounting square screens onto a circular hole.


http://www.24hourengineer.com/search?q=%22OLEDHoleMount%22&max-results=20&by-date=true


The included model works for this screen.
https://www.amazon.com/gp/product/B06XXTHLNW/
Cheaper models are available, but they will require modifying the variables in the OpenSCAD code.
The critical values are:
[] boardRiserHeight // How thick are the components on the back of the board? Some are very thin.
[] antiRotationPegDiameter // Set this to "0" if you do not want an anti-rotation peg.
[] horizontalDistanceBetweenMountingHoles // Length, in millimeters, between the hole centers at the top of the OLED PCB (Printed Circuit Board).
[] verticalDistanceBetweenMountingHoles // Length, in millimeters, between the hole centers at the sides of the OLED PCB.
[] PCBDiagonal // The diagonal measurement of your PCB. Set to "0" if you want the code to calculate the distance based on the vertical and horizontal hole distances.
[] OLEDPanelWidth // Width of the screen. This is for the screen component and creates a window in the lid.
[] OLEDPanelHeight // Screen height. This is for the screen component and creates a window in the lid.

