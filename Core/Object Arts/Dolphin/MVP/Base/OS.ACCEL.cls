"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.ACCEL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ACCEL_Size' -> 16r6.
			'_OffsetOf_cmd' -> 16r4.
			'_OffsetOf_fVirt' -> 16r0.
			'_OffsetOf_key' -> 16r2
		}!

OS.ACCEL guid: (Core.GUID fromString: '{87b4c5c8-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.ACCEL comment: 'ACCEL is an <ExternalStructure> class to represent the Win32 structure of the same name.

ACCEL is used to associate accelerator key entries with a Window.'!

!OS.ACCEL categoriesForClass!External-Data-Structured-Win32! !

!OS.ACCEL methodsFor!

cmd: anInteger
	"Set the receiver's 'cmd' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_cmd put: anInteger!

fVirt: anInteger
	"Set the receiver's 'fVirt' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_fVirt put: anInteger!

key: anInteger
	"Set the receiver's 'key' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_key put: anInteger! !

!OS.ACCEL categoriesForMethods!
cmd:!**compiled accessors**!public! !
fVirt:!**compiled accessors**!public! !
key:!**compiled accessors**!public! !
!

!OS.ACCEL class methodsFor!

byteSize
	^_ACCEL_Size!

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
		defineField: #fVirt type: UInt8Field new beWriteOnly;
		defineField: #key type: UInt16Field new beWriteOnly;
		defineField: #cmd type: UInt16Field new beWriteOnly!

getFieldNames
	^#(#fVirt #key #cmd)! !

!OS.ACCEL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

