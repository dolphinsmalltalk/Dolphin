"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #ACCEL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ACCEL guid: (GUID fromString: '{87b4c5c8-026e-11d3-9fd7-00a0cc3e4a32}')!
ACCEL comment: 'ACCEL is an <ExternalStructure> class to represent the Win32 structure of the same name.

ACCEL is used to associate accelerator key entries with a Window.'!
!ACCEL categoriesForClass!External-Data-Structured-Win32! !
!ACCEL methodsFor!

cmd: anObject 
	"Set the receiver's cmd field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #cmd) put: anObject!

fVirt: anObject 
	"Set the receiver's fVirt field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject!

key: anObject 
	"Set the receiver's key field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #key) put: anObject! !
!ACCEL categoriesFor: #cmd:!**compiled accessors**!public! !
!ACCEL categoriesFor: #fVirt:!**compiled accessors**!public! !
!ACCEL categoriesFor: #key:!**compiled accessors**!public! !

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
		defineField: #cmd type: WORDField new beWriteOnly! !
!ACCEL class categoriesFor: #defineFields!initializing!public! !

