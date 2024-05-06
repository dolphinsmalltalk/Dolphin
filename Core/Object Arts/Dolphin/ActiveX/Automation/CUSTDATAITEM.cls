"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #CUSTDATAITEM
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_guid _OffsetOf_varValue'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CUSTDATAITEM guid: (GUID fromString: '{a72e70d7-34d7-4c65-9b12-5941c51fa3c2}')!

CUSTDATAITEM addClassConstant: '_OffsetOf_guid' value: 16r0!
CUSTDATAITEM addClassConstant: '_OffsetOf_varValue' value: 16r10!

CUSTDATAITEM comment: '<CUSTDATAITEM> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATAITEM'' from type information in the ''Ole Automation Type Library'' library.

CUSTDATAITEM is used to represent blocks of custom data stored in a type library.'!

!CUSTDATAITEM categoriesForClass!OAIDL-Structs! !

!CUSTDATAITEM methodsFor!

guid
	"Answer the <GUID> value of the receiver's 'guid' field."

	^GUID fromAddress: bytes yourAddress!

varValue
	"Answer the <VARIANT> value of the receiver's 'varValue' field."

	^VARIANT fromAddress: bytes yourAddress + _OffsetOf_varValue! !

!CUSTDATAITEM categoriesForMethods!
guid!**compiled accessors**!public! !
varValue!**compiled accessors**!public! !
!

!CUSTDATAITEM class methodsFor!

defineFields
	"Define the fields of the CUSTDATAITEM structure.
		CUSTDATAITEM compileDefinition
	
		typedef 		struct tagCUSTDATAITEM {
			GUID guid;
			VARIANT varValue;
		} CUSTDATAITEM;

	"

	self
		defineField: #guid type: (StructureField type: GUID) beReadOnly;
		defineField: #varValue type: (StructureField type: VARIANT) beReadOnly!

getFieldNames
	^#(#guid #varValue)! !

!CUSTDATAITEM class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

