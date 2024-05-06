"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #DVTARGETDEVICE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_tdDeviceNameOffset _OffsetOf_tdDriverNameOffset _OffsetOf_tdExtDevmodeOffset _OffsetOf_tdPortNameOffset _OffsetOf_tdSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DVTARGETDEVICE guid: (GUID fromString: '{48447b1a-95e7-4ede-be68-a34481486812}')!

DVTARGETDEVICE addClassConstant: '_OffsetOf_tdDeviceNameOffset' value: 16r6!
DVTARGETDEVICE addClassConstant: '_OffsetOf_tdDriverNameOffset' value: 16r4!
DVTARGETDEVICE addClassConstant: '_OffsetOf_tdExtDevmodeOffset' value: 16rA!
DVTARGETDEVICE addClassConstant: '_OffsetOf_tdPortNameOffset' value: 16r8!
DVTARGETDEVICE addClassConstant: '_OffsetOf_tdSize' value: 16r0!

DVTARGETDEVICE comment: '<DVTARGETDEVICE> is an <ExternalStructure> class to wrap the struct ''OCIDL.DVTARGETDEVICE'' from type information in the ''OCIDL Library'' library.

The type library contains no documentation for this struct

WARNING: This comment was automatically generated from the struct''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

!DVTARGETDEVICE categoriesForClass!External-Data-Structured-COM! !

!DVTARGETDEVICE methodsFor!

tdData
	"Answer a pointer to the receiver's variable data part."

	^(ExternalPointer fromAddress: (bytes yourAddress + 12))
		byteSize: (self tdSize - 12);
		yourself!

tdData: anObject 
	"Set the receiver's variable data part."

	| size |
	size := anObject size min: self tdSize - 12.
	bytes 
		replaceFrom: 1
		to: size
		with: anObject
		startingAt: 1!

tdDeviceNameOffset
	"Answer the <Integer> value of the receiver's 'tdDeviceNameOffset' field."

	^bytes wordAtOffset: _OffsetOf_tdDeviceNameOffset!

tdDeviceNameOffset: anInteger
	"Set the receiver's 'tdDeviceNameOffset' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_tdDeviceNameOffset put: anInteger!

tdDriverNameOffset
	"Answer the <Integer> value of the receiver's 'tdDriverNameOffset' field."

	^bytes wordAtOffset: _OffsetOf_tdDriverNameOffset!

tdDriverNameOffset: anInteger
	"Set the receiver's 'tdDriverNameOffset' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_tdDriverNameOffset put: anInteger!

tdExtDevmodeOffset
	"Answer the <Integer> value of the receiver's 'tdExtDevmodeOffset' field."

	^bytes wordAtOffset: _OffsetOf_tdExtDevmodeOffset!

tdExtDevmodeOffset: anInteger
	"Set the receiver's 'tdExtDevmodeOffset' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_tdExtDevmodeOffset put: anInteger!

tdPortNameOffset
	"Answer the <Integer> value of the receiver's 'tdPortNameOffset' field."

	^bytes wordAtOffset: _OffsetOf_tdPortNameOffset!

tdPortNameOffset: anInteger
	"Set the receiver's 'tdPortNameOffset' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_tdPortNameOffset put: anInteger!

tdSize
	"Answer the <Integer> value of the receiver's 'tdSize' field."

	^bytes dwordAtOffset: _OffsetOf_tdSize!

tdSize: anInteger
	"Set the receiver's 'tdSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_tdSize put: anInteger! !

!DVTARGETDEVICE categoriesForMethods!
tdData!accessing!public! !
tdData:!accessing!public! !
tdDeviceNameOffset!**compiled accessors**!public! !
tdDeviceNameOffset:!**compiled accessors**!public! !
tdDriverNameOffset!**compiled accessors**!public! !
tdDriverNameOffset:!**compiled accessors**!public! !
tdExtDevmodeOffset!**compiled accessors**!public! !
tdExtDevmodeOffset:!**compiled accessors**!public! !
tdPortNameOffset!**compiled accessors**!public! !
tdPortNameOffset:!**compiled accessors**!public! !
tdSize!**compiled accessors**!public! !
tdSize:!**compiled accessors**!public! !
!

!DVTARGETDEVICE class methodsFor!

defineFields
	"Define the fields of the DVTARGETDEVICE structure.
	N.B. This is a variable length structure!! This definition was originally auto-generated
	by the type library analyer, but because type libraries cannot represent variable length
	structures correct (the last member appears as a BYTE* pointer rather than BYTE[1]),
	we have modified it and moved it out of the auto generation category to prevent it
	being overwritten in future.

		DVTARGETDEVICE compileDefinition
	
		typedef 		struct tagDVTARGETDEVICE {
			unsigned long tdSize;
			unsigned short tdDriverNameOffset;
			unsigned short tdDeviceNameOffset;
			unsigned short tdPortNameOffset;
			unsigned short tdExtDevmodeOffset;
			BYTE tdData[1];
		} DVTARGETDEVICE;

	"

	self
		defineField: #tdSize type: DWORDField new;
		defineField: #tdDriverNameOffset type: WORDField new;
		defineField: #tdDeviceNameOffset type: WORDField new;
		defineField: #tdPortNameOffset type: WORDField new;
		defineField: #tdExtDevmodeOffset type: WORDField new
	"Hand modified - implement tdData manually"
	"defineField: #tdData type: ... offset: 12"

	"Type lib thinks this is a 16-byte structure, but in fact it is 12+"
	"self byteSize: 16"!

getFieldNames
	^#(#tdSize #tdDriverNameOffset #tdDeviceNameOffset #tdPortNameOffset #tdExtDevmodeOffset)! !

!DVTARGETDEVICE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

