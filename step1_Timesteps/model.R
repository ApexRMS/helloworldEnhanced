library(rsyncrosim)      # Load SyncroSim R package
myScenario <- scenario()  # Get the SyncroSim scenario that is currently running

# Load RunControl datasheet to be able to set timesteps
runSettings <- datasheet(myScenario, name = "helloworldEnhanced_RunControl")

# Set timesteps - can set to different frequencies if desired
setTimestep <- seq(runSettings$MinimumTimestep, runSettings$MaximumTimestep)

# Load scenario's input datasheet from SyncroSim library into R dataframe
myInputDataframe <- datasheet(myScenario,
                              name = "helloworldEnhanced_InputDatasheet")

# Modify input dataframe so values of x and a are specified for each timestep
allTimesteps <- data.frame(Timestep = setTimestep)
completeInput <- merge(myInputDataframe, allTimesteps, all = T)
completeInput$x <- na.omit(completeInput$x)[cumsum(!is.na(completeInput$x))]
completeInput$a <- na.omit(completeInput$a)[cumsum(!is.na(completeInput$a))]

# Extract model inputs from complete input dataframe
x <- completeInput$x
a <- completeInput$a

# Do calculations
y <- x * setTimestep + a

# Setup empty R dataframe ready to accept output in SyncroSim datasheet format
myOutputDataframe <- datasheet(myScenario,
                               name = "helloworldEnhanced_OutputDatasheet")

# Copy output into this R dataframe
myOutputDataframe <- data.frame(Timestep = setTimestep, y = y)

# Save this R dataframe back to the SyncroSim library's output datasheet
saveDatasheet(myScenario,
              data=myOutputDataframe,
              name="helloworldEnhanced_OutputDatasheet")