%{
READ ME
Written by Kyle Tucker on May 11, 2018

Image Processing Assumptions:
-Only 3 possible depths in y direction for OCT models
-Camera is parallel with water channel glass
-Dots are perfectly placed on OCT models
-Dot centroids, after image processing, are perfectly aligned on OCT models
-All dots can be seen by camera
-Radial distortion is negligible
-OCTs at a given depth are in the same order from left to right as their confluence points

Important Notes for Image Processing:
-Depths in GUI are the depths of dots, NOT OCT centroids
-User must install image processing toolbox for code to work
-Color scheme must stay the same for code to work, even if shapes change
-Image file extensions must currently be renamed from ?.JPG? to ?.jpg?
-Bubbles sometimes form next to dots, and must be scraped away for image processing to work
-If only circles are used, code will be much faster

Remaining Work For OCT Array:
-Order polarizer lens and temporary camera stand
-Write code that does power calculations
-Get all motors on OCT array running (on of the problems is that the fishing line is tangled in motors)
-Allow user to input hidden dot locations
-Determine EXACTLY how accurate 3D coordinates of dots are
-Build permanent and adjustable camera stand
-Fine tune array so that everything is aligned correctly 
-Print drag screens that work or work on current drag screens
-Allow user to give percentage between two dots where mean tether is approximated to be
-Allow code to grab image straight from camera (this is likely present in Nathan?s code)

Link to camera stand: https://www.amazon.com/Professional-Lightweight-Camcorder-Panasonic-Carrying/dp/B00HHD5MB0/ref=sr_1_3?s=electronics&ie=UTF8&qid=1526054384&sr=1-3&keywords=sony+camera+stand

Polarizer must have diameter of 55mm
%}