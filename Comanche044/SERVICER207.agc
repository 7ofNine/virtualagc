### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    SERVICER207.agc
## Purpose:     A section of Comanche revision 044.
##              It is part of the reconstructed source code for the
##              original release of the flight software for the Command
##              Module's (CM) Apollo Guidance Computer (AGC) for Apollo 10.
##              The code has been recreated from a copy of Comanche 055. It
##              has been adapted such that the resulting bugger words
##              exactly match those specified for Comanche 44 in NASA drawing
##              2021153D, which gives relatively high confidence that the
##              reconstruction is correct.
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2020-12-03 MAS  Created from Comanche 51.

## Page 819
# PROGRAM NAME -	PREREAD, READACCS, SERVICER, AVERAGE G.
# MOD NO. 00 BY M. HAMILTON	DEC. 12, 1966
#
# FUNCTIONAL DESCRIPTION
#
# THE ROUTINES DESCRIBED BELOW ARE USED TO CALCULATE VALUES OF RN, VN, AND GDT/2 DURING ACCELERATED FLIGHT.
# THE SEVERAL ROUTINES COMPRISE A PACKAGE AND ARE NOT MEANT TO BE USED AS SEPARATE SUBROUTINES.
#
# GENERAL REFERENCES TO  SERVICER  OR  AVERAGE G  ARE UNDERSTOOD TO REFER TO THE ENTIRE SET OF ROUTINES INCLUDING
# READACCS, SERVICER, AVERAGE G, INTEREAD, SMOOTHER, AND ANY ADDITIONAL ROUTINES ATTACHED AT AVGEXIT (SEE BELOW).
#
# PROGRAMS INITIATING SERVICER ARE REQUIRED TO MAKE A WAITLIST CALL FOR PREREAD (OR, IF LIFTOFF, FOR BIBIBIAS)
# AT 2 SECONDS BEFORE THE FIRST AVERAGE G UPDATE IN ORDER TO INITIALIZE THE SEQUENCE, WHICH WILL RECUR EVERY
# 2 SECONDS FROM THAT TIME ON AS LONG AS AVEGFLAG REMAINS SET.
#
# THE USE OF ERASABLE AVGEXIT ALLOWS VARIOUS ROUTINES TO BE PERFORMED AS PART OF THE NORMAL CYCLE (SEE
# EXPLANATION OF AVGEXIT BELOW).
#
# DESCRIPTIONS OF INDIVIDUAL ROUTINES FOLLOW.
#
#	PREREAD
#
#		PREVIOUSLY EXTRAPOLATED VALUES COPIED FROM RN1, VN1, AND PIPTIME1 INTO RN, VN, AND PIPTIME.
#		LASTBIAS JOB SCHEDULED.
#		PIPS READ AND CLEARED VIA PIPASR SUBROUTINE.
#		AVERAGE G FLAG SET ON.
#		DRIFT FLAG SET OFF.
#		V37 FLAG SET ON.
#		INITIALIZATION OF	1) THRUST MONITOR (DVMON) - DVCNTR SET TO ONE.
#					2) TOTAL ACCUMULATED DELV VALUE (DVTOTAL) - SET TO ZERO.
#					3) AXIS VECTOR (AXIS) - SET TO (.5,0,0).
#		NORMLIZE JOB SCHEDULED.
#		READACCS TASK CALLED IN 2 SECONDS.
#
#	NORMLIZE
#
#		GDT/2 INITIALIZED VIA CALCGRAV SUBROUTINE.
#
#	READACCS
#
#		IF ONMON FLAG SET QUIKREAD ROUTINE IS PERFORMED BEFORE PIPASR ZEROS THE PIPA REGISTERS, AND THE 1/2 SEC
#		ONMONITOR LOOP IS INITIATED TO PROVIDE DOWNLINK INFORMATION DURING ENTRY.
#		PIPS READ AND CLEARED BY PIPASR SUBROUTINE.
#		IF CM/DSTBY IS ON, ENTRY VARIABLES INITIALIZED AND SETJTAG TASK CALLED.
## Page 820
#
#		IF AVERAGEG FLAG ON	READACCS CALLED TO RECYCLE IN 2 SECONDS.
#		IF AVERAGEG FLAG OFF	AVERAGE G EXIT (AVGEXIT) SET TO 2CADR AVGEND FOR FINAL PASS.
#		SERVICER JOB SCHEDULED.
#		TEST CONNECTOR OUTBIT TURNED ON.
#
# 	ONMNITOR
#
#		A SEQUENCE OF THREE PASSES THROUGH QUICKREAD FOLLOWING A CALL TO READACCS WITH ONMONFLG SET AT 1/2 
#		SEC INTERVALS.  INTERVALS ARE COUNTED OUT BY PIPCTR, INITIALISED AT 3 BY READACCS
#
#	QUIKREAD
#
#		READS CURRENT PIPS INTO X,Y,ZPIPBUF.  READS OLD X,Y,ZPIPBUF INTO X,Y,ZOLDBUF.  VALUES ARE SENT TO
#		DOWNLIST DURING ENTRY.
#
#	SERVICER
#
#		DELV VALUES CHECKED TO DETECT RUNAWAY PIP -
#			IF BAD PIP	1) ALARM SENT.
#					2) COMPENSATION, DVTOTAL ACCUMULATION, AND DVMON BYPASSED.  CONTROL
#					   TRANSFERRED TO AVERAGE G.
#		PIPS COMPENSATED VIA 1/PIPA SUBROUTINE.
#		DVTOTAL INCREMENTED BY ABSOLUTE VALUE OF DELV.
#		THRUST MONITOR (DVMON) PERFORMED UNLESS IDLE FLAG IS ON.
#		CONTROL TRANSFERRED TO AVERAGE G.
#
#	DVMON
#
#		THRESHOLD VALUE (PLACED IN DVTHRUSH BY USER) CHECKED AGAINST ABSOLUTE VALUE OF DELV TO CHECK
#		THRUST LEVEL.
#
#			IF THRUST	1) ULLAGE OFF ROUTINE PERFORMED.
#					2) STEERING FLAG TURNED ON AT FIRST DETECTION OF THRUST.
#					3) CONTROL TRANSFERRED TO AVERAGE G.
#			IF NO THRUST	1) ON FIRST PASS THROUGH MONITOR, CONTROL TRANSFERRED TO AVERAGE G.
#					2) ON SUBSEQUENT PASSES, CONTROL TRANSFERRED TO ENGINE FAIL ROUTINE IF THRUST
#					   HAS FAILED FOR 3 CONSECUTIVE PASSES.
#
#	ENGINE FAIL
#
#		ENGFAIL1 TASK CALLED IN 2.5 SECONDS.  THIS WILL RETURN CONTROL TO TIG-5 SO THAT THE IGNITION
#			SEQUENCE MAY BE REPEATED.
#		ENGINOF3 PERFORMED.
#		DAP SET UP FOR RCS.
#	
#	AVERAGE G
## Page 821
#		RN1, VN1, GDT1/2 CALCULATED VIA CALCRVG ROUTINE BY UPDATING RN, VN WITH DELV AND AN AVERAGED VALUE
#			OF GDT/2.
#		RN1, VN1, GDT1/2, PIPTIME1 COPIED INTO RN, VN, GDT/2, PIPTIME FOR RESTART PROTECTION.
#		CONTROL TRANSFERRED TO ADDRESS SPECIFIED BY USER (OR BY READACCS FOR LAST PASS) IN AVGEXIT.
#		LAST PASS (AVGEND)	1) FREE FALL GYRO COMPENSATION SET UP.
#					2) DRIFT FLAG TURNED ON.
#					3) STATE VECTOR TRANSFERRED VIA AVETOMID ROUTINE.
#					4) ONMONITOR FLAG RESET.
#					5) V37 FLAG RESET.
#					6) TEST CONNECTOR OUTBIT RESET.
#					7) CONTROL TRANSFERRED TO CANV37 TO CONTINUE MM CHANGE ROUTINE (R00).
#
# CALLING SEQUENCE
#
#	PREREAD ENTERED DIRECTLY FROM TIG-30 VIA POSTJUMP.
#	READACCS CALLED AS WAITLIST TASK.					   .
#
# SUBROUTINES CALLED
#
# 	UTILITY ROUTINES - PHASCHNG FLAGUP FLAGDOWN NOVAC FINDVAC WAITLIST ALARM NEWPHASE 2PHSCHNG
#
#	OTHER - PIPASR 1/PIPA CALCGRAV CALCRVG AVETOMID
#
# NORMAL EXIT MODES
#
#	ENDOFJOB	TASKOVER	CANV37
#
#	AVGEXIT -	THIS IS A DOUBLE PRECISION ERASABLE LOCATION BY WHICH CONTROL IS TRANSFERRED AT THE END
#				OF EACH CYCLE OF AVERAGE G.
#			THE 2CADR OF A ROUTINE TO BE PERFORMED AT THAT TIME (E.G., STEERING EQUATIONS TO BE PERFORMED
#				AT 2 SECOND INTERVALS) MAY BE SET BY THE USER INTO AVGEXIT.
#			ALL SUCH ROUTINES SHOULD RETURN TO SERVEXIT, WHICH IS THE NORMAL EXIT FROM AVERAGE G.
#
#	SERVEXIT -	DOES A PHASE CHANGE FOR RESTART PROTECTION AND GOES TO ENDOFJOB.
#			THE 2CADR OF SERVEXIT IS SET INTO AVGEXIT BY THE USER IF NO OTHER ROUTINE (SEE ABOVE).
#
#	AVGEND -	LAST PASS OF AVERAGE G EXITS HERE, BYPASSING SPECIAL ROUTINE (SEE ABOVE UNDER READACCS).
#			FINAL EXIT IS TO CANV37.				F AVERAGE G).
#
# OUTPUT
#
#	DVTOTAL(2)  PIPTIME(2)  XPIPBUF(2)  YPIPBUF(2)  ZPIPBUF(2)
#	RN(6)		REFERENCE COORD.	SCALED AT 2(+29) M/CS
#	VN(6)		REFERENCE COORD.	SCALED AT 2(+7) M/CS
#	GDT/2(6)	REFERENCE COORD.	SCALED AT 2(+7) M/CS
#	DELV(6)		STABLE MEMB. COORD.	SCALED AT 2(+14)*5.85*10(-4) M/CS (KPIP1 USED TO GET DV/2 AT 2(+7))
## Page 822
#	DELVREF(6)	REFERENCE COORD.	SCALED AT 2(+7) M/CS
#
# INITIALIZATION
#
#	ONMONITOR FLAG SET BY ENTRY TO SHOW PIPBUF VALUES REQUIRED.
#	IDLE FLAG ON IF DVMON TO BE BYPASSED.
#	DVTHRUSH SET TO APPROPRIATE VALUE FOR DVMON.
#	AVGEXIT SET TO 2CADR OF ROUTINE, IF ANY, TO BE PERFORMED AFTER EACH CYCLE OF AVERAGE G.  IF NO ROUTINE
#		TO BE DONE, AVGEXIT SET TO SERVEXIT.
#	VALUES NEEDED
#		REFSMMAT
#		UNITW -  FULL UNIT VECTOR, IN REFERENCE COORD., OF EARTH S ROTATIONAL VECTOR
#		RN1, VN1, PIPTIME1 -  IN REFERENCE COORD., CONSISTENT WITH TIME OF EXECUTION OF PREREAD
#
# DEBRIS
#
#	CENTRALS	A, L, Q
#	OTHER		INTERNAL - DVCNTR(1)  PIPAGE(1)  PIPCTR(1)  AVGEXIT(2)
#			EXTERNAL - ITEMP1(1)  ITEMP2(1)  RUPTREG1(1)  TEMX(1)  TEMY(1)  TEMZ(1)
#			USEFUL DEBRIS
#				RN1(6)  VN1(6)  GDT1/2  PIPTIME1(2)
#					THESE LOCATIONS USED AS BUFFER STORAGE FOR NEWLY CALCULATED VALUES OF RN, VN, GDT/2,
#					AND PIPTIME DURING PERFORMANCE OF SERVICER ROUTINES.
#				UNITR - HALF UNIT VECTOR OF RN, REFERENCE COORD.
#				RMAG SCALED AT 2(+58) IN 36D.
#				RMAGSQ SCALED AT 2(+58) IN 34D.
#				(RE/RMAG)SQ IN 32D.

		BANK	27
		SETLOC	SERVICES
		BANK
		
		EBANK=	DVCNTR
