# Setting up an ICMPtunnel demo on Docker

Following are my notes on setting up a basic 5-container network to demonstrate the use of an ICMPtunnel.  The architecture is based on vanilla Ubuntu containers, OpenVSwitch, iproute2, and the icmptunnel utility by Dhaval Kapil. Links to source material are at the end of this file.

I've attempted to obfuscate much of the architecture generation stuff by automating it.  It will generate the architecture depicted in the architecture.png file.

## Assumptions/Disclaimers

- Unless otherwise noted, all commands in the below are executed as root.
- It is assumed that you understand the basic use of Docker (the build, run, and exec functions).
- This demo is intended for use by Tidewater Community College's Cyber Club (TC4), for use in creating additional CTF challenges,
- This demo is intended to be built on your desktop machine, which is running Docker and OpenVSwitch. This is because the build script installs a  Wireshark container which you will access via http://127.0.0.1:3001.  For Ubuntu users, Dpcler and OpenVSwitch can be installed via:
```c
apt-get install -y docker.io openvswitch-switch
```
All other binaries will be installed via the scripts in this repo.
- Is is recommended that your read and underrstand each script/file before running any of the scripts.  I've added commentary to each, to help explain what each command does.

## Steps for setup

1) If the files aren't already executable, run the following:
    
    ```c
    chmod a+x build build-images client destroy destory-images proxy
    ```

2) Create the images via:
    
    ```c
    ./build-images
    ```
    
    Note: the first time that you run this, it will take a couple minutes to build the 5 local images.

3) Deploy the containers by running the build script:
    
    ```c
    ./build
    ```

4) Check that all 5 containers (wireshark, boxa, boxb, boxc, and boxd) have been deployed, by running:
    
    ```c
    docker ps
    ```
    
    If not all 5 are running, scroll back through the "./build" script's output and look for errors.  If that doesn't show anything untowards, try running:
    
    ```c
    docker logs container_name
    ```
    
    where "container_name" is the name of the missing container.

5) Access the command line of the proxy (running the server end of the tunnel), and create the server end of the tunnel by running:
    
    ```c
    nohup ./icmptunnel -s 10.0.1.1 &
    exit
    ```
    
    Note: I've created a couple scripts (client, proxy), to access the containers, that will save keystrokes.  Look at their source code to see how they work.

6) To create the "local" end of the tunnel, access the command line of the client and run:
    
    ```c
    nohup ./icmptunnel -c 10.2.2.2 &
    ```

7) Point your browser at http://127.0.0.1:3001 and resize the window as desired.  Select eth1 as the interface.

8) Back in the client command line, run the following:
    
    ```c
    lynx http://192.168.9.2/images.jpeg
    ```
    
    Follow the prompts to download the file to disk.  If you receive a file called images.jpeg, that is 5662 in size, then it worked.  Take a look at your wireshark display.  You should notice that the file transfer was made over ICMP.

## Additional research

In the packet capture, you'll see some spurious echo requests with a "no response found!" message at the end. I think this might be caused by not disabling ICMP response from the containers hosting either end of the tunnel.  If anyone's interested in experimenting, try configuring the container to ignore ICMP (the software will still respond to received ICMP packets).

## Sources

- https://dhavalkapil.com/icmptunnel/
- https://github.com/DhavalKapil/icmptunnel/
- architecture image was generated via: https://app.diagrams.net/
