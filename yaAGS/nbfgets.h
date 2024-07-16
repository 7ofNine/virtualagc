#pragma once
// AGC etc. 
// should actually be used for common library getween ags and AGc
// Temporary for defining the interface to nbfgets. Used for debugging but only used for AGS
// debugging is not active for AGC

//---------------------------------------------------------------------------
// Function prototypes.

char *nbfgets (char *Buffer, int Length);
void nbfgets_ready (const char *);