# *************************************   PREREAD   **************************************************************

		COUNT	37/SERV
		
PREREAD		CAF	PRIO21		# CALLER MUST PROTECT PREREAD
		TC	NOVAC
		EBANK=	NBDX
		2CADR	LASTBIAS	# DO LAST GYRO COMPENSATION IN FREE FALL
		
					# CALL-TO AND LASTBIAS ITSELF ARE NOT
					#	PROTECTED. REREADAC SETS 1/PIPADT
					#	TO 2.0 SECS IN CASE LASTBIAS LOST.
					#	(REDUNDANT IF LASTBIAS IS AOK)
## Page 823
REDO5.31	TC	PREREAD1

		CAF	PRIO32
		TC	FINDVAC		# SET UP NORMLIZE JOB REQUIRED PRIOR TO
		EBANK=	DVCNTR		# FIRST AVERAGE G PASS
		2CADR	NORMLIZE
		
		CAF	2SECS
		TC	WAITLIST
		EBANK=	AOG
		2CADR	READACCS
		
		CS	TWO
		TC	NEWPHASE
		OCT	5
		
		TCF	TASKOVER
		
PREREAD1	EXTEND
		QXCH	RUPTREG1
		
		TC	PIPASR		# CLEAR + READ PIPS LAST TIME IN FREE FALL
		
		CAF	ONE		# SET UP PIPAGE FOR REREADAC IN CASE A
		TS	PIPAGE		# 	RESTART OCCURS BEFORE READACCS
		
		CS	FLAGWRD1	# SET AVEG FLAG
		MASK	BIT1
		ADS	FLAGWRD1
		
		CA	POSMAX
		MASK	FLAGWRD2
		TS	FLAGWRD2	# KNOCK DOWN DRIFT FLAG
		
		CS	FLAGWRD7	# SET V37 FLAG
		MASK	BIT6
		ADS	FLAGWRD7
		
		CAF	ZERO
		TS	DVTOTAL		# CLEAR DVTOTAL
		TS	DVTOTAL +1
		
		TC	RUPTREG1

