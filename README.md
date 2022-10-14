# ForCoast-SM-A4

### Description

The service module offers a time window estimate where spat are likely to arrive in your site from different source location. Based on environmental condition service module detect spawning events, hence the module computes a spawning period and a delay between spawning and spat settlement to assess the period  where  spat could  be  collected. 

### How to run

* Containerize contents in docker
* Run the command Docker run forcoast/forcoast-sm-a4 &lt;ptm> &lt;tt> &lt;gdt> &lt;ttcs> &lt;pldmin> &lt;pldmax> &lt;sd> &lt;token> &lt;chat_id> &lt;bulletin> &lt;method>
  * ptm : switch temperature threshold (0) or cumalitve temperature (1), default: 1
  * tt: threshold temperature, default: 9
  * gdt: threshold of temperature for gonade development, default: 7
  * ttcs: threshold of cumulative temperature, default: 325
  * pldmin: minimal pelagic larval duration of the selected species, default: 20
  * pldmax: maximal pelagic larval duration of the selected species, default: 45
  * sd : duration of the spawning period, default: 30
  * token: The telegram bot token, default: 5267228188:AAGx60FtWgHkScBb3ISFL1dp6Oq_9z9z0rw
  * chat_id: The telegram chat id, default: -1001573378021
  * bulletin: File path of the bulletin to be sent, default: ./output/bulletin.png
  * method: Method used for sending bulletin, file or URL, default: file
* Example of use: Docker run forcoast/forcoast-sm-a2 eforie 2022-07-09 3 github https://raw.githubusercontent.com/FORCOAST/ForCoast-A2-Settings/Eforie_case_1/config.yaml https://raw.githubusercontent.com/FORCOAST/ForCoast-A2-Settings/Eforie_case_1/sources.txt https://raw.githubusercontent.com/FORCOAST/ForCoast-A2-Settings/Eforie_case_1/targets.txt /usr/src/app/data/ 5267228188:AAGx60FtWgHkScBb3ISFL1dp6Oq_9z9z0rw -1001780197306

### Licence

Licensed under the Apache License, Version 2.0
