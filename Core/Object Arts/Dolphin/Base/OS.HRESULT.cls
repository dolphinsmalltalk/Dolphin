"Filed out from Dolphin Smalltalk"!

External.AbstractInt32
	subclass: #'OS.HRESULT'
	instanceVariableNames: ''
	classVariableNames: 'Facilities Fail'
	imports: #(#{OS.KernelLibrary private})
	classInstanceVariableNames: ''
	classConstants: {
			'_HRESULT_Size' -> 16r4.
			'CLASS_E_CLASSNOTAVAILABLE' -> -16r7FFBFEEF.
			'CLASS_E_NOAGGREGATION' -> -16r7FFBFEF0.
			'CLASS_E_NOTLICENSED' -> -16r7FFBFEEE.
			'E_ABORT' -> -16r7FFFBFFC.
			'E_ACCESSDENIED' -> -16r7FF8FFFB.
			'E_FAIL' -> -16r7FFFBFFB.
			'E_HANDLE' -> -16r7FF8FFFA.
			'E_INVALIDARG' -> -16r7FF8FFA9.
			'E_NOINTERFACE' -> -16r7FFFBFFE.
			'E_NOTIMPL' -> -16r7FFFBFFF.
			'E_OUTOFMEMORY' -> -16r7FF8FFF2.
			'E_PENDING' -> -16r7FFFFFF6.
			'E_POINTER' -> -16r7FFFBFFD.
			'E_UNEXPECTED' -> -16r7FFF0001.
			'FACILITY_CERT' -> 16rB.
			'FACILITY_CONTROL' -> 16rA.
			'FACILITY_DIRECTDRAW' -> 16r876.
			'FACILITY_DISPATCH' -> 16r2.
			'FACILITY_ITF' -> 16r4.
			'FACILITY_NT_BIT' -> 16r10000000.
			'FACILITY_NULL' -> 16r0.
			'FACILITY_RPC' -> 16r1.
			'FACILITY_SSPI' -> 16r9.
			'FACILITY_STORAGE' -> 16r3.
			'FACILITY_WIN32' -> 16r7.
			'FACILITY_WINDOWS' -> 16r8.
			'S_FALSE' -> 16r1.
			'S_OK' -> 16r0.
			'SEVERITY_ERROR' -> 16r1.
			'SEVERITY_SUCCESS' -> 16r0.
			'STATUS_INVALID_PARAMETER' -> -16r3FFFFFF3.
			'STATUS_OBJECT_TYPE_MISMATCH' -> -16r3FFFFFDC.
			'STATUS_TIMER_RESOLUTION_NOT_SET' -> -16r3FFFFDBB.
			'WCODE_HRESULT_FIRST' -> -16r7FFBFE00.
			'WCODE_HRESULT_LAST' -> -16r7FFB0001
		}!

OS.HRESULT guid: (Core.GUID fromString: '{87b4c5ae-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.HRESULT comment: ''!

!OS.HRESULT categoriesForClass!External-Data-Unstructured! !

!OS.HRESULT methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	"Implementation note: We have to reduce the provided Locale to its primary because the system message text is only available in a limited range of languages, and for most locale's the FormatMessage from system operation will fail."

	| buf len flags hModule code lcid isNt |
	buf := Utf16String newFixed: 255.
	flags := ##(FORMAT_MESSAGE_FROM_SYSTEM bitOr: FORMAT_MESSAGE_IGNORE_INSERTS).
	code := self asInteger.
	isNt := code allMask: FACILITY_NT_BIT.
	hModule := isNt
				ifTrue: 
					[flags := flags bitOr: FORMAT_MESSAGE_FROM_HMODULE.
					code := code bitAnd: ##(FACILITY_NT_BIT bitInvert).
					(Kernel32 getModuleHandle: 'ntdll') asInteger].
	lcid := aPuttableStream locale primary lcid.
	
	[len := Kernel32
				formatMessage: flags
				lpSource: hModule
				dwMessageId: code
				dwLanguageId: lcid
				lpBuffer: buf
				nSize: buf size + 1
				arguments: 0.
	len == 0 and: [lcid ~~ 0]]
			whileTrue: 
				["If it fails for the primary of the supplied Locale, try with default"
				lcid := 0].
	len == 0
		ifTrue: 
			[aPuttableStream
				nextPutAll: 'Unrecognised ';
				nextPutAll: (isNt ifTrue: ['NTSTATUS'] ifFalse: ['HRESULT']);
				nextPutAll: ' - 0x'.
			self asUnsignedInteger printOn: aPuttableStream base: 16]
		ifFalse: 
			["Windows appends trailing line delimiter, and breaks up the text into lines too, 
			so we remove them."
			((buf resize: len) lines reject: [:each | each isEmpty])
				do: [:each | aPuttableStream nextPutAll: each]
				separatedBy: [aPuttableStream space]]!

errorCode
	"Answer the Win32 status code extracted from the receiver's code."

	^self asUnsignedInteger maskClear: ##(8191 bitShift: 16)!

facility
	"Answer a string describing the facility of the receiver's HRESULT code."

	^Facilities at: self facilityCode ifAbsent: 'Unknown facility'!

facilityCode
	"Answer the Win32 facility code extracted from the receiver's code.

		#define HRESULT_FACILITY(hr)  (((hr) >> 16) & 0x1fff)"

	^(bytes uint16AtOffset: 2) bitAnd: 16r1FFF!

failed
	"Answer whether the receiver represents the result of a failed operation
	(named for compatibility with the C/C++ FAILED macro)."

	^(bytes at: 4) anyMask: 16r80!

isNtStatus
	"Answer whether the receiver represents an NTSTATUS code."

	"Equivalent to:
		^self asUnsignedInteger allMask: FACILITY_NT_BIT"

	^(bytes at: 4) allMask: 16r10!

isSeverityError
	"Answer whether the receiver is a SEVERITY_ERROR code."

	^self severity == SEVERITY_ERROR!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

printOn: aStream
	"Append a debug textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPutAll: '(0x'.
	self asUnsignedInteger printOn: aStream base: 16.
	aStream
		nextPutAll: ' - ';
		display: self;
		nextPut: $)!

