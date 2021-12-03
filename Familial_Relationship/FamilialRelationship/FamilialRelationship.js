/**
 * @projectDescription	Displays demographic information for a single patient set.
 * @inherits	i2b2
 * @namespace	i2b2.FamilialRelationship
 * @author	Nick Brown, Nick Benik, Griffin Weber MD PhD
 * @version 	1.3
 * ----------------------------------------------------------------------------------------
 * updated 12-22-08: 	Initial Launch [Griffin Weber] 
 */

i2b2.FamilialRelationship.Init = function(loadedDiv) {
	i2b2.FamilialRelationship.model.generatedQueryName = "";
	
	var selTrgt = $$("DIV#HelloHSD-mainDiv SELECT#RelationshipSetCreator-relationshipList")[0];
	var t1 = "MotherOf";
	var n1 = new Option(t1, t1);
	selTrgt.options[selTrgt.length] = n1;
	var t2 = "FatherOf";
	var n2 = new Option(t2, t2);
	selTrgt.options[selTrgt.length] = n2;
	var t3 = "ChildOf";
	var n3 = new Option(t3, t3);
	selTrgt.options[selTrgt.length] = n3;
	var t4 = "SpouceOf";
	var n4 = new Option(t4, t4);
	selTrgt.options[selTrgt.length] = n4;
	var t5 = "SiblingOf";
	var n5 = new Option(t5, t5);
	selTrgt.options[selTrgt.length] = n5;
	var t6 = "TwinOf";
	var n6 = new Option(t6, t6);
	selTrgt.options[selTrgt.length] = n6;
	var t7 = "FraternalTwinOf";
	var n7 = new Option(t7, t7);
	selTrgt.options[selTrgt.length] = n7;
	var t8 = "IdenticalTwinOf";
	var n8 = new Option(t8, t8);
	selTrgt.options[selTrgt.length] = n8;
	
	// register DIV as valid DragDrop target for Patient Record Sets (PRS) objects
	var op_trgt = {dropTarget:true};
	i2b2.sdx.Master.AttachType("HelloHSD-PRSDROP", "PRS", op_trgt);
	i2b2.sdx.Master.AttachType("HelloHSD-PRSDROP2", "PRS", op_trgt);
	// drop event handlers used by this plugin
	i2b2.sdx.Master.setHandlerCustom("HelloHSD-PRSDROP", "PRS", "DropHandler", i2b2.FamilialRelationship.prsDropped);
	i2b2.sdx.Master.setHandlerCustom("HelloHSD-PRSDROP2", "PRS", "DropHandler", i2b2.FamilialRelationship.prsDropped2);
	
	
	// manage YUI tabs
	this.yuiTabs = new YAHOO.widget.TabView("HelloHSD-TABS", {activeIndex:0});
	this.yuiTabs.on('activeTabChange', function(ev) { 
		//Tabs have changed 
		if (ev.newValue.get('id')=="HelloHSD-TAB1") {
			// user switched to Results tab
			if (i2b2.FamilialRelationship.model.prsRecord) {
				// contact PDO only if we have data
				if (i2b2.FamilialRelationship.model.dirtyResultsData) {
					// recalculate the results only if the input data has changed
					i2b2.FamilialRelationship.getResults();
				}
			}
		}
	});
	
	z = $('anaPluginViewFrame').getHeight() - 34;
	$$('DIV#HelloHSD-TABS DIV.HelloHSD-MainContent')[0].style.height = z;
//	$$('DIV#HelloHSD-TABS DIV.HelloHSD-MainContent')[1].style.height = z;
//	$$('DIV#HelloHSD-TABS DIV.HelloHSD-MainContent')[2].style.height = z;
	
};

i2b2.FamilialRelationship.Unload = function() {
	// purge old data
	i2b2.FamilialRelationship.model.prsRecord = false;
	return true;
};

i2b2.FamilialRelationship.prsDropped = function(sdxData) {
	sdxData = sdxData[0];	// only interested in first record
	// save the info to our local data model
	i2b2.FamilialRelationship.model.prsRecord = sdxData;
	// let the user know that the drop was successful by displaying the name of the patient set
	$("HelloHSD-PRSDROP").innerHTML = i2b2.h.Escape(sdxData.sdxInfo.sdxDisplayName);
	// temporarly change background color to give GUI feedback of a successful drop occuring
	$("HelloHSD-PRSDROP").style.background = "#CFB";
	setTimeout("$('HelloHSD-PRSDROP').style.background='#DEEBEF'", 250);	
	// optimization to prevent requerying the hive for new results if the input dataset has not changed
	i2b2.FamilialRelationship.model.dirtyResultsData = true;	
	i2b2.FamilialRelationship.setQueryName();
	
};

