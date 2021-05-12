# Covid-19-Pool-Testing
This application is a simulator for Covid-19 spreading with different option to prevent further spread of the disease including pool-testing, vaccination ratio, stay at home option with different percentage. There are also settings for different sample size in the simulator to simulate different sizes of cities. There is also a SIR model of the current simulation. The simulation in MATLAB is not that great. Therefore, I will only introduce one sick to the whole samples ranging from size of 50 to 200.

## Pre-request
A decent computer 

## Getting Started
1. Download Matlab on your computer
2. Open simulator_exported.m in MATLAB Editor
3. Set the current folder to proj
4. Run it by pressing the run button
5. Choose the option that you want above the "Simulation" button (Stay at home option will not work if you choose a stay at home percentage without switching on the stay at home button)
6. Press the "Simulation" button 
7. You will see the number of people that is ill at that time under the simulation and SIR model of a chart of record of illness from the beginning to the current time
8. Have fun with the simulation and remember to wear your mask!

## Warning 
+ To run the simulation smoothly, the mouse should be stationary and no other memory consuming application should be running in the background.
+ The slider and inputs will not work after the simulation started. Input should be done before pressing the simulation button.
+ User should not close the window during the simulation. It should be closed only after the simulation is over and the particle is not moving anymore. Any error due to close the window before the simulation is over is due to the limtation of MATLAB.
+ MATLAB is not the best language to write a simulator in. There is a very high chance that data will be overlapped if the simulation button is pressed again in the same run. FOR ANOTHER SIMULATION, PLEASE CLOSE THE CURRENT WINDOW AND PRESS RUN AGAIN IN THE M-FILE.

## Tools Used 
+ MATLAB
+ MATLAB bulit-in AppDesigner
+ A heart that hope everyone stay safe :)
