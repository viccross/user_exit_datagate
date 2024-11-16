//DSNTIJAS JOB ,,MSGLEVEL=1,CLASS=A,MSGCLASS=H, 
// REGION=0M,NOTIFY=&SYSUID 
//* JOB NAME = DSNTIJAS 
//* 
//* DESCRIPTIVE NAME = INSTALLATION JOB STREAM 
//* 
//*    Licensed Materials - Property of IBM 
//*    5650-DB2 
//*    (C) COPYRIGHT 2013, 2018 IBM Corp.  All Rights Reserved. 
//* 
//*    STATUS = Version 12 
//* 
//* FUNCTION = CREATE ACCELERATOR DATABASE 
//* 
//* PSEUDOCODE = 
//*   DSNTICU  STEP     Optional: DROP the accelerator database 
//*   DSNTIAC  STEP     Create the accelerator database 
//*   DSNTIAI  STEP     Optional: Initialize the accelerator database 
//*   DSNTICR  Step     Optional: RESTRICT ON DROP 
//* 
//* DEPENDENCIES = 
//* 
//* NOTES = 
//*    PRIOR TO RUNNING THIS JOB, customize it for your system: 
//*    (1) (A) Review the buffer pool settings in the CREATE TABLESPACE
//*            and CREATE INDEX statements processed by this job. 
//*            Update the values as necessary. 
//*        (B) Review the storage group settings in the CREATE 
//*            TABLESPACE and CREATE INDEX statements processed by this
//*            job. Update the values as necessary. 
//*    (2) Add a valid job card. 
//*    (3) Change all occurrences of the following strings: 
//*        (A) Change the subsystem name 'DBD1!' to the SSID of your 
//*            DB2. 
//*        (B) Change 'DB2V13' to the prefix of the target library 
//*            for DB2. 
//*        (C) Change 'DSNTIA!!' to the plan name for DSNTIAD on your 
//*            DB2. 
//*    (4) Refer to your accelerator product documentation for 
//*        information on how to initialize the accelerator database. 
//*        Job step DSNTIAI contains guidance and sample statements 
//*        for initializing the accelerator database.  However, you 
//*        might not need to run that job step if your accelerator 
//*        product does the initialization. Do not run job step 
//*        DSNTIAI if you use the IBM DB2 Analytics Accelerator 
//*        for z/OS. 
//*    (5) If the tables in the accelerator database need to be 
//*        dropped, verify that the following subsystem parameters 
//*        are set properly prior to dropping the tables so that 
//*        acceleration is no longer considered for an SQL statement. 
//*         (1) ACCEL set to NO or not specified 
//*         (2) GET_ACCEL_ARCHIVE set to NO or not specified 
//*         (3) QUERY_ACCELERATION set to NONE or not specified 
//* 
//* CHANGE LOG = 
//*   09/01/11 Add to V10                               PM50435 / n0109
//*   05/24/12                                  n4629r5_inst3 / n4629r5
//*            Add ARCHIVE to SYSACCELERATEDTABLES 
//*   07/06/12                                  n4629r6_inst1 / n4629r6
//*            Change DSNACCEL.SYSACCEL to LOCKSIZE ROW 
//*   08/02/12 Add to V11                162353 / n109r6_inst1 / n109r6
//*   01/31/14 pm95610_inst               merge_c_rally1 pm95610 s20260
//*            Add SYSACCEL.SYSACCELERATEDPACKAGES 
//*   06/18/14 Add optional restrict on drop    PI27766/f175218/f175223
//*   09/08/15 Add new column ACCELERATORSRL to table  s21401 / PI49422
//*            SYSACCELERATORS and ALTER ADD COL stmt           s24899 
//*   06/15/17 Add new column REMOTELOCATION to table           PI82739
//*              SYSACCELERATEDTABLES 
//*            Add new table, SYSACCEL.SYSACCELERATEDTABLESAUTH PI82739
//*   09/06/17 Add new column ACCELERATOR_TYPE to table          s63349
//*            SYSACCELERATORS. 
//*            Add new column ACCELERATOR to table 
//*            SYSACCELERATEDPACKAGES 
//*   05/03/18 Create each SYSACCEL table in a dedicated UTS    PI96859
//*   07/10/19 Add new column ACCELERATION_WAITFORDATA to 
//*            table SYSACCELERATEDPACKAGES     e85303 s53809 / PH14116
//*   09/30/20 E4698 Add column SYSACCELERATEDTABLES.FEATURE    PH30574
//*   11/01/21 For SYSACCEL.SYSACCELERATEDPACKAGES column       PH41064
//*            ACCELERATION_WAITFORDATA , change decimal specification 
//*            from (5,1) to (5, 1) in case DECP DECIMAL=COMMA 
//* 
//*********************************************************************
//JOBLIB  DD  DISP=SHR, 
//            DSN=DB2V13.SDSNLOAD 
//* 
//*  //****************************************************************
//*  //* Optional: Drop the accelerator database 
//*  //****************************************************************
//DSNTICU EXEC PGM=IKJEFT01,DYNAMNBR=20 
//SYSTSPRT DD  SYSOUT=* 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSTSIN  DD  * 
       DSN SYSTEM(DBD1) 
       RUN PROGRAM(DSNTIAD)  PLAN(DSNTIA13) PARM('RC0') - 
            LIBRARY('DBD1.RUNLIB.LOAD') 
       END 
