/**
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

package net.mashment.drools;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 * @author festradasolano
 * 
 */
public class NmsitDao {

	/**
	 * Serial UID.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Database host.
	 */
	private static String dbhost = "localhost";

	/**
	 * Database user.
	 */
	private static String dbuser = "root";

	/**
	 * Database password.
	 */
	private static String dbpass = "root";

	/**
	 * Database name.
	 */
	private static String dbname = "wireit";

	/**
	 * 
	 */
	public NmsitDao() {
		super();
	}

	public static boolean addNmsit(String situation, String eac, String rule) {
		// get and check connection
		Connection connection = NmsitDao.connect();
		if (connection == null) {
			return false;
		}
		try {
			// execute SQL query to insert nmsit in database
			Statement statement = connection.createStatement();
			statement
					.executeUpdate("INSERT INTO nmsit (situation, eac, rule) VALUES ('"
							+ situation + "', '" + eac + "', '" + rule + "');");
			connection.close();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public static boolean deleteNmsit(String situation) {
		// get and check connection
		Connection connection = NmsitDao.connect();
		if (connection == null) {
			return false;
		}
		try {
			// execute SQL query to delete nmsit by situation
			Statement statement = connection.createStatement();
			statement
					.executeQuery("DELETE FROM nmsit WHERE situation = LOWER('"
							+ situation + "');");
			connection.close();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public static JSONArray listNmsits() {
		// get and check connection
		Connection connection = NmsitDao.connect();
		if (connection == null) {
			return null;
		}
		try {
			// execute SQL query to get all nmsits
			Statement statement = connection.createStatement();
			ResultSet result = statement.executeQuery("SELECT * FROM nmsit;");
			// walk through nmsits to build response
			JSONArray jsonArrayNmsit = new JSONArray();
			while (result.next()) {
				JSONObject jsonNmsit = new JSONObject();
				jsonNmsit.put("id", result.getInt("id"));
				jsonNmsit.put("situation", result.getString("situation"));
				jsonNmsit.put("eac", result.getString("eac"));
				jsonNmsit.put("rule", result.getString("rule"));
				jsonArrayNmsit.put(jsonNmsit);
			}
			connection.close();
			return jsonArrayNmsit;
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static JSONObject loadNmsit(String situation) {
		// get and check connection
		Connection connection = NmsitDao.connect();
		if (connection == null) {
			return null;
		}
		try {
			// execute SQL query to get nmsit by situation
			Statement statement = connection.createStatement();
			ResultSet result = statement
					.executeQuery("SELECT * FROM nmsit WHERE situation = LOWER('"
							+ situation + "');");
			// if nmsit exists, build response
			JSONObject jsonNmsit = null;
			if (result.next()) {
				jsonNmsit = new JSONObject();
				jsonNmsit.put("id", result.getInt("id"));
				jsonNmsit.put("situation", result.getString("situation"));
				jsonNmsit.put("eac", result.getString("eac"));
				jsonNmsit.put("rule", result.getString("rule"));
			}
			connection.close();
			return jsonNmsit;
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Connects to MySQL database.
	 * 
	 * @return Connection to MySQL database
	 */
	private static Connection connect() {
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