## Page 824
# *************************************   READACCS   *************************************************************
		EBANK=	AOG
READACCS	TC	PIPASR

PIPSDONE	CAF	FIVE
		TS	L
		COM
		DXCH	-PHASE5
		
REDO5.5		CAF	ONE		# SHOW PIPS HAVE BEEN READ
		TS	PIPAGE
		
		CA	TWO		# SET PIPCTR FOR ONMINTOR
		TS	PIPCTR		# AFTER ABOVE PHASCHNG
		
		CS	CM/FLAGS
		MASK	BIT2		# CM/DSTBY
		CCS	A
		TC	CHEKAVEG
		
		CS	PIPTIME1 +1
		TS	TBASE6		# FOR RESTARTS
		EXTEND			# CONTINUE FOR ENTRY DAP
		DCA	AOG
		DXCH	AOG/PIP
		CA	AMG
		XCH	AMG/PIP
		EXTEND
		DCA	ROLL/180
		DXCH	ROLL/PIP
		CA	BETA/180
		XCH	BETA/PIP
		CA	CM/FLAGS
		MASK	BIT12		# CM/DAPARM 93D BIT12
		EXTEND			# DURING ENTRY, WHEN RCS DAP IS INACTIVE,
		BZF	NOSAVPIP	# SAVE PIPAS EACH 0.5 SEC FOR TM.
		
		CA	0.5SEC
		TC	WAITLIST
		EBANK=	XPIPBUF
		2CADR	QUIKREAD
		
					# NO NEED TO RESTART PROTECT THIS.
		CA	DELVX		# SAVE PIPAS AS READ (BUT NOT COMPENSATED)
		XCH	XPIPBUF
		TS	XOLDBUF
		
		CA	DELVY
		XCH	YPIPBUF
		TS	YOLDBUF
