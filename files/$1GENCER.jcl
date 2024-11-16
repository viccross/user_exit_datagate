//AQTSSLDG JOB MSGCLASS=H,CLASS=A,NOTIFY=&SYSUID,REGION=0M 
//*********************************************************************
//CRTCA    EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
 SETROPTS CLASSACT(DIGTCERT DIGTRING) 
 RDEFINE FACILITY IRR.DIGTCERT.LISTRING UACC(NONE) 
 RDEFINE FACILITY IRR.DIGTCERT.LIST UACC(NONE) 
 PERMIT IRR.DIGTCERT.LIST - 
        CLASS(FACILITY) ID(STCDB2) ACCESS(CONTROL) 
 PERMIT IRR.DIGTCERT.LISTRING - 
        CLASS(FACILITY) ID(STCDB2) ACCESS(READ) 
 PE IRR.DIGTCERT.LIST CL(FACILITY) ID(IBMUSER) ACC(READ) 
 PE IRR.DIGTCERT.LISTRING CL(FACILITY) ID(IBMUSER) ACC(UPDATE) 
 SETR RACLIST (DIGTRING) REFRESH 
 SETR RACLIST (DIGTCERT) REFRESH 
 SETR RACLIST (FACILITY) REFRESH 
//*********************************************************************
//* CREATE SIGNER CERTIFICATE 
//*********************************************************************
//CRTSIG    EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
 RACDCERT CERTAUTH - 
          GENCERT - 
          SUBJECTSDN(OU('DB2 SERVER CA') - 
                     O('IBM') - 
                     L('UKI') - 
                     C('UK')) - 
          NOTAFTER(DATE(2030-12-31)) - 
          WITHLABEL('DB2 SERVER CA') - 
          KEYUSAGE(CERTSIGN) 
  SETR RACLIST (DIGTRING) REFRESH 
  SETR RACLIST (DIGTCERT) REFRESH 
  SETR RACLIST (FACILITY) REFRESH 
//*********************************************************************
//*********************************************************************
//* CREATE SERVER CERTIFICATE FOR DB2 
//*********************************************************************
//CRTSER    EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
  RACDCERT ID(STCDB2) - 
           DELETE(LABEL('DB2LABEL')) 
  RACDCERT ID(STCDB2) - 
           GENCERT   - 
           SUBJECTSDN(CN('DBD1') - 
                      OU('UKI') - 
                      O('IBM') - 
                      C('UK')) - 
           ALTNAME(DOMAIN('itzvsi-zos*')) - 
           NOTAFTER(DATE(2030-12-31)) - 
           WITHLABEL('DB2LABEL') - 
           SIGNWITH(CERTAUTH LABEL('DB2 SERVER CA')) 
  SETR RACLIST (DIGTRING) REFRESH 
  SETR RACLIST (DIGTCERT) REFRESH 
  SETR RACLIST (FACILITY) REFRESH 
//CRTSER2   EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
RACDCERT ID(STCDB2) - 
         DELETE(LABEL('DG2LABEL')) 
RACDCERT ID(STCDB2) - 
         GENCERT   - 
         SUBJECTSDN(CN('DGSERVER') - 
                    OU('UKI') - 
                    O('IBM') - 
                   C('UK')) - 
         ALTNAME( - 
             DOMAIN('*.containers.appdomain.cloud')) - 
         NOTAFTER(DATE(2030-12-31)) - 
         SIZE(2048) - 
         WITHLABEL('DG2LABEL') - 
         KEYUSAGE(HANDSHAKE) - 
         SIGNWITH(CERTAUTH LABEL('DB2 SERVER CA')) 
SETR RACLIST (DIGTRING) REFRESH 
SETR RACLIST (DIGTCERT) REFRESH 
SETR RACLIST (FACILITY) REFRESH 
//********************************************************************
//* EXPORT DB2 DATA GATE CERTIFICATE 
//********************************************************************
//CRTEX    EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
RACDCERT - 
         EXPORT(LABEL('DG2LABEL')) - 
         ID(STCDB2) - 
         DSN('DB2.DG.P12') - 
         FORMAT(PKCS12DER) - 
         PASSWORD('PASSWORD') 
/* 
//* CREATE KEY RING FOR DB2 SERVER 
//********************************************************************
//CRTKR    EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
RACDCERT ID(STCDB2) ADDRING(DBD1RING) 
RACDCERT ID(STCDB2) - 
         CONNECT(CERTAUTH - 
         LABEL('DB2 SERVER CA') RING(DBD1RING)) 
RACDCERT ID(STCDB2) - 
         CONNECT(ID(STCDB2) - 
         LABEL('DB2LABEL') - 
         RING(DBD1RING) DEFAULT) 
SETR RACLIST (DIGTRING) REFRESH 
SETR RACLIST (DIGTCERT) REFRESH 
SETR RACLIST (FACILITY) REFRESH 
//*********************************************************************
//* PERMIT USER RACF ACCESS TO RUN INTEGRATED SYNCHRONIZATION 
//*********************************************************************
//ACCELACC EXEC PGM=IKJEFT01 
//SYSTSPRT DD SYSOUT=* 
//SYSUADS  DD DSN=SYS1.UADS,DISP=SHR 
//SYSLBC   DD DSN=SYS1.VS01.BRODCAST,DISP=SHR 
//SYSTSIN  DD * 
  RDEFINE DSNR (DBD1.ACCEL) OWNER(STCDB2) UACC(NONE) 
  RDEFINE DSNR (DBD1.DIST) OWNER(STCDB2) UACC(NONE) 
  PERMIT DBD1.ACCEL CLASS(DSNR) ID(STCDB2) ACCESS(READ) 
  PERMIT DBD1.DIST CLASS(DSNR) ID(STCDB2) ACCESS(READ) 
  PERMIT DBD1.ACCEL CLASS(DSNR) ID(IBMUSER) ACCESS(READ) 
  PERMIT DBD1.DIST CLASS(DSNR) ID(IBMUSER) ACCESS(READ) 
  SETR RACLIST (DSNR) REFRESH 
/*