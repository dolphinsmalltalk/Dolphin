"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #PARAMDESCEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PARAMDESCEX guid: (GUID fromString: '{C06F3B61-0868-11D3-93AF-00A024CA708A}')!
PARAMDESCEX comment: 'PARAMDESCEX is an <ExternalStructure> to represent the AX Automation PARAMDESCEX structure.

The PARAMDESCEX structure is used to hold the default value (in a variant) for a particular parameter.

Fields:
	cBytes		<DWORD> size of structure (24).
	varDefaultValue	<VARIANT> default value of parameter described by structure.
'!
!PARAMDESCEX categoriesForClass!External-Data-Structured-COM! !
!PARAMDESCEX methodsFor!

varDefaultValue
	"Answer the receiver's varDefaultValue field as a Smalltalk object."

	^VARIANT fromAddress: bytes yourAddress + ##(self offsetOf: #varDefaultValue)! !
!PARAMDESCEX categoriesFor: #varDefaultValue!**compiled accessors**!public! !

!PARAMDESCEX class methodsFor!

defineFields
	"Define the fields of the PARAMDESCEX structure.
	Note that due to Zp8 packing this is actually a 24 byte structure!!

		PARAMDESCEX compileDefinition.

		struct PARAMDESCEX
		{
			ULONG cBytes;
			VARIANTARG varDefaultValue;
		};
	"

	self
		defineField: #cBytes			type: DWORDField filler;
		defineField: #varDefaultValue	type: (StructureField type: VARIANT) beReadOnly
! !
!PARAMDESCEX class categoriesFor: #defineFields!initializing!public! !