## Page 825
		CA	DELVZ
		XCH	ZPIPBUF
		TS	ZOLDBUF
		
NOSAVPIP	CA	FIVE
		TS	CM/GYMDT
		
		CA	JTAGTIME	# ACTIVATE CM/RCS AFTER PIPUP TO GO
					# IN JTAGTIME +5 CS.
		TC	WAITLIST
		EBANK=	AOG
		2CADR	SETJTAG
		
		CS	THREE		# 1.3SPOT FOR SETJTAG
		TC	NEWPHASE
		OCT	1
		
		CAF	OCT37
		TS	L
		COM
		DXCH	-PHASE5
		
CHEKAVEG	CS	FLAGWRD1
		MASK	BIT1
		CCS	A		# IF AVEG FLAG DOWN SET FINAL EXIT AVEG
		TC	AVEGOUT
		
		CAF	2SECS
		TC	WAITLIST
		EBANK=	AOG
		2CADR	READACCS
		
MAKESERV	CAF	PRIO20		# ESTABLISH SERVICER ROUTINE
		TC	FINDVAC
		EBANK=	DVCNTR
		2CADR	SERVICER
		
		CS	FOUR		# RESTART SERVICER AND READACCS
		TC	NEWPHASE
		OCT	5
		
		CAF	BIT9
		EXTEND
		WOR	DSALMOUT	# TURN TEST CONNECTOR OUTBIT ON
		
		TCF	TASKOVER	# END PREVIOUS READACCS WAITLIST TASK
		
