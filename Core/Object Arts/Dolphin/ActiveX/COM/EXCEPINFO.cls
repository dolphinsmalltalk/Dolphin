"Filed out from Dolphin Smalltalk"!

OLEFinalizableStructure subclass: #EXCEPINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwHelpContext _OffsetOf_pfnDeferredFillIn _OffsetOf_pvReserved _OffsetOf_pwszDescription _OffsetOf_pwszHelpFile _OffsetOf_pwszSource _OffsetOf_scode _OffsetOf_wCode _OffsetOf_wReserved'
	poolDictionaries: 'Win32Errors'
	classInstanceVariableNames: ''!
EXCEPINFO guid: (GUID fromString: '{c06f3b63-0868-11d3-93af-00a024ca708a}')!
EXCEPINFO addClassConstant: '_OffsetOf_dwHelpContext' value: 16r10!
EXCEPINFO addClassConstant: '_OffsetOf_pfnDeferredFillIn' value: 16r18!
EXCEPINFO addClassConstant: '_OffsetOf_pvReserved' value: 16r14!
EXCEPINFO addClassConstant: '_OffsetOf_pwszDescription' value: 16r8!
EXCEPINFO addClassConstant: '_OffsetOf_pwszHelpFile' value: 16rC!
EXCEPINFO addClassConstant: '_OffsetOf_pwszSource' value: 16r4!
EXCEPINFO addClassConstant: '_OffsetOf_scode' value: 16r1C!
EXCEPINFO addClassConstant: '_OffsetOf_wCode' value: 16r0!
EXCEPINFO addClassConstant: '_OffsetOf_wReserved' value: 16r2!
EXCEPINFO comment: 'EXCEPINFO is the class of <ExternalStructure>s representing the OLE Automation structure of the same name. EXCEPINFO is used to return exception details from IDispatch::Invoke().'!
!EXCEPINFO categoriesForClass!External-Data-Structured-COM! !
!EXCEPINFO methodsFor!

_deepCopy: copiesDictionary 
	"Private - Answer a 'deep copy' of the receiver, cloning only those parts not already included
	in the IdentityDictionary argument, copiesDictionary."

	"Implementation Note: We have no copiable instance variables, but must copy the BSTRs embedded
	in the structure, something which our #copy implementation does."

	^self copy!

bstrDescription
	"Answer the receiver's bstrDescription field as a Smalltalk object."

	^BSTR fromAddress: self pwszDescription!

bstrDescription: anObject 
	"Set the receiver's bstrDescription field to the value of anObject."

	self pwszDescription: anObject yourAddress!

bstrHelpFile
	"Answer the receiver's bstrHelpFile field as a Smalltalk object."

	^BSTR fromAddress: self pwszHelpFile!

bstrHelpFile: anObject 
	"Set the receiver's bstrHelpFile field to the value of anObject."

	self pwszHelpFile: anObject yourAddress!

bstrSource
	"Answer the receiver's bstrSource field as a Smalltalk object."

	^BSTR fromAddress: self pwszSource!

bstrSource: anObject 
	"Set the receiver's bstrSource field to the value of anObject."

	self pwszSource: anObject yourAddress!

copy
	"Answer an <EXCEPINFO> which is a copy of the receiver. The embedded BSTRs
	must be copied (the accessor copies because BSTR>>fromAddress: copies)."

	| copy |
	copy := super copy.
	copy bstrSource: self bstrSource detach.
	copy bstrDescription: self bstrDescription detach.
	copy bstrHelpFile: self bstrHelpFile detach.
	^copy!

description
	"Answer the receiver's bstrDescription field as a <readableString> Smalltalk object.
	This is the error string set by the object which reported the error."

	^self wstrDescription asString!

description: errorDescription
	"Set the receiver's bstrDescription field to a <BSTR> copy of the <readableString>
	or <BSTR> argument."

	| bstr |
	(bstr := errorDescription asBSTR) == errorDescription
		ifTrue: [bstr := errorDescription copy].
	self bstrDescription: bstr detach.!

dwHelpContext
	"Answer the <Integer> value of the receiver's 'dwHelpContext' field."

	^bytes dwordAtOffset: _OffsetOf_dwHelpContext!

dwHelpContext: anInteger
	"Set the receiver's 'dwHelpContext' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwHelpContext put: anInteger!

helpFile
	"Answer the receiver's bstrHelpFile field as a <readableString> Smalltalk object."

	^self wstrHelpFile asString!

helpFile: helpFilePath
	"Set the receiver's bstrHelpFile field to a <BSTR> copy of the <readableString>
	or <BSTR> argument."

	| bstr |
	(bstr := helpFilePath asBSTR) == helpFilePath
		ifTrue: [bstr := helpFilePath copy].
	self bstrHelpFile: bstr detach.!

hresult
	"Answer the HRESULT associated with the receiver.
	This may need to be generated from the error code, depending on which was specified."

	| wCode |
	wCode := self wCode.
	^wCode == 0 
		ifTrue: [self scode]
		ifFalse: 
			[wCode >= 16rFE00 ifTrue: [WCODE_HRESULT_LAST] ifFalse: [WCODE_HRESULT_FIRST + wCode]]!

pfnDeferredFillIn
	"Answer the <ExternalAddress> value of the receiver's 'pfnDeferredFillIn' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pfnDeferredFillIn) asExternalAddress!

