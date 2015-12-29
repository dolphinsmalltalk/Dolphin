"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #CUSTDATAITEM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CUSTDATAITEM guid: (GUID fromString: '{A72E70D7-34D7-4C65-9B12-5941C51FA3C2}')!
CUSTDATAITEM comment: '<CUSTDATAITEM> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATAITEM'' from type information in the ''Ole Automation Type Library'' library.

CUSTDATAITEM is used to represent blocks of custom data stored in a type library.'!
!CUSTDATAITEM categoriesForClass!OAIDL-Structs! !
!CUSTDATAITEM methodsFor!

guid
	"Answer the receiver's guid field as a Smalltalk object."

	^GUID fromAddress: bytes yourAddress!

varValue
	"Answer the receiver's varValue field as a Smalltalk object."

	^VARIANT fromAddress: bytes yourAddress + ##(self offsetOf: #varValue)! !
!CUSTDATAITEM categoriesFor: #guid!**compiled accessors**!public! !
!CUSTDATAITEM categoriesFor: #varValue!**compiled accessors**!public! !

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
		defineField: #varValue type: (StructureField type: VARIANT) beReadOnly! !
!CUSTDATAITEM class categoriesFor: #defineFields!initializing!public! !

