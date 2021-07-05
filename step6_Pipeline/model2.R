library(rsyncrosim)      # Load SyncroSim R package
library(raster)          # Load raster package
myScenario <- scenario()  # Get the SyncroSim scenario that is currently running

# Create temporary folder for storing rasters
tempFolderPath <- envTempFolder("OutputExportMap2")

# Load RunControl datasheet to be able to set timesteps
runSettings <- datasheet(myScenario, name = "helloworldEnhanced_RunControl")

# Get sequence of all timesteps for all iterations
Timesteps <- rep(seq(runSettings$MinimumTimestep,
                     runSettings$MaximumTimestep),
                 runSettings$MaximumIteration)

# Get sequence of iterations
Iterations <- rep(1:runSettings$MaximumIteration,
                  each = length(Timesteps) / runSettings$MaximumIteration)

# Load raster input 
rasterMap <- datasheetRaster(
  myScenario,
  datasheet = "helloworldEnhanced_IntermediateDatasheet",
  column = "InterceptRasterFileName"
)

# Setup empty R dataframe ready to accept output in SyncroSim datasheet format
myOutputDataframe <- datasheet(myScenario,
                               name = "helloworldEnhanced_OutputDatasheet")


# Classify values in raster to output
classes <- c(-Inf, -10, 1,
             -10, 0, 2,
             0, 10, 3,
             10, 20, 4,
             20, Inf, 5)
classes_mat <- matrix(classes, ncol = 3, byrow = T)
newRasterMaps <- reclassify(rasterMap, classes_mat)

# Add the new raster for this timestep/iteration to the output
newRasterNames <- file.path(paste0(tempFolderPath, 
                                   "/rasterMap_iter", Iterations, "_ts",
                                   Timesteps, ".tif"))
writeRaster(newRasterMaps, filename = newRasterNames,
            format = "GTiff", overwrite = TRUE, bylayer = TRUE)

# Copy the relevant outputs into a dataframe
myOutputDataframe <- data.frame(Iteration = Iterations,
                                Timestep = Timesteps, 
                                InterceptRasterFileName = newRasterNames)

# Save this R dataframe back to the SyncroSim library's output datasheet
saveDatasheet(myScenario,
              data = myOutputDataframe,
              name = "helloworldEnhanced_OutputDatasheet")
