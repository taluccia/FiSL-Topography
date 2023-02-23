# Wrapper functions for terrain based metrics (hydroplogy, morphology, anemology)
# v. September 11, 2014
# 
#  Change log:
#  September 2014  Added wetnessindex wrapper function 

# Helper function to Calculate cellsize of a saga grid or an ascii grid based on header information
#  (extensions .sgrd or .asc)
get.cellsize <- function(x){
  # x = path to a X.sgrd file.
  # this returns the cellsize from the file
  l <- readLines(con=x, n=20)
  l <- grep("CELLSIZE", l, value=TRUE)
  stopifnot(length(l)==1)
  cellsize <- as.numeric(gsub("[^[:digit:]\\.]", "", l ))
  cellsize
}


#### Hydro ##### 

hydro <- function(input, outdir, workspace, env=env) {
  # Arguments:
  #  input : the path to an input grid in SAGA format (without the .sgrd extension)
  # output : the path to the final output for the raster (package) file.  It should have the 
  #    placeholder "[metric]" which will be replaced with the individual hydro metric names.
  # workspace : the working directory where intermediate files will be created.  There should NOT 
  #    be anything important in this directory.
  # env : the rsaga environment in which to do the processing (optional) but required if you
  #    don't want to use the default.
  stopifnot(require(RSAGA), require(raster))
  output <- "[outdir]/[input]_hydro_[metric]"
  outdir <- gsub("/$", "", outdir) # drop trailing "/"
  output <- gsub("[outdir]", outdir, output, fixed=TRUE)
  
  
  gsub("/*$", "/", workspace) # ensure trailing "/" 
  ow <- getwd()
  on.exit(setwd(ow))
  setwd(workspace)
  
  if(!grepl("\\.sgrd$", input))  
    input <- paste(input, ".sgrd", sep="")
  if(!file.exists(input)) stop("Couldn't find file:", input)
  
  verbose = TRUE
  
  # output is expected to have [metric] in path.
  # eg:  output <- "a/long/path/[metric]"
  
  metrics <- c("carea", "cheight", "cslope", "caspect", "cflowpath")
  
  setwd(workspace)
  if(verbose) cat("Running hydro on '", input, "'\n", sep="")
  rsaga.parallel.processing(in.dem=input, out.carea = "carea", out.cheight = "cheight", 
                            out.cslope = "cslope", out.caspect = "caspect", 
                            out.flowpath = "cflowpath", method = "mfd", linear.threshold = Inf, 
                            convergence = 1.1, env = env)
  
  ## next convert .sdat to raster, then write raster to disk
  if(verbose) cat("Converting output to Raster files.\n")
  input.name <- gsub("^.*/", "", input)  # lop of all but the filename
  input.name <- gsub(".[^.]*$", "", input.name) # remove extension
  for(metric in metrics){
    if(verbose)cat(".")
    # metric <- metrics[1] # for testing
    file <- paste(workspace, metric, ".sdat",  sep="")  # path to file in working directoty
    if(!file.exists(file)) stop("Expected ouput grid '", file, "' wasn't found.")
    o <- gsub("[metric]", metric, output, fixed=TRUE) # make output path for this metric
    o <- gsub("[input]", input.name, o, fixed=TRUE)
    r<-raster(x=file, native=TRUE)
    writeRaster(r, filename=o, overwrite=TRUE)
  }
  if(verbose) cat("\nDone with Hydro call.\n")
}

#### Morpho ##### 

## local morphometry, 3 x 3 window
morpho<-function(input, outdir, workspace, env=env()) {
  stopifnot(require(RSAGA), require(raster))
  # Arguments:
  #  input : the path to an input grid in SAGA format (without the .sgrd extension)
  # output : the path to the final output for the raster (package) file.  It should have the 
  #    placeholder "[metric]" which will be replaced with the individual hydro metric names.
  # workspace : the working directory where intermediate files will be created.  There should NOT 
  #    be anything important in this directory.
  # env : the rsaga environment in which to do the processing (optional) but required if you
  #    don't want to use the default.
  
  output= "[outdir]/[input]_morpho_[metric]"
  outdir <- gsub("/$", "", outdir) # drop trailing "/"
  output <- gsub("[outdir]", outdir, output, fixed=TRUE)
  
  verbose = TRUE
  
  gsub("/*$", "/", workspace) # ensure trailing "/" 
  ow <- getwd()
  on.exit(setwd(ow))
  setwd(workspace)
  
  # Add extension to input file name
  if(!grepl("\\.sgrd$", input))  
    input <- paste(input, ".sgrd", sep="")
  if(!file.exists(input)) stop("Couldn't find file:", input)
  
  metrics <- c("slope", "aspect", "curv","hcurv", "vcurv")
  if(verbose) cat("Running morpho on '", input, "'\n", sep="")
  rsaga.local.morphometry(in.dem=input, out.slope = "slope", out.aspect = "aspect", 
                          out.curv = "curv", out.hcurv = "hcurv", out.vcurv = "vcurv",
                          method = "poly2zevenbergen", env = env)
  
  ## next convert .sdat to raster, then write raster to disk
  input.name <- gsub("^.*/", "", input)  # lop of all but the filename
  input.name <- gsub(".[^.]*$", "", input.name) # remove extension
  if(verbose) cat("Converting output to raster (R package) files.\n")
  for(metric in metrics){   
    # metric <- metrics[1] # for testing
    file <- paste(workspace, metric, ".sdat",  sep="")  # path to file in working directoty
    if(!file.exists(file)) stop("Expected ouput grid '", file, "' wasn't found.")
    o <- gsub("[metric]", metric, output, fixed=TRUE) # make output path for this metric
    o <- gsub("[input]", input.name, o, fixed=TRUE)
    r<-raster(x=file, native=TRUE)
    writeRaster(r, filename=o, overwrite=TRUE)
    if(verbose)cat("\t\t", o, "\n", sep="")
  }
  if(verbose) cat("\nDone with Morpho call.\n")
}



