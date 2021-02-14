"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.CUSTDATAITEM'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_guid' -> 16r0.
		'_OffsetOf_varValue' -> 16r10
	}!
OS.COM.CUSTDATAITEM guid: (Core.GUID fromString: '{a72e70d7-34d7-4c65-9b12-5941c51fa3c2}')!
OS.COM.CUSTDATAITEM comment: '<CUSTDATAITEM> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATAITEM'' from type information in the ''Ole Automation Type Library'' library.

CUSTDATAITEM is used to represent blocks of custom data stored in a type library.'!
!OS.COM.CUSTDATAITEM categoriesForClass!OAIDL-Structs! !
!OS.COM.CUSTDATAITEM methodsFor!

guid
	"Answer the <GUID> value of the receiver's 'guid' field."

	^GUID fromAddress: bytes yourAddress!

varValue
	"Answer the <VARIANT> value of the receiver's 'varValue' field."

	^VARIANT fromAddress: bytes yourAddress + _OffsetOf_varValue! !
!OS.COM.CUSTDATAITEM categoriesFor: #guid!**compiled accessors**!public! !
!OS.COM.CUSTDATAITEM categoriesFor: #varValue!**compiled accessors**!public! !

!OS.COM.CUSTDATAITEM class methodsFor!

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
!OS.COM.CUSTDATAITEM class categoriesFor: #defineFields!public!template definition! !
!OS.COM.CUSTDATAITEM class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

