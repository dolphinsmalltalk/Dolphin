/******************************************************************************

	File: VMPointers.h

	Description:

	Notes:	

	The VMRegistry is stored in a static data area for efficiency reasons - the 
	members can be accessed with a single instruction. It also means that this 
	structure cannot move, and does not need to be re-established. By storing 
	these references in space managed by the ObjectMemory (i.e. inside a real
	object) we avoid reference and GC compaction problems - i.e. all the 
	VM references are automatically visible to the ObjectMemory, and can be 
	shared with Smalltalk code too. The Smalltalk code can freely write to this 
	Array if it wants to update/replace one of the VM referenced objects.

	N.B. THIS MUST BE KEPT IN SYNC WITH ISTASM.INC (use H2INC.EXE) AND THE 
	SMALLTALK CODE IF THE SIZE CHANGES.

******************************************************************************/
#pragma once

#include "bytecdes.h"

#if defined(VM)

#include "STString.h"
#include "STArray.h"

namespace ST
{
	class Symbol;
	class Semaphore;
	class ProcessorScheduler;
	class Array;
	class BlockClosure;
	class ExternalHandle;
	class Behavior;
	class MemoryManager;
	class VariableBinding;
}
typedef TOTE<ST::Symbol> SymbolOTE;
typedef TOTE<ST::Semaphore> SemaphoreOTE;
typedef TOTE<ST::ProcessorScheduler> SchedulerOTE;
typedef TOTE<ST::BlockClosure> BlockOTE;
typedef TOTE<ST::ExternalHandle> HandleOTE;
typedef TOTE<ST::Behavior> BehaviorOTE;
typedef TOTE<ST::MemoryManager> MemManOTE;
typedef TOTE<ST::VariableBinding> VariableBindingOTE;
#else
typedef void OTE;
typedef OTE Utf8StringOTE;
typedef OTE SymbolOTE;
typedef OTE SemaphoreOTE;
typedef OTE SchedulerOTE;
typedef OTE ArrayOTE;
typedef OTE BlockOTE;
typedef OTE HandleOTE;
typedef OTE BehaviorOTE;
typedef OTE MemManOTE;
typedef OTE VariableBindingOTE;
typedef OTE ArrayOTE;
#endif

// Should ideally be sized to a multiple of 16 bytes, accounting for object header size (currently 0)
// Definition in istasm.inc must match
struct VMPointers //: public Object
{
	union
	{
		struct
		{
			// 1.. Special constant objects used by the VM - DO NOT CHANGE THE ORDER OF THESE!!!!!!
			POTE Nil;											// 1
			POTE True;											// 2
			POTE False;											// 3
			Utf8StringOTE* EmptyString;							// 4
			Utf8StringOTE* LineDelimString;						// 5
			ArrayOTE* EmptyArray;								// 6
			BlockOTE* EmptyBlock;								// 7
			BlockOTE* EmptyDebugBlock;							// 8

			POTE SmalltalkDictionary;							// 9	- Pointer to Smalltalk variable (a variable binding)
			SchedulerOTE* Scheduler;							// 10	- Pointer to Processor object

			// 11..16
			// Selectors used by the Dolphin VM
			SymbolOTE* DoesNotUnderstandSelector;				// 11
			SymbolOTE* MustBeBooleanSelector;					// 12
			SymbolOTE* CannotReturnSelector;					// 13
			SymbolOTE* vmiSelector;								// 14
			SymbolOTE* InternSelector;							// 15

			// 16..47 Array of special selectors

			SymbolOTE* specialSelectors[NumSpecialSelectors];	// 16..47

			// 48..50 Other selectors
			SymbolOTE* callbackPerformSymbol;					// 48
			SymbolOTE* callbackPerformWithSymbol;				// 49
			SymbolOTE* callbackPerformWithWithSymbol;			// 50
			SymbolOTE* callbackPerformWithWithWithSymbol;		// 51
			SymbolOTE* callbackPerformWithArgumentsSymbol;		// 52
			Oop _unused53;										// 53
			SymbolOTE* windowCreatedSelector;					// 54
			SymbolOTE* instVarAtPutSymbol;						// 55

			// 56..65
			SymbolOTE* lookupKeySymbol;							// 56
			SymbolOTE* wndProcSelector;							// 57

			SymbolOTE* asNumberSymbol;							// 58
			// TODO - Remove these when compiler no longer uses them.
			SymbolOTE* fullBindingForSelector;					// 59
			SymbolOTE* allInstVarNamesSelector;					// 60
			SymbolOTE* understandsArithmeticSelector;				// 61
			SymbolOTE* canUnderstandSelector;						// 62
			SymbolOTE* negativeSelector;							// 63
			SymbolOTE* evaluateExpressionSelector;				// 64
			SymbolOTE* newBindingRefSelector;					// 65

			// 66..85
			SymbolOTE* compilerNotificationCallback;			// 66
			SymbolOTE* namespaceAnnotationSelector;				// 67

			SymbolOTE* genericCallbackSelector;					// 68
			SymbolOTE* setScopeSelector;						// 69
			SymbolOTE* virtualCallbackSelector;					// 70
			SymbolOTE* exSpecialSelectors[NumExSpecialSends];	// 71,72,73
			Oop _unused74to80[7];								// 74, 75,76,77,78,79,80