wetnessindex <- function(input, outdir, workspace, env=env) {
  
  # Arguments:
  #  input : the path to an input grid in SAGA format (without the .sgrd extension)
  # output : the path to the final output for the raster (package) file.  It should have the 
  #    placeholder "[metric]" which will be replaced with the individual hydro metric names.
  # workspace : the working directory where intermediate files will be created.  There should NOT 
  #    be anything important in this directory.
  # env : the rsaga environment in which to do the processing (optional) but required if you
  #    don't want to use the default.
  
  
  stopifnot(require(RSAGA), require(raster))
  
  verbose = TRUE
  
  gsub("/*$", "/", workspace) # ensure trailing "/" 
  ow <- getwd()
  on.exit(setwd(ow))
  setwd(workspace)
  
  if(!grepl("\\.sgrd$", input))  
    input <- paste(input, ".sgrd", sep="")
  if(!file.exists(input)) stop("Couldn't find file:", input)
  
  input.name <- gsub("^.*/", "", input)  # lop of all but the filename
  input.name <- gsub("\\.[^.]*$", "", input.name) # remove extension
  file.name <- paste(input.name, "_swi", sep="")  
  
  # this produces a [name]_swi.sgrd file in the temporary directory (workspace)
  rsaga.wetness.index(in.dem = input, out.wetness.index = file.name ,env=env)  
  
  if(verbose) cat("Converting output to raster (R package) files.\n")
  
  
  file <- paste(workspace,"/",  file.name, ".sdat",  sep="")  # path to file in working directoty
  if(!file.exists(file)) stop("Expected ouput grid '", file, "' wasn't found.")
  output <- paste(output.dir, file.name, sep="")
  r<-raster(x=file, native=TRUE)
  writeRaster(r, filename=output, overwrite=TRUE)
  
  if(verbose) cat("\nDone with Wetness Index call.\n")
  

}

####### Wind Shelter ######

## windshelter
wind <-function(input, outdir, workspace, env=env, radius=500, direction ){
  stopifnot(require(RSAGA), require(raster))
  # Arguments:
  #  input : the path to an input grid in an ESRI ascii grid format (don't include .asc extension)
  # output : the path to the final output for the raster (package) file.  It can have the 
  #    placeholders:
  #       "[direction]"  will be replaced with the wind direction,
  #       "[radius]"  will be replaced with the radius.
  #       "[input]  will be replaced with the input file name (without extension)
  # workspace : the working directory where intermediate files will be created.  There should NOT 
  #    be anything important in this directory.
  # env : the rsaga environment in which to do the processing (optional) but required if you
  #    don't want to use the default.
  # radius - the radius (in mapunits) within which the windsheltering is calculated
  # direction - the wind direction on which the calculations are based in deg. clockwise from North.
  verbose=TRUE
  
  output <- "[outdir]/[input]_ws[direction]"
  outdir <- gsub("/$", "", outdir) # drop trailing "/"
  output <- gsub("[outdir]", outdir, output, fixed=TRUE)
  
  
  deg2rad <- function(deg) {
    return(deg * (pi/180))
  }
  
  # add extension to input file (if it's not already there)
  if(!grepl("\\.asc$", input))  
    input <- paste(input, ".asc", sep="")
  if(!file.exists(input)) stop("Couldn't find file:", input)
  
  #####################
  ## hardwired tolerance matches pi/4 from inputs. 
  tol =  45  # in degrees
  ######################
  
  tolerance <- deg2rad(tol) 
  direction.rad <- deg2rad(direction)
  cellsize <- get.cellsize(input)  # look up cellsize of sgrd (funtion defined at top)
  radius.cells <- round(radius/cellsize)
  stopifnot(radius.cells > 0)
  
  ctrl<-wind.shelter.prep(radius=radius.cells, 
                          direction=direction.rad, 
                          tolerance=tolerance, 
                          cellsize=cellsize)
  
  input.name <- gsub("^.*/", "", input)  # lop of all but the filename
  input.name <- gsub("\\.[^.]*$", "", input.name) # remove extension
  file.name <- paste(input.name, "_", direction, sep="")
  
  ow <- getwd()
  on.exit(setwd(ow))
  setwd(workspace)
  
  focal.function(in.grid=input, fun=wind.shelter, out.grid.prefix=file.name, control=ctrl, 
                 radius=radius.cells, is.pixel.radius=TRUE, search.mode="circle")
  
  ## next convert .asc to raster, then write raster to disk
  if(verbose) cat("Converting output to raster (R package) files.\n")
  file <- paste(file.name, "_windshelter.asc",  sep="")  # path to temporary .asc in working directoty
  if(!file.exists(file)) stop("Expected ouput grid '", file, "' wasn't found.")
  o <- gsub("[direction]", direction, output, fixed=TRUE)  # output file path
  o <- gsub("[input]", input.name, o, fixed=TRUE)
  o <- gsub("[radius]", radius, o, fixed=TRUE)
  
  r<-raster(x=file, native=TRUE)
  writeRaster(r, filename=o, overwrite=TRUE)
  if(verbose) cat("\t\t", o, "\n", sep="")
  
  if(verbose) cat("\nDone with wind call.\n")
  
}



