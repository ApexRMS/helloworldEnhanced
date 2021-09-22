# Load SyncroSim python package
import sys
sys.path.append("C:/gitprojects/pysyncrosim") # this part will be removed once we release
import pysyncrosim as ps

# Load rasterio package
import rasterio

# Load numpy and pandas
import numpy as np
import pandas as pd

# Get the SyncroSim Scenario that is currently running
myScenario = ps.Scenario()

# Create a temporary folder for storing rasters
temp_folder_path = ps.runtime_temp_folder("OutputExportMap")

# Load Run Control Datasheet to set timesteps
run_settings = myScenario.datasheets(name="RunControl")

# Start progress bar
max_t = run_settings.MaximumTimestep.item()
max_i = run_settings.MaximumIteration.item()
total_steps = max_t * max_i
ps.progress_bar(report_type="begin", total_steps=total_steps)

# Set timesteps
timesteps = np.array(range(run_settings.MinimumTimestep.item(),
                           run_settings.MaximumTimestep.item() + 1))

# Load Scenario's input Datasheet from SyncroSim Library into DataFrame
my_input_dataframe = myScenario.datasheets(name="InputDatasheet")

# Extract model inputs from Input DataFrame
m_mean = my_input_dataframe.mMean.item()
m_sd = my_input_dataframe.mSD.item()

# Load raster input
raster_map = myScenario.datasheet_raster(datasheet="InputDatasheet",
                                         column="InterceptRasterFile")
raster_values = raster_map[0].values

# Set up empty pandas DataFrame to accept output values
my_output_dataframe = myScenario.datasheets(name="IntermediateDatasheet",
                                            empty=True)

# For loop through iterations
for iter in range(1, max_i + 1):

    # Report progress bar
    ps.progress_bar(report_type="step")
    ps.progress_bar(report_type="report", iteration=iter, timestep=0)
    
    # Extract a slope value from normal distribution
    m = np.random.normal(loc=m_mean, scale=m_sd)
    
    # Use each cell in the raster as the intercept in linear equation
    new_raster_list = [np.add(raster_values, x) for x in timesteps * m]

    filename_list = []
    for ts in range(0, len(timesteps)):
        filename = f"{temp_folder_path}/rasterMap_iter{iter}_ts{ts}.tif"
        with rasterio.open(filename, "w", driver="GTiff",
                           height=raster_values.shape[0],
                           width=raster_values.shape[1],
                           count=1, dtype=raster_values.dtype,
                           crs=raster_map[0].crs) as infile:
            infile.write(new_raster_list[ts], indexes=1)
        filename_list.append(filename)

    # The y value will be the sum of all the cells in each raster
    y = [np.sum(x) for x in new_raster_list]


    # Store relevant output in temporary data frame
    temp_data_frame = pd.DataFrame({"Timestep": timesteps,
                                    "Iteration": [iter] * len(y),
                                    "y": y,
                                    "OutputRasterFile": filename_list})

    # Append temporary data frame to output data frame
    my_output_dataframe = my_output_dataframe.append(temp_data_frame)

# Save the output DataFrame to the Scenario output Datasheet
myScenario.save_datasheet(name="IntermediateDatasheet",
                          data=my_output_dataframe)

# End progress bar
ps.progress_bar(report_type="end")
