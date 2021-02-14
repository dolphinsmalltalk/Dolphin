"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.LICINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
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

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

fLicVerified
	"Answer the <Boolean> value of the receiver's 'fLicVerified' field."

	^(bytes dwordAtOffset: _OffsetOf_fLicVerified) asBoolean!

fRuntimeKeyAvail
	"Answer the <Boolean> value of the receiver's 'fRuntimeKeyAvail' field."

	^(bytes dwordAtOffset: _OffsetOf_fRuntimeKeyAvail) asBoolean! !
!OS.COM.LICINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!OS.COM.LICINFO categoriesFor: #fLicVerified!**compiled accessors**!public! !
!OS.COM.LICINFO categoriesFor: #fRuntimeKeyAvail!**compiled accessors**!public! !

!OS.COM.LICINFO class methodsFor!

defineFields
	"Define the fields of the LICINFO structure.

		LICINFO compileDefinition.

		strict LICINFO
		{
			ULONG cbLicInfo;
			BOOL  fRuntimeKeyAvail;
			BOOL  fLicVerified;
		};"

	self
		defineField: #dwSize		type: DWORDField writeOnly beOverride;
		defineField: #fRuntimeKeyAvail	type: BOOLField readOnly;
		defineField: #fLicVerified		type: BOOLField readOnly!

getFieldNames
	^#(#dwSize #fRuntimeKeyAvail #fLicVerified)! !
!OS.COM.LICINFO class categoriesFor: #defineFields!public!template definition! !
!OS.COM.LICINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

