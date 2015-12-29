"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #DVTARGETDEVICE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DVTARGETDEVICE guid: (GUID fromString: '{48447B1A-95E7-4EDE-BE68-A34481486812}')!
DVTARGETDEVICE comment: '<DVTARGETDEVICE> is an <ExternalStructure> class to wrap the struct ''OCIDL.DVTARGETDEVICE'' from type information in the ''OCIDL Library'' library.

The type library contains no documentation for this struct

WARNING: This comment was automatically generated from the struct''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!DVTARGETDEVICE categoriesForClass!No category! !
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
	"Answer the receiver's tdDeviceNameOffset field as a Smalltalk object."

	^(bytes wordAtOffset: 6)!

tdDeviceNameOffset: anObject
	"Set the receiver's tdDeviceNameOffset field to the value of anObject."

	bytes wordAtOffset: 6 put: anObject!

tdDriverNameOffset
	"Answer the receiver's tdDriverNameOffset field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

tdDriverNameOffset: anObject
	"Set the receiver's tdDriverNameOffset field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject!

tdExtDevmodeOffset
	"Answer the receiver's tdExtDevmodeOffset field as a Smalltalk object."

	^(bytes wordAtOffset: 10)!

tdExtDevmodeOffset: anObject
	"Set the receiver's tdExtDevmodeOffset field to the value of anObject."

	bytes wordAtOffset: 10 put: anObject!

tdPortNameOffset
	"Answer the receiver's tdPortNameOffset field as a Smalltalk object."

	^(bytes wordAtOffset: 8)!

tdPortNameOffset: anObject
	"Set the receiver's tdPortNameOffset field to the value of anObject."

	bytes wordAtOffset: 8 put: anObject!

tdSize
	"Answer the receiver's tdSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

tdSize: anObject
	"Set the receiver's tdSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!DVTARGETDEVICE categoriesFor: #tdData!accessing!public! !
!DVTARGETDEVICE categoriesFor: #tdData:!accessing!public! !
!DVTARGETDEVICE categoriesFor: #tdDeviceNameOffset!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdDeviceNameOffset:!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdDriverNameOffset!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdDriverNameOffset:!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdExtDevmodeOffset!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdExtDevmodeOffset:!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdPortNameOffset!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdPortNameOffset:!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdSize!**compiled accessors**!public! !
!DVTARGETDEVICE categoriesFor: #tdSize:!**compiled accessors**!public! !

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
	"self byteSize: 16"! !
!DVTARGETDEVICE class categoriesFor: #defineFields!initializing!public! !

