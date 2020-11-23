Case Study 10
================
Collin O’Connor
November 12, 2020

``` r
library(raster)
library(rasterVis)
library(rgdal)
library(ggmap)
library(tidyverse)
library(knitr)
library(ncdf4)
library(sf)
```

``` r
dir.create("data",showWarnings = F) #create a folder to hold the data

lulc_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MCD12Q1.051_aid0001.nc?raw=true"
lst_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MOD11A2.006_aid0001.nc?raw=true"

# download them
download.file(lulc_url,destfile="data/MCD12Q1.051_aid0001.nc", mode="wb")
download.file(lst_url,destfile="data/MOD11A2.006_aid0001.nc", mode="wb")
lulc=stack("data/MCD12Q1.051_aid0001.nc",varname="Land_Cover_Type_1")
lst=stack("data/MOD11A2.006_aid0001.nc",varname="LST_Day_1km")
```

``` r
lulc=lulc[[13]]
plot(lulc)
```

![](case_study_10_files/figure-gfm/lulc_1year-1.png)<!-- -->

``` r
  Land_Cover_Type_1 = c(
    Water = 0, 
    `Evergreen Needleleaf forest` = 1, 
    `Evergreen Broadleaf forest` = 2,
    `Deciduous Needleleaf forest` = 3, 
    `Deciduous Broadleaf forest` = 4,
    `Mixed forest` = 5, 
    `Closed shrublands` = 6,
    `Open shrublands` = 7,
    `Woody savannas` = 8, 
    Savannas = 9,
    Grasslands = 10,
    `Permanent wetlands` = 11, 
    Croplands = 12,
    `Urban & built-up` = 13,
    `Cropland/Natural vegetation mosaic` = 14, 
    `Snow & ice` = 15,
    `Barren/Sparsely vegetated` = 16, 
    Unclassified = 254,
    NoDataFill = 255)
  lcd=data.frame(
  ID=Land_Cover_Type_1,
  landcover=names(Land_Cover_Type_1),
  col=c("#000080","#008000","#00FF00", "#99CC00","#99FF99", "#339966", "#993366", "#FFCC99", "#CCFFCC", "#FFCC00", "#FF9900", "#006699", "#FFFF00", "#FF0000", "#999966", "#FFFFFF", "#808080", "#000000", "#000000"),
  stringsAsFactors = F)
# colors from https://lpdaac.usgs.gov/about/news_archive/modisterra_land_cover_types_yearly_l3_global_005deg_cmg_mod12c1
kable(head(lcd))
```

|                             | ID | landcover                   | col      |
| :-------------------------- | -: | :-------------------------- | :------- |
| Water                       |  0 | Water                       | \#000080 |
| Evergreen Needleleaf forest |  1 | Evergreen Needleleaf forest | \#008000 |
| Evergreen Broadleaf forest  |  2 | Evergreen Broadleaf forest  | \#00FF00 |
| Deciduous Needleleaf forest |  3 | Deciduous Needleleaf forest | \#99CC00 |
| Deciduous Broadleaf forest  |  4 | Deciduous Broadleaf forest  | \#99FF99 |
| Mixed forest                |  5 | Mixed forest                | \#339966 |

``` r
# convert to raster (easy)
lulc=as.factor(lulc)

# update the RAT with a left join
levels(lulc)=left_join(levels(lulc)[[1]],lcd)
```

    ## Joining, by = "ID"

``` r
# plot it
gplot(lulc)+
  geom_raster(aes(fill=as.factor(value)))+
  scale_fill_manual(values=levels(lulc)[[1]]$col,
                    labels=levels(lulc)[[1]]$landcover,
                    name="Landcover Type")+
  coord_equal()+
  theme(legend.position = "right")+
  guides(fill=guide_legend(ncol=1,byrow=TRUE))
```

![](case_study_10_files/figure-gfm/ggplot-1.png)<!-- -->

``` r
plot(lst[[1:12]])
```

![](case_study_10_files/figure-gfm/plotall-1.png)<!-- -->

``` r
offs(lst)=-273.15
plot(lst[[1:10]])
```

![](case_study_10_files/figure-gfm/plotall-2.png)<!-- -->

``` r
tdates=names(lst)%>%
  sub(pattern="X",replacement="")%>%
  as.Date("%Y.%m.%d")

names(lst)=1:nlayers(lst)
lst=setZ(lst,tdates)
```

    class       : SpatialPoints 
    features    : 1 
    extent      : 1387674, 1387674, 2349491, 2349491  (xmin, xmax, ymin, ymax)
    crs         : +proj=aea +lat_0=23 +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs 

![](case_study_10_files/figure-gfm/Timeseries-1.png)<!-- -->

``` r
tmonth=as.numeric(format(getZ(lst),"%m"))
lst_month=stackApply(x =lst,fun = mean,na.rm=T,indices=tmonth)
names(lst_month)=month.name
gplot(lst_month)+
      geom_raster(aes(fill=value)) +
  scale_fill_gradient(low='blue',high='red') +
  facet_wrap(~variable) +
  theme(axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank())
```

![](case_study_10_files/figure-gfm/convert%20months-1.png)<!-- -->

``` r
kable(cellStats(lst_month,mean))
```

|           |          x |
| :-------- | ---------: |
| January   | \-2.127506 |
| February  |   8.710271 |
| March     |  18.172077 |
| April     |  23.173591 |
| May       |  26.990005 |
| June      |  28.840144 |
| July      |  27.358260 |
| August    |  22.927727 |
| September |  15.477510 |
| October   |   8.329881 |
| November  |   0.586179 |
| December  | \-4.754134 |

``` r
lulc2=resample(lulc,lst,method='ngb')
lcds1=cbind.data.frame(values(lst_month),ID=values(lulc2[[1]])) 
testa= lcds1 %>% 
  gather(key='month',value = 'value',-ID) %>%
  mutate(ID=as.numeric(ID),month=factor(month,
                                        levels=month.name,
                                        ordered=T))
testb=left_join(lcds1,lcd)
```

    ## Joining, by = "ID"

``` r
testc = testb %>%
  filter(landcover%in%c("Urban & built-up","Deciduous Broadleaf forest"))
```

``` r
testd=reshape2::melt(testc, id.vars="landcover",
               measure.vars=c("January","February","March",
                              "April","May","June","July","August",
                              "September","October","November",
                              "December"))

ggplot(testd,aes(x=variable,y=value))+
  geom_jitter(width=.3)+
  geom_violin(color='red',alpha=.4)+
  ylab(expression(paste("Monthly Mean Land Surface Temperature (",
                        ~degree,"C)",sep="")))+
  xlab("Month")+
  theme(axis.text.x = element_text(angle=65,vjust=.65))+
  ggtitle("Land Surface Temperature in Urban Forest")+
  facet_wrap(~landcover)
```

![](case_study_10_files/figure-gfm/final_plot-1.png)<!-- -->
