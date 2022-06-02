# ForCoast-SM-A4

Test of SM A4 for containerisation

To build this image: <br />
-Make sure the EOL of run.sh is in UNIX
-Open cmd or powershell with Docker running <br />
-cd %directory of the dockerfile% <br />
-Then run the command: "docker build -t forcoast-sm-a4 ."

Available parameters:  <br />
- ptm : switch temperature treshold (0) or cumalitve temperature (1), default: 1 <br />
- tt: treshold temperature, default: 9 <br />
- gdt: treshold of temperature for gonade development, default: 7 <br />
- ttcs: treshold of cumulative temperature, default: 325 <br />
- pldmin: minimal pelagic larval duration of the selected species, default: 20 <br />
- pldmax: maximal pelagic larval duration of the selected species, default: 45 <br />
- sd : duration of the spawning period, default: 30 <br />
- token: The telegram bot token, default: 5267228188:AAGx60FtWgHkScBb3ISFL1dp6Oq_9z9z0rw <br />
- chat_id: The telegram chat id, default: -1001573378021 <br />
- bulletin: File path of the bulletin to be sent, default: ./output/bulletin.png <br />
- method: Method used for sending bulletin, file or URL, default: file <br />

To run the container:<br />

- "docker run forcoast-sm-a4 ptm tt gdt ttcs pldmin pldmax sd token chat_id bulletin method" all parameters need to be given
- Example with default values: "docker run forcoast-sm-a4 1 9 7 325 20 45 30 5267228188:AAGx60FtWgHkScBb3ISFL1dp6Oq_9z9z0rw  -1001573378021 ./output/bulletin.png file"
