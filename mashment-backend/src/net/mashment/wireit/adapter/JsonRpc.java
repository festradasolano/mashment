/*
 * Copyright 2012-2014 Felipe Estrada-Solano <festradasolano at gmail>
 * Copyright 2012      Oscar Mauricio Caicedo <omcaicedo at gmail>
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * 
 * 		http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package net.mashment.wireit.adapter;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 * Back-end of the WireIt's JSON RPC adapter to connect to the MySQL database to
 * save, delete, and get mashments.
 * 
 * Copyright 2012-2014 Felipe Estrada-Solano <festradasolano at gmail>
 * Copyright 2012      Oscar Mauricio Caicedo <omcaicedo at gmail>
 * 
 * Distributed under the Apache License, Version 2.0 (see LICENSE for details)
 * 
 * @author festradasolano
 * @author omcaicedo
 */
public class JsonRpc extends HttpServlet {

	/**
	 * Serial UID.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Database host.
	 */
	private String dbhost = "localhost";

	/**
	 * Database user.
	 */
	private String dbuser = "root";

	/**
	 * Database password.
	 */
	private String dbpass = "root";

	/**
	 * Database name.
	 */
	private String dbname = "wireit";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public JsonRpc() {
		super();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		out.println("No Request");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest
	 * , javax.servlet.http.HttpServletResponse)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		BufferedReader reader = request.getReader();
		String s;
		String body = "";
		// get request
		while ((s = reader.readLine()) != null) {
			body += s;
		}
		reader.close();
		PrintWriter out = response.getWriter();
		JSONObject jsresp = new JSONObject();
		try {
			// get method
			JSONObject jsreq = new JSONObject(body);
			JSONObject reqParams = jsreq.getJSONObject("params");
			jsresp.put("id", jsreq.get("id"));
			String method = jsreq.getString("method");
			// check method: list, load, save, or delete
			if (method.equalsIgnoreCase("listWirings")) {
				JSONArray dbResponse = this.listMashments(reqParams
						.getString("language"));
				jsresp.put("result", dbResponse);
				jsresp.put("error", "NULL");
			} else if (method.equalsIgnoreCase("loadWiring")) {
				JSONObject dbResponse = this.loadMashment(
						reqParams.getString("language"),
						reqParams.getString("name"));
				jsresp.put("result", dbResponse);
				jsresp.put("error", "NULL");
			} else if (method.equalsIgnoreCase("saveWiring")) {
				this.saveMashment(reqParams.getString("language"),
						reqParams.getString("name"),
						reqParams.getString("working"));
				jsresp.put("result", "true");
				jsresp.put("error", "NULL");
			} else if (method.equalsIgnoreCase("deleteWiring")) {
				this.deleteMashment(reqParams.getString("language"),
						reqParams.getString("name"));
				jsresp.put("result", "true");
				jsresp.put("error", "NULL");
			} else {
				jsresp.put("result", "NULL");
				jsresp.put("error", "No method " + method);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		out.print(jsresp);
	}

	/**
	 * Lists mashments from database that belongs to a visual language.
	 * 
	 * @param language
	 *            Visual language to list mashments from database
	 * @return List of mashments from database that belongs to a visual language
	 * @throws SQLException
	 * @throws JSONException
	 */
	private JSONArray listMashments(String language) throws SQLException,
			JSONException {
		// execute SQL query
		Connection con = this.connect();
		Statement stmt = con.createStatement();
		ResultSet result = stmt
				.executeQuery("SELECT * from wirings WHERE language=\'"
						+ language + "\'");
		// build response
		JSONArray jsResponse = new JSONArray();
		while (result.next()) {
			JSONObject jso = new JSONObject();
			jso.put("id", result.getString("id"));
			jso.put("name", result.getString("name"));
			jso.put("language", result.getString("language"));
			jso.put("working", result.getString("working"));
			jsResponse.put(jso);
		}
		con.close();
		return jsResponse;

	}

	/**
	 * Load a mashment from database by name that belong to a visual language
	 * 
	 * @param language
	 *            Visual language to load mashment from database
	 * @param name
	 *            Mashment's name to load from database
	 * @return Mashment from database loaded by the name that belong to the
	 *         visual language
	 * @throws SQLException
	 * @throws JSONException
	 */
	private JSONObject loadMashment(String language, String name)
			throws SQLException, JSONException {
		// execute SQL query
		Connection con = this.connect();
		Statement stmt = con.createStatement();
		ResultSet result = stmt
				.executeQuery("SELECT * from wirings WHERE name = \'" + name
						+ "\' AND language=\'" + language + "\'");
		// build response
		JSONObject jso = new JSONObject();
		if (result.next()) {
			jso.put("id", result.getString("id"));
			jso.put("name", result.getString("name"));
			jso.put("language", result.getString("language"));
			jso.put("working", result.getString("working"));
		}
		return jso;
	}

	/**
	 * Stores in database the mashment along with its name and visual language.
	 * 
	 * @param language
	 *            Visual language to store mashment in database
	 * @param name
	 *            Mashment's name to store in database
	 * @param working
	 *            Mashment: modules and links
	 * @throws SQLException
	 */
	private void saveMashment(String language, String name, String working)
			throws SQLException {
		// execute SQL query
		Connection con = this.connect();
		Statement stmt = con.createStatement();
		ResultSet existCheck = stmt
				.executeQuery("SELECT * from wirings WHERE name = \'" + name
						+ "\' AND language=\'" + language + "\'");
		String nworking = working.replaceAll("\\\\", "\\\\\\\\");
		if (existCheck.next()) {
			stmt.executeUpdate("UPDATE wirings SET working='" + nworking
					+ "' where name='" + name + "' AND language='" + language
					+ "';");
		} else {
			stmt.executeUpdate("INSERT INTO wirings (name, language, working) VALUES ('"
					+ name + "' , '" + language + "' , '" + nworking + "');");
		}
	}

	/**
	 * Delete a mashment from database by name that belong to a visual language
	 * 
	 * @param language
	 *            Visual language to delete mashment from database
	 * @param name
	 *            Mashment's name to delete from database
	 * @throws SQLException
	 */
	private void deleteMashment(String language, String name)
			throws SQLException {
		// execute SQL query
		Connection con = this.connect();
		Statement stmt = con.createStatement();
		stmt.executeUpdate("DELETE from wirings WHERE name = \'" + name
				+ "\' AND language=\'" + language + "\'");

	}

	/**
	 * Connects to MySQL database.
	 * 
	 * @return Connection to MySQL database
	 */
	private Connection connect() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://"
					+ dbhost + "/" + dbname, dbuser, dbpass);
			return con;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

}
