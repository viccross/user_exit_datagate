//DBD1INSE  JOB CLASS=A,MSGCLASS=X, 
//  REGION=0M 
//*********************************************************************
//* JOB NAME = DSNTIJUZ 
//* 
//* DESCRIPTIVE NAME = INSTALLATION JOB STREAM 
//* 
//*    Licensed Materials - Property of IBM 
//*    5698-DB2 
//*    COPYRIGHT IBM Corp 1982, 2022 
//* 
//*    STATUS = Version 13 
//* 
//* FUNCTION = DSNZPARM UPDATES 
//* 
//* PSEUDOCODE = 
//*   DSNTIZA  STEP  ASSEMBLE DSN6.... MACROS, CREATE DSNZPARM 
//*   DSNTIZL  STEP  LINK EDIT DSNZPARM 
//*   DSNTIMQ  STEP  SMP/E PROCESSING FOR DSNZPARM (OPTIONAL) 
//* 
//* NOTES = STEP DSNTIMQ MUST BE CUSTOMIZED FOR SMP.  SEE THE NOTES 
//*         PRECEDING STEP DSNTIMQ BEFORE RUNNING THIS JOB. 
//* 
//* Change activity = 
//*   09/11/2013 Add DSN6SPRM.ACCELMODEL               DM1761 / PM96478
//*   10/15/2013 Remove EDMPOOL            pl160_inst1 / pl160 / n17984
//*   03/08/2014 Add option V12R1 to APPLCOMPAT     s19928_inst1 s19928
//*   05/21/2014 Change NEWFUN default to V12                    171968
//*   02/18/2014 Add RLFENABLE, RLFERRSTC,          s20000_inst2 s20000
//*              and RLFERRDSTC 
//*   02/18/2004 Add DSN6SPRM.PAGESET_PAGENUM               e203_s20176
//*   03/18/2014 Add SUPPRESS_HINT_SQLCODE_DYN         PI13724 / DM1814
//*   01/09/2014 Add ALTERNATE_CP, UTIL_DBBSG,      n18023 s12997_inst1
//*              and UTIL_LGBSG  s12997 
//*   09/02/2011 Remove LOBVALA, LOBVALS,         s22058_inst1 / s22058
//*                     XMLVALA, XMLVALS 
//*   10/04/2014 Add REMOTE_COPY_SW_ACCEL              PI25747 / DM1834
//*   01/06/2015 Add DSN6GRP.PEER_RECOVERY                       dp1857
//*   03/07/2015 Add DSN6SPRM.COPY_FASTREPLICATION  s23187_inst1 s23187
//*   01/12/2015 Add DSN6SPRM.RENAMETABLE              PI32291 / DN1840
//*   03/17/2015 Add DSN6SPRM.RETRY_STOPPED_OBJECTS    PI36922 / DM1851
//*   05/07/2015 Add DSN6SPRM.UTILS_HSM_MSGDS_HLQ   s17863_inst1 s17863
//*   03/30/2015 Add DEFAULT_INSERT_ALGORITHM       s17836_inst1 s17836
//*   07/14/2015 Add DSN6SPRM.STATFDBK_PROFILE      s24345_inst1 s24345
//*   01/06/2015                     s2593_install / s2600_s18668 s2593
//*              Remove REORG_IGNORE_FREESPACE                    s2593
//*   09/17/2015 Add PROFILE_AUTOSTART                    s20059 dp1897
//*   10/01/2015 Add PAGEABLE_1MB_FOR_THREADS       s25942_inst1 s25942
//*   07/27/2015 Add AUTH_COMPATIBILITY              s20166_inst s20166
//*   05/15/2015                                    s17830_inst1 s17830
//*              Add DSN6SPRM.CACHEDYN_STABILIZATION 
//*   04/28/2015 Add DSN6SPRM.DDL_MATERIALIZATION n22751_inst1 / n22751
//*   10/02/2015 Remove obsolete parms              dp1831_inst1 dp1831
//*                - DSN6ARVP.ALCUNIT                            dp1831
//*                - DSN6ARVP.CATALOG                            dp1831
//*                - DSN6SPRM.CACHE_DEP_TRACK_STOR_LIM           dp1831
//*                - DSN6SPRM.CACHEDYN_FREELOCAL                 dp1831
//*                - DSN6SPRM.CHECK_SETCHKP                      dp1831
//*                - DSN6SPRM.CONTSTOR                           dp1831
//*                - DSN6SPRM.DB2SORT                            dp1831
//*                - DSN6SPRM.INDEX_IO_PARALLELISM               dp1831
//*                - DSN6SPRM.LEMAX                              dp1831
//*                - DSN6SPRM.MINSTOR                            dp1831
//*                - DSN6SPRM.RRF                                dp1831
//*                - DSN6SPRM.UTSORTAL                           dp1831
//*              Change defaults as indicated                    dp1831
//*                - DSN6ARVP.PRIQTY                             dp1831
//*                    from 4320 (blocks) to 125 (cylinders)     dp1831
//*                - DSN6ARVP.SECQTY                             dp1831
//*                    from 540 (blocks) to 15 (cylinders)       dp1831
//*                - DSN6SPRM.EDM_SKELETON_POOL                  dp1831
//*                    from 10240 to 51200                       dp1831
//*                - DSN6SPRM.PREVENT_NEW_IXCTRL_PART            dp1831
//*                    from NO to YES                            dp1831
//*                - DSN6SYSP.SMFACCT                            dp1831
//*                    from '1' to '1,2,3,7,8'                   dp1831
//*   06/01/2015 Add DSN6SPRM.COMPRESS_DIRLOB       s10853_inst1 s10853
//*                                                      ss19510 s10853
//*   02/06/2015 Add INDEX_MEMORY_CONTROL   pl155_zparmf2 n17840_s19906
//*   01/12/2016 Change ACCELMODEL default to YES  pi39062_part2 DM1861
//*   10/29/2015 Add DSN6SPRM.MATERIALIZE_NODET_SQLTUDF  PI46932 DM1912
//*   02/15/2016 Long data set names                            PI42601
//*   04/13/2016 Remove PAGEABLE_1MB_FOR_THREADS                 183360
//*                                                             PI59531
//*   03/16/2016 Add SQLINTRP, INLISTP, MAX_OPT_STOR,           PI58414
//*                  MXTBJOIN, OPTXQB, SECADM1_INPUT_STYLE,     PI58414
//*                  SECADM2_INPUT_STYLE, UNION_COLNAME_7,      PI58414
//*                  PTASKROL, REVOKE_DEP_PRIVILEGES,           PI58414
//*                  SECADM1_TYPE, SECADM2_TYPE,                PI58414
//*                  SECADM1, SECADM2, SEPARATE_SECURITY        PI58414
//*   04/14/2016 Add SQLLEVEL                        s27418inst2 s27418
//*   04/29/2016 Remove NEWFUN                       s27418inst4 s27418
//*   02/11/2016 Add DSN6SPRM.MOVE_TO_ARCHIVE_DEFAULT  PI56767 / DN1934
//*   08/05/2016 Add DSN6SPRM.DISALLOW_SEL_INTO_UNION    PI67611 DM1946
//*   06/06/2017 Add DSN6SPRM.ZHYPERLINK                         S51617
//*   09/21/2017 Add QUERY_ACCEL_WAITFORDATA                     s63349
//*   06/24/2017 Add DSN6SPRM.STATCLGSRT                 PI76730 E36963
//*   08/07/2017 Split up DSNTIJUZ                     s64075 / PI85767
//*               - DSNTIJUZ: For DSNZPARM 
//*               - DSNTIJUA: For DSNHDECP 
//*               - DSNTIJUM: For DSNHMCID 
//*               - DSNTIJUL: For BSDS / Change log inventory 
//*   03/18/2017 Add ENCRYPTION_KEYLABEL                         E26155
//*   06/21/2018 Remove references to ADSNLOAD           PI98672/s77957
//*   02/16/2017 Add DSN6SPRM.TS_COMPRESSION_TYPE         S49659 E38875
//*   05/20/2018 Add DSN6LOGP.CDDS_MODE                  PI97992/s77487
//*              and DSN6LOGP.CDDS_PREFIX 
//*   09/17/2018 Add DSN6SPRM.FLASHCOPY_XRCP             PH01728/s22693
//*   12/10/2018 Add DSN6SPRM.REORG_TS_NOPAD_DEFAULT     PH00317/s88820
//*   10/16/2018 Add DSN6SPRM.STATPGSAMP                 PH07220/s83939
//*   07/26/2019 Add DSN6SPRM.DISALLOW_SSARAUTH          PH16579/e83611
//*   10/11/2019 Add DSN6SPRM.UTILS_BLOCK_FOR_CDC        PH14363/e75390
//*   01/09/2020 Change the PCLOSET default from 10 to 45  PH21370/e491
//*              Change the CHKFREQ default from 5 to 3    PH21370/e491
//*              Change the MAXRBLK default from 400000    PH21370/e491
//*                 to 1000000 
//*              Change the NPGTHRSH default from 0 to 1   PH21370/e491
//*              Change the INLISTP default from 50 to 1000     PH21370
//*              Remove continuation char at the end of         PH21370
//*                 XML_RANDOMIZE_DOCID 
//*   02/03/2020 Avoid GIM40501E in DSNTIMQ                     PH20105
//*   02/06/2020 Add DSN6SYSP.STATIME_MAIN          PH18658 / E293-S325
//*   03/05/2020 Remove COMPRESS_SPT01                     PH24358/e491
//*              Remove SPT01_INLINE_LENGTH                PH24358/e491
//*   04/22/2020 Remove OBJECT_CREATE_FORMAT               PH26317/e491
//*              Remove UTILITY_OBJECT_CONVERSION          PH26317/e491
//*   07/02/2020 Add DSN6SPRM.MFA_AUTHCACHE_UNUSED_TIME    PH21341/e886
//*   07/23/2020 Change the default from 2 to 1           PH27822/e6317
//*              for DEFAULT_INSERT_ALGORITHM 
//*   07/09/2020 Add DSN6SPRM.LOAD_RO_OBJECTS           PH26131 / e5738
//*   07/06/2020 Add DSN6SPRM.ALLOW_UPD_DEL_INS_WITH_UR         PH14791
//*   08/06/2020 Add DSN6SPRM.UTILS_USE_ZSORT             PH28183/e4192
//*   05/28/2020 Remove CACHEPAC and CACHERAC              PH28280/e491
//*              Remove IRLMAUT and IRLMSWT                PH28280/e491
//*              Remove CHGDC and EDPROP                   PH28280/e491
//*              Remove PCLOSEN and MGEXTSZ                PH28280/e491
//*   02/16/2021 Add option V13 to APPLCOMPAT              e6837- s6972
//*FF 06/03/2021 Add DSN6SPRM.FTB_NON_UNIQUE_INDEX        PH30978/e7890
//*   07/12/2021 Add TABLE_COL_NAME_EXPANSION                    e10735
//*   07/09/2021 Add SPREG_LOCK_TIMEOUT_MAX                       e8876
//*FF 07/29/2021 Add DSN6SPRM.REORG_INDEX_NOSYSUT1        PH25217/e4191
//*FF 07/23/2021 Add DSN6SPRM.REORG_IC_LIMIT_DASD         PI75518/e1548
//*              Add DSN6SPRM.REORG_IC_LIMIT_TAPE         PI75518/e1548
//*FF 07/23/2021 Add DSN6SPRM.SUBSTR_COMPATIBILITY        PH36071/e8565
//*FF 07/12/2021 Add DSN6SPRM.LOAD_DEL_IMPLICIT_SCALE           PH36908
//*   07/20/2021 Remove AUTHCACH                                  e9004
//*   08/31/2021 Change DSN6SPRM.PAGESET_PAGENUM default          e9967
//*                from ABSOLUTE to RELATIVE 
//*              Change DSN6SYSP.STATIME_MAIN default             e9967
//*                from 60 to 10 seconds 
//*   11/08/2021 Remove obsolete parms                    s16498-e15136
//*                - DSN6GRP.IMMEDWRI                            e15136
//*                - DSN6SPRM.HONOR_KEEPDICTIONARY               e15136
//*                - DSN6SPRM.IX_TB_PART_CONV_EXCLUDE            e15136
//*                - DSN6SPRM.SUBQ_MIDX                          e15136
//*                - DSN6SYSP.DSVCI                              e15136
//*   11/11/2021 Change defaults as indicated             s16498-e15136
//*                - DSN6FAC.DDF from NO to AUTO                 e15136
//*                - DSN6SPRM.FTB_NON_UNIQUE_INDEX               e15136
//*                    from NO to YES                            e15136
//*                - DSN6SPRM.MAXSORT_IN_MEMORY                  e15136
//*                    from 1000 to 2000                         e15136
//*                - DSN6SPRM.SRTPOOL                            e15136
//*                    from 10000 to 20000                       e15136
//*   12/07/2021 Remove obsolete parms                    s16679-e15136
//*                - DSN6FAC.DDF_COMPATIBILITY                   e15136
//*                - DSN6FAC.MAXTYPE1                            e15136
//*                - DSN6LOGP.MAXARCH                            e15136
//*                - DSN6SPRM.OPT1ROWBLOCKSORT                   e15136
//*                - DSN6SPRM.PLANMGMTSCOPE                      e15136
//*                - DSN6SPRM.REALSTORAGE_MANAGEMENT             e15136
//*                - DSN6SYSP.EXTRAREQ                           e15136
//*                - DSN6SYSP.EXTRASRV                           e15136
//*   11/01/2021 Add DSN6SPRM.UTILITY_HISTORY                     e9680
//*   01/18/2022 Remove obsolete parms                    s17074-e15136
//*                - DSN6FAC.RESYNC                              e15136
//*                - DSN6SPRM.PARA_EFF                           e15136
//*                - DSN6SYSP.TRACSTR                            e15136
//*              Change defaults as indicated             s17074-e15136
//*                - DSN6FAC.MAXCONQN and DSN6FAC.MAXCONQW       e15136
//*                    from OFF to ON                            e15136 
//*                - DSN6LOGP.OUTBUFF                            e15136 
//*                    from 4000 to 102400                       e15136 
//*                - DSN6SPRM.EDMDBDC                            e15136 
//*                    from 23400 to 40960                       e15136 
//*                - DSN6SPRM.EDM_SKELETON_POOL                  e15136 
//*                    from 51200 to 81920                       e15136 
//*                - DSN6SPRM.NUMLKTS                            e15136 
//*                    from 2000 to 5000                         e15136 
//*                - DSN6SPRM.NUMLKUS                            e15136 
//*                    from 10000 to 20000                       e15136 
//*   03/14/2022 Add DSN6SPRM.PACKAGE_DEPENDENCY_LEVEL           e11871 
//*   10/05/2022 Add DSN6SPRM.MAX_UDF                           PH44833 
//*   09/16/2022 Add DSN6SPRM.LA_SINGLESEL_ISOCS_CDY     PH49335/e14924 
//*   08/24/2022 Add DSN6SPRM.MXAIDTCACH                 PH51892/e20560 
//*   09/25/2023 Add DSN6SYSP.STATIME_DDF                PH56228/e26343 
//* 
//********************************************************************* 
//* 
//DSNTIZA EXEC PGM=ASMA90,PARM='OBJECT,NODECK' 
//STEPLIB  DD DISP=SHR,DSN=DB2V13.SDSNLOAD 
//SYSLIB   DD  DISP=SHR, 
//         DSN=DB2V13.SDSNMACS 
//         DD  DISP=SHR, 
//         DSN=SYS1.MACLIB 
//SYSLIN   DD  DSN=&&LOADSET(DSNTILMM), 
//             DISP=(NEW,PASS), 
//             UNIT=SYSDA,SPACE=(800,(50,50,2)), 
//             DCB=(BLKSIZE=800) 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSUT1   DD  UNIT=SYSDA,SPACE=(800,(50,50),,,ROUND) 
//SYSUT2   DD  UNIT=SYSDA,SPACE=(800,(50,50),,,ROUND) 
//SYSUT3   DD  UNIT=SYSDA,SPACE=(800,(50,50),,,ROUND) 
//SYSIN    DD  * 
    DSN6SPRM   RESTART,                                                X
               ALL,                                                    X
               ABEXP=YES,                                              X
               ABIND=YES,                                              X
               ACCEL=AUTO,                                             X
               ACCELMODEL=YES,                                         X
               ADMTPROC=DBD1ADMT,                                      X
               AEXITLIM=10,                                            X
               ALLOW_UPD_DEL_INS_WITH_UR=NO,                           X
               ALTERNATE_CP=,                                          X
               APPLCOMPAT=V13R1M501,                                   X
               AUTH=YES,                                               X
               AUTH_COMPATIBILITY=(),                                  X
               AUTHEXIT_CACHEREFRESH=NONE,                             X
               AUTHEXIT_CHECK=PRIMARY,                                 X
               BIF_COMPATIBILITY=CURRENT,                              X
               BINDNV=BINDADD,                                         X
               BMPTOUT=4,                                              X
               CACHEDYN=YES,                                           X
               CACHEDYN_STABILIZATION=BOTH,                            X
               CATALOG=DBD1,                                           X
               CATDDACL=,                                              X
               CATDMGCL=,                                              X
               CATDSTCL=,                                              X
               CATXDACL=,                                              X
               CATXMGCL=,                                              X
               CATXSTCL=,                                              X
               CDSSRDEF=1,                                             X
               CHECK_FASTREPLICATION=REQUIRED,                         X
               COMCRIT=NO,                                             X
               COMPRESS_DIRLOB=NO,                                     X
               COPY_FASTREPLICATION=PREFERRED,                         X
               DBACRVW=NO,                                             X
               DDL_MATERIALIZATION=ALWAYS_IMMEDIATE,                   X
               DDLTOX=1,                                               X
               DECDIV3=NO,                                             X
               DEFAULT_INSERT_ALGORITHM=1,                             X
               DEFLTID=IBMUSER,                                        X
               DESCSTAT=YES,                                           X
               DISABLE_EDMRTS=NO,                                      X
               DISALLOW_SEL_INTO_UNION=YES,                            X
               DISALLOW_SSARAUTH=NO,                                   X
               DLITOUT=6,                                              X
               DSMAX=20000,                                            X
               EDMDBDC=40960,                                          X
               EDMSTMTC=122880,                                        X
               EDM_SKELETON_POOL=81920,                                X
               ENCRYPTION_KEYLABEL=,                                   X
               EN_PJSJ=OFF,                                            X
               EVALUNC=NO,                                             X
               FCCOPYDDN=HLQ.&&DB..&&SN..N&&DSNUM..&&UQ.,              X
               FLASHCOPY_COPY=NO,                                      X
               FLASHCOPY_LOAD=NO,                                      X
               FLASHCOPY_PPRC=REQUIRED,                                X
               FLASHCOPY_REORG_TS=NO,                                  X
               FLASHCOPY_REBUILD_INDEX=NO,                             X
               FLASHCOPY_REORG_INDEX=NO,                               X
               FLASHCOPY_XRCP=YES,                                     X
               FTB_NON_UNIQUE_INDEX=YES,                               X
               GET_ACCEL_ARCHIVE=NO,                                   X
               IGNSORTN=NO,                                            X
               INDEX_CLEANUP_THREADS=10,                               X
               INDEX_MEMORY_CONTROL=AUTO,                              X
               INLISTP=1000,                                           X
               IRLMPRC=DBD1IRLM,                                       X
               IRLMSID=DID1,                                           X
               IRLMRWT=30,                                             X
               LA_SINGLESEL_ISOCS_CDY=NO,                              X
               LIKE_BLANK_INSIGNIFICANT=NO,                            X
               LOAD_DEL_IMPLICIT_SCALE=NO,                             X
               LOAD_RO_OBJECTS=NO,                                     X
               LRDRTHLD=10,                                            X
               MATERIALIZE_NODET_SQLTUDF=NO,                           X
               MAINTYPE=SYSTEM,                                        X
               MAXRBLK=1000000,                                        X
               MAXKEEPD=5000,                                          X
               MAX_CONCURRENT_PKG_OPS=10,                              X
               MAX_NUM_CUR=500,                                        X
               MAX_OPT_CPU=100,                                        X
               MAX_OPT_STOR=40,                                        X
               MAX_ST_PROC=2000,                                       X
               MAX_UDF=2000,                                           X
               MAXSORT_IN_MEMORY=2000,                                 X
               MAXTEMPS=0,                                             X
               MAXTEMPS_RID=NOLIMIT,                                   X
               MFA_AUTHCACHE_UNUSED_TIME=0,                            X
               MINDVSCL=NONE,                                          X
               MOVE_TO_ARCHIVE_DEFAULT=N,                              X
               MXAIDTCACH=0,                                           X
               MXDTCACH=20,                                            X
               MXQBCE=1023,                                            X
               MXTBJOIN=225,                                           X
               NPGTHRSH=1,                                             X
               NUMLKTS=5000,                                           X
               NUMLKUS=20000,                                          X
               OPTHINTS=NO,                                            X
               OPTXQB=ON,                                              X
               PACKAGE_DEPENDENCY_LEVEL=PACKAGE,                       X
               PADIX=NO,                                               X
               PAGESET_PAGENUM=RELATIVE,                               X
               PARAMDEG=0,                                             X
               PARAMDEG_DPSI=0,                                        X
               PARAMDEG_UTIL=99,                                       X
               PCTFREE_UPD=0,                                          X
               PKGREL_COMMIT=YES,                                      X
               PLANMGMT=EXTENDED,                                      X
               PREVENT_ALTERTB_LIMITKEY=NO,                            X
               PREVENT_NEW_IXCTRL_PART=YES,                            X
               QUERY_ACCELERATION=NONE,                                X
               QUERY_ACCEL_OPTIONS=(NONE),                             X
               QUERY_ACCEL_WAITFORDATA=0,                              X
               REALSTORAGE_MAX=NOLIMIT,                                X
               REC_FASTREPLICATION=PREFERRED,                          X
               RECALL=YES,                                             X
               REFSHAGE=0,                                             X
               RECALLD=120,                                            X
               RENAMETABLE=DISALLOW_DEP_VIEW_SQLTUDF,                  X
               REORG_DROP_PBG_PARTS=DISABLE,                           X
               REORG_IC_LIMIT_DASD=0,                                  X
               REORG_IC_LIMIT_TAPE=0,                                  X
               REORG_INDEX_NOSYSUT1=YES,                               X
               REORG_LIST_PROCESSING=PARALLEL,                         X
               REORG_MAPPING_DATABASE=,                                X
               REORG_PART_SORT_NPSI=AUTO,                              X
               REORG_TS_NOPAD_DEFAULT=YES,                             X
               RESTORE_RECOVER_FROMDUMP=NO,                            X
               RESTORE_TAPEUNITS=NOLIMIT,                              X
               RESTRICT_ALT_COL_FOR_DCC=NO,                            X
               RETLWAIT=0,                                             X
               RETRY_STOPPED_OBJECTS=NO,                               X
               REVOKE_DEP_PRIVILEGES=SQLSTMT,                          X
               RGFCOLID=DSNRGCOL,                                      X
               RGFDBNAM=DSNRGFDB,                                      X
               RGFDEDPL=NO,                                            X
               RGFDEFLT=ACCEPT,                                        X
               RGFESCP=,                                               X
               RGFFULLQ=YES,                                           X
               RGFINSTL=NO,                                            X
               RGFNMORT=DSN_REGISTER_OBJT,                             X
               RGFNMPRT=DSN_REGISTER_APPL,                             X
               RRULOCK=YES,                                            X
               SECADM1_INPUT_STYLE=CHAR,                               X
               SECADM1_TYPE=AUTHID,                                    X
               SECADM1=IBMUSER,                                        X
               SECADM2_INPUT_STYLE=CHAR,                               X
               SECADM2_TYPE=AUTHID,                                    X
               SECADM2=IBMUSER,                                        X
               SECLCACH=255,                                           X
               SEPARATE_SECURITY=NO,                                   X
               SIMULATED_CPU_COUNT=OFF,                                X
               SIMULATED_CPU_SPEED=OFF,                                X
               SITETYP=LOCALSITE,                                      X
               SJTABLES=10,                                            X
               SKIPUNCI=NO,                                            X
               SPREG_LOCK_TIMEOUT_MAX=-1,                              X
               SRTPOOL=20000,                                          X
               STARJOIN=DISABLE,                                       X
               STATCLGSRT=10,                                          X
               STATFDBK_PROFILE=YES,                                   X
               STATFDBK_SCOPE=ALL,                                     X
               STATHIST=NONE,                                          X
               STATPGSAMP=SYSTEM,                                      X
               STATROLL=YES,                                           X
               STATSINT=30,                                            X
               SUBSTR_COMPATIBILITY=PREVIOUS,                          X
               SUPERRS=YES,                                            X
               SUPPRESS_HINT_SQLCODE_DYN=NO,                           X
               SYSADM=IBMUSER,                                         X
               SYSADM2=IBMUSER,                                        X
               SYSOPR1=IBMUSER,                                        X
               SYSOPR2=IBMUSER,                                        X
               SYSTEM_LEVEL_BACKUPS=NO,                                X
               TABLE_COL_NAME_EXPANSION=OFF,                           X
               TEMPLATE_TIME=UTC,                                      X
               TRKRSITE=NO,                                            X
               TS_COMPRESSION_TYPE=FIXED_LENGTH,                       X
               UNION_COLNAME_7=NO,                                     X
               UTIL_DBBSG=,                                            X
               UTIL_LGBSG=,                                            X
               UTIL_TEMP_STORCLAS=,                                    X
               UTILITY_HISTORY=NONE,                                   X
               UTILS_BLOCK_FOR_CDC=NO,                                 X
               UTILS_DUMP_CLASS_NAME=,                                 X
               UTILS_HSM_MSGDS_HLQ=,                                   X
               UTILS_USE_ZSORT=NO,                                     X
               UTIMOUT=6,                                              X
               VOLTDEVT=SYSDA,                                         X
               WFDBSEP=NO,                                             X
               WFSTGUSE_AGENT_THRESHOLD=0,                             X
               WFSTGUSE_SYSTEM_THRESHOLD=90,                           X
               XLKUPDLT=NO,                                            X
               XML_RESTRICT_EMPTY_TAG=NO,                              X
               ZHYPERLINK=DISABLE,                                     X
               ZOSMETRICS=NO 
    DSN6ARVP   ARCWRTC=(1,3,4),                                        X
               ARCWTOR=YES,                                            X
               ARCPFX1=DBD1.ARCHLOG1,                                  X
               ARCPFX2=DBD1.ARCHLOG2,                                  X
               ARCRETN=9999,                                           X
               BLKSIZE=24576,                                          X
               COMPACT=NO,                                             X
               PRIQTY=125,                                             X
               PROTECT=NO,                                             X
               QUIESCE=5,                                              X
               SECQTY=15,                                              X
               SVOLARC=NO,                                             X
               TSTAMP=YES,                                             X
               UNIT=SYSALLDA,                                          X
               UNIT2= 
    DSN6LOGP   DEALLCT=(0),                                            X
               MAXRTU=2,                                               X
               OUTBUFF=102400,                                         X
               CDDS_MODE=NONE,                                         X
               CDDS_PREFIX=DSNCAT,                                     X
               REMOTE_COPY_SW_ACCEL=DISABLE,                           X
               TWOACTV=NO,                                             X
               TWOARCH=NO,                                             X
               ARC2FRST=NO 
    DSN6SYSP   ACCESS_CNTL_MODULE=DSNX@XAC,                            X
               ACCUMACC=10,                                            X
               ACCUMUID=0,                                             X
               AUDITST=NO,                                             X
               BACKODUR=5,                                             X
               CHKFREQ=3,                                              X
               CHKLOGR=NOTUSED,                                        X
               CHKMINS=NOTUSED,                                        X
               CHKTYPE=SINGLE,                                         X
               CONDBAT=10000,                                          X
               CTHREAD=200,                                            X
               DEL_CFSTRUCTS_ON_RESTART=NO,                            X
               DLDFREQ=ON,                                             X
               DPSEGSZ=32,                                             X
               DSSTIME=5,                                              X
               EXTSEC=YES,                                             X
               IDAUTH_MODULE=DSN3@ATH,                                 X
               IDBACK=50,                                              X
               IDFORE=50,                                              X
               IDXBPOOL=BP0,                                           X
               IMPDSDEF=YES,                                           X
               IMPDSSIZE=4,                                            X
               IMPTKMOD=YES,                                           X
               IMPTSCMP=NO,                                            X
               IXQTY=0,                                                X
               LBACKOUT=AUTO,                                          X
               LOB_INLINE_LENGTH=0,                                    X
               MAXDBAT=200,                                            X
               MAXOFILR=100,                                           X
               MON=NO,                                                 X
               MONSIZE=1048576,                                        X
               PCLOSET=45,                                             X
               PROFILE_AUTOSTART=NO,                                   X
               PTASKROL=YES,                                           X
               RLF=NO,                                                 X
               RLFENABLE=DYNAMIC,                                      X
               RLFERR=NOLIMIT,                                         X
               RLFERRSTC=NOLIMIT,                                      X
               RLFTBL=01,                                              X
               RLFAUTH=SYSIBM,                                         X
               ROUTCDE=(1),                                            X
               SIGNON_MODULE=DSN3@SGN,                                 X
               SMFACCT=(1,2,3,7,8),                                    X
               SMFCOMP=OFF,                                            X
               SMFSTAT=YES,                                            X
               SMF89=NO,                                               X
               STATIME=1,                                              X
               STATIME_MAIN=10,                                        X
               STATIME_DDF=0,                                          X
               STORMXAB=0,                                             X
               STORTIME=180,                                           X
               SYNCVAL=NO,                                             X
               TBSBPOOL=BP0,                                           X
               TBSBP8K=BP8K0,                                          X
               TBSBP16K=BP16K0,                                        X
               TBSBP32K=BP32K,                                         X
               TBSBPLOB=BP0,                                           X
               TBSBPXML=BP16K0,                                        X
               TRACTBL=16,                                             X
               TSQTY=0,                                                X
               UIFCIDS=NO,                                             X
               URCHKTH=5,                                              X
               URLGWTH=10,                                             X
               WLMENV=DBD1WLM1,                                        X
               XML_RANDOMIZE_DOCID=NO 
    DSN6FAC    DDF=AUTO,                                               X
               CMTSTAT=INACTIVE,                                       X
               IDTHTOIN=120,                                           X
               MAXCONQN=ON,                                            X
               MAXCONQW=ON,                                            X
               RLFERRD=NOLIMIT,                                        X
               RLFERRDSTC=NOLIMIT,                                     X
               TCPALVER=NO,                                            X
               SQLINTRP=ENABLE,                                        X
               TCPKPALV=120,                                           X
               POOLINAC=120,                                           X
               PRIVATE_PROTOCOL=NO 
    DSN6GRP    DSHARE=NO,                                              X
               GRPNAME=DSNCAT,                                         X
               MEMBNAME=DSN1,                                          X
               PEER_RECOVERY=NONE,                                     X
               RANDOMATT=YES 
    END 