i2b2.FamilialRelationship.prsDropped2 = function(sdxData) {
	sdxData = sdxData[0];	// only interested in first record
	// save the info to our local data model
	i2b2.FamilialRelationship.model.prsRecord2 = sdxData;
	// let the user know that the drop was successful by displaying the name of the patient set
	$("HelloHSD-PRSDROP2").innerHTML = i2b2.h.Escape(sdxData.sdxInfo.sdxDisplayName);
	// temporarly change background color to give GUI feedback of a successful drop occuring
	$("HelloHSD-PRSDROP2").style.background = "#CFB";
	setTimeout("$('HelloHSD-PRSDROP2').style.background='#DEEBEF'", 250);	
	// optimization to prevent requerying the hive for new results if the input dataset has not changed
	i2b2.FamilialRelationship.model.dirtyResultsData = true;
	i2b2.FamilialRelationship.setQueryName();
};


i2b2.FamilialRelationship.setQueryName = function() {
	var set1name = '---';
	var set2name = '---';
	if (i2b2.FamilialRelationship.model.prsRecord != null) {
		set1name = i2b2.FamilialRelationship.model.prsRecord.sdxInfo.sdxDisplayName;
		set1name = set1name.substring(0,Math.min(set1name.indexOf("[") - 1, 15));
	}
	if (i2b2.FamilialRelationship.model.prsRecord2 != null){
		set2name = i2b2.FamilialRelationship.model.prsRecord2.sdxInfo.sdxDisplayName;
		set2name = set2name.substring(0,Math.min(set2name.indexOf("[") - 1, 15));
	}	
	var relationshipType = $$("DIV#HelloHSD-mainDiv SELECT#RelationshipSetCreator-relationshipList")[0].value;
	if (i2b2.FamilialRelationship.model.generatedQueryName == $$("DIV#HelloHSD-mainDiv TEXTAREA#HelloHSD-queryName")[0].value || $$("DIV#HelloHSD-mainDiv TEXTAREA#HelloHSD-queryName")[0].value == "") {
		i2b2.FamilialRelationship.model.generatedQueryName = set1name + "-" + relationshipType + "-" + set2name;
		$$("DIV#HelloHSD-mainDiv TEXTAREA#HelloHSD-queryName")[0].value	= set1name + "-" + relationshipType + "-" + set2name;
	}
};

i2b2.FamilialRelationship.selectChange = function() {
	i2b2.FamilialRelationship.model.dirtyResultsData = true;
	i2b2.FamilialRelationship.setQueryName();
}

