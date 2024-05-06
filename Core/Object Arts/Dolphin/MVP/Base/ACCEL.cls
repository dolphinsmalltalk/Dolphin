"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #ACCEL
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cmd _OffsetOf_fVirt _OffsetOf_key'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ACCEL guid: (GUID fromString: '{87b4c5c8-026e-11d3-9fd7-00a0cc3e4a32}')!

ACCEL addClassConstant: '_OffsetOf_cmd' value: 16r4!
ACCEL addClassConstant: '_OffsetOf_fVirt' value: 16r0!
ACCEL addClassConstant: '_OffsetOf_key' value: 16r2!

ACCEL comment: 'ACCEL is an <ExternalStructure> class to represent the Win32 structure of the same name.

ACCEL is used to associate accelerator key entries with a Window.'!

!ACCEL categoriesForClass!External-Data-Structured-Win32! !

!ACCEL methodsFor!

cmd: anInteger
	"Set the receiver's 'cmd' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_cmd put: anInteger!

fVirt: anInteger
	"Set the receiver's 'fVirt' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_fVirt put: anInteger!

key: anInteger
	"Set the receiver's 'key' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_key put: anInteger! !

!ACCEL categoriesForMethods!
cmd:!**compiled accessors**!public! !
fVirt:!**compiled accessors**!public! !
key:!**compiled accessors**!public! !
!

!ACCEL class methodsFor!

defineFields
	"Define the Win32 ACCEL structure. Note that this structure requires packing to achieve natural field alignment.

		ACCEL compileDefinition

		typedef struct tagACCEL 
		{
			BYTE   fVirt;
			WORD   key;
			WORD   cmd;
		} ACCEL;
	"

	self
		defineField: #fVirt type: BYTEField new beWriteOnly;
		defineField: #key type: WORDField new beWriteOnly;
		defineField: #cmd type: WORDField new beWriteOnly!

getFieldNames
	^#(#fVirt #key #cmd)! !

!ACCEL class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

