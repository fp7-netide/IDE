# NetIDE Eclipse Plug-Ins

This Repository contains the plug-ins needed for a graphical network editing and the generation of platform-specific code.

## Installation

1. Download Eclipse Luna Modeling Tools at www.eclipse.org.
2. Start Eclipse and open the Git Perspective.
3. From the window menu, select "Help -> Install Modeling Components". Select and install XText.
4. Clone or add this repository and import all projects in the "plugins"-folder into your workspace. Import "eu.netide.configuration" as a general project.
5. Go back to the Java perspective and open eu.netide.configuration/model/Topology.genmodel
6. Right-click the root element in the tree view and select "Generate All"
7. Right-click the project eu.netide.configuration and select "Run As -> Eclipse Application"
8. In the new eclipse instance, clone or add this repository like in step 3 and import the project "Network.design"
9. You're good to go!

## Usage

In order to model network environments, we first need a new modeling project and a new network model.

1. Open the modeling perspective.
2. Right-click the Model Explorer view and select "New -> Modeling Project"
3. Right-click the newly created project and select "New -> Other". From the thereby opened view, select "Example EMF Model Creation Wizards -> Topology Model". Give it a name and select Network Environment as the Model Object.
4. Right-click your modeling project again and choose "Viewpoints Selection". From there, choose "Topology".
5. Expand your model in the Model Explorer, right-click the Network Environment and select "New Representation -> new NetworkEnvironment".
6. There is your graphical editor.

Once you have modeled a network environment, you might want to generate a mininet configuration for simulation purposes. Here is how it works:

1. Expand your topology model in the Model Explorer
2. Right-click the Network Environment model
3. Select "Generate Mininet Configuration"
4. A folder named "gen/mininet" containing a configuration class should appear in your modeling project.

## Troubleshooting

*Compiler errors after pulling*

The code you just pulled may use a more recent version of the Topology meta-model. If you run into compiler errors, just repeat step 5 and 6 from the Installation guide. This generates new model code from the newest version of the meta-model.
