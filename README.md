# helloworldEnhanced

The helloworldEnhanced Package suite is intended as an example of how to add more advanced features to a simple [SyncroSim]( https://syncrosim.com/ ) package.  Instructions on how to develop the base Hello World package from scratch are posted in the SyncroSim documentation on [creating a package](http://docs.syncrosim.com/how_to_guides/package_create_bundle.html). Instructions on how to enhance this base Hello World package are posted in the SyncroSim documentation on [enhancing a package](http://docs.syncrosim.com/how_to_guides/package_create_timesteps.html).

This directory contains the code to replicate each step in the [enhancing a package](http://docs.syncrosim.com/how_to_guides/package_create_timesteps.html) tutorial, as well as the bundled *.ssimpkg* files for each step. The Packages in the helloworldEnhanced Package suite correspond to the steps in the [enhancing a package](http://docs.syncrosim.com/how_to_guides/package_create_timesteps.html) tutorial:

1. **Adding Timesteps:** `helloworldTime`

2. **Representing Uncertainty:** `helloworldUncertainty`

3. **Linking Models:** `helloworldPipeline`

4. **Integrating Spatial Data:** `helloworldSpatial`

To install each step of the helloworldEnhanced Package suite, you can do either of the following:

1. Use the SyncroSim package manager directly to install the .ssimpkg for a specific step.

* Clone this repository

```
git clone https://github.com/ApexRMS/helloworldEnhanced
```

* Navigate to the folder of the step you want to install (e.g. **helloworldTime**)

```
cd helloworldEnhanced/helloworldTime
```

* Install using the package manager `--finstall` command (Note: include the entire path to the package manager executable)

```
SyncroSim.PackageManger.exe --finstall=helloworldEnhanced.ssimpkg
```

* Check if installation succeeded

```
SyncroSim.PackageManager.exe --installed
```

2. Use the `auto-install.ps1` script in powershell.

* Clone this repository

```
git clone https://github.com/ApexRMS/helloworldEnhanced
```

* Open the `auto-install.ps1` script in a text editor

* Replace **<WORKING FOLDER>** with the location of your *working folder* (e.g. **c:\temp**)

* Replace **<STEP>** with the step you want to install (e.g., **helloworldSpatial**)

* Run the script from *powershell*

```
.\auto-install.ps1
```