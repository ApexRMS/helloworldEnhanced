# Load SyncroSim python package
import sys
sys.path.append("C:/gitprojects/pysyncrosim") # this part will be removed once we release
import pysyncrosim as ps

# Load numpy and pandas
import numpy as np
import pandas as pd

# Get the SyncroSim Scenario that is currently running
myScenario = ps.Scenario()

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
my_input_dataframe = myScenario.datasheets(name="IntermediateDatasheet")

# Set up empty pandas DataFrame to accept output values
my_output_dataframe = myScenario.datasheets(name="OutputDatasheet")

# For loop through iterations
for i in range(1, run_settings.MaximumIteration.item() + 1):

    # Report progress bar
    ps.progress_bar(report_type="step")
    ps.progress_bar(report_type="report", iteration=i, timestep=0)
    
    # Only load y for this iteration
    y = my_input_dataframe[my_input_dataframe["Iteration"] == i].y
    
    # Do calculations
    y_cum = np.cumsum(y)

    # Store relevant output in temporary data frame
    temp_data_frame = pd.DataFrame({"Timestep": timesteps,
                                    "Iteration": [i] * len(y_cum),
                                    "yCum": y_cum})

    # Append temporary data frame to output data frame
    my_output_dataframe = my_output_dataframe.append(temp_data_frame)

# Save the output DataFrame to the Scenario output Datasheet
myScenario.save_datasheet(name="OutputDatasheet",
                          data=my_output_dataframe)

# End progress bar
ps.progress_bar(report_type="end")
