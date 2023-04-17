# FiSL-Topography

## Overview 

Calculate multiple terrain variables to evaluate roll in burn severity for FiSL project

Moisture gradient are important predictors of burn severity in Boreal forests that have more simple topographic features compared to sub alpine forests. 

# Essential scripts
* FieldDataOrganize.Rmd 
* ExploreFieldPoints.Rmd
* FABDEMMosaicToEA.Rmd
* CheckDEMMosaicPointOverlay.Rmd
* GeoTiffToASCii.Rmd

# Notes on Steps
1. FieldDataOrganize.Rmd -> organize field data and convert to point shapefile
2. ExploreFieldPoints.Rmd -> use to figure out smaller point groupings for DEM Mosaics to use in SAGA
2. FABDEMMosaicToEA.Rmd -> Combine FAB DEMs for each study area
3. CheckDEMMosaicPointOverlay.Rmd -> Overlay points with rasters to make sure subgroups align
3. GeoTiffToASCii.Rmd -> convert geotiffs to ascii files for processing in SAGA














## Data and processing
Use 
[DEM](https://data.bris.ac.uk/data/dataset/25wfy0f9ukoge2gs7a5mqpq2j7)
DEM is bare earth removal of trees at 30 m resolution. Chosen over Arctic DEM
[Topography Metrics](https://www.sciencebase.gov/catalog/item/53db9ca0e4b0fba533faf4be)
[Field Data](https://daac.ornl.gov/ABOVE/guides/ABoVE_Plot_Data_Burned_Sites.html)
[field data 1983-2016](https://daac.ornl.gov/ABOVE/guides/ABoVE_Plot_Data_Burned_Sites.html)


[tree canopy ABoVE](https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=2012)

Topography Metrics (adapting code Sandra Haire)

Test with 1 DEM tile at 30 m resolution


# Projections 
From NASA ABoVE

Projection Specifications:
Canada_Albers_Equal_Area_Conic
WKID (EPSG): 102001 Authority: ESRI
Projection: Albers
False_Easting: 0.0
False_Northing: 0.0
Central_Meridian: -96.0
Standard_Parallel_1: 50.0
Standard_Parallel_2: 70.0
Latitude_Of_Origin: 40.0
Linear Unit: Meter (1.0)
Geographic Coordinate System: GCS_North_American_1983
Angular Unit: Degree (0.0174532925199433)
Prime Meridian: Greenwich (0.0)
Datum: North_American_1983
  Spheroid: GRS_1980
    Semimajor Axis: 6378137.0
    Semiminor Axis: 6356752.314140356
    Inverse Flattening: 298.257222101
    

# Field Data from ABoVE
[Data avaialbe on ORNL DAAC](https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=1744)
Coordinate system WGS8 84

Variables of interest from AK_CA_Burned_Plot_Data_1983_2016.csv

* Elevation
* accuracy_vertical
* slope
* aspect
* moisture
* ag_biomass_combusted
* Burn_depth

# Getting SAGA to work with R and QGIS on a Mac OS Monterey 12.4 (07-12-22)
**RESOURCES**
[RSAGA pAckage PDF](https://cran.r-project.org/web/packages/RSAGA/RSAGA.pdf)
[SAGA Command line](https://dges.carleton.ca/CUOSGwiki/index.php/Automating_SAGA_Workflows_Using_Command_Line_Scripting#:~:text=SAGA%20GIS%20provides%20access%20to,using%20Task%20Scheduler%20or%20cron.)
[2020 dated link in last comment for setting up SAGA on Mac and accessing SAGA GUI](https://sourceforge.net/p/saga-gis/wiki/Compiling%20SAGA%20on%20Mac%20OS%20X/)
For RSAGA
Install homebrew
[Install gdal with homebrew](9https://formulae.brew.sh/formula/gdal) in the terminal type `brew install gdal`


 [SAGA Download](https://sourceforge.net/projects/saga-gis/)

For QGIS
Install Homebrew
In terminal with homebrew `brew install saga-gis`

# Potentially adapting code fo R saga

Use code from Krawchuk et al Ecosphere 2016 paper, [linked here](https://www.sciencebase.gov/catalog/item/53db9ca0e4b0fba533faf4be)


# Calculation for TWI
[see here](https://courses.gisopencourseware.org/mod/book/tool/print/index.php?id=41)
