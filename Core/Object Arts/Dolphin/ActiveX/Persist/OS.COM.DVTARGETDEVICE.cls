"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.DVTARGETDEVICE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_DVTARGETDEVICE_Size' -> 16rC.
			'_OffsetOf_tdDeviceNameOffset' -> 16r6.
			'_OffsetOf_tdDriverNameOffset' -> 16r4.
			'_OffsetOf_tdExtDevmodeOffset' -> 16rA.
			'_OffsetOf_tdPortNameOffset' -> 16r8.
			'_OffsetOf_tdSize' -> 16r0
		}!

OS.COM.DVTARGETDEVICE guid: (Core.GUID fromString: '{48447b1a-95e7-4ede-be68-a34481486812}')!

OS.COM.DVTARGETDEVICE comment: '<DVTARGETDEVICE> is an <ExternalStructure> class to wrap the struct ''OCIDL.DVTARGETDEVICE'' from type information in the ''OCIDL Library'' library.

The type library contains no documentation for this struct

WARNING: This comment was automatically generated from the struct''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

!OS.COM.DVTARGETDEVICE categoriesForClass!External-Data-Structured-COM! !

!OS.COM.DVTARGETDEVICE methodsFor!

tdData
	"Answer a pointer to the receiver's variable data part."

	^(Pointer fromAddress: (bytes yourAddress + 12))
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

	^bytes uint16AtOffset: _OffsetOf_tdDeviceNameOffset!

tdDeviceNameOffset: anInteger
	"Set the receiver's 'tdDeviceNameOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_tdDeviceNameOffset put: anInteger!

tdDriverNameOffset
	"Answer the <Integer> value of the receiver's 'tdDriverNameOffset' field."

	^bytes uint16AtOffset: _OffsetOf_tdDriverNameOffset!

tdDriverNameOffset: anInteger
	"Set the receiver's 'tdDriverNameOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_tdDriverNameOffset put: anInteger!

tdExtDevmodeOffset
	"Answer the <Integer> value of the receiver's 'tdExtDevmodeOffset' field."

	^bytes uint16AtOffset: _OffsetOf_tdExtDevmodeOffset!

tdExtDevmodeOffset: anInteger
	"Set the receiver's 'tdExtDevmodeOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_tdExtDevmodeOffset put: anInteger!

tdPortNameOffset
	"Answer the <Integer> value of the receiver's 'tdPortNameOffset' field."

	^bytes uint16AtOffset: _OffsetOf_tdPortNameOffset!

tdPortNameOffset: anInteger
	"Set the receiver's 'tdPortNameOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_tdPortNameOffset put: anInteger!

tdSize
	"Answer the <Integer> value of the receiver's 'tdSize' field."

	^bytes uint32AtOffset: _OffsetOf_tdSize!

tdSize: anInteger
	"Set the receiver's 'tdSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_tdSize put: anInteger! !

!OS.COM.DVTARGETDEVICE categoriesForMethods!
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

!OS.COM.DVTARGETDEVICE class methodsFor!

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
		defineField: #tdSize type: UInt32Field new;
		defineField: #tdDriverNameOffset type: UInt16Field new;
		defineField: #tdDeviceNameOffset type: UInt16Field new;
		defineField: #tdPortNameOffset type: UInt16Field new;
		defineField: #tdExtDevmodeOffset type: UInt16Field new
	"Hand modified - implement tdData manually"
	"defineField: #tdData type: ... offset: 12"

	"Type lib thinks this is a 16-byte structure, but in fact it is 12+"
	"self byteSize: 16"!

getFieldNames
	^#(#tdSize #tdDriverNameOffset #tdDeviceNameOffset #tdPortNameOffset #tdExtDevmodeOffset)! !

!OS.COM.DVTARGETDEVICE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

