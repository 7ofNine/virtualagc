// This is originally implemented in agc_engine. But we don't need the whole engine
// here . We only took those parts out we actually need
// we also need DecodeDigitalDownLink and agc_utilities

#include "yaAGC/agc_engine.h"

int DownlinkListBuffer[MAX_DOWNLINK_LIST];
int DownlinkListCount = 0;
int DownlinkListExpected = 0;
int DownlinkListZero = -1;

ProcessDownlinkList_t *ProcessDownlinkList = NULL;

int CmOrLm = 0;	// Default is 0 (LM); other choice is 1 (CM)
char Sbuffer[SHEIGHT][SWIDTH + 1];
int Sheight = DEFAULT_SHEIGHT, Swidth = DEFAULT_SWIDTH;

int Portnum = 19697;

