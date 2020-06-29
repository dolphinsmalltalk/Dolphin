"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #LICINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_fLicVerified' -> 16r8.
		'_OffsetOf_fRuntimeKeyAvail' -> 16r4
	}!
LICINFO guid: (GUID fromString: '{87b4c5b8-026e-11d3-9fd7-00a0cc3e4a32}')!
LICINFO comment: 'LICINFO is an ExternalStructure class to represent the COM structure of the same name. LICINFO is used for licensing purposes in conjunction with IClassFactory2. Please refer to COM reference materials for further information.

Member variables:
*	cbLicInfo			<DWORD> sizeof the LICINFO structure
	fRuntimeKeyAvail;		<Boolean>
	fLicVerified		<Boolean>

*Renamed dwSize for compatibility with standard initialization code.'!
!LICINFO categoriesForClass!External-Data-Structured-COM! !
!LICINFO methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

fLicVerified
	"Answer the <Boolean> value of the receiver's 'fLicVerified' field."

	^(bytes dwordAtOffset: _OffsetOf_fLicVerified) asBoolean!

fRuntimeKeyAvail
	"Answer the <Boolean> value of the receiver's 'fRuntimeKeyAvail' field."

	^(bytes dwordAtOffset: _OffsetOf_fRuntimeKeyAvail) asBoolean! !
!LICINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!LICINFO categoriesFor: #fLicVerified!**compiled accessors**!public! !
!LICINFO categoriesFor: #fRuntimeKeyAvail!**compiled accessors**!public! !

!LICINFO class methodsFor!

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
!LICINFO class categoriesFor: #defineFields!public!template definition! !
!LICINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

