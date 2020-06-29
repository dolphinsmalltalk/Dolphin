"Filed out from Dolphin Smalltalk 7"!

OLEFinalizableStructure subclass: #MULTI_QI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hr' -> 16r8.
		'_OffsetOf_pIID' -> 16r0.
		'_OffsetOf_pItf' -> 16r4
	}!
MULTI_QI guid: (GUID fromString: '{87b4c5c2-026e-11d3-9fd7-00a0cc3e4a32}')!
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
!MULTI_QI categoriesFor: #hr!**compiled accessors**!public! !
!MULTI_QI categoriesFor: #hr:!**compiled accessors**!public! !
!MULTI_QI categoriesFor: #pIID!**compiled accessors**!public! !
!MULTI_QI categoriesFor: #pIID:!**compiled accessors**!public! !
!MULTI_QI categoriesFor: #pItf!**compiled accessors**!public! !
!MULTI_QI categoriesFor: #pItf:!**compiled accessors**!public! !

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
!MULTI_QI class categoriesFor: #clear:!public!realizing/unrealizing! !
!MULTI_QI class categoriesFor: #defineFields!public!template definition! !
!MULTI_QI class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

