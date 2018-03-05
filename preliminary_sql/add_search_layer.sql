SET CLIENT_ENCODING TO UTF8;
BEGIN;

INSERT INTO map_layers(maplayerid, name, layerdefinitions, isoverlay, icon, activated, addtomap)
VALUES (public.uuid_generate_v1mc(), 'Search Results', '[
  {
     "id": "search-results-heat",
     "type": "heatmap",
     "source": "search-results-hashes",
     "paint": {
         "heatmap-weight": [
             "interpolate", [
                 "linear"
             ],
             [
                 "get",
                 "doc_count"
             ],
             0,
             0,
             6,
             1
         ],
         "heatmap-intensity": [
             "interpolate", [
                 "linear"
             ],
             [
                 "zoom"
             ],
             0,
             1,
             25,
             10
         ],
         "heatmap-color": [
             "interpolate", [
                 "linear"
             ],
             [
                 "heatmap-density"
             ],
             0,
             "rgba(33,102,172,0)",
             0.2,
             "rgb(103,169,207)",
             0.4,
             "rgb(209,229,240)",
             0.6,
             "rgb(253,219,199)",
             0.8,
             "rgb(239,138,98)",
             1,
             "rgb(178,24,43)"
         ],
         "heatmap-radius": [
             "interpolate", [
                 "linear"
             ],
             [
                 "zoom"
             ],
             0,
             2,
             25,
             25
         ],
         "heatmap-opacity": 1
     }
 },
 {
     "id": "search-results-points-markers",
     "type": "symbol",
     "source": "search-results-points",
     "filter": [
         "all", [
             "==",
             "$type",
             "Point"
         ],
         [
             "!=",
             "highlight",
             true
         ]
     ],
     "layout": {
         "icon-image": "marker-15",
         "icon-size": 2,
         "icon-offset": [0, -6],
         "icon-allow-overlap": true
     },
     "paint": {}
 },
 {
     "id": "search-results-points-markers-highlighted",
     "type": "symbol",
     "source": "search-results-points",
     "filter": [
         "all", [
             "==",
             "$type",
             "Point"
         ],
         [
             "==",
             "highlight",
             true
         ]
     ],
     "layout": {
         "icon-image": "marker-15",
         "icon-size": 3,
         "icon-offset": [0, -6],
         "icon-allow-overlap": true
     },
     "paint": {}
 }
]', TRUE, 'ion-search', TRUE, TRUE);