severity
	"Answer the severity of the HRESULT (1 for errors, otherwise 0)."

	^(bytes at: 4) bitShift: -7!

signal
	"Signal the occurrence of the exceptional condition that this HRESULT code describes."

	^HRESULTError signalHRESULT: self!

statusCode
	"Answer the Win32 status code extracted from the receiver.

		#define HRESULT_CODE(hr)	((hr) & 0xFFFF)"

	^bytes uint16AtOffset: 0!

succeeded
	"Answer whether the receiver represents the result of a successful operation
	(named for compatibility with the C/C++ SUCCEEDED macro)."

	^self failed not!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes int32AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_value put: anInteger! !

!OS.HRESULT categoriesForMethods!
displayOn:!displaying!public! !
errorCode!accessing!public! !
facility!accessing!public! !
facilityCode!accessing!public! !
failed!public!testing! !
isNtStatus!public!testing! !
isSeverityError!public!testing! !
isSigned!public!testing! !
printOn:!displaying!public! !
severity!accessing!public! !
signal!public!raising! !
statusCode!accessing!public! !
succeeded!public!testing! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!OS.HRESULT class methodsFor!

decodePrimitiveFailureCode: anInteger
	"Private - Answer an <integer> instantiated from the NTSTATUS/HRESULT code packed into a primitive failure code.
	The VM packs such codes into a SmallInteger primitive failure code by stripping out bit 27, which is not used."

	^((anInteger bitShift: 1) bitAnd: -16r10000000) bitOr: (anInteger bitAnd: 16r7FFFFFF)!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: Int32Field new beOverride!

fail
	"Answer the generic failure HRESULT."

	^Fail!

fromPrimitiveFailureCode: anInteger
	"Answer a new instance of the receiver representing the packed-HRESULT primitive failure code, anInteger.
	Packed HRESULT codes are created by the VM to pack a 32-bit HRESULT into a 31-bit SmallInteger by dropping an unused bit (27)."

	^self new value: (self decodePrimitiveFailureCode: anInteger)!

fromUnsignedInteger: anUnsignedInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new unsignedValue: anUnsignedInteger!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Fail := self fromInteger: E_FAIL.
	Facilities := LookupTable new.
	self bindingsDo: [:each | (each key beginsWith: 'FACILITY_') ifTrue: [self registerFacility: each value name: each key]].
	self registerFacility: FACILITY_NT_BIT >> 16 name: 'NTSTATUS'!

notImplemented
	"Answer the 'not implemented' HRESULT."

	^self fromInteger: E_NOTIMPL!

ntStatusCode: anInteger
	"Make and answer an HRESULT from the NT status code, anInteger."

	^self fromUnsignedInteger: (anInteger bitOr: FACILITY_NT_BIT)!

ok
	"Answer the 'OK' HRESULT."

	^self new!

registerFacility: anInteger name: aString 
	"Register the specified facility code name for the specified facility code"

	Facilities at: anInteger put: aString!

severity: sev facility: fac code: code
	"Make and answer an HRESULT from the arguments."

	^self fromUnsignedInteger: (
		((sev bitAnd: 1) bitShift: 31) bitOr:
			(((fac bitAnd: 16r1FFF) bitShift: 16) bitOr: (code bitAnd: 16rFFFF)))
!

status: code facility: fac
	"Make and answer an HRESULT from the arguments."

	^self severity: SEVERITY_ERROR facility: fac code: code!

unregisterFacility: anInteger
	"Unregister the specified facility code name for the specified facility code"

	Facilities removeKey: anInteger ifAbsent: nil!

win32Error: anInteger
	^self status: anInteger facility: FACILITY_WIN32! !

!OS.HRESULT class categoriesForMethods!
decodePrimitiveFailureCode:!private!utilities! !
defineFields!public!template definition! !
fail!constants!instance creation!public! !
fromPrimitiveFailureCode:!instance creation!public! !
fromUnsignedInteger:!instance creation!public! !
initialize!development!initializing!private! !
notImplemented!constants!instance creation!public! !
ntStatusCode:!instance creation!public! !
ok!constants!instance creation!public! !
registerFacility:name:!public! !
severity:facility:code:!instance creation!public! !
status:facility:!instance creation!public! !
unregisterFacility:!public! !
win32Error:!instance creation!public! !
!

