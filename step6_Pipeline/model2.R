library(rsyncrosim)      # Load SyncroSim R package
library(raster)          # Load raster package
myScenario <- scenario()  # Get the SyncroSim scenario that is currently running

# Create temporary folder for storing rasters
tempFolderPath <- envTempFolder("OutputExportMap")

# Load RunControl datasheet to be able to set timesteps
runSettings <- datasheet(myScenario, name = "helloworldEnhanced_RunControl")

# Set timesteps - can set to different frequencies if desired
Timesteps <- seq(runSettings$MinimumTimestep, runSettings$MaximumTimestep)

# Load raster input 
rasterMap <- datasheetRaster(myScenario,
                             datasheet="helloworldEnhanced_IntermediateDatasheet",
                             column="RasterFileName")

# Setup empty R dataframe ready to accept output in SyncroSim datasheet format
myOutputDataframe <- datasheet(myScenario,
                               name = "helloworldEnhanced_OutputDatasheet")

# For loop through iterations
for (iter in runSettings$MinimumIteration:runSettings$MaximumIteration) {
  
  # Classify values in raster to output
  classes <- c(-Inf, -10, "Very Low",
               -10, 0, "Low",
               0, 10, "Medium",
               10, 20, "High",
               20, Inf, "Extreme")
  classes_mat <- matrix(classes, ncol=3, byrow=T)
  newRasterMap <- reclassify(rasterMap, classes_mat)
  
  # Extract a slope value from normal distribution
  b <- rnorm(n = 1, mean = bMean, sd = bSD)
  
  newRasterMaps <- calc(rasterMap, function(m) m * Timesteps + b,
                        forceapply=TRUE)
  
  # Add the new raster for this timestep/iteration to the output
  newRasterNames <- file.path(paste0(tempFolderPath, 
                                     "/rasterMap_iter", iter, "_ts",
                                     Timesteps, ".tif"))
  writeRaster(newRasterMaps, filename=newRasterNames,
              format="GTiff", overwrite=TRUE, bylayer=TRUE)
  
  # Store the relevant outputs in a temporary dataframe
  tempDataframe <- data.frame(Iteration = iter,
                              Timestep = Timesteps, 
                              RasterFileName = newRasterNames)
  
  # Copy output into this R dataframe
  myOutputDataframe <- addRow(myOutputDataframe, tempDataframe)
}

# Save this R dataframe back to the SyncroSim library's output datasheet
saveDatasheet(myScenario,
              data=myOutputDataframe,
              name="helloworldEnhanced_IntermediateDatasheet")