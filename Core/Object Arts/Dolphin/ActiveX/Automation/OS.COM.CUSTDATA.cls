"Filed out from Dolphin Smalltalk 7"!

OLEFinalizableStructure subclass: #CUSTDATA
	instanceVariableNames: 'contents'
	classVariableNames: 'WellKnownCustomAttributes'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cCustData' -> 16r0.
		'_OffsetOf_prgCustData' -> 16r4
	}!
CUSTDATA guid: (GUID fromString: '{c06f3b7b-0868-11d3-93af-00a024ca708a}')!
CUSTDATA comment: '<CUSTDATA> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATA'' from type information in the ''Ole Automation Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CUSTDATA categoriesForClass!External-Data-Structured-COM! !
!CUSTDATA methodsFor!

basicFree
	"Private - Free external resources owned by the receiver."

	OLEAutLibrary default clearCustData: self!

buildContents
	| attrs |
	attrs := LookupTable new.
	self prgCustData do: 
			[:each |
			| id |
			id := each guid.
			attrs at: (WellKnownCustomAttributes at: id ifAbsent: [id]) put: each varValue].
	^attrs!

cCustData
	"Private - Answer the <Integer> value of the receiver's 'cCustData' field."

	^bytes dwordAtOffset: _OffsetOf_cCustData!

contents
	"Answer a <LookupTable> containing the custom attribute entries in the receiver. The keys of
	the table are either the <GUID> attribute ids, or for some well known custom attributes
	symbolic names, and the values the custom attribute <VARIANT> values."

	^contents ifNil: [contents := self buildContents]!

prgCustData
	"Answer the <StructureArray> value of the receiver's 'prgCustData' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_prgCustData)
		length: self cCustData
		elementClass: CUSTDATAITEM! !
!CUSTDATA categoriesFor: #basicFree!private!realizing/unrealizing! !
!CUSTDATA categoriesFor: #buildContents!printing-IDL!private! !
!CUSTDATA categoriesFor: #cCustData!**compiled accessors**!private! !
!CUSTDATA categoriesFor: #contents!printing-IDL!public! !
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
		defineField: #cCustData type: DWORDField readOnly beNonBrowsable;
		defineField: #prgCustData
			type: (StructureArrayPointerField type: CUSTDATAITEM
					arrayLength: (ConformantArrayFieldLength lengthField: #cCustData)) beReadOnly!

getFieldNames
	^#(#cCustData #prgCustData)!

initialize
	"Define some custom attributes to work around the limitiations of type libraries in not
	supporting certain key IDL attributes that are required to correctly describe C structures;
	size_is and length_is are not supported at all, and 'string' cannot be applied to fixed or
	conformant arrays of characters (only pointers)."

	WellKnownCustomAttributes := LookupTable new.
	WellKnownCustomAttributes
		at: (GUID fromString: '{664f8323-a768-4acc-a2c8-8fa05d138897}') put: #string;
		at: (GUID fromString: '{82a85647-bd20-4075-823b-d9758c4391eb}') put: #length_is;
		at: (GUID fromString: '{be29f9d9-7844-49e1-aacb-8e19386529df}') put: #size_is;
		shrink! !
!CUSTDATA class categoriesFor: #defineFields!public!template definition! !
!CUSTDATA class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!CUSTDATA class categoriesFor: #initialize!public! !

