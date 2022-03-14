# ForCoast-SM-A4

Test of SM A4 for containerisation

To build this image: <br />
-Open cmd or powershell with Docker running <br />
-cd %directory of the dockerfile% <br />
-Then run the command: "docker build -t forcoast-sm-a4 ."

To run the container: <br />
- "docker run forcoast-sm-a4" will run the container with the image on default parameters <br />
- To run with parameters "docker run -e parameter=value focoast-sm-a4" <br />
- Example: "docker run -e nd=3 -e ptm=1 -e tt=9 forcoast-sm=a4" <br />

Available parameters:  <br />
- nd : the number of days, default: 3 <br />
- ptm : switch temperature treshold (0) or cumalitve temperature (1), default: 1 <br />
- tt: treshold temperature, default: 9 <br />
- gdt: treshold of temperature for gonade development, default: 7 <br />
- ttcs: treshold of cumulative temperature, default: 325 <br />
- pldmin: minimal pelagic larval duration of the selected species, default: 20 <br />
- pldmax: maximal pelagic larval duration of the selected species, default: 45 <br />
- sd : duration of the spawning period, default: 30

To run the container:<br />

"docker run forcoast-sm-a3 $1 $2 $3 $4 $5 $6 $7 $8" all parameters need to be given
Example with default values: "docker run forcoast-sm-a3 3 1 9 7 325 20 45 30"
