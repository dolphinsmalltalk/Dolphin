"Filed out from Dolphin Smalltalk X6.1"!

OLEFinalizableStructure subclass: #CUSTDATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CUSTDATA guid: (GUID fromString: '{C06F3B7B-0868-11D3-93AF-00A024CA708A}')!
CUSTDATA comment: '<CUSTDATA> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATA'' from type information in the ''Ole Automation Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CUSTDATA categoriesForClass!External-Data-Structured-COM! !
!CUSTDATA methodsFor!

basicFree
	"Private - Free external resources owned by the receiver."

	OLEAutLibrary default clearCustData: self!

cCustData
	"Answer the receiver's cCustData field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

contents
	"Answer a <LookupTable> containing the custom attribute entries in the receiver.
	The keys of the table are the <GUID> attribute ids, and the values the custom attribute values."

	| attrs |
	attrs := LookupTable new.
	self prgCustData do: [:each | attrs at: each guid put: each varValue value].
	^attrs!

prgCustData
	"Answer the receiver's prgCustData field as a Smalltalk object."

	^StructureArray 
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #prgCustData))
		length: self cCustData
		elementClass: CUSTDATAITEM! !
!CUSTDATA categoriesFor: #basicFree!private!realizing/unrealizing! !
!CUSTDATA categoriesFor: #cCustData!**compiled accessors**!public! !
!CUSTDATA categoriesFor: #contents!printing-IDL!private! !
!CUSTDATA categoriesFor: #prgCustData!**compiled accessors**!public! !

!CUSTDATA class methodsFor!

defineFields
	"Define the fields of the CUSTDATA structure.
		CUSTDATA compileDefinition
	
		typedef 		struct tagCUSTDATA {
			unsigned long cCustData;
			CUSTDATAITEM* prgCustData;
		} CUSTDATA;

	"

	self
		defineField: #cCustData type: DWORDField readOnly;
		defineField: #prgCustData
			type: (ConformantStructureArrayPointerField type: CUSTDATAITEM length: #cCustData) beReadOnly! !
!CUSTDATA class categoriesFor: #defineFields!initializing!public! !

