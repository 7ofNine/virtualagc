### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    SERVICE_ROUTINES.agc
## Purpose:     The main source file for Luminary revision 069.
##              It is part of the source code for the original release
##              of the flight software for the Lunar Module's (LM) Apollo
##              Guidance Computer (AGC) for Apollo 10. The actual flown
##              version was Luminary 69 revision 2, which included a
##              newer lunar gravity model and only affected module 2.
##              This file is intended to be a faithful transcription, except
##              that the code format has been changed to conform to the
##              requirements of the yaYUL assembler rather than the
##              original YUL assembler.
## Reference:   pp. 1368-1374
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2016-12-13 MAS  Created from Luminary 99.
##              2016-12-18 MAS  Updated from comment-proofed Luminary 99 version.
##		2017-01-10 RRB	Updated for Luminary 69.
##              2017-01-21 HG   fix operand OCT 7 -> OCT7
##		2017-01-28 RSB	Proofed comment text using octopus/prooferComments
##				and fixed errors found.

## Page 1368
		BANK	10
		SETLOC	DISPLAYS
		BANK
		COUNT*	$$/DSPLA

UPENT2		TS	L		# WHICH FLAGWORD IS IT
		MASK	OCT7
		XCH	L		# SAVE IN L FOR INDEXING
		
		MASK	OCT77770	# OBTAIN THE BIT INFORMATION
		INHINT			# PREVENT INTERUPTS
		TS	ITEMP1		# STORE THE BIT INFORMATION TEMPORARIALY

		NDX	L
		CS	FLAGWRD0
		MASK	ITEMP1
		NDX	L
		ADS	FLAGWRD0
		RELINT			# RELEASE INTERUPT INHIBIT

		INCR	Q		# OBTAIN THE CORRECT RETURN ADDRESS
		TC	Q		# RETURN

DOWNENT2	TS	L		# WHICH FLAGWORD IS IT
		MASK	OCT7
		XCH	L		# SAVE IN L FOR INDEXING

		MASK	OCT77770	# OBTAIN THE BIT INFORMATION
		COM			# START TO PROCESS THE INFORMATION

		INHINT			# PREVENT INTERUPTS
		NDX	L
		MASK	FLAGWRD0
		NDX	L
		TS	FLAGWRD0
		RELINT			# RELEASE INTERUPT INHIBIT

		INCR	Q		# OBTAIN THE CORRECT RETURN ADDRESS
		TC	Q		# RETURN

OCT7		EQUALS	SEVEN

## Page 1369
#     UPFLAG AND DOWNFLAG ARE ENTIRELY GENERAL FLAG SETTING AND CLEARING SUBROUTINES.   USING THEM, WHETHER OR
# NOT IN INTERRUPT, ONE MAY SET OR CLEAR ANY SINGLE, NAMED BIT IN ANY ERASABLE REGISTER, SUBJECT OF COURSE TO
# EBANK SETTING.   A "NAMED" BIT, AS THE WORD IS USED HERE, IS ANY BIT WITH A NAME FORMALLY ASSIGNED BY THE YUL
# ASSEMBLER.
#
#     AT PRESENT THE ONLY NAMED BITS ARE THOSE IN THE FLAGWORDS.   ASSEMBLER CHANGES WILL MAKE IT POSSIBLE TO
# NAME ANY BIT IN ERASABLE MEMORY.
#
#     CALLING SEQUENCES ARE AS FOLLOWS :-
#		TC	UPFLAG			TC	DOWNFLAG
#		ADRES	NAME OF FLAG		ADRES	NAME OF FLAG
#
#     RETURN IS TO THE LOCATION FOLLOWING THE "ADRES" ABOUT .58 MS AFTER THE "TC".
#
#     UPON RETURN A CONTAINS THE CURRENT FLAGWRD SETTING.

		BLOCK	02
		SETLOC	FFTAG1
		BANK
		COUNT*	$$/FLAG

UPFLAG		CA	Q
		TC	DEBIT
		COM			# +(15 - BIT)
		EXTEND
		ROR	LCHAN		# SET BIT
COMFLAG		INDEX	ITEMP1
		TS	FLAGWRD0
		LXCH	ITEMP3
		RELINT
		TC	L

DOWNFLAG	CA	Q
		TC	DEBIT
		MASK	L		# RESET BIT
		TCF	COMFLAG

DEBIT		AD	ONE		# GET DE BITS
		INHINT
		TS	ITEMP3
		CA	LOW4		# DEC15
		TS	ITEMP1
		INDEX	ITEMP3
		CA	0 -1		# ADRES
		TS	L
		CA	ZERO
## Page 1370
		EXTEND
		DV	ITEMP1		# A = FLAGWRD, L = (15 - BIT)
		DXCH	ITEMP1
		INDEX	ITEMP1
		CA	FLAGWRD0
		TS	L		# CURRENT STATE
		INDEX	ITEMP2
		CS	BIT15		# -(15 - BIT)
		TC	Q

