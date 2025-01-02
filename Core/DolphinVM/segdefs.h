/******************************************************************************

	File: segdefs.h

	Description:

	Dolphin Smalltalk VM segment definitions

******************************************************************************/
#pragma once

//#define _TEXTSEG1(name)  "_text$" #name
#define _TEXTSEG1(name)

#define BYTECODES_SEG _TEXTSEG1(1_Bytecodes)
#define PRIM_SEG	_TEXTSEG1(2_Primitives)	// Primitives
#define FPPRIM_SEG	_TEXTSEG1(5_PrimitivesFP)	// Floating point prims
#define LIPRIM_SEG	_TEXTSEG1(6_PrimitivesLI)	// Large Integer prims
#define INTERP_SEG _TEXTSEG1(4_Interpreter)	// Bytecode interpreter
#define MEM_SEG		_TEXTSEG1(3_ObjMem)	// Object Memory allocation, etc
#define RAREBC_SEG	_TEXTSEG1(7_RareBytecodes)
#define PROCESS_SEG	_TEXTSEG1(8_Process)	// Process subsystem
#define GC_SEG		_TEXTSEG1(A_GC)		// Collector/compactor
#define INTERPMISC_SEG	_TEXTSEG1(B_InterpMisc)	// Miscellaneous parts of the bytecode interpreter
#define FFI_SEG		_TEXTSEG1(C_FFI)			// Foreign function interface
#define FFIPRIM_SEG	_TEXTSEG1(D_PrimitivesFFI)	// FFI associated primitives

#define _TEXTSEG2(name)  "_text$" #name
//#define _TEXTSEG2(name)

#define XIF_SEG		_TEXTSEG2(XDolphinIF)		// DolphinIF (i.e. from compiler)

#define INIT_SEG	_TEXTSEG2(XInit)		// Initializing
#define TERM_SEG	_TEXTSEG2(XTerm)		// Terminating
#define DEBUG_SEG	_TEXTSEG2(XDebug)	// Debug support

//#define ATL_SEG		_TEXTSEG2(AXHOST)	// Use default code seg?
