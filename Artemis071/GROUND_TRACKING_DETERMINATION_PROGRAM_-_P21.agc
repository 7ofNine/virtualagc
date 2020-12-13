### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    GROUND_TRACKING_DETERMINATION_PROGRAM_-_P21.agc
## Purpose:     A section of Artemis revision 071.
##              It is part of the reconstructed source code for the first
##              release of the flight software for the Command Module's
##              (CM) Apollo Guidance Computer (AGC) for Apollo 15 through
##              17. The code has been recreated from a copy of Artemis 072.
##              It has been adapted such that the resulting bugger words
##              exactly match those specified for Artemis 071 in NASA
##              drawing 2021154-, which gives relatively high confidence
##              that the reconstruction is correct.
## Reference:   455
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2019-08-14 MAS  Created from Artemis 072.

## Page 455
# GROUND TRACKING DETERMINATION PROGRAM P21
#
# PROGRAM DESCRIPTION
# MOD NO - 1
# MOD BY - N. M. NEVILLE
#
# FUNCTIONAL DECRIPTION-
#
# 	TO PROVIDE THE ASTRONAUT DETAILS OF THE LM OR CSM GROUND TRACK WITHOUT
# 	THE NEED FOR GROUND COMMUNICATION (REQUESTED BY DSKY).
#
# CALLING SEQUENCE -
#
# 	ASTRONAUT REQUEST THROUGH DSKY V37E21E
#
# SUBROUTINES CALLED-
#
# 	GOPERF4
# 	GOFLASH
# 	THISPREC
# 	OTHPREC
# 	LAT-LONG
#
# NORMAL EXIT MODES-
#
# 	ASTRONAUT REQUEST TROUGH DSKY TO TERMINATE PROGRAM V34E
#
# ALARM OR ABORT EXIT MODES-
# 
# 	NONE
#
# OUTPUT -
#
# 	OCTAL DISPLAY OF OPTION CODE AND VEHICLE WHOSE GROUND TRACK IS TO BE
# 	COMPUTED
#		OPTION CODE	00002
#		THIS		00001
#		OTHER		00002
#	DECIMAL DISPLAY OF TIME TO BE INTEGRATED TO HOURS , MINUTES , SECONDS
#	DECIMAL DISPLAY OF LAT,LONG,ALT
#
# ERASABLE INITIALIZATION REQUIRED
#
#	AX0	 2DEC	4.652459653 E-5   RADIANS       %68-69 CONSTANTS"
#
#	-AY0	 2DEC	2.147535898 E-5   RADIANS
#
#	AZ0	 2DEC	.7753206164	  REVOLUTIONS
#
# 	FOR LUNAR ORBITS 504LM VECTOR IS NEEDED
#
#	504LM	 2DEC	-2.700340600 E-5  RADIANS
#
#	504LM _2 2DEC	-7.514128400 E-4  RADIANS
#
#	504LM _4 2DEC	_2.553198641 E-4  RADIANS
#
#	NONE
#
# DEBRIS
#
## Page 456
#	CENTRALS - A,Q,L
#	OTHER - THOSE USED BY THE ABOVE LISTED SUBROUTINES
#	SEE LEMPREC,LAT-LONG

		SBANK=	LOWSUPER	# FOR LOW 2CADR'S.

		SETLOC	P20S
		BANK

		EBANK=	P21TIME
		COUNT*	$$/P21
PROG21		CAF	ONE
		TS	OPTION2		# ASSUMED VEHICLE IS LM, R2 = 00001
		TC	UPFLAG
		ADRES	TRACKFLG

		CAF	BIT2		#  OPTION 2
		TC	BANKCALL
		CADR	GOPERF4
		TC	GOTOPOOH	# TERMINATE
		TC	+2		# PROCEED VALUE OF ASSUMED VEHICLE OK
		TC	-5		# R2 LOADED THROUGH DSKY
		CAF	ZERO		# ZERO DSPTEM
		TS	DSPTEM1
		TS	DSPTEM1 +1
P21PROG1	CAF	V6N34		# LOAD DESIRED TIME OF LAT-LONG.
		TC	VNFLASH
		TC	INTPRET
		DLOAD	BZE
			DSPTEM1
			P21PRTM		# SET TO INTEG TO PRES TIME
