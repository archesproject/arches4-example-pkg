#!/bin/bash

eval HERPATH=$PWD
read -e -p "Enter the path to arches: " ARCHESPATH
eval ARCHESPATH=$ARCHESPATH
cd $ARCHESPATH

# Rebuild db
python manage.py packages -o setup_db

# Load Liverpool specific Arches defaut thesauri and collections
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/arches_liverpool_concepts.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_Additional_Schemes.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_dm_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_HER_Designation_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_HER_Period_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_Monument_Types_v4.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_Recording_Event_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/Lincoln_Source_Type.xml -ow overwrite -st keep
python manage.py packages -o import_reference_data -s $HERPATH/reference_data/arches_liverpool_collections.xml -ow overwrite -st keep

# Load Resource Models, Branches
python manage.py packages -o import_graphs -s arches/db/graphs/branches
python manage.py packages -o import_graphs -s $HERPATH/graphs/branches/
python manage.py packages -o import_graphs -s $HERPATH/graphs/resource_models/

# Load Overlays
python manage.py packages -o add_mapbox_layer -j $HERPATH/mapbox_styles/Emerald/style.json -n "Emerald" -b
python manage.py packages -o add_mapbox_layer -j $HERPATH/mapbox_styles/Outdoors/style.json -n "Outdoors" -b
python manage.py packages -o add_mapbox_layer -j $HERPATH/mapbox_styles/Light/style.json -n "Light Streets" -b
python manage.py packages -o add_mapbox_layer -j $HERPATH/mapbox_styles/Dark/style.json -n "Dark Streets" -b
python manage.py packages -o add_mapbox_layer -j $HERPATH/mapbox_styles/Satellite-Streets/style.json -n Satellite_Streets -b
python manage.py packages -o add_tileserver_layer -m $HERPATH/tilestache/town_plan_3857.xml -n "Lincoln 1886-1998"
python manage.py packages -o add_tileserver_layer -m arches/tileserver/hillshade.xml -n "Hillshade"

# Load Business Data
python manage.py packages -o import_business_data -s $HERPATH/business_data/HER\ Activities_master.csv -c $HERPATH/business_data/HER\ Activities.mapping -ow overwrite -bulk
python manage.py packages -o import_business_data -s $HERPATH/business_data/HER\ Information\ Assets.csv -c $HERPATH/business_data/HER\ Information\ Assets.mapping -ow overwrite -bulk
python manage.py packages -o import_business_data -s $HERPATH/business_data/HER\ Monuments\ Workshop.csv -c $HERPATH/business_data/HER\ Monuments.mapping -ow overwrite -bulk
python manage.py packages -o import_business_data -s $HERPATH/business_data/HER\ Actors_master.csv -c $HERPATH/business_data/HER\ Actors.mapping -ow overwrite -bulk