			// Classes required by Dolphin VM
			// 81..90
			BehaviorOTE* ClassMetaclass;						// 81
			BehaviorOTE* ClassCharacter;						// 82
			BehaviorOTE* ClassArray;							// 83
			BehaviorOTE* ClassAnsiString;						// 84
			BehaviorOTE* ClassSymbol;							// 85
			BehaviorOTE* ClassSmallInteger;						// 86
			BehaviorOTE* ClassProcess;							// 87
			BehaviorOTE* ClassCompiledMethod;					// 88
			BehaviorOTE* ClassContext;							// 89
			BehaviorOTE* ClassBlockClosure;						// 90

			// 91..100
			BehaviorOTE* ClassMessage;							// 91
			BehaviorOTE* ClassByteArray;						// 92
			BehaviorOTE* ClassUtf16String;						// 93 - These two previously LPI and LNI
			BehaviorOTE* ClassCompiledExpression;				// 94
			BehaviorOTE* ClassExternalMethod;					// 95
			BehaviorOTE* ClassFloat;							// 96
			BehaviorOTE* ClassUndefinedObject;					// 97
			BehaviorOTE* ClassVariableBinding;					// 98 - Only required for debugging and crash dump

			BehaviorOTE* ClassSemaphore;						// 99
			BehaviorOTE* ClassExternalAddress;					// 100

			// 101..110
			BehaviorOTE* ClassExternalHandle;					// 101
			POTE Dispatcher;									// 102 - Actually this doesn't need to be a class at all
			BehaviorOTE* ClassLPVOID;							// 103
			BehaviorOTE* ClassUtf8String;						// 104
			BehaviorOTE* ClassBindingReference;					// 105
			BehaviorOTE* ArrayBinding;							// 106
			BehaviorOTE* ClassLargeInteger;						// 107 - 2's complement Large Integers (32 or more bits)
			BehaviorOTE* ClassVARIANT;							// 107
			BehaviorOTE* ClassBSTR;								// 108
			BehaviorOTE* ClassDATE;								// 110

			// 111..120
			// POTEs of misc. objects ref'd by VM
			Oop Corpse;											// 111
			SemaphoreOTE* InputSemaphore;						// 112
			SemaphoreOTE* FinalizeSemaphore;					// 113
			SemaphoreOTE* BereavementSemaphore;					// 114
			BlockOTE* MarkedBlock;								// 115
			ArrayOTE* SignalQueue;								// 116
			ArrayOTE* InterruptQueue;							// 117
			ArrayOTE* FinalizeQueue;							// 118
			ArrayOTE* BereavementQueue;							// 119
			BehaviorOTE* ClassGUID;								// 120

			// 121..126
			HandleOTE* KernelHandle;							// 121 - Kernel32 handle
			HandleOTE* VMHandle;								// 122 - Handle of VM DLL
			HandleOTE* DolphinHandle;							// 123 - Handle of Dolphin application instance
			BehaviorOTE* ClassIUnknown;							// 124
			HandleOTE* WakeupEvent;								// 125 - Handle of Win32 Event object
			ArrayOTE* VMReferences;								// 126 - Created after loading bootstrap image (i.e. not in the bootstrap image)

			// 127..192

			HandleOTE* MsgWndHandle;							// 127
			BehaviorOTE* ClassIDispatch;						// 128
			Oop ImageVersionMajor;								// 129 - MS word of image version
			Oop	ImageVersionMinor;								// 130 - LS word of image version
			Oop InterruptHotKey;								// 131 - HOTKEYF_XXX|VK_XXX value to be used for interrupt key, e.g. Ctrl+Break = VK_CANCEL
			HandleOTE* CRTHandle;								// 132 - Handle of CRT library linked with the VM.
			MemManOTE* MemoryManager;							// 133 - Current memory manager object

			BehaviorOTE* ClassUInt8;							// 134
			BehaviorOTE* ClassInt8;								// 135
			BehaviorOTE* ClassUInt16;							// 136
			BehaviorOTE* ClassInt16;							// 137
			BehaviorOTE* ClassUInt32;							// 138
			BehaviorOTE* ClassInt32;							// 139
			BehaviorOTE* ClassFLOAT;							// 140
			BehaviorOTE* ClassDOUBLE;							// 141
			BehaviorOTE* ClassVARBOOL;							// 142
			BehaviorOTE* ClassCURRENCY;							// 143
			BehaviorOTE* ClassDECIMAL;							// 144
			BehaviorOTE* ClassLPBSTR;							// 145
			BehaviorOTE* ClassUInt64;							// 146
			BehaviorOTE* ClassInt64;							// 147
			BehaviorOTE* ClassUIntPtr;							// 148
			BehaviorOTE* ClassIntPtr;							// 149

			SemaphoreOTE* TimingSemaphore;						// 150

			BehaviorOTE* ClassMethodAnnotations;				// 151
			POTE SmalltalkNamespaceAnnotation;					// 152
			POTE _unused153to192[40];							// 153-192
		};
		Oop pointers[192];
	};
};

// Globally accessible pointers, but please don't write to them!
extern /*const*/ VMPointers Pointers;
extern VMPointers _Pointers;

#if defined (VM)
template <class T> inline bool isNil(const TOTE<T>* ote)
{
	return ote == reinterpret_cast<const TOTE<T>*>(Pointers.Nil);
}

template <class T> inline bool isBehavior(const TOTE<T>* ote)
{
	return isMetaclass(ote) || isMetaclass(ote->m_oteClass);
}
template <class T> inline bool isMetaclass(const TOTE<T>* ote)
{
	return ote->m_oteClass == Pointers.ClassMetaclass;
}

template <class T> inline void NilOutPointer(TOTE<T>*& ote)
{
	ote->countDown();
	ote = reinterpret_cast<TOTE<T>*>(Pointers.Nil);
}
#endif
