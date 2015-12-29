"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #LICINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LICINFO guid: (GUID fromString: '{87B4C5B8-026E-11D3-9FD7-00A0CC3E4A32}')!
LICINFO comment: 'LICINFO is an ExternalStructure class to represent the COM structure of the same name. LICINFO is used for licensing purposes in conjunction with IClassFactory2. Please refer to COM reference materials for further information.

Member variables:
*	cbLicInfo			<DWORD> sizeof the LICINFO structure
	fRuntimeKeyAvail;		<Boolean>
	fLicVerified		<Boolean>

*Renamed dwSize for compatibility with standard initialization code.'!
!LICINFO categoriesForClass!External-Data-Structured-COM! !
!LICINFO methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

fLicVerified
	"Answer the receiver's fLicVerified field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #fLicVerified)) asBoolean!

fRuntimeKeyAvail
	"Answer the receiver's fRuntimeKeyAvail field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #fRuntimeKeyAvail)) asBoolean! !
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
		defineField: #fLicVerified		type: BOOLField readOnly! !
!LICINFO class categoriesFor: #defineFields!initializing!public! !

