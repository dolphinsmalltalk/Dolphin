"Filed out from Dolphin Smalltalk"!

ExternalInteger subclass: #HRESULT
	instanceVariableNames: ''
	classVariableNames: 'Facilities FACILITY_NT_BIT Fail'
	poolDictionaries: 'FacilityCodes Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
HRESULT guid: (GUID fromString: '{87b4c5ae-026e-11d3-9fd7-00a0cc3e4a32}')!
HRESULT addClassConstant: 'FACILITY_NT_BIT' value: 16r10000000!
HRESULT comment: ''!
!HRESULT categoriesForClass!External-Data-Unstructured! !
!HRESULT methodsFor!

asSignedInteger
	"Answer the signed 32-bit <Integer> value of the receiver."

	^bytes sdwordAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 32-bit <Integer> value of the receiver."

	^bytes dwordAtOffset: 0!

displayOn: aStream
	"Append a textual representation of the receiver to aStream.
		(HRESULT fromInteger: Win32Errors.E_ABORT) displayString.
	"

	| buf len flags hModule code |
	buf := Utf16String newFixed: 255.
	flags := ##(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS).
	code := self asInteger.
	hModule := (code allMask: FACILITY_NT_BIT)
				ifTrue: 
					[flags := flags bitOr: FORMAT_MESSAGE_FROM_HMODULE.
					code := code bitAnd: ##(FACILITY_NT_BIT bitInvert).
					NTLibrary default asParameter asInteger].
	len := KernelLibrary default
				formatMessage: flags
				lpSource: hModule
				dwMessageId: code
				dwLanguageId: 0
				lpBuffer: buf
				nSize: buf size + 1
				arguments: 0.
	len == 0
		ifTrue: 
			[aStream
				nextPutAll: 'Unrecognised ';
				nextPutAll: (self isNtStatus ifTrue: ['NTSTATUS'] ifFalse: ['HRESULT']);
				nextPutAll: ' - ';
				nextPutAll: (self asUnsignedInteger printStringRadix: 16)]
		ifFalse: 
			["Windows appends trailing line delimiter, and breaks up the text into lines too, 
			so we remove them."
			(buf resize: len) lines do: [:each | aStream nextPutAll: each] separatedBy: [aStream space]]!

errorCode
	"Answer the Win32 status code extracted from the receiver's code."

	^self asUnsignedInteger maskClear: ##(8191 bitShift: 16)!

facility
	"Answer a string describing the facility of the receiver's HRESULT code."

	^Facilities at: self facilityCode ifAbsent: ['Unknown facility']!

facilityCode
	"Answer the Win32 facility code extracted from the receiver's code.

		#define HRESULT_FACILITY(hr)  (((hr) >> 16) & 0x1fff)"

	^(bytes wordAtOffset: 2) bitAnd: 16r1FFF!

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
	self asUnsignedInteger printOn: aStream base: 16 showRadix: false.
	aStream
		nextPutAll: ' - ';
		display: self;
		nextPut: $)!

severity
	"Answer the severity of the HRESULT (1 for errors, otherwise 0)."

	^(bytes at: 4) bitShift: -7!

statusCode
	"Answer the Win32 status code extracted from the receiver.

		#define HRESULT_CODE(hr)	((hr) & 0xFFFF)"

	^bytes wordAtOffset: 0!

succeeded
	"Answer whether the receiver represents the result of a successful operation
	(named for compatibility with the C/C++ SUCCEEDED macro)."

	^self failed not!

unsignedValue: anUnsigned
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes dwordAtOffset: 0 put: anUnsigned!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sdwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_value put: anInteger! !
!HRESULT categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
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
statusCode!accessing!public! !
succeeded!public!testing! !
unsignedValue:!accessing!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!HRESULT class methodsFor!

decodePrimitiveFailureCode: anInteger
	"Private - Answer an <integer> instantiated from the NTSTATUS/HRESULT code packed into a primitive failure code.
	The VM packs such codes into a SmallInteger primitive failure code by stripping out bit 27, which is not used."

	^((anInteger bitShift: 1) bitAnd: -16r10000000) bitOr: (anInteger bitAnd: 16r7FFFFFF)!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: SDWORDField new beOverride!

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
	FacilityCodes
		keysAndValuesDo: [:eachKey :eachValue | self registerFacility: eachValue name: eachKey].
	self registerFacility: FACILITY_NT_BIT >> 16 name: 'NTSTATUS'!

notImplemented
	"Answer the 'not implemented' HRESULT."

	^self fromInteger: E_NOTIMPL!

ntStatusCode: anInteger
	"Make and answer an HRESULT from the NT status code, anInteger."

	^self fromUnsignedInteger: (anInteger bitOr: FACILITY_NT_BIT)!

ok
	"Answer the 'OK' HRESULT."

	^self fromInteger: S_OK!

registerFacility: anInteger name: aString 
	"Register the specified facility code name for the specified facility code"

	Facilities at: anInteger put: aString!

severity: sev facility: fac code: code
	"Private - Make and answer an HRESULT from the arguments."

	^self fromUnsignedInteger: (
		((sev bitAnd: 1) bitShift: 31) bitOr:
			(((fac bitAnd: 16r1FFF) bitShift: 16) bitOr: (code bitAnd: 16rFFFF)))
!

status: code facility: fac
	"Private - Make and answer an HRESULT from the arguments."

	^self severity: SEVERITY_ERROR facility: fac code: code!

unregisterFacility: anInteger 
	"Unregister the specified facility code name for the specified facility code"

	Facilities removeKey: anInteger ifAbsent: []!

win32Error: anInteger 
	^self 
		severity: SEVERITY_ERROR
		facility: FACILITY_WIN32
		code: anInteger! !
!HRESULT class categoriesForMethods!
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
severity:facility:code:!instance creation!private! !
status:facility:!instance creation!private! !
unregisterFacility:!public! !
win32Error:!instance creation!public! !
!

