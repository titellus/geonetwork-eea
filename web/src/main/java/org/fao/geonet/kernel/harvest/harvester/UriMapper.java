//=============================================================================
//===	Copyright (C) 2001-2007 Food and Agriculture Organization of the
//===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
//===	and United Nations Environment Programme (UNEP)
//===
//===	This program is free software; you can redistribute it and/or modify
//===	it under the terms of the GNU General Public License as published by
//===	the Free Software Foundation; either version 2 of the License, or (at
//===	your option) any later version.
//===
//===	This program is distributed in the hope that it will be useful, but
//===	WITHOUT ANY WARRANTY; without even the implied warranty of
//===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//===	General Public License for more details.
//===
//===	You should have received a copy of the GNU General Public License
//===	along with this program; if not, write to the Free Software
//===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: geonetwork@osgeo.org
//==============================================================================

package org.fao.geonet.kernel.harvest.harvester;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import jeeves.resources.dbms.Dbms;
import org.jdom.Element;

//=============================================================================

/** Create a mapping (remote URI) -> (local ID / change date). Retrieves all
  * metadata of a given harvest uuid and puts them into an hashmap.
  */

public class UriMapper
{
	private HashMap<String, List<RecordInfo>> hmUriRecords = new HashMap<String, List<RecordInfo>>();

	//--------------------------------------------------------------------------
	//---
	//--- Constructor
	//---
	//--------------------------------------------------------------------------

	public UriMapper(Dbms dbms, String harvestUuid) throws Exception
	{
		String query = "SELECT id, uuid, harvestUri, changeDate, isTemplate FROM Metadata WHERE harvestUuid=?";

		List idsList = dbms.select(query, harvestUuid).getChildren();

		for (int i=0; i<idsList.size(); i++)
		{
			Element record = (Element) idsList.get(i);

			String uri  = record.getChildText("harvesturi");

			List<RecordInfo> records = hmUriRecords.get(uri);
			
			if (records == null) {
				records = new ArrayList<RecordInfo>();
				hmUriRecords.put(uri, records);
			}
			
			records.add(new RecordInfo(record));
		}
	}

	//--------------------------------------------------------------------------
	//---
	//--- API methods
	//---
	//--------------------------------------------------------------------------

	public List<RecordInfo> getRecords(String uri) { return hmUriRecords.get(uri); }

	//--------------------------------------------------------------------------

	public Iterable<String> getUris() { return hmUriRecords.keySet(); }
	
}

//=============================================================================

