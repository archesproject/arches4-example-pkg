DROP VIEW IF EXISTS vw_monuments;
CREATE OR REPLACE VIEW vw_monuments AS
with mv as (select tileid, resourceinstanceid, nodeid, ST_Union(geom) as geom, ST_GeometryType(geom) as geom_type
	from mv_geojson_geoms
	group by tileid, nodeid, resourceinstanceid, ST_GeometryType(geom)) -- Union like geometry types within the same tile into a multipart geometry
select row_number() over () as gid,
        mv.resourceinstanceid,
	mv.tileid,
	mv.nodeid,
	ST_GeometryType(geom) as geom_type,
	name_tile.tiledata ->> '677f303d-09cc-11e7-9aa6-6c4008b05c4c' as name,  -- get a simple string value from tile json
	(select value from values where cast(name_tile.tiledata ->> '677f39a8-09cc-11e7-834a-6c4008b05c4c' as uuid) = valueid ) as nametype, -- get a concept's value label
	(select value from values where cast(component.tiledata ->>'ab74b009-fa0e-11e6-9e3e-026d961c88e6' as uuid) = valueid ) as construction_type,
	array_to_string((select array_agg(v.value) from unnest(ARRAY(SELECT jsonb_array_elements_text(component.tiledata -> 'ab74afec-fa0e-11e6-9e3e-026d961c88e6'))::uuid[]) item_id left join values v on v.valueid=item_id), ',') as const_tech, -- get the value labels from a concept list
	(select value from values where cast(record.tiledata ->> '677f2c0f-09cc-11e7-b412-6c4008b05c4c' as uuid) = valueid ) as record_type,
	geom
from mv
left join tiles name_tile
	 on mv.resourceinstanceid = name_tile.resourceinstanceid
	 and name_tile.tiledata->>'677f39a8-09cc-11e7-834a-6c4008b05c4c'
		!= ''
left join tiles component
	on name_tile.resourceinstanceid = component.resourceinstanceid
	and component.tiledata->>'ab74afec-fa0e-11e6-9e3e-026d961c88e6'
		!= ''
left join tiles record
        on name_tile.resourceinstanceid = record.resourceinstanceid
        and record.tiledata->>'677f2c0f-09cc-11e7-b412-6c4008b05c4c'
		!= ''
where (select graphid from resource_instances where mv.resourceinstanceid = resourceinstanceid) = 'ab74af76-fa0e-11e6-9e3e-026d961c88e6'