## Page 826
AVEGOUT		EXTEND
		DCA	AVOUTCAD
		DXCH	AVGEXIT
		TCF	MAKESERV
		
		EBANK=	DVCNTR
AVOUTCAD	2CADR	AVGEND

## Page 827
# ROUTINE NAME:	ONMNITOR
# MOD 04 BY BAIRNSFATHER 30 APR 1968	REDO ONMNITOR TO SAVE PIPS EACH 0.5 SEC FOR TM,ENTRY.
# MOD 03 BY FISHER DECEMBER 1967
# MOD 02 BY RYE SEPT 1967
# MOD 01 BY KOSMALA 23 MAR 1967
# MOD 00 BY KOSMALA 27 FEB 1967
#
# FUNCTIONAL DESCRIPTION
#
#	THE PURPOSE OF ONMONITOR IS TO PROVIDE 1/2 SEC. READING OF PIPAS FOR DOWNLIST DURING ENTRY.
#	X,Y,ZPIPBUF CONTAIN PRESENT VALUES X,Y,ZOLDBUF CONTAIN VALUES FROM PREVIOUS READING.
#
# CALLING SEQUENCE
#
#	CALL AS WAITLIST TASK. TERMINATES ITSELF IN TASKOVER
#
# INITIALISATION
#
#	PIPCTR = 2 (FOR DT = 0.5 SEC)
#	X,Y,ZPIPBUF SET TO PREVIOUS PIPAX,Y,Z
#
# OUTPUT
#
#	X,Y,ZPIPBUF, X,Y,ZOLDBUF
#
# DEBRIS
#
#	X,Y,ZPIPBUF CONTAIN LAST PIPAX,Y,Z VALUES
#		X,Y,ZOLDBUF CONTAIN LAST-BUT-ONE PIPAX,Y,Z VALUES
#	RUPTREG1
#	PIPCTR

ONMNITOR	TS	PIPCTR

		TC	FIXDELAY	# WAIT
0.5SEC		DEC	50

QUIKREAD	CAF	TWO
		TS	RUPTREG1
		INDEX	A
		CA	PIPAX		# SAVE ACTUAL PIPAS FOR TM.
		INDEX	RUPTREG1
		XCH	XPIPBUF		# UPDATE X,Y,ZPIPBUF
		INDEX	RUPTREG1
		TS	XOLDBUF		# AND X,Y,ZOLDBUF
CHKCTR		CCS	RUPTREG1
		TCF	QUIKREAD +1	# LOOP AGAIN
		CCS	PIPCTR
		TCF	ONMNITOR
		TC	TASKOVER

## Page 828
# *************************************   SERVICER   *************************************************************

		EBANK=	DVCNTR
		
SERVICER	CAF	TWO
		INHINT
PIPCHECK	TS	RUPTREG1

		DOUBLE
		INDEX	A
		CCS	DELVX
		TC	+2
		TC	PIPLOOP
		
		AD	-MAXDELV	# DO PIPA-SATURATION TEST BEFORE
		EXTEND
		BZMF	PIPLOOP		# COMPENSATION.
		
		TC	ALARM
		OCT	00205		# SATURATED-PIPA ALARM   ***CHANGE LATER
		TC	AVERAGEG
		
PIPLOOP		CCS	RUPTREG1
		TCF	PIPCHECK
		
		TC	PHASCHNG	# RESTART REREADAC + SERVICER
		OCT	16035
		OCT	20000
		EBANK=	DVCNTR
		2CADR	DVTOTUP
		
		TC	BANKCALL	# PIPA COMPENSATION CALL
		CADR	1/PIPA
		
DVTOTUP		TC	INTPRET
		VLOAD	ABVAL		# GET ABS VALUE OF DELV
			DELV
		DMP	EXIT
			KPIP1		# SCALE AT 2(+7)
			
		EXTEND
		DCA	MPAC
		DAS	DVTOTAL		# ACCUMULATE DVTOTAL