pwszDescription
	"Answer the <Integer> value of the receiver's 'pwszDescription' field."

	^bytes uintPtrAtOffset: _OffsetOf_pwszDescription!

pwszDescription: anInteger
	"Set the receiver's 'pwszDescription' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_pwszDescription put: anInteger!

pwszHelpFile
	"Answer the <Integer> value of the receiver's 'pwszHelpFile' field."

	^bytes uintPtrAtOffset: _OffsetOf_pwszHelpFile!

pwszHelpFile: anInteger
	"Set the receiver's 'pwszHelpFile' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_pwszHelpFile put: anInteger!

pwszSource
	"Answer the <Integer> value of the receiver's 'pwszSource' field."

	^bytes uintPtrAtOffset: _OffsetOf_pwszSource!

pwszSource: anInteger
	"Set the receiver's 'pwszSource' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_pwszSource put: anInteger!

scode
	"Answer the <Integer> value of the receiver's 'scode' field."

	^bytes sdwordAtOffset: _OffsetOf_scode!

scode: anInteger
	"Set the receiver's 'scode' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_scode put: anInteger!

source
	"Answer a <readableString> description of the source of the error.
	This should be the error source's version independent Prog ID, but some objects
	do not follow the convention."

	^self wstrSource asString!

source: errorSourceString
	"Set the receiver's bstrSource field to a <BSTR> copy of the <readableString>
	or <BSTR> argument."

	| bstr |
	(bstr := errorSourceString asBSTR) == errorSourceString
		ifTrue: [bstr := errorSourceString copy].
	self bstrSource: bstr detach.!

wCode
	"Answer the <Integer> value of the receiver's 'wCode' field."

	^bytes wordAtOffset: _OffsetOf_wCode!

wCode: anInteger
	"Set the receiver's 'wCode' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wCode put: anInteger!

wstrDescription
	"Answer the receiver's bstrDescription field as a <Utf16String>."

	^Utf16String fromAddress: self pwszDescription!

wstrHelpFile
	"Answer the receiver's bstrHelpFile field as a <Utf16String>."

	^Utf16String fromAddress: self pwszHelpFile!

wstrSource
	"Answer the receiver's bstrSource field as a <Utf16String>."

	^Utf16String fromAddress: self pwszSource! !
!EXCEPINFO categoriesForMethods!
_deepCopy:!copying!private! !
bstrDescription!accessing!public! !
bstrDescription:!accessing!public! !
bstrHelpFile!accessing!public! !
bstrHelpFile:!accessing!public! !
bstrSource!accessing!public! !
bstrSource:!accessing!public! !
copy!copying!public! !
description!accessing!public! !
description:!accessing!public! !
dwHelpContext!**compiled accessors**!public! !
dwHelpContext:!**compiled accessors**!public! !
helpFile!accessing!public! !
helpFile:!accessing!public! !
hresult!accessing!public! !
pfnDeferredFillIn!**compiled accessors**!public! !
pwszDescription!**compiled accessors**!public! !
pwszDescription:!**compiled accessors**!public! !
pwszHelpFile!**compiled accessors**!public! !
pwszHelpFile:!**compiled accessors**!public! !
pwszSource!**compiled accessors**!public! !
pwszSource:!**compiled accessors**!public! !
scode!**compiled accessors**!public! !
scode:!**compiled accessors**!public! !
source!accessing!public! !
source:!accessing!public! !
wCode!**compiled accessors**!public! !
wCode:!**compiled accessors**!public! !
wstrDescription!accessing!public! !
wstrHelpFile!accessing!public! !
wstrSource!accessing!public! !
!

!EXCEPINFO class methodsFor!

clear: addressOrBytes
	"Free external resources referenced by the structure
	of the receiver's element type at the specified address."

	| lib |
	lib := OLEAutLibrary default.
	4 to: 12 by: 4 do: [:offset | lib sysFreeString: (addressOrBytes sdwordAtOffset: offset)]
!

defineFields
	"Define the fields of the EXCEPINFO structure.

		EXCEPINFO compileDefinition.

		struct EXCEPINFO 
		{
			unsigned short wCode;			// An error code describing the error.
			unsigned short wReserved;    
			BSTR bstrSource;				// Source of the exception.
			BSTR bstrDescription;			// Textual description of the error.
			BSTR bstrHelpFile;				// Help file path.
			unsigned long dwHelpContext;	// Help context ID.    
			void FAR* pvReserved;			// Pointer to function that fills in Help and description info.
			HRESULT (STDAPICALLTYPE FAR* pfnDeferredFillIn)(struct tagEXCEPINFO FAR*);
			SCODE scode;					// Error code
		}; 
	"

	self
		defineField: #wCode type: WORDField new;
		defineField: #wReserved type: WORDField filler;
		defineField: #pwszSource type: UINT_PTRField new;
		defineField: #pwszDescription type: UINT_PTRField new;
		defineField: #pwszHelpFile type: UINT_PTRField new;
		defineField: #dwHelpContext type: DWORDField new;
		defineField: #pvReserved type: LPVOIDField filler;
		defineField: #pfnDeferredFillIn type: LPVOIDField readOnly;
		defineField: #scode type: SDWORDField new!

getFieldNames
	^#(#wCode #pwszSource #pwszDescription #pwszHelpFile #dwHelpContext #pfnDeferredFillIn #scode)! !
!EXCEPINFO class categoriesForMethods!
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

