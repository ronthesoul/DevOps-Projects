
####Hey Alex,
This project works well, i tried to add the ISO but i was unable to attach it here due to it's size. I will show you that the iso file works on tuesday. 

Structure of the project: 

**system_setup.sh script** - is located in profile.d and is ment to start the sequence of the scripts in start time. 

**Any config file** that it's name should be in the format "Name"-config.cfg* i used ronn-config.cfg.txt the config file should be located in a usb or virtual drive. 

**configlib.sh -** A library that is ment to store functions that could be used by all of the scripts. 

**configmount.sh -** The first script, maps the relevnt block device, mounts it to /mnt/config_disk and then to search for the config file, this scripts also spawns two bash child process that were ment to run the other scripts. 
this approach was taken so the pointer varible of the config file would be passed to the rest of the scripts. 

**software_setup.sh -** The seconds scripts, takes an array of the required softwares from the config file and installs them, uses a function from the configlib.sh file. 

**confighost.sh -** the third and finale script that is ment to configure the system by the config file. 




![image](https://github.com/user-attachments/assets/84c496b0-c975-465c-8bd2-c7d7032d4dc7)