P21PROG2	STCALL	TDEC1		# INTEG TO TIME SPECIFIED IN TDEC
			INTSTALL
		BON	SET
			P21FLAG
			P21CONT		# ON...RECYCLE USING BASE VECTOR
			VINTFLAG	# OFF..1ST PASS CALC BASE VECTOR
		SLOAD	SR1
			OPTION2
		BHIZ	CLEAR
			+2		# ZERO..THIS VEHICLE (CM)
			VINTFLAG	# ONE...OTHER VEHICLE(LM)
		CLEAR	CLEAR
			DIM0FLAG
			INTYPFLG	# PRECISION
		CALL
			INTEGRV		# CALCULATE
		GOTO			# .AND
			P21VSAVE	# ..SAVE BASE VECTOR
P21CONT		VLOAD			# RECYCLE..INTEG FROM BASE VECTOR			
## Page 457
			P21BASER
		STOVL	RCV		# ..POS
			P21BASEV
		STODL	VCV		# ..VEL
			P21TIME
		STORE	TET		# ..TIME
		CLEAR	CLEAR
			DIM0FLAG
			MOONFLAG
		SLOAD	BZE
			P21ORIG
			+3		# ZERO = EARTH
		SET			# ...2 = MOON
			MOONFLAG
		CALL
			INTEGRVS
P21VSAVE	DLOAD			# SAVE CURRENT BASE VECTOR
			TAT
		STOVL	P21TIME		# ..TIME
			RATT1
		STOVL	P21BASER	# ..POS B-29 OR B-27
			VATT1
		STORE	P21BASEV	# ..VEL B-7  OR B-5
		BONCLR			# WITH ADJUSTED P29 BASE TIME, SKIP
			NEWTFLAG	#      P29 DISPLAYS
			HOP29DSP
		BOFF	RTB		# RETURN TO P29 IF P29FLAG IS SET
			P29FLAG
			+2
			LONGPASS
		ABVAL	SL*
			0,2
		STOVL	P21VEL		# /VEL/ FOR N73 DSP
			RATT
		UNIT	DOT
			VATT		# U(R).(V)
		DDV	ASIN		# U(R).U(V)
			P21VEL
		STORE	P21GAM		# SIN-1 U(R).U(V), -90 TO +90
		SXA,2	SET
			P21ORIG		# 0 = EARTH  2 = MOON
			P21FLAG
P21DSP		CLEAR	SLOAD		# GENERATE DISPLAY DATA
			LUNAFLAG
			X2
		BZE	SET
			+2		# 0 = EARTH
			LUNAFLAG
		VLOAD
			RATT
## Page 458
		STODL	ALPHAV
			TAT
		CLEAR	CALL
			ERADFLAG
			LAT-LONG
		DMP			# MPAC = ALT, METERS B-29
			K.01
		STORE	P21ALT		# ALT/100 FOR N73 DSP
		EXIT
		CAF	V06N43		# DISPLAY LAT,LONG,ALT
		TC	BANKCALL	# LAT,LONG = REVS B0	BOTH EARTH/MOON
		CADR	GOFLASH		# ALT = METERS B-29	BOTH EARTH/MOON
		TC	GOTOPOOH	# TERM
		TC	GOTOPOOH
		TC	INTPRET		# V32E RECYCLE
		DLOAD	DAD
			P21TIME
			600SEC		# 600 SECONDS OR 10 MIN
		STORE	DSPTEM1
		RTB	
			P21PROG1
P21PRTM		RTB	GOTO
			LOADTIME
			P21PROG2
600SEC		2DEC	60000		# 10 MIN

P21ONENN	OCT	00001		# NEEDED TO DETERMINE VEHICLE
		OCT	00000		# TO BE INTEGRATED
V06N43		VN	00643
V6N34		=	V06N34
K.01		2DEC	.01

		SETLOC	P29TAG1
		BANK

		COUNT*	$$/P29
		EBANK=	LONGFOR

P29		TC	INTPRET		# TIME-TO-LONGITUDE PROGRAM
		SET	RTB		# SET=P29,CLEARED=P21--CHECKED IN P21
			P29FLAG		# FLAG ALSO MARKS FIRST PASS THRU P29
			PROG21		# GET BASE TIME + STATE VECTOR FROM P21
