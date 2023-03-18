"Filed out from Dolphin Smalltalk"!

OS.COM.OLEStructure
	subclass: #'OS.COM.IDLDESC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_IDLDESC_Size' -> 16r8.
			'_OffsetOf_dwReserved' -> 16r0.
			'_OffsetOf_wIDLFlags' -> 16r4
		}!
OS.COM.IDLDESC guid: (Core.GUID fromString: '{c06f3b80-0868-11d3-93af-00a024ca708a}')!
OS.COM.IDLDESC comment: 'IDLDESC is an <ExternalStructure> class to represent the AX Automation structure, IDLDESC.

IDLDESC contains basic marshalling information for a function argument, basically consisting of flags which relate to attributes such as ''in'', ''out'' and ''retval'', which are defined in the IDL for the argument.

Member variables:
	dwReserved	<DWORD> "reserved for future use"
	wIDLFlags	<WORD> Flags from the IDLFLAGS enumeration.

Note that this structure is only 6-bytes long, and may require packing when embedded in other structures.'!
!OS.COM.IDLDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.IDLDESC methodsFor!

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

	^bytes uint16AtOffset: _OffsetOf_wIDLFlags! !
!OS.COM.IDLDESC categoriesForMethods!
isIn!public!testing! !
isOut!public!testing! !
isRetVal!public!testing! !
wIDLFlags!**compiled accessors**!public! !
!

!OS.COM.IDLDESC class methodsFor!

byteSize
	^_IDLDESC_Size!

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
		defineField: #dwReserved		type: UInt32Field filler;
		defineField: #wIDLFlags		type: UInt16Field readOnly
!

getFieldNames
	^#(#wIDLFlags)! !
!OS.COM.IDLDESC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

