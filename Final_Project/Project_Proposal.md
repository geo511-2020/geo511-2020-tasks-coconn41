GEO 511 Project Proposal
================
Collin O’Connor

## Problem / Question:

The deer tick or blacklegged tick (<i>Ixodes scapularis</i>) is the most
medically relevant species of hard tick that in New York State (NYS).
<i>I. scapularis</i> populations in NYS may carry a plethora of
pathogens, including but not limited to:

  - <i>Borrelia burgdorferi</i> - the causitive agent of Lyme disease
  - <i>Anaplasma phagocytophilum</i> - the causitive agent of human
    granulocytic anaplasmosis
  - <i>Babesia microti</i> - the causitive agent of babesiosis in humans
  - <i>Borrelia miyamotoi</i> - causative of a relapsing tick fever

The prevalence of the above pathogens varies both spatially and
temporally in NYS, which results in varying risk for NYS citizens.
Because these pathogens are not transmitted from tick to tick
transovarially, they are required to be maintained throughout
populations of animal hosts in the various ecosystems of NYS. Data
suggests that certain land use and land cover types are beneficial for
populations of animals which maintain these pathogens, and potentially
for the pathogen’s themselves. This project aims to explore any trends
between pathogen prevalence within <i>I. scapularis</i> at the county
level and land use / land cover types in NYS.

## Examples:

### Image 1

