# DevOps Projects

A collection of shell scripts designed to automate system setup, software installation, and host configuration. This project provides a structured approach to bootstrapping a system using a configuration file stored on a USB or virtual drive.

## Overview

The project is built around a sequence of scripts that are executed on system startup. The overall workflow involves:
- **Mounting** a configuration drive.
- **Parsing** a configuration file for required software and settings.
- **Installing** necessary software.
- **Configuring** the host system according to the provided parameters.

## Project Structure

- **system_setup.sh**  
  *Location:* `profile.d/`  
  *Description:* This is the entry-point script that triggers the sequence of scripts during system startup.

- **Configuration File**  
  *Naming Convention:* Must follow the format `Name-config.cfg` (e.g., `ronn-config.cfg.txt`).  
  *Location:* The configuration file should reside on a USB or virtual drive to be accessible by the scripts.

- **configlib.sh**  
  *Description:* A library of reusable functions. These functions are used by the other scripts to keep code DRY (Don't Repeat Yourself) and maintain consistency.

- **configmount.sh**  
  *Description:*  
  - Maps the relevant block device.
  - Mounts the device to `/mnt/config_disk`.
  - Searches for the configuration file on the mounted drive.
  - Spawns two child bash processes to run the subsequent scripts.  
  *Note:* This approach ensures that a reference to the configuration file is passed along the chain of scripts.

- **software_setup.sh**  
  *Description:*  
  - Reads an array of required software from the configuration file.
  - Installs the listed software using functions provided in `configlib.sh`.

- **confighost.sh**  
  *Description:*  
  - Applies system configuration settings as defined in the configuration file.
  - Acts as the final step in the setup sequence.

## Prerequisites

- A Unix-like operating system (Linux, BSD, etc.)
- A USB or virtual drive containing the configuration file.
- Administrative privileges to mount devices and install software.

## Setup and Usage

1. **Prepare the Configuration File:**  
   - Create a configuration file using the naming format `Name-config.cfg` (e.g., `ronn-config.cfg.txt`).
   - Populate the file with the required parameters, including an array of software packages to install and any system configuration settings.

2. **Place the Configuration File:**  
   - Copy the configuration file to a USB or virtual drive that is accessible to your system.

3. **Execution Flow:**  
   - Please Insert the ISO image to a virtualization software like virtualbox or VMware.
   - Ensure that your virtial drive or USB drive are inserted in the storage section.
   - Setup the ISO, when it boots it will ask you a passowrd to sudo.
   - after you provide sudo passowrd the system_setup will begin.

## ISO File Note

Due to its large size, the ISO file used for demonstration purposes is not included in this repository. It has been tested and will be available for demonstration on request.

## Contributing
Ron Negrov


## Acknowledgements

This project was developed to streamline system setup and configuration, providing a reproducible and efficient approach to DevOps practices.

---


![image](https://github.com/user-attachments/assets/84c496b0-c975-465c-8bd2-c7d7032d4dc7)



