///////////////////////////////////////////////////////////////////////////////
// Structure exception codes

#pragma once
#include "rc_vm.h"

// Similar to MAKE_SCODE, but makes a customer (non-MS) exception code
#define MAKE_CUST_SCODE(sev,fac,code) (DWORD((1<<29) | MAKE_SCODE(sev, fac, code)))

enum class VMExceptions : DWORD
{
	// Define the exception code to jump out of Smalltalk back to caller
	CallbackExit = MAKE_CUST_SCODE(SEVERITY_SUCCESS, FACILITY_NULL, 0),
	CallbackUnwind = MAKE_CUST_SCODE(SEVERITY_SUCCESS, FACILITY_NULL, 1),
	// This is handy for forcing crash dump output when one doesn't want an actual crash
	// (useful during debugging for recording machine state, for example).
	DumpStatus = MAKE_CUST_SCODE(SEVERITY_SUCCESS, FACILITY_NULL, 2),
	CrtFault = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_CRTFAULT),
	RecursiveDnu = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_RECURSIVEDNU),
	StackOverflow = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_STACKOVERFLOW),
	Exit = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_EXIT),
	OtFull = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_OTFULL),
	OtCommitFail = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_OTCOMMITFAIL),
	OtReserveFail = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_OTRESERVEFAIL),
	ZctReserveFail = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_ZCTRESERVEFAIL),
	ZctCommitFail = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, IDP_ZCTCOMMITFAIL),
	TerminateThread = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, 0x300)
};

constexpr DWORD SE_VMFIRST = static_cast<DWORD>(VMExceptions::CrtFault);
constexpr DWORD SE_VMLAST = static_cast<DWORD>(VMExceptions::ZctCommitFail);