AVERAGEG	TC	PHASCHNG
		OCT	10035
		
		TC	INTPRET
		CALL
## Page 829
			CALCRVG
		EXIT
		
		TC	PHASCHNG
		OCT	10035
		
		CAF	OCT31		# COPY RN1,VN1,GOT102,GOBL1/2,PIPTIME1
		TC	GENTRAN		# INTO RN, VN, GDT/12, GOBL/2,PIPTIME
		ADRES	RN1
		ADRES	RN
		RELINT			# GENTRAN DOES AN INHINT
		TC	PHASCHNG
		OCT	10035

		EXTEND
		DCA	AVGEXIT
		DXCH	Z		# AVERAGEG EXIT
		
AVGEND		CA	PIPTIME +1	# FINAL AVERAGE G EXIT
		TS	OLDBT1		# SET UP FREE FALL GYRO COMPENSATION
		
		TC	UPFLAG		# SET DRIFTFLG
		ADRES	DRIFTFLG	# BIT 15 FLAG 2
		TC	2PHSCHNG
		OCT	5		# GROUP 5 OFF
		OCT	05022		# GROUP 2 ON FOR AVETOMID
		OCT	20000
		
		TC	INTPRET
		CALL
			AVETOMID	# CONVERT STATE VECTOR TO REFERENCE SCALE.
		EXIT
		
		CAF	ZERO		# ZERO MARK COUNTERS.
		TS	VHFCNT
		TS	TRKMKCNT
		
		TC	BANKCALL
		CADR	PIPFREE
		
		CS	BIT9
		TS	MRKBUF2		# INVALIDATE MARK BUFFER
		EXTEND
		WAND	DSALMOUT
		
		TC	DOWNFLAG
		ADRES	CM/DSTBY
		
		TC	DOWNFLAG
		ADRES	V37FLAG

## Page 830
		CAF	BIT7		# RESTORE GROUP 1 + 2 IF P20 IS RUNNING.
		MASK	FLAGWRD0
		EXTEND
		BZF	+4
		
		TC	2PHSCHNG
		OCT	111		# 1.11SPOT
		OCT	132		# 2.13SPOT
		
		TC	POSTJUMP
		CADR	CANV37
		
SERVEXIT	TC	PHASCHNG
		OCT	00035		# A, 5.3 = REREADAC 	(ONLY)
		
		TCF	ENDOFJOB
		
DVTHRUSH	EQUALS	ELEVEN		# 15 PERCENT OF 2SEC PIPA ACCUMULATION,
					#	FOR 503-FULL CSM/LEM....DELV SC.AT
					#	5.85 CM/SEC.
					
-MAXDELV	DEC	-6398		# 3200 PPS FOR 2 SEC CCS TAKES 1

JTAGTIME	DEC	120		# = 1 SEC + T CDU, T CDU = .1 SEC

2.5SEC		DEC	250
MDOTFAIL	DEC	144.0 B-16	# 5 SEC MASS LOSS AT 28.8 KG/SEC
					# SHOULD BE 2-4 SECS FOR NO START
					#	    6-8 SECS FOR FAILURE
					
## Page 831
# NORMLIZE PERFORMS THE INITIALIZATION REQUIRED PRIOR TO THE FIRST ENTRY TO AVERAGEG, AND SCALES RN SO THAT IT
# HAS 1 LEADING BINARY ZERO.  IN MOST MISSIONS, RN WILL BE SCALED AT 2(+29), BUT IN THE 206 MISSION, RN WILL BE
# SCALED AT 2(+24) M.

NORMLIZE	CAF	THIRTEEN	# SET UP TO COPY 14 REGS- RN1,VN1,PIPTIME1
		TC	GENTRAN		# INTO RN,VN,PIPTIME
		ADRES	RN1		# FROM HERE
		ADRES	RN		# TO HERE
		
		RELINT
		TC	INTPRET
		VLOAD	CALL		# LOAD RN FOR CALCGRAV
			RN
			CALCGRAV	# INITIALISE UNITR RMAG GDT1
			
		STOVL	GDT/2
			GOBL1/2
		STORE	GOBL/2
		EXIT
		TCF	ENDOFJOB
		