## relative position
relpos<-function(input, outdir, workspace, env=env){
  stopifnot(require(RSAGA), require(raster))
  verbose=TRUE
  radius = 500 # could become a parameter if need be
  output <- "[outdir]/[input]_relpos"
  outdir <- gsub("/$", "", outdir) # drop trailing "/"
  output <- gsub("[outdir]", outdir, output, fixed=TRUE)
  
  # Set workspace for duration of function
  ow <- getwd()
  on.exit(setwd(ow))
  setwd(workspace)  
  
  # add extension to input file (if it's not already there)
  if(!grepl("\\.asc$", input))  
    input <- paste(input, ".asc", sep="")
  if(!file.exists(input)) stop("Couldn't find file:", input)
  
  cellsize <- get.cellsize(input)  # look up cellsize (funtion defined at top)
  radius.cells <- radius/cellsize  # it sounds like this doesn't have to be an integer
  stopifnot(radius.cells > 0)
  
  # 
  input.name <- gsub("^.*/", "", input)  # lop of all but the filename
  input.name <- gsub("\\.[^.]*$", "", input.name) # remove extension
  
  
  # focal function requires an ascii grid
  if(verbose) cat("Calling focal function (relpos)\n")
  focal.function(in.grid=input, 
                 fun=relative.position, 
                 out.grid.prefix=input.name, 
                 radius=radius.cells, 
                 is.pixel.radius=TRUE, 
                 search.mode="circle")
  
  
  ## next convert .asc to raster, then write raster to disk
  if(verbose) cat("Converting output to raster (R package) files.\n")
  file <- paste(input.name, "_relpos.asc",  sep="")  # path to temporary .asc in working directoty
  if(!file.exists(file)) stop("Expected ouput grid '", file, "' wasn't found.")
  o <- output
  o <- gsub("[input]", input.name, o, fixed=TRUE)
  o <- gsub("[radius]", radius, o, fixed=TRUE) # not currently used but could be if we decide to vary radius
  
  r<-raster(x=file, native=TRUE)
  writeRaster(r, filename=o, overwrite=TRUE)
  file.remove(file) # delete file from working dir
  if(verbose) cat("\nDone with relpos:\t",o, sep="")
}

# Note although this function is using two of the other output grids as inputs
#  I'm still using the standard input path as an argument so that the calling
#   is the same as the other functions.

## TCI is calculated using output from two functions (morph and hydro)
## input files are located in outpath
converg<-function(input, outdir, ...){ 
  # ... is there so we can have workspace and env arguments even though we don't use them
  verbose = TRUE
  stopifnot(require(raster))
  input.name <- gsub("^.*/", "", input)  # lop of all but the filename
  input.name <- gsub("\\.[^.]*$", "", input.name) # remove extension
  outdir <- gsub("/*$", "/", outdir) # enforce trailing "/"
  if(verbose) cat("Starting converge ", input.name, "\n",  sep="")
  cp <- paste(outdir, input.name, "_hydro_carea.grd", sep="")
  sp <- paste(outdir, input.name, "_morpho_slope.grd", sep="")
  missing <- c(!file.exists(cp, sp))
  if(any(missing)) 
    stop("Couldn't find required grid(s): '", 
         paste(c(cp, sp)[missing], collapse="', '"), "'.", sep="")
  
  carea <- raster(cp)
  slope <- raster(sp)
  tci<-log(carea / slope)
  
  file <- paste(outdir, input.name, "_tci", sep="")
  writeRaster(tci, filename=file, overwrite=TRUE)
  if(verbose) cat("Done with converg: '", file, "'\n", sep="")
}
