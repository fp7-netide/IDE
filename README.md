# NetIDE Eclipse Plug-Ins

This Repository contains the plug-ins needed for a graphical network editing and the generation of platform-specific code.

### Requirements

In order to use NetIDE to its full extend, you need to install [VirtualBox](http://virtualbox.org) and [Vagrant](http://www.vagrantup.com). NetIDE deploys your network apps on virtual machines which are set up and managed with vagrant.

In order to execute commands on your VM through the IDE, you also need an installation of SSH. If you are running Windows, make sure that your ssh executable is referenced in the PATH variable.

You'll also need at least Java 8.

## Installation

### ...using the Eclipse Marketplace
1. Open your Eclipse installation and navigate to ```Help->Eclipse Marketplace...``` in the Menubar. 
2. Search for ```NetIDE```, click ```Install``` and follow the instructions. After restarting Eclipse, NetIDE is ready to run.

Alternatively, you can drag the button below into your running Eclipse window.

<a href="http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=2428949" class="drag" title="Drag to your running Eclipse workspace to install NetIDE"><img src="http://marketplace.eclipse.org/sites/all/themes/solstice/_themes/solstice_marketplace/public/images/btn-install.png" alt="Drag to your running Eclipse workspace to install NetIDE" /></a>

### ...using the Update Site
1. Open your Eclipse installation and navigate to ```Help->Install New Software...```. 
2. Enter ```http://updatesite.netide.eu/stable``` for a stable installation or ```http://updatesite.netide.eu/nightly``` for nightly builds.
3. Select ```NetIDE``` click ```Next``` and follow the instructions. After restarting Eclipse, NetIDE is ready to run.


### ...by building from source

Navigate to the folder ```releng/eu.netide.parent``` and type ```mvn package```. The build process can take some time.

Once it has finished, you'll find the contents of an eclipse update site as a zip file in ```releng/eu.netide.product/target```.

Open your Eclipse installation, go to ```Help->Install New Software->Add->Archive``` and enter the location of the zip file.

Select NetIDE from the list and follow the instructions. After restarting Eclipse, NetIDE is ready to run.



### Set up Eclipse

1. Download Eclipse Mars or Luna Modeling Tools at www.eclipse.org.
2. From the window menu, select `Help -> Install Modeling Components`. Select and install Sirius and Xtext.
3. Go to `Help -> Eclipse Marketplace...`, search for and install TM Terminal.
4. Go to `Help -> Install New Software`, enter [http://updatesite.netide.eu/dependencies](http://updatesite.netide.eu/dependencies), and install the packages provided by this repository.
5. Start Eclipse and open the Git Perspective.
6. Clone or add this git repository and import all projects from the "plugins"-folder into your workspace. To do so, enter to the folder "Working Directory", right-click on the folder "plugins" and select "Import Projects". Follow the steps in the wizard.
7. Open the Plug-In Development perspective and open eu.netide.configuration/model/Topology.genmodel. Right-click the root element in the tree view and select `Generate All`
8. For both projects "eu.netide.parameters.language" and "eu.netide.sysreq", do the following:
    1. Find the \*.mwe2 file in the source folder.
    2. Right-click on the mwe2 file and select "Run As -> MWE2 Workflow". A dialog box should pop up informing you about errors in the project. Click "Proceed".
    3. A console view in the bottom region will appear and ask you to install the Antlr parser. Type "y" into the console and hit Return.
9. Right-click the project eu.netide.configuration and select `Run As -> Eclipse Application`
10. If you want to develop your Python-based controllers in Eclipse as well, you can install the [PyDev](http://www.pydev.org/) plug-in for Eclipse from the Eclipse Marketplace.

## Usage

Consult the [wiki pages](https://github.com/fp7-netide/IDE/wiki) for a detailed usage manual.

## Examples

For examples, have a look at the examples folder. You can import the examples into your runtime workspace from there.

## Troubleshooting

### Vagrant does not start when running a launch configuration

If Vagrant displays the error message `The box 'ubuntu/trusty64' could not be found`, make sure you have installed a recent version of vagrant. For example, the version in the repositories for Ubuntu 14.04 LTS (1.4.3-1) is too old. After upgrading Vagrant, it may be necessary to remove the directory `~/.vagrant.d`.

If your vagrant executable is not in a standard location (`/usr/bin/vagrant` or `C:\Hashicorp\Vagrant\bin\vagrant.exe`) you have to enter your custom location under "Window -> Preferences -> NetIDE".

### Generating mininet configurations fails with "The chosen operation is not currently available"

This error occurs if the projects in the `plugins`-folder have not been imported properly. They have to be imported as Projects, or, in the case of `eu.netide.configuration`, as General Projects. The simplest way to do this is to right-click the `plugins`-folder in the Git perspective and choosing "Import Projects..." from the menu.

### Compiler errors after pulling

The code you just pulled may use a more recent version of the Topology meta-model. If you run into compiler errors, just repeat step 7 and 8 from the Installation guide. This generates new model code from the newest version of the meta-model.

### Large amounts of disk space used

NetIDE creates a VM for each topology modeling project to set up a clean simulation environment. Delete the gen folder in your project and open the Virtualbox GUI to delete the VM completely, once you do not need it anymore.
