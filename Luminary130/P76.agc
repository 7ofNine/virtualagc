### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P76.agc
## Purpose:	A section of the reconstructed source code for Luminary 130.
##		This was the original program released for the Apollo 13 LM,
##		although several more revisions would follow. It has been
##		reconstructed from a listing of Luminary 131, from which it
##		differs on only two lines in P70-P71. The difference is
##		described in detail in Luminary memo #129, which was used
##		to perform the reconstruction. This file is intended to be a
##		faithful reconstruction, except that the code format has been
##		changed to conform to the requirements of the yaYUL assembler
##		rather than the original YUL assembler.
## Reference:	pp. 711-713
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo
## Mod history:	05/24/03 RSB.	Began transcribing.
##		2017-01-06 RSB	Page numbers now agree with those on the
##				original harcopy, as opposed to the PDF page
##				numbers in 1701.pdf.
##		2017-02-24 RSB	Proofed comment text using octopus/ProoferComments.
##		2018-09-04 MAS	Copied from Luminary 131 for Luminary 130.

## Page 711
# 1)	PROGRAM NAME - TARGET DELTA V PROGRAM (P76).
# 2)	FUNCTIONAL DESCRIPTION - UPON ENTRY BY ASTRONAUT ACTION, P76 FLASHES DSKY REQUESTS TO THE ASTRONAUT
#	TO PROVIDE VIA DSKY (1) THE DELTA V TO BE APPLIED TO THE OTHER VEHICLE STATE VECTOR AND (2) THE
#	TIME (TIG) AT WHICH THE OTHER VEHICLE VELOCITY WAS CHANGED BY EXECUTION OF A THRUSTING MANEUVER. THE
#	OTHER VEHICLE STATE VECTOR IS INTEGRATED TO TIG AND UPDATED BY THE ADDITION OF DELTA V (DELTA V HAVING
#	BEEN TRANSFORMED FROM LV TO REF COSYS).  USING INTEGRVS, THE PROGRAM THEN INTEGRATES THE OTHER
#	VEHICLE STATE VECTOR TO THE STATE VECTOR OF THIS VEHICLE, THUS INSURING THAT THE W-MATRIX AND BOTH VEHICLE
#	STATES CORRESPOND TO THE SAME TIME.
# 3)	ERASABLE INITIALIZATION REQUIRED - NONE.
# 4)	CALLING SEQUENCES AND EXIT MODES - CALLED BY ASTRONAUT REQUEST THRU DSKY V 37 E 76E.
#	EXITS BY TCF ENDOFJOB.
# 5)	OUTPUT - OTHER VEHICLE STATE VECTOR INTEGRATED TO TIG AND INCREMENTED BY DELTA V IN REF COSYS.
#	THE PUSHLIST CONTAINS THE MATRIX BY WHICH THE INPUT DELTA V MUST BE POST-MULTIPLIED TO CONVERT FROM LV
#	TO REF COSYS.
# 6)	DEBRIS - OTHER VEHICLE STATE VECTOR.
# 7)	SUBROUTINES CALLED - BANKCALL, GOXDSPF, CSMPREC (OR LEMPREC), ATOPCSM (OR ATOPLEM), INTSTALL, INTWAKE, PHASCHNG
#	INTPRET, INTEGRVS, AND MINIRECT.
# 8)	FLAG USE - MOONFLAG, CMOONFLAG, INTYPFLG, RASFLAG, AND MARKCTR.

		BANK	30
		SETLOC	P76LOC
		BANK

		COUNT*	$$/P76

		EBANK=	TIG

P76		TC	UPFLAG
		ADRES	TRACKFLG

		TC	INTPRET
		VLOAD
			DELVLVC
		STORE	DELVOV
		EXIT

		CAF	V06N84 +1	# FLASH VERB 06 NOUN 33, DISPLAY LAST TIG,
		TC	BANKCALL	# AND WAIT FOR KEYBOARD ACTION.
		CADR	GOFLASH
		TCF	ENDP76
		TC	+2		# PROCEED
		TC	-5		# STORE DATA AND REPEAT FLASHING
		CAF	V06N84		# FLASH LAST DELTA V,
		TC	BANKCALL	# AND WAIT FOR KEYBOARD ACTION.
		CADR	GOFLASH
		TCF	ENDP76
		TC	+2
		TC	-5
		TC	INTPRET		# RETURN TO INTERPRETIVE CODE
## Page 712
		DLOAD	SET
			TIG
			NODOFLAG
		STCALL	TDEC1		# SET TDEC1=TIG FOR ORBITAL INTEGRATION
			OTHPREC
COMPMAT		VLOAD	UNIT
			RATT
		VCOMP			# U(-R)
		STORE	24D		# U(-R) TO 24D
		VXV	UNIT		# U(-R) X V = U(V X R)
			VATT
		STORE	18D
		VXV	UNIT		# U(V X R) X U(-R) = U((R X V) X R)
			24D
		STOVL	12D
			DELVOV
		VXM	VSL1		# V(MPAC)=DELTA V IN REFCOSYS
			12D
		VAD
			VATT
		STORE	6		# V(PD6)=VATT + DELTA V
		CALL			# PREVENT WOULD-BE USER OF ORBITAL
			INTSTALL	# INTEG FROM INTERFERING WITH UPDATING
		CALL
			P76SUB1
		VLOAD	VSR*
			6
			0,2
		STOVL	VCV
			RATT
		VSR*
			0,2
		STODL	RCV
			TIG
		STORE	TET
		CLEAR	DLOAD
			INTYPFLG
			TETTHIS
INTOTHIS	STCALL	TDEC1
			INTEGRVS
		CALL
			INTSTALL
		VLOAD
			RATT1
		STORE	RRECT
		STODL	RCV
			TAT
		STOVL	TET
			VATT1
		CALL
## Page 713
			MINIRECT
		EXIT
		TC	PHASCHNG
		OCT	04024

		TC	INTPRET
		SET	CALL
			REINTFLG
			ATOPOTH
		CALL
			INTWAKE0
OUT		CLEAR	EXIT		# ALLOW V37.  NO NEED TO CLEAR NODOFLAG AT
			NODOFLAG	# ENDP76 SINCE FLAG NOT SET WHEN DISPLAY
					# RESPONSES TRANSFER THERE FROM P76+.
ENDP76		CAF	ZERO
		TS	MARKCTR		# CLEAR RR TRACKING MARK COUNTER
		TCF	GOTOPOOH

V06N84		NV	0684
		NV	0633
P76SUB1		AXT,2	SET
			2
			MOONFLAG	# SET MEANS MOON IS SPHERE OF INFLUENCE.
		BON	AXT,2
			CMOONFLG	# SET MEANS PERM CM STATE IN LUNAR SPHERE.
			QPRET
			0
		CLEAR	RVQ
			MOONFLAG