![](https://www.lib.ncsu.edu/sites/default/files/wysiwyg-uploads/NLCD_NC.jpg)

Image Example 1 is an extract of the National Land Cover Dataset (NLCD).
More specifically, this extract is the NLCD raster extracted by the
shape of North Carolina. This serves as a useful example of what the
NLCD extract raster will look like, only substituting the shape of NYS.

### Image 2

![](https://ars.els-cdn.com/content/image/1-s2.0-S0924271620300587-gr9.jpg)

Image 2 is from a publication that explains the land cover change index
in the NLCD. This image shows aggregate statistics for multiple polygons
within a larger polygon. This is what I am to do with the counties of
NYS. Although this image does not use the specific variables I expect to
explore, it shows the concept of having multiple polygons take values
from a raster (in this case the NLCD) to later be used for analysis.

### Image 3

![](https://www.cdc.gov/csels/dsepd/ss1978/lesson4/images/Figure4.3.jpg)

Image 3 is an example of a time-series graph from the CDC. This
particular graph shows age at death in years along the y-axis, and year
along the x-axis. One of the goals of this project is to create graphs
that visualize the change in prevalence over time for each of the
pathogens described earlier. This should be done for each county in NYS.

### Link 1

[Interactive Map Link](https://pad.human.cornell.edu/profiles/index.cfm)

Link 1 leads to an example of an interactive map of NYS County polygons
which contain demographic, social and economic data, courtesy of Cornell
University. This example shows one of the goals of this project. I hope
to have an interactive map of counties that contains the summary data
for the tick pathogen prevalence data as well as the land use / land
cover data. Additionally, the time-series charts (see image 3) for each
county should also appear. Ideally, when clicking on a county, these
features should either pop up or open in a new link, as this example
from Cornell does.

## Proposed Data Sources:

There are three data sources required for this project:

1.  Tick pathogen prevalence data
2.  Land use / land cover data
3.  Spatial polygon data of NYS Counties

### Tick pathogen prevalence data

The New York State Department of Health (NYSDOH) Vector Ecology Lab
conducts seasonal tick-surveys throughout NYS. These surveys measure
density of ticks in the environment, and also measure the pathogen
prevalence of <i>B. burgdorferi</i>, <i>A. phagocytophilum</i>, <i>B.
microti</i>, and <i>B. miyamotoi</i> in the collected ticks. Pathogen
prevalence is determined through PCR testing of individual tick
specimens. These data are available to the public via [Health Data
NY](https://health.data.ny.gov/), for both
[adult](https://health.data.ny.gov/Health/Access-Adult-Deer-Tick-Collection-Data-by-County-E/fkdr-6a5t)
and
[nymphal](https://health.data.ny.gov/Health/Access-Nymph-Deer-Tick-Collection-Data-by-County-E/7qid-kum3)
tick density. These data on Health Data NY show tables and maps, but do
not conduct any statistical testing or plot any time-series charts. They
also do not utilize and ecological data, as is the goal of this project.
This project will only be looking at adult tick data, as there are
generally more adult tick samples from collections.

### Land use / land cover data

Quality raster data for land use and/or land cover type is available
from different sources. For this project, I plan to use the National
Land Cover Dataset (NLCD) 2016 (CONUS). The NLCD 2016 is available for
download from the [Multi-Resolution Land Characteristics Consortium
(MRLC) website](https://www.mrlc.gov/data/nlcd-2016-land-cover-conus),
which describes the dataset as a product from the U.S. Geological Survey
and several other federal agencies. The data is gathered via a multitude
of methods, listed in the description at the link above. The dataset is
a raster dataset which breaks down each pixel of the contiguous United
States into the specified categories shown below:

<img src="https://www.mrlc.gov/sites/default/files/NLCD_Colour_Classification_Update.jpg" width="300" height="600">

### New York State County polygon data

To get polygon data for NYS, I plan on using the NYS Civil Boundaries
County Shoreline data from NYS GIS Clearinghouse. This dataset has
accurate polygon edges for the edge of NYS counties. This is essential
because these polygons will be used to extract data from the NLCD
dataset, which has accurate data on the shorelines of state and county
polygons. The polygon data can be downloaded
[here](http://gis.ny.gov/gisdata/metadata/nysgis.Counties_Shoreline.pdf).

## Proposed Methods:

There are a few main tasks that must be addressed for this project:

1.  Extracting entire U.S. NLCD dataset to just the outline of NYS
2.  Calculating percent coverage values for land use cover and type for
    each county
3.  Creating choropleth map for each pathogen at county level across all
    years
4.  Calculating Spearman-rank correlations for each pathogen’s
    prevalence at county level.
5.  Creating interactive maps that display the following when a county
    is highlighted/clicked:
      - Table for pathogen prevalence by year
      - Table for percentage of area covered by specific land use / land
        cover types
      - Time-series graph of pathogen prevalence by year

### Extracting / Calculating percent coverage values

The first step for this project is to load the NLCD 2016 dataset and NYS
shoreline polygon into R via the raster and sf packages. The raster
package uses the following call:

``` r
raster()
```

to load raster data, while the sf package uses the following call:

``` r
read_sf()
```

to load polygon data from an outside data source.

Once these two datasets are loaded, I will check their coordinate
reference (CRS) systems with:

``` r
crs()
```

from the raster package, and adjust reference systems as necessary. Once
both datasets are on the same CRS, the NLCD must be extracted to match
the size of the NYS polygon. In the same extraction step, percent of
area covered by specific land cover / type categories can be calculated
This will be done with the following call:

``` r
extract(NLCD,NYScounties,fun=sum)
```

Summing the values for each category will then allow their total percent
area to be calculated. There may be some required spatial subsetting
prior to this step, but that still needs to be examined.

### Creating choropleth maps

In order to create choropleth maps for each pathogen across all years in
the data, county level pathogen data will first have to be joined to the
spatial polygon data. This is possible through the simple call of:

``` r
merge()
```

Once the data is joined, the choropleth map can be created. In order to
create the map, I will be using the tmap package. The tmap package will
allow me to create choropleth maps through the following calls:

``` r
tm_shape(NYScounties) +
  tm_fill(col="Borr_burgdorferi_prev") +
  tm_borders()
```

The above calls will create a choropleth map of a color scale ordered by
the prevalence of <i>B. burgdorferi</i> in every county. Other fine
tuning will likely be necessary to make the maps, including facets for
years and pathogen types.

### Calculating Spearman-rank correlations

The analysis phase of this project comes into play when examining the
land use / land cover types at the county level, and how they are
related to individual pathogen prevalence. Spearman-rank correlation is
a a statistical test for correlation that is different from the standard
Pearson’s test. It is utilized when by giving observations in a variable
a value of their relative rank compared to all other observations in the
data. This is useful when examining pathogen prevalence data, where some
of the pathogens will have a 0% prevalence for many of the years in the
study. Having too many 0 values can provide a misleading result in the
Pearson’s test of correlation, and will be more accurate to the truth
with the Spearman-rank. The Spearman-rank test is used in R with the
following call:

``` r
raster(Landuse,County,method="spearman")
```

After conducting the Spearman-rank test, I will organize the results in
the table using a loop.

### Creating interactive maps displaying data

In order to create interactive maps to display the data mentioned above,
I will be utilizing the leaflet package. The leaflet package creates
interactive maps of polygons through the following call with:

``` r
leaflet(Countypolygons) %>%
  addPolygons(color="")
```

Of note, the data trying to be displayed in the interactive map will
have to merged beforehand.

In order to add tables, images and graphs into the interactive map, the
leafpop package is required. In order to add these features, something
to the effect of the following call is utilized:

``` r
leaflet(data, popup = popupTable())
```

In the above call, the text ‘Table’ can be replaced with Image or Graph
for the desired data display.

## Expected results

I anticipate a few difficulties with this project:

  - The first difficulty is that NLCD 2016 file is very large, and may
    require me to download the file on my local machine instead of
    downloading it directly from the internet. Ideally, it will be
    downloaded from the internet within the R code for reproducibility.

  - The second difficulty I anticipate is getting the extracted NLCD
    data into percentage format. This may require me to subset by
    category and calculate area for each NLCD category. This will be
    labor intensive if I cannot find an elegant way to work through this
    problem.

  - The third difficulty I anticipate is being able to fit all of the
    visualization information I would like into this project. The data I
    will be using is for multiple years, likely presenting a data
    overload for each year. It may force me to find averages across all
    years, which is misleading if there is pathogen prevalence growth
    over the range of the data. Ideally, I will be able to facet all of
    the diplay data in a clear and easy to understand way.

Overall, I believe this project will be a successful attempt at
conducted a simple analysis that is also informative. The Spearman-rank
correlations will be an oversimplification of a complex ecological
system, and they will not capture the full story of the spatial
variation of tick pathogen prevalence in NYS. At minimum, the
correlations will provide statistically significant results that inform
which counties are more risky for some diseases than others due to their
land use cover and types. Following the analysis, I am confident that
the data can be displayed in an effective way. Interactive mapping is
the best way to display this data in a non-publication medium, where
static maps are generally the go-to. All in all, I think the project
will be successful based on my expectations and this outline.
