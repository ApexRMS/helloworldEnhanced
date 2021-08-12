# Load libraries
library(raster)
library(this.path)

# Set working directory
setwd(this.dir())

# Create a new raster with the following dimensions
r <- raster(ncol=5, nrow=5, xmn=-1, xmx=1, ymn=-1, ymx=1)

# Assign values to all the cells in the raster using a normal dist
values(r) <- rnorm(ncell(r))

# Plot to see how it looks
plot(r)

# Write raster data to a file
writeRaster(r, filename = "input-raster.tif", writeFormats="GTiff")