LONGPASS	CAF	V06N43LP
		TC	VNFLASHR	# ASTRONAUT LOADS DESIRED LONGITUDE
		TCF	+4
		CAF	FIVE		# BLANK R1,R3
		TC	BLANKET
		TC	ENDOFJOB
		DXCH	LONG
		DXCH	LONGFOR		# STORE DESIRED LONGITUDE
## Page 459
		TC	INTPRET
HOP29DSP	VLOAD	PDDL		# STORE UNIT NORTH(IN PLANETARY COORDS )
			UNITZ		#      AND BASE TIME ON PUSHLIST FOR
			P29BASET	#      RP-TO-R
		STORE	PASSTIME	# INITIALIZE TIME OF CROSSING
		PDDL	SET
			ZEROVECS
			P29FLAG		# IN CASE OF RESTART OR REPEAT INTEGRATION
		STORE	DELTLONG	# INITIALIZE LONGITUDE DIFFERENCE TO ZERO
		CLEAR	BOFF
			LUNAFLAG
			CMOONFLG
			+4
		SET	DLOAD
			LUNAFLAG	# SET LUNAFLAG=CMOONFLG FOR LAT-LONG
			FMOON		# MPAC NONZERO FOR MOON, ZERO FOR EARTH
		CALL			# GET UNIT PLANETARY NORTH IN BASE COORDS.
			RP-TO-R
		PUSH	PUSH		# PD=12D,MUSUBZ(UNIT PLANETARY NORTH)
		VXV	UNIT
			P29BASER
		STOVL	MUSUBE		# PD=6D,MUSUBE=UNIT LOCAL EAST AT P29BASER
		VXV	UNIT
			MUSUBE
		STOVL	MUSUBC		# UNIT EQUATORIAL CENTRAL-DIRECTED VECTOR
			P29BASER
		VXV	UNIT		# FORM MUSUBN(UNIT ORBITAL LOCAL NORTH)
			P29BASEV
		PUSH	PUSH		# PD=18D
		VXV	UNIT
			P29BASER
		STOVL	MUSUBS		# PD=12D,MUSUBS=UNIT ORBITAL TANG. VEL.
		DOT	PDVL		# PD=8D,MUSUBZ AT 0D, EXCHANGE DOT-PRODUCT
			0D		#      WITH MUSUBN IN PUSHLIST
		SIGN	STADR		# PD=6D, PUT MUSUBN IN HEMI. OF MUSUBZ
		STOVL	MUSUBN
			P29BASER
HOPALONG	BOFF	VSR2		# MUST BE B+29 FOR LAT-LONG
			CMOONFLG
			+1
		STODL	ALPHAV		# STORE FOR LAT-LONG
			PASSTIME
		CLEAR	CALL		# FIND LONGITUDE FOR PRESENT ITERATION OF
			ERADFLAG	#      POSITION VECTOR
			LAT-LONG
		DLOAD	DSU		# COMPARE WITH DESIRED LONGITUDE
			LONGFOR
			LONG
		PUSH	ABS		# PD=2D, SAVE DELTA
		DSU	BMN		# IF WITHIN EPSILONG, DISPLAY RESULTS
## Page 460
			EPSILONG	# .01 DEGREES
			PASSOUT
		BOV			# CLEAR OVERFLOW INDICATOR
			+1
		DAD	BOV		# CHECK WHETHER WITHIN EPSILON OF 360 DEG.
			TWICEEPS	# .02 DEGREES
			PASSOUT
		BOFCLR	DLOAD		# P29FLAG CLEARED FOR LATER PASSES
			P29FLAG		# PD=0D
			MODULO
		BPL	DAD		# MAKE DELTA>0
			+2
			DPPOSMAX
		BOFF	DSU		# FOR EARTH,DELTA>0
			CMOONFLG	# FOR MOON, DELTA.0
			HOP1
			DPPOSMAX
		PDDL	GOTO		# PD=2D
			FMOON		# 327.8/328.8, 8+1
			HOP2
		SETLOC	P29TAG2
		BANK

		COUNT*	$$/P29
HOP1		PDDL			# PD=2D
			FEARTH		# 16/15, B+1
