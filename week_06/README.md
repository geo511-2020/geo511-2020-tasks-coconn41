 The st_sf call seems useful to create your own geometry columns. I have yet to encounter a need to do so, but it seems that it could be useful down the road.
 I have used slice() before, but having it described in prose is helpful. It is the row equivalent of select, meaning it will take a single observation from your database.
 setdiff() seems EXTREMELY useful. I have had multiple instances where joining data drops observations, but I can't see what those observations are. 
 st_intersects, st_disjoint, st_within, st_touches, and st_is_within_distance all seem extremely useful for comparing geometries to each other on a relative surface.
 st_join is obviously useful as a geometric join
 st_distance is useful for calculating distance obviously. I'm curious if it does it on 2-D planes or by using Haversine?