i2b2.FamilialRelationship.getResults = function() {
	if (i2b2.FamilialRelationship.model.dirtyResultsData) {

		// var msg_filter = '<input_list>\n' +
			// '	<patient_list max="99999" min="0">\n' +
			// '		<patient_set_coll_id>'+i2b2.HelloHSD.model.prsRecord.sdxInfo.sdxKeyValue+'</patient_set_coll_id>\n'+
			// '	</patient_list>\n'+
			// '</input_list>\n'+
			// '<filter_list />\n'+
			// '<output_option>\n'+
			// '	<patient_set select="using_input_list" onlykeys="false"/>\n'+
			// '</output_option>\n';

		 var resultInstanceID1 = i2b2.FamilialRelationship.model.prsRecord.sdxInfo.sdxKeyValue;
		 var resultInstanceID2 = i2b2.FamilialRelationship.model.prsRecord2.sdxInfo.sdxKeyValue;
		 var relationshipType = $$("DIV#HelloHSD-mainDiv SELECT#RelationshipSetCreator-relationshipList")[0].value;
		 var queryName = $$("DIV#HelloHSD-mainDiv TEXTAREA#HelloHSD-queryName")[0].value;
		 i2b2.FamilialRelationship.model.queryName = $$("DIV#HelloHSD-mainDiv TEXTAREA#HelloHSD-queryName")[0].value;
	/*	 
			'<analysis_definition>\n' +
			'	<analysis_plugin_name>HEALTHCARE_SYSTEM_DYNAMICS\n' +
			'	</analysis_plugin_name>\n' +
			'	<version>1.0</version>\n' +
			'	<crc_analysis_input_param name="Patient Set">\n' +
			'		<param type="int" column="patient_set_coll_id">\n' +
						+i2b2.HelloHSD.model.prsRecord.sdxInfo.sdxKeyValue+'\n'+
			'		</param>\n' +
			'	</crc_analysis_input_param>\n' +
			'	<crc_analysis_result_list>\n' + 
			'		<result_output full_name="XML" priority_index="1" name="XML"/>\n' +
			'	</crc_analysis_result_list>\n' +
			'</analysis_definition>\n';


			'	<analysis_definition>\n' +
			'		<analysis_plugin_name>CALCULATE_PATIENTCOUNT_FROM_CONCEPTPATH\n' +
			'		</analysis_plugin_name>\n' +
			'		<version>1.0</version>\n' +
			'		<crc_analysis_input_param name="ONT request">\n' +
			'			<param type="int" column="item_key">\n' +
			'				\\\\rpdr\\RPDR\\Diagnoses\\Circulatory system (390-459)\\\n' +
			'			</param>\n' +
			'		</crc_analysis_input_param>\n' +
			'		<crc_analysis_result_list>\n' +
			'			<result_output full_name="XML" priority_index="1" name="XML"/>\n' +
			'		</crc_analysis_result_list>\n' +
			'	</analysis_definition>\n';
*/

		i2b2.FamilialRelationship.model.prsRecord.sdxInfo.sdxKeyValue;

		// callback processor
		var scopedCallback = new i2b2_scopedCallback();
		scopedCallback.scope = this;
		scopedCallback.callback = function(results) {
			// THIS function is used to process the AJAX results of the getChild call
			//		results data object contains the following attributes:
			//			refXML: xmlDomObject <--- for data processing
			//			msgRequest: xml (string)
			//			msgResponse: xml (string)
			//			error: boolean
			//			errorStatus: string [only with error=true]
			//			errorMsg: string [only with error=true]
			
			// check for errors
			if (results.error) {
				alert('The results from the server could not be understood.  Press F12 for more information.');
				console.error("Bad Results from Cell Communicator: ",results);
				return false;
			}

			$$("DIV#HelloHSD-mainDiv DIV#HelloHSD-TABS DIV.results-working")[0].hide();			
			$$("DIV#HelloHSD-mainDiv DIV#HelloHSD-TABS DIV.results-finished")[0].show();

			result_instance_id = i2b2.h.XPath(results.refXML, 'descendant::query_result_instance/result_instance_id/text()/..')[0].firstChild.nodeValue
			
			// optimization - only requery when the input data is changed
			i2b2.FamilialRelationship.model.dirtyResultsData = false;	

			var scopedCallback2 = new i2b2_scopedCallback();
			scopedCallback2.scope = this;
			scopedCallback2.callback = function(results) {
				// THIS function is used to process the AJAX results of the getChild call
				//		results data object contains the following attributes:
				//			refXML: xmlDomObject <--- for data processing
				//			msgRequest: xml (string)
				//			msgResponse: xml (string)
				//			error: boolean
				//			errorStatus: string [only with error=true]
				//			errorMsg: string [only with error=true]
				
				// check for errors
				if (results.error) {
					alert('The results from the server could not be understood.  Press F12 for more information.');
					console.error("Bad Results from Cell Communicator: ",results);
					return false;
				}
				
				// get all the patient records
				//var pData = i2b2.h.XPath(results.refXML, 'descendant::i2b2_result_envelope/result/data[@column]/text()/..');
				//var hData = new Hash();
				var resultEnvelopeXml = i2b2.h.XPath(results.refXML, 'descendant::xml_value/text()/..')[0].firstChild.nodeValue;
				//var re = new RegExp('<', 'g');
				//var resultEnvelope = resultEnvelopeXml.replace(re, '&lt;');
				//var re2 = new RegExp('>', 'g');
				//resultEnvelope = resultEnvelope.replace(re, '&gt;')
				var pc1 = resultEnvelopeXml.indexOf("patient_count");
				var pc2 =resultEnvelopeXml.indexOf("<",pc1);
				var patientCount = resultEnvelopeXml.substring(pc1+15, pc2)
				//var s = '<div>' + resultEnvelope + '</div>';
				var s = '<br><hr size="1" noshade><br><div><b>' + i2b2.FamilialRelationship.model.queryName + '</b> Patient set has <b>' + patientCount + '</b> patients. <br>The patient set can be viewed in the Queries window or used in further queries.</div>';
				/*for (var i1=0; i1<pData.length; i1++) {
					var patient_num = pData[i1].getAttribute('column');
					//var fact_count = pData[i1].firstChild.nodeValue;
					s += patient_num + '<br>';
				}
				s += '</div>';*/
				$$("DIV#HelloHSD-mainDiv DIV#HelloHSD-TABS DIV.results-finished")[0].innerHTML = s;
				i2b2.CRC.ctrlr.history.Refresh();
			}
			
			i2b2.CRC.ajax.getQueryResultInstanceList_fromQueryResultInstanceId("Plugin:FamilialRelationship", {qr_key_value: result_instance_id}, scopedCallback2);
		}
		


		
		
		$$("DIV#HelloHSD-mainDiv DIV#HelloHSD-TABS DIV.results-directions")[0].hide();
		$$("DIV#HelloHSD-mainDiv DIV#HelloHSD-TABS DIV.results-finished")[0].hide();
		$$("DIV#HelloHSD-mainDiv DIV#HelloHSD-TABS DIV.results-working")[0].show();		
		
		
		
		// AJAX CALL USING THE EXISTING CRC CELL COMMUNICATOR
		i2b2.CRC.ajax.getFamilialRelationships("Plugin:FamilialRelationship", {resultInstanceID1: resultInstanceID1, resultInstanceID2: resultInstanceID2, relationshipType: relationshipType, queryName:queryName }, scopedCallback);
		
	}
}



