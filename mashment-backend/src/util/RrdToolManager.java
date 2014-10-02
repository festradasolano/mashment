/**
 * 
 */
package util;

import static org.rrd4j.ConsolFun.AVERAGE;
import static org.rrd4j.DsType.GAUGE;

import java.awt.Color;
import java.io.File;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.ws.rs.core.Context;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.rrd4j.ConsolFun;
import org.rrd4j.DsType;
import org.rrd4j.core.RrdDb;
import org.rrd4j.core.RrdDef;
import org.rrd4j.core.Sample;
import org.rrd4j.core.Util;
import org.rrd4j.graph.RrdGraph;
import org.rrd4j.graph.RrdGraphDef;

import com.sun.jersey.api.client.UniformInterfaceException;

/**
 * @author felipe
 * 
 */
public class RrdToolManager {

	@Context
	ServletContext context;

	private static final String RRDTOOL_PATH = "rrdtool";

	private static final String SPSL_PATH = "switchportstatslogs";

	static final int IMG_WIDTH = 500;

	static final int IMG_HEIGHT = 300;

	private String getSpslGraphFilePath(String fileName) {
		String spslGraphsDirPath = getSpslGraphsDirPath();
		if (spslGraphsDirPath != null) {
			return spslGraphsDirPath + fileName;
		} else {
			return null;
		}
	}

	private String getSpslGraphsDirPath() {
		String graphsDirPath = getGraphsDirPath();
		if (graphsDirPath != null) {
			String spslGraphsDirPath = graphsDirPath + SPSL_PATH
					+ Util.getFileSeparator();
			File spslGraphsDir = new File(spslGraphsDirPath);
			return (spslGraphsDir.exists() || spslGraphsDir.mkdirs()) ? spslGraphsDirPath
					: null;
		} else {
			return null;
		}
	}

	private String getGraphsDirPath() {
		String classPath = this.getClass()
				.getResource(this.getClass().getSimpleName() + ".class")
				.getPath();
		String graphsDirPath = classPath.substring(0,
				classPath.indexOf("WEB-INF"))
				+ RRDTOOL_PATH + Util.getFileSeparator();
		File graphsDir = new File(graphsDirPath);
		return (graphsDir.exists() || graphsDir.mkdirs()) ? graphsDirPath
				: null;
	}

	public RrdToolManager() {
	}

