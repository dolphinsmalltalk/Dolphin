"Filed out from Dolphin Smalltalk"!

OLEFinalizableStructure subclass: #MULTI_QI
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_hr _OffsetOf_pIID _OffsetOf_pItf'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MULTI_QI guid: (GUID fromString: '{87b4c5c2-026e-11d3-9fd7-00a0cc3e4a32}')!
MULTI_QI addClassConstant: '_OffsetOf_hr' value: 16r8!
MULTI_QI addClassConstant: '_OffsetOf_pIID' value: 16r0!
MULTI_QI addClassConstant: '_OffsetOf_pItf' value: 16r4!
MULTI_QI comment: 'MULTI_QI is an <ExternalStructure> class to represent the Win32 COM structure of the same name.

Arrays of MULTI_QI structures can be used to query multiple interface pointers in a single request. This is only really important for DCOM as it helps to minimize the number of network round-trips that are performed.'!
!MULTI_QI categoriesForClass!External-Data-Structured-COM! !
!MULTI_QI methodsFor!

hr
	"Answer the <Integer> value of the receiver's 'hr' field."

	^bytes sdwordAtOffset: _OffsetOf_hr!

hr: anInteger
	"Set the receiver's 'hr' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_hr put: anInteger!

pIID
	"Answer the <IID> value of the receiver's 'pIID' field."

	^IID fromAddress: (bytes intPtrAtOffset: _OffsetOf_pIID)!

pIID: anIID
	"Set the receiver's 'pIID' field to the value of the argument, anIID"

	bytes uintPtrAtOffset: _OffsetOf_pIID put: anIID yourAddress!

pItf
	"Answer the <IUnknown> value of the receiver's 'pItf' field."

	^IUnknown fromAddress: (bytes intPtrAtOffset: _OffsetOf_pItf)!

pItf: anIUnknown
	"Set the receiver's 'pItf' field to the value of the argument, anIUnknown"

	bytes uintPtrAtOffset: _OffsetOf_pItf put: anIUnknown yourAddress! !
!MULTI_QI categoriesForMethods!
hr!**compiled accessors**!public! !
hr:!**compiled accessors**!public! !
pIID!**compiled accessors**!public! !
pIID:!**compiled accessors**!public! !
pItf!**compiled accessors**!public! !
pItf:!**compiled accessors**!public! !
!

!MULTI_QI class methodsFor!

clear: addressOrBytes
	"Free external resources referenced by the structure
	of the receiver's element type at the specified address."

	| pi |
	pi := addressOrBytes sdwordAtOffset: 4.
	pi notNull ifTrue: [(IUnknown attach: pi) free]!

defineFields
	"Define the fields of the MULTI_QI structure.

		MULTI_QI compileDefinition.

		struct  MULTI_QI
		{
			const IID*	pIID;
			IUnknown*	pItf;
			HRESULT		hr;
		};

	"

	self
		defineField: #pIID	type: (PointerField type: IID);
		defineField: #pItf	type: (PointerField type: IUnknown);
		defineField: #hr	type: SDWORDField new!

getFieldNames
	^#(#pIID #pItf #hr)! !
!MULTI_QI class categoriesForMethods!
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