## Page 1371
# DELAYJOB - A GENERAL ROUTINE TO DELAY A JOB A SPECIFIC AMOUNT OF TIME BEFORE PICKING UP AGAIN.
#
# ENTRANCE REQUIREMENTS ...
#		CAF	DT		DELAY JOB FOR DT CENTISECS
#		TC	BANKCALL
#		CADR	DELAYJOB

		BANK	06
		SETLOC	DLAYJOB
		BANK

# THIS MUST REMAIN IN BANK 0 *****************************************

		COUNT*	$$/DELAY
DELAYJOB	INHINT
		TS	Q		# STORE DELAY DT IN Q FOR DLY -1 IN

		CAF	DELAYNUM	# WAITLIST
DELLOOP		TS	RUPTREG1
		INDEX	A
		CA	DELAYLOC	# IS THIS DELAYLOC AVAILABLE
		EXTEND
		BZF	OK2DELAY	# YES

		CCS	RUPTREG1	# NO, TRY NEXT DELAYLOC
		TCF	DELLOOP

		DXCH	BUF2
		TC	BAILOUT1	# NO AVAILABLE LOCS.
		OCT	1104

OK2DELAY	CA	TCSLEEP		# SET WAITLIST IMMEDIATE RETURN
		TS	WAITEXIT

		CA	FBANK
		AD	RUPTREG1	# STORE BBANK FOR TASK CALL
		TS	L

		CAF	WAKECAD		# STORE CADR FOR TASK CALL
		TCF	DLY2 -1		# DLY IS IN WAITLIST ROUTINE

TCGETCAD	TC	MAKECADR	# GET CALLERS FCADR

		INDEX	RUPTREG1
		TS	DELAYLOC	# SAVE DELAY CADRS

		TC	JOBSLEEP

WAKER		CAF	ZERO
		INDEX	BBANK
		XCH	DELAYLOC	# MAKE DELAYLOC AVAILABLE
## Page 1372
		TC	JOBWAKE

		TC	TASKOVER

TCSLEEP		GENADR	TCGETCAD -2
WAKECAD		GENADR	WAKER

## Page 1373
# GENTRAN, A BLOCK TRANSFER ROUTINE.
#
# WRITTEN BY D. EYLES
# MOD 1 BY KERNAN				UTILITYM REV 17 11/18/67
#
# MOD 2 BY SCHULENBERG (REMOVE RELINT) SKIPPER REV 4 2/28/68
#
#          THIS ROUTINE IS USEFULL FOR TRANSFERING N CONSECUTIVE ERASABLE OR FIXED QUANTITIES TO SOME OTHER N
# CONSECUTIVE ERASABLE LOCATIONS.  IF BOTH BLOCKS OF DATA ARE IN SWITCHABLE EBANKS, THEY MUST BE IN THE SAME ONE.
#
#          GENTRAN IS CALLABLE IN A JOB AS WELL AS A RUPT.  THE CALLING SEQUENCE IS:
#                                         I        CA    N-1              # OF QUANTITIES MINUS ONE.
#                                         I +1     TC    GENTRAN          IN FIXED-FIXED.
#                                         I +2     ADRES L                STARTING ADRES OF DATA TO BE MOVED.
#                                         I +3     ADRES M                STARTING ADRES OF DUPLICATION BLOCK.
#                                         I +4                            RETURNS HERE.
#
#          GENTRAN TAKES 25 MCT'S (300 MICROSECONDS) PER ITEM + 5 MCT'S (60 MICS) FOR ENTERING AND EXITING.
#          A, L AND ITEMP1 ARE NOT PRESERVED.

		BLOCK	02
		SETLOC	FFTAG4
		BANK

		EBANK=	ITEMP1

		COUNT*	$$/TRAN

GENTRAN		INHINT
		TS	ITEMP1		# SAVE N-1.
		INDEX	Q		# C(Q) = ADRES L.
		AD	0		# ADRES (L + N - 1).
		INDEX	A
		CA	0		# C(ABOVE).
		TS	L		# SAVE DATA.
		CA	ITEMP1
		INDEX	Q
		AD	1		# ADRES (M + N - 1).
		INDEX	A
		LXCH	0		# STUFF IT.
		CCS	ITEMP1		# LOOP UNTIL N-1 = 0.
		TCF	GENTRAN +1
		TCF	Q+2		# RETURN TO CALLER.

## Page 1374
# B5OFF   ZERO BIT 5 OF EXTVBACT, WHICH IS SET BY TESTXACT.
#          MAY BE USED AS NEEDED BY ANY EXTENDED VERB WHICH HAS DONE TESTXACT

		COUNT*	$$/EXTVB

B5OFF		CS	BIT5
		MASK	EXTVBACT
		TS	EXTVBACT
		TC	ENDOFJOB


