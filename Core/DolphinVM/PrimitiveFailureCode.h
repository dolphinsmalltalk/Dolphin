#pragma once

#include <ntstatus.h>
#include <winerror.h>
#include "VMExcept.h"

typedef _Return_type_success_(return >= 0) int32_t NTSTATUS;

// Define a macro that packs an HRESULT. Then use these for the primitive failure codes. There is already image code to unpack
#define PFC_FROM_HRESULT(hr) ((SmallInteger)(((hr) & 0x7ffffff) << 1 | ((hr) & 0xf0000000) | 1))
#define PFC_FROM_NT(nt) PFC_FROM_HRESULT(HRESULT_FROM_NT(nt))
#define PFC_FROM_WIN32(err) PFC_FROM_HRESULT(__HRESULT_FROM_WIN32(err))

// We use HRESULT codes for the primitive failure codes as these have existing localised error messages. In some cases we are rather stretching
// the use of the error out of its domain, but the message is relevant.
// Some codes are commented out because they are not currently used.

enum class _PrimitiveFailureCode : SmallInteger 
{
	NoError = 0,
	//AccessDenied = PFC_FROM_WIN32(ERROR_ACCESS_DENIED),								// Access is denied.
	AccessViolation = PFC_FROM_WIN32(ERROR_NOACCESS),								// Invalid access to memory location.
	AlreadyComplete = PFC_FROM_NT(STATUS_ALREADY_COMPLETE),							// The requested action was completed by an earlier operation.
	//AlreadyInitialized = PFC_FROM_WIN32(ERROR_ALREADY_INITIALIZED),					// An attempt was made to perform an initialization operation when initialization has already been completed.
	AssertionFailure = PFC_FROM_NT(STATUS_ASSERTION_FAILURE),						// An assertion failure has occurred.
	//BadArguments = PFC_FROM_WIN32(ERROR_BAD_ARGUMENTS),								// One or more arguments are not correct.
	//BufferTooSmall = PFC_FROM_WIN32(ERROR_INSUFFICIENT_BUFFER),						// The data area passed to a system call is too small.
	ClassNotRegistered = PFC_FROM_HRESULT(REGDB_E_CLASSNOTREG),						// Class not registered
	DataTypeMismatch = PFC_FROM_WIN32(ERROR_DATATYPE_MISMATCH),						// Data supplied is of wrong type.
	EndOfFile = PFC_FROM_WIN32(ERROR_HANDLE_EOF),									// Reached the end of the file.
	Failed = PFC_FROM_HRESULT(E_FAIL),												// Unspecified error
	FloatDenormalOperand = PFC_FROM_NT(STATUS_FLOAT_DENORMAL_OPERAND),				// Floating-point denormal operand.
	FloatDivideByZero = PFC_FROM_NT(STATUS_FLOAT_DIVIDE_BY_ZERO),					// Floating-point division by zero.
	FloatInexactReult = PFC_FROM_NT(STATUS_FLOAT_INEXACT_RESULT),					// Floating-point inexact result.
	FloatInvalidOperation = PFC_FROM_NT(STATUS_FLOAT_INVALID_OPERATION),			// Floating-point invalid operation.
	FloatOverflow = PFC_FROM_NT(STATUS_FLOAT_OVERFLOW),								// Floating-point overflow.
	FloatStackCheck = PFC_FROM_NT(STATUS_FLOAT_STACK_CHECK),						// Floating-point stack check.
	FloatUnderflow = PFC_FROM_NT(STATUS_FLOAT_UNDERFLOW),							// Floating-point underflow.
	FloatMultipleFaults = PFC_FROM_NT(STATUS_FLOAT_MULTIPLE_FAULTS),
	FloatMultipleTraps = PFC_FROM_NT(STATUS_FLOAT_MULTIPLE_TRAPS),
	IllegalCharacter = PFC_FROM_NT(STATUS_ILLEGAL_CHARACTER),						// An illegal character was encountered. For a multi-byte character set this includes a lead byte without a succeeding trail byte. For the Unicode character set this includes the characters 0xFFFF and 0xFFFE.
	//IllegalMethodCall = PFC_FROM_HRESULT(E_ILLEGAL_METHOD_CALL),					// A method was called at an unexpected time.
	IllegalStateChange = PFC_FROM_HRESULT(E_ILLEGAL_STATE_CHANGE),					// An illegal state change was requested.
	IntegerDivideByZero = PFC_FROM_NT(STATUS_INTEGER_DIVIDE_BY_ZERO),				// Integer division by zero.
	IntegerOverflow = PFC_FROM_NT(STATUS_INTEGER_OVERFLOW),							// Integer overflow.
	IntegerOutOfRange = PFC_FROM_HRESULT(FWP_E_OUT_OF_BOUNDS),						// An integer value is outside the allowed range.
	InternalError = PFC_FROM_NT(STATUS_INTERNAL_ERROR),								// An internal error occurred.
	//InvalidData = PFC_FROM_WIN32(ERROR_INVALID_DATA),								// The data is invalid.
	//InvalidFlag = PFC_FROM_WIN32(ERROR_INVALID_FLAG_NUMBER),						// The flag passed is not correct.
	//InvalidFunction = PFC_FROM_WIN32(ERROR_INVALID_FUNCTION),						// Incorrect function.
	//InvalidHandle = PFC_FROM_WIN32(ERROR_INVALID_HANDLE),							// The handle is invalid.
	InvalidParameter = PFC_FROM_NT(STATUS_INVALID_PARAMETER),						// An invalid parameter was passed to a service or function
	InvalidParameter1 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_1),					// An invalid parameter was passed to a service or function as the first argument.
	InvalidParameter2 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_2),					// An invalid parameter was passed to a service or function as the second argument.
	InvalidParameter3 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_3),					// An invalid parameter was passed to a service or function as the third argument.
	InvalidParameter4 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_4),					// An invalid parameter was passed to a service or function as the fourth argument.
	InvalidParameter5 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_5),					// An invalid parameter was passed to a service or function as the fifth argument.
	InvalidParameter6 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_6),					// An invalid parameter was passed to a service or function as the sixth argument.
	InvalidParameter7 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_7),					// An invalid parameter was passed to a service or function as the seventh argument.
	InvalidParameter8 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_8),					// An invalid parameter was passed to a service or function as the eigth argument.
	InvalidParameter9 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_9),					// An invalid parameter was passed to a service or function as the nineth argument.
	InvalidParameter10 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_10),					// An invalid parameter was passed to a service or function as the tenth argument.
	InvalidParameter11 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_11),					// An invalid parameter was passed to a service or function as the eleventh argument.
	InvalidParameter12 = PFC_FROM_NT(STATUS_INVALID_PARAMETER_12),					// An invalid parameter was passed to a service or function as the twelfth argument.
	InvalidParameterMix = PFC_FROM_NT(STATUS_INVALID_PARAMETER_MIX),				// An invalid combination of parameters was specified.
	InvalidPointer = PFC_FROM_HRESULT(E_POINTER),									// Invalid pointer
	//InvalidUnwindTarget = PFC_FROM_WIN32(ERROR_INVALID_UNWIND_TARGET),				// An invalid unwind target was encountered during an unwind operation.
	InvalidVariant = PFC_FROM_NT(STATUS_INVALID_VARIANT),							// The supplied variant structure contains invalid data.
	NoMemory = PFC_FROM_WIN32(ERROR_NOT_ENOUGH_MEMORY),								// Not enough memory resources are available to process this command.
	NonInstantiable = PFC_FROM_WIN32(ERROR_DS_CLASS_MUST_BE_CONCRETE),				// The class of the object must be structural; you cannot instantiate an abstract class.
	//NothingToTerminate = PFC_FROM_WIN32(ERROR_NOTHING_TO_TERMINATE),				// A process being terminated has no threads to terminate.
	ObjectTypeMismatch = PFC_FROM_NT(STATUS_OBJECT_TYPE_MISMATCH),					// {Wrong Type} There is a mismatch between the type of object required by the requested operation and the type of object that is specified in the request.
	OutOfBounds = PFC_FROM_HRESULT(E_BOUNDS),										// The operation attempted to access data outside the valid range
	NoCallbackActive = PFC_FROM_WIN32(ERROR_NO_CALLBACK_ACTIVE),					// A callback return system service cannot be executed when no callback is active.
	//NotFound = PFC_FROM_NT(STATUS_NOT_FOUND),										// The object was not found.
	NotImplemented = PFC_FROM_HRESULT(E_NOTIMPL),									// Not implemented
	NotSupported = PFC_FROM_NT(STATUS_NOT_SUPPORTED),								// The request is not supported.
	Pending = PFC_FROM_HRESULT(E_PENDING),											// The data necessary to complete this operation is not yet available.
	ProcNotFound = PFC_FROM_WIN32(ERROR_PROC_NOT_FOUND),							// The specified procedure could not be found.
	Retry = PFC_FROM_NT(STATUS_RETRY),												// The request needs to be retried.
	//SignalRefused = PFC_FROM_WIN32(ERROR_SIGNAL_REFUSED),							// The recipient process has refused the signal.
	//SignalPending = PFC_FROM_WIN32(ERROR_SIGNAL_PENDING),							// A signal is already pending.
	ThreadIsTerminating = PFC_FROM_NT(STATUS_THREAD_IS_TERMINATING),				// An attempt was made to access a thread that has begun termination.
	Timeout = PFC_FROM_WIN32(ERROR_TIMEOUT),										// This operation returned because the timeout period expired.
	Unsuccessful = PFC_FROM_NT(STATUS_UNSUCCESSFUL),								// {Operation Failed} The requested operation was unsuccessful.
	UnsupportedType = PFC_FROM_WIN32(ERROR_UNSUPPORTED_TYPE),						// Data of this type is not supported.
	UnmappableCharacter = PFC_FROM_NT(STATUS_UNMAPPABLE_CHARACTER),					// No mapping for the Unicode character exists in the target multi-byte code page.
	UndefinedCharacter = PFC_FROM_NT(STATUS_UNDEFINED_CHARACTER),					// The Unicode character is not defined in the Unicode character set installed on the system.
	WrongNumberOfArgs = PFC_FROM_HRESULT(TYPE_E_OUTOFBOUNDS),						// Invalid number of arguments
	DebugBreakpoint = PFC_FROM_NT(STATUS_BREAKPOINT),								// A breakpoint has been reached.
	DebugStep = PFC_FROM_NT(STATUS_SINGLE_STEP),									// A single step or trace operation has just been completed.
	CrtFault = PFC_FROM_HRESULT(static_cast<DWORD>(VMExceptions::CrtFault)),
	PrivilegedInstruction = PFC_FROM_NT(STATUS_PRIVILEGED_INSTRUCTION),				// Privileged instruction
	IllegalInstruction = PFC_FROM_NT(STATUS_ILLEGAL_INSTRUCTION),					// An attempt was made to execute an illegal instruction.
	DatatypeMisalignment = PFC_FROM_NT(STATUS_DATATYPE_MISALIGNMENT),				// A datatype misalignment was detected in a load or store instruction
	ArrayBoundsExceeded = PFC_FROM_NT(STATUS_ARRAY_BOUNDS_EXCEEDED),				// Array bounds exceeded
	InPageError = PFC_FROM_NT(STATUS_IN_PAGE_ERROR),								// The instruction at 0x%p referenced memory at 0x%p. The required data was not placed into memory because of an I/O error status of 0x%x.
	NonContinuable = PFC_FROM_NT(STATUS_NONCONTINUABLE_EXCEPTION),					// Windows cannot continue from this exception.
	StackOverflow = PFC_FROM_WIN32(ERROR_STACK_OVERFLOW),							// Recursion too deep; the stack overflowed.
	InvalidDisposition = PFC_FROM_NT(STATUS_INVALID_DISPOSITION),					// An invalid exception disposition was returned by an exception handler.
	GuardPageViolation = PFC_FROM_NT(STATUS_GUARD_PAGE_VIOLATION),					// A page of memory that marks the end of a data structure, such as a stack or an array, has been accessed.
	InvalidHandle = PFC_FROM_NT(STATUS_INVALID_HANDLE),								// An invalid HANDLE was specified.
	PossibleDeadlock = PFC_FROM_NT(STATUS_POSSIBLE_DEADLOCK)						// Possible deadlock condition.
};
