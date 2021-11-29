package edu.harvard.i2b2.plugin.pb.main;

import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import edu.harvard.i2b2.common.exception.I2B2DAOException;
import edu.harvard.i2b2.common.exception.I2B2Exception;
import edu.harvard.i2b2.common.util.jaxb.JAXBUtil;
import edu.harvard.i2b2.crc.datavo.i2b2message.SecurityType;
import edu.harvard.i2b2.crc.datavo.i2b2result.BodyType;
import edu.harvard.i2b2.crc.datavo.i2b2result.DataType;
import edu.harvard.i2b2.crc.datavo.i2b2result.ResultEnvelopeType;
import edu.harvard.i2b2.crc.datavo.i2b2result.ResultType;
import edu.harvard.i2b2.crc.datavo.ontology.ConceptType;
import edu.harvard.i2b2.crc.datavo.ontology.ConceptsType;
import edu.harvard.i2b2.crc.datavo.setfinder.query.AnalysisDefinitionType;
import edu.harvard.i2b2.crc.datavo.setfinder.query.AnalysisParamType;
import edu.harvard.i2b2.plugin.pb.dao.DAOFactoryHelper;
import edu.harvard.i2b2.plugin.pb.dao.DataSourceLookupHelper;
import edu.harvard.i2b2.plugin.pb.dao.SetFinderDAOFactory;
import edu.harvard.i2b2.plugin.pb.dao.setfinder.IQueryInstanceDao;
import edu.harvard.i2b2.plugin.pb.dao.setfinder.IQueryMasterDao;
import edu.harvard.i2b2.plugin.pb.dao.setfinder.IQueryResultInstanceDao;
import edu.harvard.i2b2.plugin.pb.dao.setfinder.IXmlResultDao;
import edu.harvard.i2b2.plugin.pb.dao.setfinder.QueryStatusTypeId;
import edu.harvard.i2b2.plugin.pb.datavo.CRCJAXBUtil;
import edu.harvard.i2b2.plugin.pb.datavo.DataSourceLookup;
import edu.harvard.i2b2.plugin.pb.datavo.QtQueryInstance;
import edu.harvard.i2b2.plugin.pb.datavo.QtQueryMaster;
import edu.harvard.i2b2.plugin.pb.datavo.QtQueryResultInstance;
import edu.harvard.i2b2.plugin.pb.delegate.ontology.CallOntologyUtil;
import edu.harvard.i2b2.plugin.pb.util.I2B2RequestMessageHelper;
import edu.harvard.i2b2.plugin.pb.util.PMServiceAccountUtil;
import edu.harvard.i2b2.plugin.pb.util.QueryProcessorUtil;

/**
 * 
 * runSql Plugin is configurable to run any SQL stored procedure with a 
 * @QueryInstanceID parameter.
 *
 * This plugin is designed to allow SQL developers to easily create server
 * side functionality by handling all the i2b2 parts and allowing developers
 * to focus on logic within the SQL code.
 * 
 * 
 */
public class runSql extends edu.harvard.i2b2.plugin.pb.dao.CRCDAO {

	public static void main(String args[]) throws Exception {
		System.out.println("Hello World");
		runSql main1 = new runSql();

		// read command line params[domain, project, user and analysis
		// instance id
		String arg = "", domainId = "", projectId = "", userId = "", patientSetId = "", instanceId = "", conceptPath = "", sql = "";
		int i = 0;
		while (i < args.length) {
			arg = args[i];
			System.out.println(i + " : " + arg);
			if (arg.startsWith("-domain_id")) {
				domainId = arg.replace("-domain_id=", "");
			} else if (arg.startsWith("-project_id")) {
				projectId = arg.replace("-project_id=", "");
			} else if (arg.startsWith("-user_id")) {
				userId = arg.replace("-user_id=", "");
			} else if (arg.startsWith("-instance_id")) {
				instanceId = arg.replace("-instance_id=", "");
			} else if (arg.startsWith("-sql")) {
				sql = arg.replace("-sql=", "");
			}
			i++;
		}
		System.out.println("domainId = " + domainId + " project " + projectId
				+ " userid " + userId + " instanceId " + instanceId);

		System.out.println(sql);
				
				
		// call the calculation function
		main1.calculateAndWriteResultXml(projectId, userId, domainId,
				patientSetId, instanceId, sql);
	}

	public void calculateAndWriteResultXml(String projectId, String userId,
			String domainId, String patientSetId, String instanceId, String sql) throws Exception {
		boolean errorFlag = false;
		String resultInstanceId = "";
		SetFinderDAOFactory setfinderDaoFactory = null;
		Throwable throwable = null;
		try {
			// find out datasource for the matching domain,project and user id
			DataSourceLookupHelper dataSourceLookupHelper = new DataSourceLookupHelper();
			DataSourceLookup dataSourceLookup = dataSourceLookupHelper
					.matchDataSource(domainId, projectId, userId);
					
					
			// inside analysis plugin always instanciate datasource using
			// spring, the
			// jboss container datasource will not work
			QueryProcessorUtil qpUtil = QueryProcessorUtil.getInstance();
			DataSource dataSource = qpUtil.getSpringDataSource(dataSourceLookup
					.getDataSource());
			DAOFactoryHelper daoHelper = new DAOFactoryHelper(dataSourceLookup,
					dataSource);

			// from the dao helper, get the setfinder dao factory
			setfinderDaoFactory = daoHelper.getDAOFactory()
					.getSetFinderDAOFactory();

			runPlugin(dataSource, setfinderDaoFactory, instanceId, sql);
			} catch (Exception e) {
			e.printStackTrace();
			errorFlag = true;
			// write exception stack trace to the output file
			throwable = e.getCause();
			//throw e;
		} finally {

			IQueryResultInstanceDao resultInstanceDao = setfinderDaoFactory
					.getPatientSetResultDAO();

			if (errorFlag) {
				resultInstanceDao.updatePatientSet(resultInstanceId,
						QueryStatusTypeId.STATUSTYPE_ID_ERROR, throwable
								.getMessage(), 0, 0, "");
			} else {
				resultInstanceDao.updatePatientSet(resultInstanceId,
						QueryStatusTypeId.STATUSTYPE_ID_FINISHED, 0);
			}
		}

	}
	
	public void runPlugin(DataSource dataSource,
			SetFinderDAOFactory sfDAOFactory, String instanceId, String sql)
			throws I2B2DAOException {
		this
				.setDbSchemaName(sfDAOFactory.getDataSourceLookup()
						.getFullSchema());
		String tempTableName = "";
		PreparedStatement stmt = null;
		boolean errorFlag = false;
		String itemKey = "";
		Connection conn = null;
		try {
			String patientSetSql = "exec " + sql + " @QueryInstanceID=?";
			conn = dataSource.getConnection();
			stmt = conn.prepareStatement(patientSetSql);
			stmt.setString(1, instanceId);
			stmt.execute();

		} catch (Exception sqlEx) {
			log.error("HealthcareSystemDynamics.getPatientSet:"
					+ sqlEx.getMessage(), sqlEx);
			throw new I2B2DAOException(
					"HealthcareSystemDynamics.getPatientSet:"
							+ sqlEx.getMessage(), sqlEx);
		} finally {
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