	public String createSwitchPortStatsLogsGraph(String sw,
			String portStatsLogList) throws UniformInterfaceException {
		try {
			JSONObject jsonNosSwitch = new JSONObject(sw);
			JSONArray jsonArrayPortStatsLog = new JSONArray(portStatsLogList);

			int rows = jsonArrayPortStatsLog.length();
			long start = jsonArrayPortStatsLog.getJSONObject(0).getLong("time") / 1000;
			long end = jsonArrayPortStatsLog.getJSONObject(rows - 1).getLong(
					"time") / 1000;
			long step = ((jsonArrayPortStatsLog.getJSONObject(rows - 1)
					.getLong("time")) / 1000)
					- ((jsonArrayPortStatsLog.getJSONObject(rows - 2)
							.getLong("time")) / 1000);

			String filename = jsonNosSwitch.get("nosType") + "_"
					+ jsonNosSwitch.get("nosIp").toString().replace('.', '-')
					+ "_" + jsonNosSwitch.get("nosPort") + "_"
					+ jsonNosSwitch.get("swId").toString().replace(':', '-');
			String rrdPath = getSpslGraphFilePath(filename + ".rrd");
			String imgPath = getSpslGraphFilePath(filename + ".png");

			RrdDef rrdDef = new RrdDef(rrdPath, start - 1, step);
			rrdDef.setVersion(2);
			rrdDef.addDatasource("rxPackets", DsType.GAUGE, step * 2, 0,
					Double.NaN);
			rrdDef.addDatasource("txPackets", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("rxDrops", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("txDrops", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("rxError", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("txError", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("rxFrameError", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("rxOverrunError", GAUGE, step * 2, 0,
					Double.NaN);
			rrdDef.addDatasource("rxCrcError", GAUGE, step * 2, 0, Double.NaN);
			rrdDef.addDatasource("collisions", GAUGE, step * 2, 0, Double.NaN);

			rrdDef.addArchive(ConsolFun.AVERAGE, 0.5, 1, rows);

			RrdDb rrdDb = new RrdDb(rrdDef);
			Sample sample = rrdDb.createSample();
			for (int i = 0; i < rows; i++) {
				JSONObject jsonPortStatsLog = jsonArrayPortStatsLog
						.getJSONObject(i);
				sample.setTime(jsonPortStatsLog.getLong("time") / 1000);
				sample.setValue("rxPackets",
						jsonPortStatsLog.getLong("rxPackets"));
				sample.setValue("txPackets",
						jsonPortStatsLog.getLong("txPackets"));
				sample.setValue("rxDrops", jsonPortStatsLog.getLong("rxDrops"));
				sample.setValue("txDrops", jsonPortStatsLog.getLong("txDrops"));
				sample.setValue("rxError", jsonPortStatsLog.getLong("rxError"));
				sample.setValue("txError", jsonPortStatsLog.getLong("txError"));
				sample.setValue("rxFrameError",
						jsonPortStatsLog.getLong("rxFrameError"));
				sample.setValue("rxOverrunError",
						jsonPortStatsLog.getLong("rxOverrunError"));
				sample.setValue("rxCrcError",
						jsonPortStatsLog.getLong("rxCrcError"));
				sample.setValue("collisions",
						jsonPortStatsLog.getLong("collisions"));

				sample.update();
			}

			RrdGraphDef gDef = new RrdGraphDef();
			gDef.setWidth(IMG_WIDTH);
			gDef.setHeight(IMG_HEIGHT);
			gDef.setFilename(imgPath);
			gDef.setStartTime(start);
			gDef.setEndTime(end);
			String title = "Traffic on Sw " + jsonNosSwitch.get("swId")
					+ " from " + jsonNosSwitch.get("nosType") + " in "
					+ jsonNosSwitch.get("nosIp") + ":"
					+ jsonNosSwitch.get("nosPort");
			gDef.setTitle(title);
			gDef.setVerticalLabel("Packets");

			gDef.datasource("rxPackets", rrdPath, "rxPackets",
					ConsolFun.AVERAGE);
			gDef.datasource("txPackets", rrdPath, "txPackets", AVERAGE);
			gDef.datasource("rxDrops", rrdPath, "rxDrops", AVERAGE);
			gDef.datasource("txDrops", rrdPath, "txDrops", AVERAGE);
			gDef.datasource("rxError", rrdPath, "rxError", AVERAGE);
			gDef.datasource("txError", rrdPath, "txError", AVERAGE);
			gDef.datasource("rxFrameError", rrdPath, "rxFrameError", AVERAGE);
			gDef.datasource("rxOverrunError", rrdPath, "rxOverrunError",
					AVERAGE);
			gDef.datasource("rxCrcError", rrdPath, "rxCrcError", AVERAGE);
			gDef.datasource("collisions", rrdPath, "collisions", AVERAGE);

			gDef.line("rxPackets", Color.GREEN, "rxPackets", (float) 1.5);
			gDef.line("txPackets", Color.BLUE, "txPackets", (float) 1.5);
			gDef.line("rxDrops", Color.GRAY, "rxDrops", (float) 1.5);
			gDef.line("txDrops", Color.DARK_GRAY, "txDrops", (float) 1.5);
			gDef.line("rxError", Color.RED, "rxError", (float) 1.5);
			gDef.line("txError", Color.ORANGE, "txError", (float) 1.5);
			gDef.line("rxFrameError", Color.BLACK, "rxFrameError", (float) 1.5);
			gDef.line("rxOverrunError", Color.CYAN, "rxOverrunError",
					(float) 1.5);
			gDef.line("rxCrcError", Color.PINK, "rxCrcError", (float) 1.5);
			gDef.line("collisions", Color.YELLOW, "collisions", (float) 1.5);

			gDef.setImageInfo("<img src='%s' width='%d' height = '%d'>");
			gDef.setPoolUsed(false);
			gDef.setImageFormat("png");
			new RrdGraph(gDef);

			JSONObject jsonGraphDetail = new JSONObject();
			jsonGraphDetail.put("id", filename);
			jsonGraphDetail.put("name", filename + ".png");

			rrdDb.close();

			return jsonGraphDetail.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	public String createSwitchPortStatsLastMinuteHourGraph(String sw,
			String portStatsLogList) throws UniformInterfaceException {
		try {
			JSONObject jsonNosSwitch = new JSONObject(sw);
			JSONArray jsonArrayPortStatsLog = new JSONArray(portStatsLogList);

			int rows = jsonArrayPortStatsLog.length();
			String prefixFileName = null;
			String prefixTitle = null;
			if (rows == 6) {
				prefixFileName = "lm_";
				prefixTitle = "Last Minute ";
			} else if (rows == 360) {
				prefixFileName = "lh_";
				prefixTitle = "Last Hour ";
			}

			long start = jsonArrayPortStatsLog.getJSONObject(0).getLong("time") / 1000;
			long end = jsonArrayPortStatsLog.getJSONObject(rows - 1).getLong(
					"time") / 1000;
			long step = ((jsonArrayPortStatsLog.getJSONObject(rows - 1)
					.getLong("time")) / 1000)
					- ((jsonArrayPortStatsLog.getJSONObject(rows - 2)
							.getLong("time")) / 1000);

			String filename = prefixFileName + jsonNosSwitch.get("nosType")
					+ "_"
					+ jsonNosSwitch.get("nosIp").toString().replace('.', '-')
					+ "_" + jsonNosSwitch.get("nosPort") + "_"
					+ jsonNosSwitch.get("swId").toString().replace(':', '-');
			String rrdPath = getSpslGraphFilePath(filename + ".rrd");
			String imgPath = getSpslGraphFilePath(filename + ".png");

			RrdDef rrdDef = new RrdDef(rrdPath, start - 1, step);
			rrdDef.setVersion(2);
			rrdDef.addDatasource("rxBytes", DsType.GAUGE, step * 2, 0,
					Double.NaN);
			rrdDef.addDatasource("txBytes", GAUGE, step * 2, 0, Double.NaN);

			rrdDef.addArchive(ConsolFun.AVERAGE, 0.5, 1, rows);

			RrdDb rrdDb = new RrdDb(rrdDef);
			Sample sample = rrdDb.createSample();
			for (int i = 0; i < rows; i++) {
				JSONObject jsonPortStatsLog = jsonArrayPortStatsLog
						.getJSONObject(i);
				sample.setTime(jsonPortStatsLog.getLong("time") / 1000);
				sample.setValue("rxBytes", jsonPortStatsLog.getLong("rxBytes"));
				sample.setValue("txBytes", jsonPortStatsLog.getLong("txBytes"));
				sample.update();
			}

			RrdGraphDef gDef = new RrdGraphDef();
			gDef.setWidth(IMG_WIDTH);
			gDef.setHeight(IMG_HEIGHT);
			gDef.setFilename(imgPath);
			gDef.setStartTime(start);
			gDef.setEndTime(end);
			String title = prefixTitle + "Traffic on Sw "
					+ jsonNosSwitch.get("swId") + " from "
					+ jsonNosSwitch.get("nosType") + " in "
					+ jsonNosSwitch.get("nosIp") + ":"
					+ jsonNosSwitch.get("nosPort");
			gDef.setTitle(title);
			gDef.setVerticalLabel("Bytes");

			gDef.datasource("rxBytes", rrdPath, "rxBytes", ConsolFun.AVERAGE);
			gDef.datasource("txBytes", rrdPath, "txBytes", AVERAGE);

			gDef.line("rxBytes", Color.GREEN, "rxBytes", (float) 1.5);
			gDef.line("txBytes", Color.BLUE, "txBytes", (float) 1.5);

			gDef.setImageInfo("<img src='%s' width='%d' height = '%d'>");
			gDef.setPoolUsed(false);
			gDef.setImageFormat("png");
			new RrdGraph(gDef);

			JSONObject jsonGraphDetail = new JSONObject();
			jsonGraphDetail.put("id", filename);
			jsonGraphDetail.put("name", filename + ".png");

			rrdDb.close();

			return jsonGraphDetail.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

}
