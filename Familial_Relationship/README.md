**Familial Relationship Set Creator** is an i2b2 server / webclient plugin to provide a way to handle familial relationships in i2b2. 

**There are four parts to installing Familial Relationship Set Creator:**
	1. Install the Webclient plugin
	2. Install the RunSQL_CRC_Server_Side_Plugin server side plugin
	3. Run Ontology and CRC cell database scripts to configure and enable the plugin
	4. Add familial relationship data. Sample scripts to run on the i2b2demodata are included.
	
**Install the Webclient plugin**
	1. Copy the FamilialRelationship folder to js-i2b2\cells\plugins\community\
	2. Append the following to the i2b2.hive.tempCellsList in js-i2b2/i2b2_loader.js
			,{ code:	"FamilialRelationship",
			   forceLoading: true,
			   forceConfigMsg: { params: [] },
			   roles: [],
			   forceDir: "cells/plugins/community"
			}
	3. Append the contents of i2b2_msgs_append.js to js-i2b2\cells\CRC\i2b2_msgs.js

**Install the RunSQL_CRC_Server_Side_Plugin server side plugin**
See install guide included in RunSQL plugin for details on installing the plugin.

**Run Ontology and CRC cell database scripts to configure and enable the plugin**
	1. Run SQL\Ontology_Cell.sql in your ontology (i2b2metadata) database.
	2. Open SQL\CRC_Cell.sql and edit the path to your RunSQL_CRC_Server_Side_Plugin on lines 22 and 23. Run this script in your CRC (i2b2demodata) database.
	3. Optional: To add demodata for testing this plugin, run SQL\DemoData.sql in yout CRC (i2b2demodata) database.