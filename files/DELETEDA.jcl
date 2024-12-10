//DELETE  JOB ,,MSGLEVEL=1,CLASS=A,MSGCLASS=H, 
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
DELETE from DSN81310.EMP where JOB='DESIGNER' 
AND LASTNAME='DIAZ'; 
//* 