## Page 832
# *****  PIPA READER *****
# MOD NO. 00 BY D. LICKLY DEC. 9 1966
#
# FUNCTIONAL DESCRIPTION
#
# SUBROUTINE TO READ PIPA COUNTERS, TRYING TO BE VERY CAREFUL SO THAT IT WILL BE RESTARTABLE.
# PIPA READINGS ARE STORED IN THE VECTOR DELV.  THE HIGH ORDER PART OF EACH COMPONENT CONTAINS THE PIPA READING,
# RESTARTS BEGIN AT REREADAC.
#
# AT THE END OF THE PIPA READER THE CDUS ARE READ AND STORED AS A
# VECTOR IN CDUTEMP.  THE HIGH ORDER PART OF EACH COMPONENT CONTAINS
# THE CDU READING IN 2S COMP IN THE ORDER CDUX,Y,Z.  THE THRUST
# VECTOR ESTIMATOR IN FINDCDUD REQUIRES THE CDUS BE READ AT PIPTIME.
#
# CALLING SEQUENCE AND EXIT
#
#	CALL VIA TC, ISWCALL, ETC.
#
#	EXIT IS VIA Q.
#
# INPUT
#
#	INPUT IS THROUGH THE COUNTERS PIPAX, PIPAY, PIPAZ, AND TIME2.
#
# OUTPUT
#
#	HIGH ORDER COMPONENTS OF THE VECTOR DELV CONTAIN THE PIPA READINGS.
#
#	PIPTIME CONTAINS TIME OF PIPA READING.
#
# DEBRIS (ERASABLE LOCATIONS DESTROYED BY PROGRAM)
#
#	LOW ORDER DELV'S ARE ZEROED FOR TM INDICATION.
#	TEMX	TEMY	TEMZ	PIPAGE

PIPASR		EXTEND
		DCA	TIME2
		DXCH	PIPTIME1	# CURRENT TIME	POSITIVE VALUE
		CS	ZERO		# INITIALIZE THESE AT NEG ZERO.
		TS	TEMX
		TS	TEMY
		TS	TEMZ
## Page 833
		CA	ZERO
		TS	DELVZ		# OTHER DELVS OK INCLUDING LOW ORDER
		TS	DELVY
		
		TS	DELVX +1	# LOW ORDER DELV'S ARE ZEROED FOR TM:  THUS
		TS	DELVY +1	# IF DNLNK'D LOW ORDER DELVS ARE NZ, THEY
		TS	DELVZ +1	# CONTAIN PROPER COMPENSATION.  IF=0, THEN
					# THE TM VALUES ARE BEFORE COMPENSATION.
					
		TS	PIPAGE		# SHOW PIPA READING IN PROGRESS
		
REPIP1		EXTEND
		DCS	PIPAX		# X AND Y PIPS READ
		DXCH	TEMX
		DXCH	PIPAX		# PIPAS SET TO NEG ZERO AS READ.
		TS	DELVX
		LXCH	DELVY
		
REPIP3		CS	PIPAZ		# REPEAT PROCESS FOR Z PIP
		XCH	TEMZ
		XCH	PIPAZ
DODELVZ		TS	DELVZ

		TC	Q
		
		EBANK=	AOG
		
REREADAC	CCS	PHASE5		# LAST PASS CHECK
		TCF	+2
		TCF	TASKOVER
		
		CAF	PRIO31		# RESTART MAY HAVE WIPED OUT LASTBIAS, AN
		TS	1/PIPADT	#	UNPROTECTED NOVAC FROM PREREAD,
					#	WHICH SET(S) UP 1/PIPADT (THUSLY)
					#	FOR NON-COASTING COMPENSATION....BE
					#	SURE 1/PIPADT IS AOK.  (PRIO31 IS
					#	2.0SEC SC.AT B+8CS)
					
		CCS	PIPAGE
		TCF	READACCS	# PIP READING NOT STARTED.  GO TO BEGINNING
		
		CAF	DONEADR		# SET UP RETURN FROM PIPASR
		TS	Q
		
		CCS	DELVZ
		TC	Q		# Z DONE, GO DO CDUS
		TCF	+3		# Z NOT DONE, CHECK Y.
		TC	Q
		TC	Q
## Page 834
		ZL
		CCS	DELVY
		TCF	+3
		TCF	CHKTEMX		# Y NOT DONE, CHECK X.
		TCF	+1
		LXCH	PIPAZ		# Y DONE, ZERO Z PIP.
		
		CCS	TEMZ
		CS	TEMZ		# TEMZ NOT = -0, CONTAINS -PIPAZ VALUE.
		TCF	DODELVZ
		TCF	-2
		LXCH	DELVZ		# TEMZ = -0, L HAS ZPIP VALUE.
		TC	Q
		
