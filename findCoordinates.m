%Title: findCoordinates
%Author: Kyle Tucker
%Date: April 23, 2018
%Purpose: To use basic geometry and snell's law to find coordinate
%locations of a dot in the water channel
    %For further explanation, open image titled 'findCoordinatesTheory.png'


function [x,y,z] = findCoordinates(x_a,w,z_a,a)
%Variables
%x_a distance in x direction from center of camera lens to image of dot as it appears on the surface of the glass
%z_a distance in z direction from center of camera lens to image of dot as it appears on the surface of the glass
%conversion is the number of pixels corresponding to 100 millimeters in the
%image
%w distance in water between inner glass surface and OCT dot. Units are millimeters
g = 12.7; %thickness of water channel glass in millimeters
%a is the distance from camera lens to outer surface of glass in millimeters
n_a = 1.000; %index of refraction for air
n_g = 1.52; %index of refraction for glass
n_w = 1.333; %index of refraction for water

%X Calculations
theta_a = atan(x_a/a); %gives theta_a in radians
theta_g = asin((n_a*sin(theta_a))/n_g); %gives theta_g in radians
x_g = g*tan(theta_g); %gives x_g in millimeters
theta_w = asin((n_g*sin(theta_g))/n_w); %gives theta_w in radians
x_w = w*tan(theta_w); %gives x_w in millimeters

phi_a = atan(z_a/a); %gives theta_a in radians
phi_g = asin((n_a*sin(phi_a))/n_g); %gives theta_g in radians
z_g = g*tan(phi_g); %gives x_g in millimeters
phi_w = asin((n_g*sin(phi_g))/n_w); %gives theta_w in radians
z_w = w*tan(phi_w); %gives x_w in millimeters

y = w+g+a; %gives y location of OCT in millimeters
x = x_a+x_g+x_w; %gives x location of OCT in millimeters
z = z_a+z_g+z_w; %gives z location of OCT in millimeters