"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.COM.LICINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_LICINFO_Size' -> 16rC.
			'_OffsetOf_fLicVerified' -> 16r8.
			'_OffsetOf_fRuntimeKeyAvail' -> 16r4
		}!

OS.COM.LICINFO guid: (Core.GUID fromString: '{87b4c5b8-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.COM.LICINFO comment: '`OS.COM.LICINFO` is an `External.Structure` class to represent the COM structure LICINFO. 

LICINFO is used for licensing purposes in conjunction with IClassFactory2. Please refer to COM reference materials for further information.

Member variables:
*	cbLicInfo			<DWORD> sizeof the LICINFO structure
	fRuntimeKeyAvail;		<Boolean>
	fLicVerified		<Boolean>

*Renamed dwSize for compatibility with standard initialization code.'!

!OS.COM.LICINFO categoriesForClass!External-Data-Structured-COM! !

!OS.COM.LICINFO methodsFor!

fLicVerified
	"Answer the <Boolean> value of the receiver's 'fLicVerified' field."

	^(bytes uint32AtOffset: _OffsetOf_fLicVerified) asBoolean!

fRuntimeKeyAvail
	"Answer the <Boolean> value of the receiver's 'fRuntimeKeyAvail' field."

	^(bytes uint32AtOffset: _OffsetOf_fRuntimeKeyAvail) asBoolean! !

!OS.COM.LICINFO categoriesForMethods!
fLicVerified!**compiled accessors**!public! !
fRuntimeKeyAvail!**compiled accessors**!public! !
!

!OS.COM.LICINFO class methodsFor!

byteSize
	^_LICINFO_Size!

defineFields
	"Define the fields of the LICINFO structure.

		LICINFO compileDefinition.

		strict LICINFO
		{
			ULONG cbLicInfo;
			BOOL  fRuntimeKeyAvail;
			BOOL  fLicVerified;
		};"

	super defineFields.
	self
		defineField: #fRuntimeKeyAvail	type: BOOLField readOnly;
		defineField: #fLicVerified		type: BOOLField readOnly!

getFieldNames
	^#(#dwSize #fRuntimeKeyAvail #fLicVerified)! !

!OS.COM.LICINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

