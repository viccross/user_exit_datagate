//AQTTIJSP JOB ,,MSGLEVEL=1,CLASS=A,MSGCLASS=H, 
// REGION=0M,NOTIFY=&SYSUID 
//* JOB NAME = AQTTIJSP 
//* 
//* Licensed Materials - Property of IBM 
//* 5697-DA7 
//* (C) COPYRIGHT IBM Corp. 2017, 2024. 
//* 
//* US Government Users Restricted Rights 
//* Use, duplication or disclosure restricted by GSA ADP Schedule 
//* Contract with IBM Corporation 
//* 
//* DISCLAIMER OF WARRANTIES : 
//* Permission is granted to copy and modify this  Sample code provided
//* that both the copyright  notice,- and this permission notice and 
//* warranty disclaimer  appear in all copies and modified versions. 
//* 
//* THIS SAMPLE CODE IS LICENSED TO YOU AS-IS. 
//* IBM  AND ITS SUPPLIERS AND LICENSORS  DISCLAIM ALL WARRANTIES, 
//* EITHER EXPRESS OR IMPLIED, IN SUCH SAMPLE CODE, INCLUDING THE 
//* WARRANTY OF NON-INFRINGEMENT AND THE IMPLIED WARRANTIES OF 
//* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT 
//* WILL IBM OR ITS LICENSORS OR SUPPLIERS BE LIABLE FOR ANY DAMAGES 
//* ARISING OUT OF THE USE OF OR INABILITY TO USE THE SAMPLE CODE OR 
//* COMBINATION OF THE SAMPLE CODE WITH ANY OTHER CODE. IN NO EVENT 
//* SHALL IBM OR ITS LICENSORS AND SUPPLIERS BE LIABLE FOR ANY LOST 
//* REVENUE, LOST PROFITS OR DATA, OR FOR DIRECT, INDIRECT, SPECIAL, 
//* CONSEQUENTIAL,INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER CAUSED AND 
//* REGARDLESS OF THE THEORY OF LIABILITY,-, EVEN IF IBM OR ITS 
//* LICENSORS OR SUPPLIERS HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH
//* DAMAGES. 
//* 
//*    STATUS = Version 7 
//* 
//* DESCRIPTION: This JCL creates DB2 for z/OS objects 
//*              required by 
//*              IBM DB2 Analytics Accelerator 
//*              for z/OS, Version 07.05.00. 
//* 
//*********************************************************************
//* Build: 20240711-0604 
//* 
//*   The AQT06TRN batch program accepts the following parameters: 
//*     - DB2SSN  : Specifies the name of the DB2 subsystem 
//* 
//*     - MODE    : Specifies the processing mode: 
//*                 - INSTALL 
//*                     Creates, binds, and grants access to the 
//*                     DB2-supplied routines and related objects. 
//*                     Existing objects are not replaced except as 
//*                     discussed above under special notices. 
//*                 - INSTALL-PREVIEW 
//*                     Same as INSTALL mode except that no changes 
//*                     are processed.  Generated JCL is outputted to 
//*                     the JCLOUT DD. 
//*                 - REINSTALL 
//*                     Similar to INSTALL mode, except that existing 
//*                     DB2-supplied routines and CGTTs are first 
//*                     dropped.  Existing related databases, table 
//*                     spaces, tables, and indexes are not dropped 
//*                     except as discussed under special notices. 
//*                 - REINSTALL-PREVIEW 
//*                     Same as REINSTALL mode except that no changes 
//*                     are processed.  Generated JCL is outputted to 
//*                     the JCLOUT DD. 
//* 
//*     - AUTHID  : Specifies the CURRENT SQLID setting to be used to 
//*                 create and configure the IDAA-supplied routines 
//*                 and related objects.  Also, the default OWNER when 
//*                 binding packages for these routines and no BINDID 
//*                 is specified. 
//*                 This parameter is optional. If it is not specified 
//*                 the user id submitting this job will be used for 
//*                 configuration. 
//*                 -> Recommendation: Specify an authorization ID that 
//*                    has sufficient privileges to execute the 
//*                    configuration steps. For details please see the 
//*                    IBM Db2 Analytics Accelerator for z/OS: 
//*                    Installation Guide 
//*     - BINDID  : Specifies the sql id which is used as package owner 
//*                 to bind the IDAA packages. 
//*                 This parameter is optional. If it is not specified 
//*                 the value of the AUTHID parameter will be used 
//*                 if the AUTHID parameter is provided. Otherwise 
//*                 the user id of the submitter of this job will be 
//*                 used. 
//*                 -> Recommendation: Specify an authorization ID that 
//*                    has sufficient privileges to bind packages and to
//*                    execute the packages as the owner. 
//*                    For details please see the IBM Db2 Analytics 
//*                    Accelerator for z/OS: Installation Guide 
//* 
//*   The AQT06TRN batch program allocates the following DD statements: 
//*   * Input DDs used by AQT06TRN: 
//*     - DBRMLIB : For IDAA-supplied DBRMs (SAQTDBRM target library) 
//* 
//*     - CFIGIN  : For configuration control statements for the 
//*                 IDAA-supplied routines, using these parameters: 
//*                 - DBD1WLM_GENERALm 
//*                     Required: The name of the WLM environment for 
//*                     running the routine. 
//*                 - GRANTTO 
//*                     Required: A comma seperated list of 
//*                     authorization IDs to be granted access to the 
//*                     routine 
//*                 - PKGOWNER 
//*                     Optional: The authorization ID to be specified 
//*                     as OWNER when binding a package for the 
//*                     routine.  If not given, the package owner is 
//*                     given by the AQT06TRN AUTHID parameter. 
//* 
//* * Work DDs used by AQT06TRN: 
//*     - SYSUT1  : For internal bind processing 
//* 
//* * Output DDs used by AQT06TRN: 
//*     - SYSPRINT: For AQT06TRN messages and reports 
//* 
//*     - SYSTSPRT: For internal bind processing 
//* 
//*     - CFIGOUT : For configuration control statements 
//* 
//*     - SQLOUT  : For SQL statements generated by AQT06TRN 
//* 
//*     - BINDOUT : For BIND commands generated by AQT06TRN 
//* 
//*     - JCLOUT  : For JCL generated by AQT06TRN in MODE(xxxx-PREVIEW)
//*                 By default this DD prints to SYSOUT 
//*                 If you want to store the JCL please specify a 
//*                 dataset that meets the according DCB (see below) 
//* 
//*   -----------------------------------------------------------------
//* 
//*  Dependencies = 
//*    The accelerator database must be created and initialized before 
//*    before running this job (see DB2 job DSNTIJAS). 
//* 
//*  Notes = 
//*    PRIOR TO RUNNING THIS JOB, customize it for your system: 
//*    (1) Add a valid job card 
//*    (2) Locate and change all occurrences of the following strings 
//*        as indicated: 
//*        (A) The subsystem name 'DBD1' to the name of your DB2 
//*        (B) 'DB2V13' to the prefix of the target library for DB2 
//*        (C) 'DATAGATE' to the prefix of the target library for the 
//*            stored procedures 
//*        (D) 'DBD1WLM_GENERAL' to the name of the WLM environment for
//*            the stored procedures 
//*        This job template defines a single string 'PUBLIC' for 
//*        the authorization-id(s) that should have EXECUTE privileges 
//*        on all created Stored Procedures. Fine-grained access 
//*        control can be implemented by granting access to specific 
//*        authorization-ids for individual stored procedures and 
//*        user-defined functions. 
//*        If custom authorizations have already been set up for the 
//*        stored procedures, be careful not to override them in an 
//*        upgrade installation by executing new GRANT statements for 
//*        already installed stored procedures 
//*    (3) If you are editing this job with the ISPF editor please 
//*        ensure that you don't use sequence numbers by issuing 
//*        the primary command 'UNNUM'. 
//* 
//*********************************************************************
//JOBLIB   DD  DISP=SHR, 
//             DSN=DB2V13.SDSNLOAD 
//         DD  DISP=SHR, 
//             DSN=DB2V13.SDSNEXIT 
//         DD  DISP=SHR, 
//             DSN=DATAGATE.SAQTMOD 
//         DD  DISP=SHR, 
//             DSN=CEE.SCEERUN 
//* 
//*********************************************************************
//* Bind the installation program package 
//*********************************************************************
//AQTBIND EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT) 
//SYSTSPRT DD  SYSOUT=* 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSTSIN  DD  * 
  DSN SYSTEM(DBD1) 
  BIND PACKAGE(SYSACCEL) MEMBER(AQTSFTRN) - 
       ACTION(REPLACE) ISO(CS) CURRENTDATA(NO) ENCODING(UNICODE) - 
       DYNAMICRULES(RUN) KEEPDYNAMIC(NO) - 
       LIBRARY('DATAGATE.SAQTDBRM') - 
       VALIDATE(RUN) 