//SYSIN    DD  * 
       DROP DATABASE DSNACCEL; 
/* 
//* 
//*********************************************************************
//* Create the accelerator databases 
//*********************************************************************
//DSNTIAC EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT) 
//SYSTSPRT DD  SYSOUT=* 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSTSIN  DD  * 
  DSN SYSTEM(DBD1) 
  RUN PROGRAM(DSNTIAD)  PLAN(DSNTIA13) - 
       LIBRARY('DBD1.RUNLIB.LOAD') 
  END 
//SYSIN    DD  * 
  CREATE DATABASE DSNACCEL 
         CCSID UNICODE; 
                                         
  CREATE TABLESPACE SYSTSACC IN DSNACCEL 
         DSSIZE 64G 
         SEGSIZE 32 
         MAXPARTITIONS 1 
         LOCKSIZE ROW 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         BUFFERPOOL BP0 
         CLOSE NO 
         CCSID UNICODE; 
                                         
  CREATE TABLESPACE SYSTSACT IN DSNACCEL 
         DSSIZE 64G 
         SEGSIZE 32 
         MAXPARTITIONS 1 
         LOCKSIZE ROW 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         BUFFERPOOL BP0 
         CLOSE NO 
         CCSID UNICODE; 
                                         
  CREATE TABLESPACE SYSTSACP IN DSNACCEL 
         DSSIZE 64G 
         SEGSIZE 32 
         MAXPARTITIONS 1 
         LOCKSIZE ROW 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         BUFFERPOOL BP0 
         CLOSE NO 
         CCSID UNICODE; 
                                                                  
  CREATE TABLESPACE SYSTSATA IN DSNACCEL 
         DSSIZE 64G 
         SEGSIZE 32 
         MAXPARTITIONS 1 
         LOCKSIZE ROW 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         BUFFERPOOL BP0 
         CLOSE NO 
         CCSID UNICODE; 
                                                                  
  CREATE TABLE "SYSACCEL"."SYSACCELERATORS" 
         ( "ACCELERATORNAME"    VARCHAR(128) NOT NULL 
         , "LOCATION"           VARCHAR(128) 
         , "ACCELERATORSRL"     CHAR(64) FOR BIT DATA DEFAULT NULL
         , "ACCELERATOR_TYPE"   SMALLINT NOT NULL WITH DEFAULT  1 
         ) 
         IN DSNACCEL.SYSTSACC 
         CCSID UNICODE; 
                                                                  
  CREATE UNIQUE INDEX "SYSACCEL"."DSNACC01" 
         ON "SYSACCEL"."SYSACCELERATORS" 
         ( "ACCELERATORNAME" ASC ) 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         CLUSTER BUFFERPOOL BP0 
         CLOSE NO; 
                                                                  
  CREATE TABLE "SYSACCEL"."SYSACCELERATEDTABLES" 
         ( "NAME"            VARCHAR(128)  NOT NULL 
         , "CREATOR"         VARCHAR(128)  NOT NULL 
         , "ACCELERATORNAME" VARCHAR(128)  NOT NULL 
         , "REMOTENAME"      VARCHAR(128)  NOT NULL 
         , "REMOTECREATOR"   VARCHAR(128)  NOT NULL 
         , "ENABLE"          CHAR(1)       NOT NULL 
         , "CREATEDBY"       VARCHAR(128)  NOT NULL 
         , "CREATEDTS"       TIMESTAMP     NOT NULL WITH DEFAULT
         , "ALTEREDTS"       TIMESTAMP     NOT NULL WITH DEFAULT
         , "REFRESH_TIME"    TIMESTAMP     NOT NULL WITH DEFAULT
         , "SUPPORTLEVEL"    SMALLINT      NOT NULL WITH DEFAULT
         , "ARCHIVE"         CHAR(1)       NOT NULL WITH DEFAULT
         , "REMOTELOCATION"  VARCHAR(128)  NOT NULL WITH DEFAULT
         , "FEATURE"         INTEGER       NOT NULL WITH DEFAULT
         ) 
         IN DSNACCEL.SYSTSACT 
         CCSID UNICODE; 
                                                                
  CREATE UNIQUE INDEX "SYSACCEL"."DSNACT01" 
         ON "SYSACCEL"."SYSACCELERATEDTABLES" 
         ( "CREATOR"          ASC 
         , "NAME"             ASC 
         , "ACCELERATORNAME"  ASC 
         ) 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         CLUSTER BUFFERPOOL BP0 
         CLOSE NO; 
                                                                
  CREATE TABLE "SYSACCEL"."SYSACCELERATEDPACKAGES" 
         ( "LOCATION"        VARCHAR(128)  NOT NULL WITH DEFAULT
         , "COLLID"          VARCHAR(128)  NOT NULL WITH DEFAULT
         , "NAME"            VARCHAR(128)  NOT NULL WITH DEFAULT
         , "CONTOKEN"        CHAR(8)       FOR BIT DATA 
                                           NOT NULL WITH DEFAULT
         , "VERSION"         VARCHAR(122)  NOT NULL WITH DEFAULT
         , "OWNER"           VARCHAR(128)  NOT NULL WITH DEFAULT
         , "CREATOR"         VARCHAR(128)  NOT NULL WITH DEFAULT
         , "TIMESTAMP"       TIMESTAMP     NOT NULL WITH DEFAULT
         , "BINDTIME"        TIMESTAMP     NOT NULL WITH DEFAULT
         , "RELBOUND"        CHAR(1)       NOT NULL WITH DEFAULT 
         , "TYPE"            CHAR(1)       NOT NULL WITH DEFAULT 
         , "COPYID"          INTEGER       NOT NULL WITH DEFAULT 
         , "QUERYACCELERATION" CHAR(1)     NOT NULL WITH DEFAULT 
         , "GETACCELARCHIVE" CHAR(1)       NOT NULL WITH DEFAULT 
         , "ACCELERATOR"     VARCHAR(128)  NOT NULL WITH DEFAULT 
         , "ACCELERATION_WAITFORDATA" DECIMAL(5, 1) 
                                           NOT NULL WITH DEFAULT -1.0
         ,  PRIMARY KEY 
              ( "LOCATION" 
              , "COLLID" 
              , "NAME" 
              , "CONTOKEN" 
              ) 
         ) 
         IN DSNACCEL.SYSTSACP 
         CCSID UNICODE; 
                                                                     
  CREATE UNIQUE INDEX "SYSACCEL"."DSNACP01" 
         ON "SYSACCEL"."SYSACCELERATEDPACKAGES" 
         ( "LOCATION"        ASC 
         , "COLLID"          ASC 
         , "NAME"            ASC 
         , "VERSION"         ASC 
         ) 
         NOT CLUSTER 
         NOT PADDED 
         USING STOGROUP SYSDEFLT 
         ERASE NO 
         FREEPAGE 0 PCTFREE 10 
         GBPCACHE CHANGED 
         DEFINE YES 
         COMPRESS NO 
         BUFFERPOOL BP0 
         CLOSE NO; 
                                                                     
  CREATE UNIQUE INDEX "SYSACCEL"."DSNACP02" 
         ON "SYSACCEL"."SYSACCELERATEDPACKAGES" 
         ( "LOCATION"        ASC 
         , "COLLID"          ASC 
         , "NAME"            ASC 
         , "CONTOKEN"        ASC 
         ) 
         NOT CLUSTER 
         NOT PADDED 
         USING STOGROUP SYSDEFLT 
         ERASE NO 
         FREEPAGE 0 PCTFREE 10 
         GBPCACHE CHANGED 
         DEFINE YES 
         COMPRESS NO 
         BUFFERPOOL BP0 
         CLOSE NO; 
                                                                
  CREATE TABLE "SYSACCEL"."SYSACCELERATEDTABLESAUTH" 
         ( "ACCELERATORNAME" VARCHAR(128)  NOT NULL 
         , "GRANTOR"         VARCHAR(128)  NOT NULL 
         , "GRANTEE"         VARCHAR(128)  NOT NULL 
         , "GRANTEETYPE"     CHAR(1)       NOT NULL 
         , "TCREATOR"        VARCHAR(128)  NOT NULL 
         , "TNAME"           VARCHAR(128)  NOT NULL 
         , "SELECTAUTH"      CHAR(1)       NOT NULL 
         , "GRANTEDTS"       TIMESTAMP     NOT NULL WITH DEFAULT
         ,  PRIMARY KEY 
              ( "TCREATOR" 
              , "TNAME" 
              , "ACCELERATORNAME" 
              , "GRANTEE" 
              ) 
         ) 
         IN DSNACCEL.SYSTSATA 
         CCSID UNICODE; 
                                                                
  CREATE UNIQUE INDEX "SYSACCEL"."DSNATA01" 
         ON "SYSACCEL"."SYSACCELERATEDTABLESAUTH" 
         ( "TCREATOR"         ASC 
         , "TNAME"            ASC 
         , "ACCELERATORNAME"  ASC 
         , "GRANTEE"          ASC 
         ) 
         USING STOGROUP SYSDEFLT 
         FREEPAGE 0 PCTFREE 10 
         CLUSTER BUFFERPOOL BP0 
         CLOSE NO; 
/* 
//* 
//*********************************************************************
//* Initialize the accelerator database 
//*********************************************************************
//* Before reviewing or modifying this job step, refer to your 
//* accelerator product documentation for information on how to 
//* initialize the accelerator database. If your accelerator product 
//* does not provide a means of initializing the accelerator database, 
//* modify and use the following statements to do the initialization. 
//* 
//* To use this job step to initialize the accelerator database, 
//* locate and replace each of the following tokens in the VALUES 
//* clauses of the INSERT statements with the appropriate values for 
//* your accelerator setup: 
//* 
//*   * accelerator-name: 
//*       Replace this token with the unique name for the accelerator 
//*       server.  This is the name by which the accelerator server 
//*       is known to local DB2 SQL accelerated query tables. 
//* 
//*   * accelerator-location: 
//*       Each row in the SYSACCEL.SYSACCELERATORS table must have at 
//*       least one corresponding row in the SYSIBM.LOCATIONS 
//*       table with a matching location value. Replace the 
//*       accelerator-location token with a name that associates the 
//*       corresponding rows. 
//* 
//*********************************************************************
//*  //DSNTIAI EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT) 
//*  //SYSTSPRT DD  SYSOUT=* 
//*  //SYSPRINT DD  SYSOUT=* 
//*  //SYSUDUMP DD  SYSOUT=* 
//*  //SYSTSIN  DD  * 
//*    DSN SYSTEM(DBD1!) 
//*    RUN PROGRAM(DSNTIAD) PLAN(DSNTIA!!) - 
//*    LIB('DBD1.RUNLIB.LOAD') 
//*    END 
//*  //SYSIN    DD  * 
//*    INSERT INTO SYSACCEL.SYSACCELERATORS 
//*           ( ACCELERATORNAME 
//*           , LOCATION 
//*           ) 
//*          VALUES 
//*           ( 'accelerator-name' 
//*           , 'accelerator-location' 
//*           ); 
//*  /* 
//* 
//*********************************************************************
//* Optional: Add RESTRICT ON DROP 
//* To prevent the tables in the accelerator database from being 
//* dropped by accident, run the ALTER TABLE statements in DSNTICR. 
//* If these tables need to be dropped after adding the RESTRICT ON 
//* DROP, follow these steps: 
//* Prior to dropping the tables in the accelerator database, 
//* verify that the following subsystem parameters are set properly so 
//* that acceleration is no longer considered for an SQL statement. 
//* (1) ACCEL set to NO or not specified 
//* (2) GET_ACCEL_ARCHIVE set to NO or not specified 
//* (3) QUERY_ACCELERATION set to NONE or not specified 
//* Remove the RESTRICT ON DROP using the following ALTER TABLE 
//* statements: 
//*   ALTER TABLE SYSACCEL.SYSACCELERATORS DROP RESTRICT ON DROP; 
//*   ALTER TABLE SYSACCEL.SYSACCELERATEDTABLES DROP RESTRICT ON DROP; 
//*   ALTER TABLE SYSACCEL.SYSACCELERATEDPACKAGES DROP RESTRICT ON DROP;
//*   ALTER TABLE SYSACCEL.SYSACCELERATEDTABLESAUTH 
//*     DROP RESTRICT ON DROP; 
//* Now drop the DSNACCEL database containing all SYSACCEL objects: 
//*   DROP DATABASE DSNACCEL; 
//* WARNING: 
//* REPAIR DBD DROP DATABASE should not be used to drop these tables. 
//********************************************************************* 
//DSNTICR EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT) 
//SYSTSPRT DD  SYSOUT=* 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSTSIN  DD  * 
       DSN SYSTEM(DBD1) 
       RUN PROGRAM(DSNTIAD) PLAN(DSNTIA13) - 
       LIB('DBD1.RUNLIB.LOAD') 
       END 
//SYSIN    DD  * 
 grant monitor2 to ibmuser; 
 GRANT EXECUTE ON FUNCTION DSNAQT.* TO IBMUSER; 
 GRANT EXECUTE ON PROCEDURE SYSPROC.* TO IBMUSER; 
 GRANT EXECUTE ON PACKAGE SYSACCEL.* TO IBMUSER; 
 GRANT EXECUTE ON PACKAGE SYSACCEL.AQTSFACT TO IBMUSER; 
 GRANT MONITOR1 TO IBMUSER; 
 GRANT TRACE TO IBMUSER; 
 GRANT DISPLAY TO IBMUSER; 
 GRANT SYSOPR TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSCOLUMNS TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSCONTROLS TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSDATABASE TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSDUMMY1 TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSINDEXES TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSRELS TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSTABLEPART TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSTABLES TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSVIEWS TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSTABLES TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSCOLUMNS TO IBMUSER; 
 GRANT SELECT ON SYSIBM.SYSDUMMY1 TO IBMUSER; 
 GRANT SELECT ON DSNAQT.ACCEL_NAMES TO IBMUSER;
/* 