CHKTEMX		CCS	TEMX		# HAS THIS CHANGED
		CS	TEMX		# YES
		TCF	+3		# YES
		TCF	-2		# YES
		TCF	REPIP1		# NO
		TS	DELVX
		
		CS	TEMY
		TS	DELVY
		
		CS	ZERO		# ZERO X AND Y PIPS
		DXCH	PIPAX		# L STILL ZERO FROM ABOVE
		
		TCF	REPIP3
		
DONEADR		GENADR	PIPSDONE

## Page 835
# *************************************************************************************************************
#
#          ROUTINE CALCRVG INTEGRATES THE EQUATIONS OF MOTION BY AVERAGING THE THRUST AND GRAVITATIONAL
# ACCELERATIONS OVER A TIME INTERVAL OF 2 SECONDS.
#
#          FOR THE EARTH-CENTERED GRAVITATIONAL FIELD, THE PERTURBATION DUE TO OBLATENESS IS COMPUTED TO THE FIRST
# HARMONIC COEFFICIENT J.
#
# ROUTINE CALCRVG REQUIRES...
#	1) THRUST ACCELERATION INCREMENTS IN DELV SCALED SAME AS PIPAX,Y,Z IN STABLE MEMBER COORDS.
#	2) VN SCALED 2(+7) M/CS IN REFERENCE COORDS.
#	3) RN SCALED AT 2(+29) METERS IN REFERENCE COORDS.
#	4) UNITW THE EARTH S UNIT ROTATIONAL VECTOR (SCALED AS A FULL UNIT VECTOR) IN REFERENCE COORDS.
#
# IT LEAVES RN1 UPDATED (SCALED AT 2(+29)M, VN1 (SCALED AT 2(+7)M/CS), AND GDT1/2 (SCALED AT 2(+7)M/CS). ALSO HALF
# UNIT VECTOR UNITR, RMAG IN 36D SCALED AT 2(+29)M, R MAG SQ. IN 34D SCALED AT 2(+58) M SQ.

CALCGRAV	UNIT	PUSH		# ENTER WITH RN IN MPAC
		STORE 	UNITR
		LXC,1	SLOAD
			RTX2
			X1
		BMN	VLOAD
			ITISMOON
		DOT	PUSH
			UNITW
		DSQ	BDSU
			DP1/20
		PDDL	DDV
			RESQ
			34D		# (RN)SQ
		STORE	32D		# TEMP FOR (RE/RN)SQ
		DMP	DMP
			20J
		VXSC	PDDL
			UNITR
		DMP	DMP
			2J
			32D
		VXSC	VAD
			UNITW
		STADR
		STORE	GOBL1/2
		VAD	PUSH
			UNITR
ITISMOON	DLOAD	NORM
			34D
			X2
		BDDV*	SLR*
## Page 836
			-MUDT(E),1
			0 -21D,2
		VXSC	STADR
		STORE	GDT1/2		# SCALED AT 2(+7) M/CS
		RVQ

CALCRVG		VLOAD	VXSC
			DELV
			KPIP1
		VXM	VSL1
			REFSMMAT
		STORE	DELVREF		# DELV IN REF COORDS AT 2(+7)
		VSR1	PUSH
		VAD	PUSH		# (DV-OLDGDT)/2 TO PD SCALED AT 2(+7)M/CS
			GDT/2
		VAD	VXSC
			VN
			2SEC(22)
		VAD	STQ
			RN
			31D
		STCALL	RN1		# TEMP STORAGE OF RN SCALED 2(+29)M
			CALCGRAV
			
		VAD	VAD
		VAD
			VN
		STCALL	VN1		# TEMP STORAGE OF VN SCALED 2(+7) M/CS
			31D
			
KPIP		2DEC	.1024		# SCALES DELV TO 2(+4)

KPIP1		2DEC	0.074880	# 207 DELV SCALING.  1 PULSE = 5.85 CM/SEC.

-MUDT(E)	2DEC*	-7.9720645 E+12 B-44*

-MUDT(M)	2DEC*	-9.805556 E+10 B-44*

2SEC(22)	2DEC	200 B-22

DP1/20		2DEC	0.05

RESQ		2DEC*	40.6809913 E12 B-59*

20J		2DEC*	3.24692010 E-2 B1*

2J		2DEC*	3.24692010 E-3 B1*