//* 
//* If a trace is needed just uncomment the ALLOCTRC step 
//* 
//*ALLOCTRC EXEC PGM=IEFBR14 
//*SYSOUT DD SYSOUT=* 
//*AQTTRACE   DD DSN=!AQTTRACE!, 
//*             DCB=(RECFM=FB,BLKSIZE=10K,LRECL=1024,DSORG=PS), 
//*             SPACE=(TRK,(100,20)), 
//*             DISP=(MOD,CATLG,KEEP) 
//*********************************************************************
//* 
//*   AQT06TRN : Install and configure IDAA-supplied routines 
//*   If a trace is needed just uncomment the AQTTRACE DD statement 
//* 
//AQT06TRN EXEC PGM=AQT06TRN,COND=(4,LT), 
//             PARM=('DB2SSN(DBD1) MODE(REINSTALL)', 
//             ' AUTHID(IBMUSER) BINDID(IBMUSER)') 
//DBRMLIB  DD  DISP=SHR,DSN=DATAGATE.SAQTDBRM 
//SYSUT1   DD  UNIT=SYSDA,SPACE=(27930,(10,5)), 
//             DCB=(RECFM=FB,LRECL=133) 
//SYSPRINT DD  SYSOUT=*,DCB=(RECFM=FB,LRECL=133) 
//SYSTSPRT DD  SYSOUT=* 
//CFIGOUT  DD  SYSOUT=* 
//SQLOUT   DD  SYSOUT=* 
//BINDOUT  DD  SYSOUT=* 
//JCLOUT   DD  SYSOUT=*,DCB=(RECFM=FB,LRECL=80) 
//*AQTTRACE DD  DSN=!AQTTRACE!, 
//*             DISP=SHR 
//CFIGIN   DD  * 
* 
* The statements below are used by PGM=AQT06TRN to customize 
* IDAA-supplied stored procedures and UDFs on this DB2. 
* 
* Rules: 
* (1) All statements are required - do not remove any. 
* (2) Statements must be separated by an all-blank line 
* (3) Lines that contain '*' in column 1 are comment lines 
* (4) Each statement specifies the WLM ENVIRONMENT (WLMENV) and 
*     execute access list (GRANTTO) for the indicated routine. 
*     WLMENV and GRANTTO are required parameters but you can modify 
*     the settings. 
* (5) Some statements also specify the package owner (PKGOWNER) 
*     for the routine.  PKGOWNER is optional.  It is ignored if 
*     specified for a routine that does not have a package. 
* (6) Do not use embedded blanks in values specified for WLMENV, 
*     GRANTTO, or PKGOWNER 
* 
* 
***********************************************************************
** Accelerator routines 
***********************************************************************
  SYSPROC.ACCEL_ADD_ACCELERATOR 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_ADD_ACCELERATOR2 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_ADD_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_ALTER_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_ARCHIVE_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_COLLECT_TABLE_STATISTICS 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_CONFIG_OPTIMIZATION_PROFILE
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_CONTROL_ACCELERATOR 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_CREATE_REFERENCE_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_QUERIES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_QUERIES2 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_QUERY_DETAILS 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_QUERY_DETAILS2 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_QUERY_EXPLAIN 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_QUERY_DOC 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_TABLES_DETAILS 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GET_TABLES_INFO 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_GRANT_TABLES_REFERENCE 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_LOAD_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_MIGRATE 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_REMOVE_ACCELERATOR 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_REMOVE_REFERENCE_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_REMOVE_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_REVOKE_TABLES_REFERENCE 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_RESTORE_ARCHIVE_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_SET_TABLES_ACCELERATION 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_SET_TABLES_REPLICATION 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_SYNCHRONIZE_SCHEMA 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_SYNCHRONIZE_TABLES 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_TEST_CONNECTION 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_UPDATE_CREDENTIALS 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  SYSPROC.ACCEL_UPDATE_SOFTWARE2 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_CANCELTASKS 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_CLEARTRACEDATA 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_GETACCELERATORINFO 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_GETACCELERATORTASKS 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_GETTRACECONFIG 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_GETTRACEDATA 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_SETTRACECONFIG 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_STARTREPLICATION 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_STOPREPLICATION 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_GETREPLICATIONEVENTS 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_WAITFORREPLICATION 
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_CONTROL_GETADDITIONALSUPPORT
    WLMENV(-) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_GETVERSION 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  DSNAQT.ACCEL_READFILE3 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 

  DSNAQT.GET_FILE_FROM_ACCELERATOR 
    WLMENV(DBD1WLM_GENERAL) 
    GRANTTO(PUBLIC) 
