"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #IDLDESC
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwReserved _OffsetOf_wIDLFlags'
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
IDLDESC guid: (GUID fromString: '{c06f3b80-0868-11d3-93af-00a024ca708a}')!
IDLDESC addClassConstant: '_OffsetOf_dwReserved' value: 16r0!
IDLDESC addClassConstant: '_OffsetOf_wIDLFlags' value: 16r4!
IDLDESC comment: 'IDLDESC is an <ExternalStructure> class to represent the AX Automation structure, IDLDESC.

IDLDESC contains basic marshalling information for a function argument, basically consisting of flags which relate to attributes such as ''in'', ''out'' and ''retval'', which are defined in the IDL for the argument.

Member variables:
	dwReserved	<DWORD> "reserved for future use"
	wIDLFlags	<WORD> Flags from the IDLFLAGS enumeration.

Note that this structure is only 6-bytes long, and may require packing when embedded in other structures.'!
!IDLDESC categoriesForClass!External-Data-Structured-COM! !
!IDLDESC methodsFor!

isIn
	"Answer whether the receiver is describing an input argument."

	^self wIDLFlags anyMask: IDLFLAG_FIN!

isOut
	"Answer whether the receiver is describing an output argument."

	^self wIDLFlags anyMask: IDLFLAG_FOUT!

isRetVal
	"Answer whether the receiver is describing a retval (i.e. return value) argument."

	^self wIDLFlags anyMask: IDLFLAG_FRETVAL!

wIDLFlags
	"Answer the <Integer> value of the receiver's 'wIDLFlags' field."

	^bytes wordAtOffset: _OffsetOf_wIDLFlags! !
!IDLDESC categoriesForMethods!
isIn!public!testing! !
isOut!public!testing! !
isRetVal!public!testing! !
wIDLFlags!**compiled accessors**!public! !
!

!IDLDESC class methodsFor!

defineFields
	"Define the fields of the IDLDESC structure.

		IDLDESC compileDefinition.

		struct IDLDESC
		{
			ULONG dwReserved;
			USHORT wIDLFlags;
		};
	"

	self
		defineField: #dwReserved		type: DWORDField filler;
		defineField: #wIDLFlags		type: WORDField readOnly
!

getFieldNames
	^#(#wIDLFlags)! !
!IDLDESC class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