//********************************************************************* 
//* LINK EDIT THE NEW DSNZPARM MEMBER.  PUT LOAD MODULE IN SDSNEXIT. 
//********************************************************************* 
//DSNTIZL EXEC PGM=IEWL,PARM='LIST,XREF,LET,RENT', 
//             COND=(4,LT) 
//DSNLOAD  DD  DISP=SHR, 
//         DSN=DB2V13.SDSNLOAD 
//SYSPUNCH DD  DSN=&&LOADSET(DSNTILMM),DISP=(OLD,DELETE) 
//SYSLMOD  DD  DISP=SHR, 
//         DSN=DBD1.SDSNEXIT 
//SYSPRINT DD  SYSOUT=* 
//SYSUDUMP DD  SYSOUT=* 
//SYSUT1   DD  UNIT=SYSDA,SPACE=(1024,(50,50)) 
//SYSLIN   DD  * 
   INCLUDE SYSPUNCH(DSNTILMM) 
   INCLUDE DSNLOAD(DSNZPARM) 
   ORDER DSNAA 
   INCLUDE DSNLOAD(DSNAA) 
   ENTRY   DSNZMSTR 
   MODE    AMODE(31),RMODE(ANY) 
   NAME    DBD1PARM(R) 
//* 
//********************************************************************* 
//* OPTIONAL DO SMP/E PROCESSING TO TRACK DSNZPARM CHANGES. 
//* 
//*  This job step defines SMP/E JCLIN processing for DB2.  Advanced 
//*  SMP/E skills are recommended.  Before enabling this job step, 
//*  be aware that: 
//*   * Any changes you make to this job may affect current or future 
//*     SMP/E processing for DB2. 
//*   * Any changes made to the low level qualifier of any data sets 
//*     used here may result in new DDDEFs being required. 
//*   * You may need to define a DDDEF for the system MACLIB in the 
//*     target zone of the CSI used for DB2, and add it to the 
//*     DDDEF(SYSLIB) concatenation. 
//* 
//*  Contact the IBM Support Center for further information. 
//* 
//* NOTE: THIS STEP MUST BE CUSTOMIZED AS FOLLOWS FOR SMP: 
//* 1. UNCOMMENT THE STEP 
//* 2. LOCATE AND CHANGE THE FOLLOWING STRINGS TO THE VALUES YOU 
//*    SPECIFIED FOR THEM IN JOB DSNTIJAE: 
//*    A.'?SMPPRE?' TO THE PREFIX OF YOUR SMP LIBRARY NAME. 
//*    B.'?SMPMLQ?' TO THE MIDDLE LEVEL QUALIFIER OF YOUR SMP CSI 
//* 3. UPDATE SYSOUT CLASSES AS DESIRED (DEFAULT IS '*') 
//*********************************************************************
//*  //DSNTIMQ EXEC PGM=GIMSMP,PARM='CSI=?SMPPRE?.?SMPMLQ?.CSI', 
//*  //             REGION=4096K,COND=(2,LT) 
//*  //SYSPRINT DD  SYSOUT=* 
//*  //SYSUDUMP DD  SYSOUT=* 
//*  //SMPCNTL DD * 
//*      SET BDY(DSNTARG). 
//*      JCLIN. 
//*      SET BDY(DSNTARG). 
//*      UCLIN. 
//*       REP MOD ( DSNAA ) DISTLIB ( ADSNLOAD ). 
//*       REP MOD ( DSNZPARM ) DISTLIB ( ADSNLOAD ). 
//*      ENDUCL. 
//*  //SMPJCLIN DD DISP=SHR, 
//*  //      DSN=DB2V13.NEW.SDSNSAMP(DSNTIJUZ) 
//* 
