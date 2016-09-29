# NetIDE Eclipse Plug-In Workbench

## Usage

### SSH Connection
To use a ssh connections the following steps need to be taken.

1. Configure SSH
1.1. Key generate: use `ssh-keygen -b 4096` with the standard options, to generate a key set.
1.2. Transfer key: use `ssh-copy-id -p <port> <boxName>@<ip>` to transfer the generated key. If you have more than one ssh-id file specify it by using `-i <ssh-id-file>` option.
1.3. Check ssh connection: use `ssh -p <port> <boxName>@<ip>` to check if a ssh connection can be established.
1.4. Make sure the specified box is running before continuing.

2. Setup SSH Profile
Username: username for the ssh connection
Port: port used for the connection
SSH ID File: SSH ID File corresponding to the key used in step 1.2.
Host: IP of the target machine

Karaf (Core): Path to the bin folder of the core installation on the target machine.
ODL Shim: Path to the bin folder of the odl installation on the target machine.

## Examples

![Alt text](/ExampleConfig.png?raw=true " ")
