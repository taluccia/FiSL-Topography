# FiSL-Topography

## Overview 

Calculate multiple terrain variables to evaluate roll in burn severity for FiSL project

Moisture gradient are important predictors of burn severity in Boreal forests that have more simple topographic features compared to sub alpine forests. 



## Data and processing
Use 
[DEM](https://data.bris.ac.uk/data/dataset/25wfy0f9ukoge2gs7a5mqpq2j7)
DEM is bare earth removal of trees at 30 m resolution. Chosen over Arctic DEM
[Topography Metrics](https://www.sciencebase.gov/catalog/item/53db9ca0e4b0fba533faf4be)


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

Varaibles of interest from AK_CA_Burned_Plot_Data_1983_2016.csv

* Elevation
* accuracy_vertical
* slope
* aspect
* moisture
* ag_biomass_combusted
* Burn_depth
