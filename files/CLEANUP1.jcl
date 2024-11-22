//CLEANUP JOB ,,MSGLEVEL=1,CLASS=A,MSGCLASS=H, 
// REGION=0M,NOTIFY=&SYSUID 
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
//DROPTBL EXEC PGM=IKJEFT01,DYNAMNBR=20 
//SYSTSPRT DD  SYSOUT=* 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSTSIN  DD  * 
       DSN SYSTEM(DBD1) 
       RUN PROGRAM(DSNTIAD)  PLAN(DSNTIA13) PARM('RC0') - 
            LIBRARY('DBD1.RUNLIB.LOAD') 
       END 
//SYSIN    DD  * 
       DELETE FROM SYSIBM.IPNAMES; 
       DELETE FROM SYSIBM.USERNAMES; 
       DELETE FROM SYSIBM.LOCATIONS; 
       DELETE FROM SYSACCEL.SYSACCELERATORS; 
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