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

package org.fao.geonet.services.metadata;

import java.io.File;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import jeeves.constants.Jeeves;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.UserSession;
import jeeves.server.context.ServiceContext;
import jeeves.utils.Util;
import jeeves.utils.Xml;

import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.constants.Params;
import org.fao.geonet.kernel.AccessManager;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.MdInfo;
import org.fao.geonet.kernel.SelectionManager;
import org.fao.geonet.kernel.search.MetaSearcher;
import org.jdom.Element;

//=============================================================================

/**
 * Process a metadata with an XSL transformation declared for the metadata
 * schema.
 * 
 * In each xml/schemas/schemaId directory, a process could be added in a
 * directory called process. Then the process could be called using the 
 * following URL :
 * http://localhost:8080/geonetwork/srv/en/metadata.massive.processing?process=keywords-comma-exploder
 * 
 * In that example the process has to be named keywords-comma-exploder.xsl.
 * 
 * @author fxprunayre
 */

public class MassiveXslProcessing implements Service {
	private String _appPath;

	public void init(String appPath, ServiceConfig params) throws Exception {
		_appPath = appPath;
		
		// TODO : here we could register process on startup
		// in order to not to check process each time.
	}

	// --------------------------------------------------------------------------
	// ---
	// --- Service
	// ---
	// --------------------------------------------------------------------------

	public Element exec(Element params, ServiceContext context)
			throws Exception {
		String process = Util.getParam(params, Params.PROCESS);

		GeonetContext gc = (GeonetContext) context
				.getHandlerContext(Geonet.CONTEXT_NAME);
		DataManager dataMan = gc.getDataManager();
		AccessManager accessMan = gc.getAccessManager();
		UserSession session = context.getUserSession();

		Dbms dbms = (Dbms) context.getResourceManager()
				.open(Geonet.Res.MAIN_DB);

		Set<Integer> metadata = new HashSet<Integer>();
		Set<Integer> notFound = new HashSet<Integer>();
		Set<Integer> notOwner = new HashSet<Integer>();
		Set<Integer> notProcessFound = new HashSet<Integer>();

		context.info("Get selected metadata");
		SelectionManager sm = SelectionManager.getManager(session);

		for (Iterator<String> iter = sm.getSelection("metadata").iterator(); iter
				.hasNext();) {
			String uuid = (String) iter.next();
			String id = dataMan.getMetadataId(dbms, uuid);
			context.info("Processing metadata with id:" + id);

			MdInfo info = dataMan.getMetadataInfo(dbms, id);

			if (info == null) {
				notFound.add(new Integer(id));
			} else if (!accessMan.isOwner(context, id)) {
				notOwner.add(new Integer(id));
			} else {

				// -----------------------------------------------------------------------
				// --- check processing exist for current schema
				String schema = info.schemaId;
				String filePath = _appPath + "xml/schemas/" + schema
						+ "/process/" + process + ".xsl";
				File xslProcessing = new File(filePath);
				if (!xslProcessing.exists()) {
					context.info("  Processing instruction not found for "
							+ schema + " schema.");
					notProcessFound.add(new Integer(id));
					continue;
				}

				// --- Process metadata
				Element md = dataMan.getMetadata(context, id, false);
				// TODO : here we could send parameters set by user from 
				// URL if needed.
				// Using Xml.transform(xml, styleSheetPath, params)
				Element processedMetadata = Xml.transform(md, filePath);
				

				// --- save metadata and return status
				dataMan.updateMetadata(context.getUserSession(), dbms, id,
						processedMetadata, false, null, context.getLanguage());

				metadata.add(new Integer(id));
			}
		}

		// invalidate current result set
		MetaSearcher searcher = (MetaSearcher) context.getUserSession()
				.getProperty(Geonet.Session.SEARCH_RESULT);

		if (searcher != null)
			searcher.setValid(false);

		// -- for the moment just return the sizes - we could return the ids
		// -- at a later stage for some sort of result display
		return new Element(Jeeves.Elem.RESPONSE).addContent(
				new Element("done").setText(metadata.size() + "")).addContent(
				new Element("notProcessFound").setText(notProcessFound.size()
						+ "")).addContent(
				new Element("notOwner").setText(notOwner.size() + ""))
				.addContent(
						new Element("notFound").setText(notFound.size() + ""));
	}

	// --------------------------------------------------------------------------
	// ---
	// --- Private methods
	// ---
	// --------------------------------------------------------------------------
}

// =============================================================================