HOP2		STORE	FUDGE
DELTLOAD	DLOAD			# PD=0D, LOAD DELTA
THETCOMP	DMP	BOV
			FUDGE
			+1		# CLEAR OVERFLOW INDICATOR
		SL1	DAD		# SHIFT TO GET B0, SINCE FUDGE IS B+1
			DELTLONG
		PUSH	BOV		# PD=2D, IF FUDGE FACTOR MAKES DELTLONG>
			ADDTEN		#      360, MODIFY BASE TIME
		STORE	DELTLONG	# CUMULATIVE EQUATORIAL DELTA
		COS	VXSC
			MUSUBE
		PDDL	SIN		# PD=6D
		VXSC	VAD		# PD=0D
			MUSUBC		# ROTATE MUSUBE THRU ANGLE DELTLONG
		VXV	UNIT		# FORM MUSUBD=ROTATED ORBITAL UNIT
			MUSUBN		#      POSITION VECTOR, OUTWARD-DIRECTED
		PUSH	PDVL		# PD=12D
			P29BASER
		UNIT	DOT		# PD=6D, DOT PRODUCT IS B+2
		SL1	PDVL		# PD=2D, MAKE B+1 FOR ACOS, EXCHANGE
		DOT	PDDL		# PD=2D, EXCHANGE WITH PUSHLIST
			MUSUBS
		ACOS	SIGN		# PD=0D
## Page 461
		PUSH	SIN		# PD=2D, FORM THETA=ORBITAL DELTA
		STODL	SNTH		# PD=0D
		COS	AXC,1
			2D
		STOVL	CSTH		# STORE ANGLE DATA AND BASE STATE VECTOR
			P29BASER	#      FOR TIME-THETA
		STOVL	RVEC
			P29BASEV
		STORE	VVEC
		BOFF	AXC,1		# SET X1=-2D FOR EARTH, -10D FOR MOON
			CMOONFLG
			+2
			10D
		CLEAR	CALL		# INTEGRATE BASE STATE VECTOR THRU THETA
			RVSW
			TIMETHET
		DLOAD	DAD
			T		# T=TIME TO TRAVERSE THETA
			P29BASET
		STOVL	PASSTIME	# TIME OF LONGITUDE CROSSING
		GOTO			# UPDATED POSITION VECTOR LOADED FOR
			HOPALONG	#      LAT-LONG
MODULO		DSU	BMN		# MPAC CONTAINS ABS(DELTA)+EPSILONG
			DPHALF		# IF THIS IS NEAR 360, MUST ADJUST DELTA
			DELTLOAD	#      BY 360 TO GET ANGLE NEAR ZERO
		DSU			# TO ADJUST, SUBTRACT DPHALF (TWICE) AND
			EPSILONG	#      EPSILONG TO GET NEGATIVE NUMBER,
		DSU	SIGN		#      AND SIGN BY UNADJUSTED DIFFERENCE,
			DPHALF		#      AT TOP OF PUSHLIST, PD=0D.
		GOTO
			THETCOMP
ADDTEN		DLOAD	DAD		# ADD 10 MINUTES TO BASE TIME
			P29BASET
			600SEC
		SET	GOTO		# SET FLAG TO SKIP DISPLAYS ON RETURN TO
			NEWTFLAG	#       P29
			P21PROG2	# GO TO P21 FOR INTEGRATION
		SETLOC	P29TAG1
		BANK

		COUNT*	$$/P29
PASSOUT		EXIT
		DXCH	PASSTIME
		DXCH	DSPTEM1
		CAF	V06N34LP
		TC	BANKCALL
		CADR	GOFLASH		# DISPLAY PASSTIME
		TC	GOTOPOOH
		TC	+2
		TC	LONGPASS	# RECYCLE TO LONGITUDE INPUT
## Page 462
		CAF	V06N43LP
		TC	BANKCALL	# DISPLAY LAT,LONG,ALT AT DESIRED
		CADR	GOFLASH		#      LONGITUDE
		TC	GOTOPOOH
		TC	GOTOPOOH
		TC	P29		# RECYCLE TO START OF PROGRAM
EPSILONG	2DEC	.2777778E-04	# .01 DEGREES
TWICEEPS	2DEC	.5555556E-04	# .02 DEGREES
FEARTH		2DEC	1.06666667 B-01	# 16/15
FMOON		2DEC	.996958637 B-01	# 327.8/328.8
V06N34LP	VN	0634
V06N43LP	VN	0643
