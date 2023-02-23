




if(FALSE){ # example usage
  
  source("../functions/terrain.function.calls.R") # changed
  calls <- read.csv("../data/callsGirds/calls.csv", stringsAsFactors=FALSE)# changed
  grids <- read.csv("../data/callsGirds/grids.csv", stringsAsFactors=FALSE) # changed
  input.dir <- "../data/dems/" # changed
  output.dir <- "../outputs/dems/" # changed
  library(RSAGA)
  grid <- "blake30"
  run <- calls$run[1]
  workspace <- "x:/Sandy/temp/" # change to???
  env <- rsaga.env(path="C:/Program Files (x86)/SAGA-GIS-2-1-0")  # non standard installation b/c 2.1.1 is at default path # change??
  run <- "ws0"
  
  # A single metric
  run.metric(grid=grid, run=run, calls=calls, input.dir=input.dir, output.dir=output.dir,  workspace=workspace, env=env)
  
  # all metrics for one grid
  for(run in calls$run) 
    run.metric(grid=grid, run=run, calls=calls, input.dir=input.dir, output.dir=output.dir, workspace=workspace, env=env)
  

}

run.metric <- function(grid, run, calls, input.dir, output.dir, workspace, env){
  grid.path <- paste(input.dir, grid, sep="")
  cr <- which(calls$run == run)
  if(length(cr) != 1) 
    stop("The run", run, "isn't in the call table.\n")
  args <- as.list(calls[cr, !names(calls) %in% c("FUN", "run"), drop=FALSE ])
  args <- args[!is.na(args)]
  args <- c(args, list(workspace=workspace, input=grid.path, outdir=output.dir))
  if(!missing(env)) args=c(args, list(env=env))
  do.call(what=calls$FUN[cr], args=args)
}
