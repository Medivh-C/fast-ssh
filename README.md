# Fast SSH

 It is specifically provided for Mac, because there are many apps that can log in to remote servers on windows.
   
 The method of logging in to the remote server is similar to the bastion machine selection interface, just select the desired computer serial number. Including ssh and sftp.

## Installation
 *Depends on `expect`, please install `expect` first.*
 
 The following are the installation steps:  
 1. brew install expect
 2. git clone https://github.com/Medivh-C/fast-ssh.git
 3. cd fast-ssh && ./install.sh
 
## Add hosts
 1. cd ~/fast-ssh/bastion
 2. ./fast-ssh.sh -a
 
## Usage
 1. cd ~/fast-ssh/bastion
 2. ./fast-ssh.sh
 
 
