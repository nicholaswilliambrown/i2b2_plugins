Repository containing i2b2 plugins developed by Nick Brown.

Plugins:

RunSQL_CRC_Server_Side_Plugin:

	This is a reusable CRC server side plugin that runs a Stored Procedure defined in the QT_ANALYSIS_PLUGIN table. 

	The stored procedure must contain the following parameters:
		@QueryInstanceID int

	Future Work:
		1. Verification of User Permissions to run plugin.
		2. Oracle and PostgreSQL compatibility.
		
Familial Relationship:
	
	This plugin extends i2b2 by adding a means of producing patient sets from familial relationship data.
	This plugin uses RunSQL_CRC_Server_Side_Plugin to allow the plugin to interact with the CRC cell.
	
	
	