"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IErrorInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IErrorInfo guid: (IID fromString: '{1CF2B120-547D-101B-8E65-08002B2BD119}')!
IErrorInfo comment: '<IErrorInfo> is a wrapper class for the standard OLE Automation interface IErrorInfo.

IErrorInfo is the interface used to make available extended error information to a client when an exception occurs and an HRESULT failure code is returned.'!
!IErrorInfo categoriesForClass!COM-Interfaces! !
!IErrorInfo methodsFor!

description
	"Answer the error description from the receiver."

	| answer |
	answer := BSTR new.
	self GetDescription: answer.
	^answer asString!

excepInfo
	"Answer an <EXCEPINFO> containing most of the details from the receiver
	(with the exception of the guid)."


	| ex bstr |
	ex := EXCEPINFO new.
	ex scode: E_FAIL.		"No other hresult available, caller might be able to substitute something more specific"
	bstr := BSTR new.
	self GetSource: bstr.
	ex bstrSource: bstr detach.
	self GetDescription: bstr.
	ex bstrDescription: bstr detach.
	self GetHelpFile: bstr.
	ex bstrHelpFile: bstr detach.
	ex dwHelpContext: self helpContext.
	^ex!

GetDescription: pBstrDescription
	"Invoke the GetDescription() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetDescription(
			[out] BSTR* pBstrDescription);

	"

	<virtual stdcall: hresult 6 bstr*>
	^self invalidCall
!

GetGUID: pGUID
	"Invoke the GetGUID() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetGUID(
			[out] GUID* pGUID);

	"

	<virtual stdcall: hresult 4 GUID*>
	^self invalidCall
!

GetHelpContext: pdwHelpContext
	"Invoke the GetHelpContext() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetHelpContext(
			[out] unsigned long* pdwHelpContext);

	"

	<virtual stdcall: hresult 8 dword*>
	^self invalidCall
!

GetHelpFile: pBstrHelpFile
	"Invoke the GetHelpFile() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetHelpFile(
			[out] BSTR* pBstrHelpFile);

	"

	<virtual stdcall: hresult 7 bstr*>
	^self invalidCall
!

GetSource: pBstrSource
	"Invoke the GetSource() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetSource(
			[out] BSTR* pBstrSource);

	"

	<virtual stdcall: hresult 5 bstr*>
	^self invalidCall
!

helpContext
	"Answer the <integer> help context associated with the receiver."

	| answer |
	answer := DWORD new.
	self GetHelpContext: answer.
	^answer!

helpFile
	"Answer the path of the error file associated with the receiver
	(used in conjunction with the error context)."

	| answer |
	answer := BSTR new.
	self GetHelpFile: answer.
	^answer asString!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream.
	As OLE interfaces are opaque, pure, interfaces, we revert to the basic
	implementation, but include the address as this may help."

	self isNull ifTrue: [^super printOn: aStream].
	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self source;
		nextPutAll: ': ';
		print: self description;
		nextPut: $)!

source
	"Answer the error description from the receiver."

	| answer |
	answer := BSTR new.
	self GetSource: answer.
	^answer asString!

sourceInterface
	"Answer the IID of the interface which raised the error."

	| answer |
	answer := IID new.
	self GetGUID: answer.
	^answer! !
!IErrorInfo categoriesFor: #description!accessing!public! !
!IErrorInfo categoriesFor: #excepInfo!accessing!public! !
!IErrorInfo categoriesFor: #GetDescription:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!IErrorInfo categoriesFor: #GetGUID:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!IErrorInfo categoriesFor: #GetHelpContext:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!IErrorInfo categoriesFor: #GetHelpFile:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!IErrorInfo categoriesFor: #GetSource:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!IErrorInfo categoriesFor: #helpContext!accessing!public! !
!IErrorInfo categoriesFor: #helpFile!accessing!public! !
!IErrorInfo categoriesFor: #printOn:!printing!public! !
!IErrorInfo categoriesFor: #source!accessing!public! !
!IErrorInfo categoriesFor: #sourceInterface!accessing!public! !

!IErrorInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OAIDL.IErrorInfo'
		IErrorInfo defineTemplate
	"

	self
		defineFunction: #GetGUID:
			argumentTypes: 'GUID*';
		defineFunction: #GetSource:
			argumentTypes: 'bstr*';
		defineFunction: #GetDescription:
			argumentTypes: 'bstr*';
		defineFunction: #GetHelpFile:
			argumentTypes: 'bstr*';
		defineFunction: #GetHelpContext:
			argumentTypes: 'dword*'
!

fromEXCEPINFO: excepInfo guid: id
	"Answer a new instance of the receiver on a system extended error object
	with details from the <EXCEPINFO> structure, excepInfo."

	^(ICreateErrorInfo fromEXCEPINFO: excepInfo guid: id) errorInfo!

source: sourceString description: descriptionString helpContext: anInteger helpFile: helpFilePath guid: aGUID
	"Answer a new instance of the receiver encapsulating all of the specified details.
		ice := self source: 'Dolphin' description: 'It is all going horribly wrong' helpContext: 1 helpFile: nil guid: GUID newUnique.
	"

	| ice |
	ice := ICreateErrorInfo new.
	ice SetSource: sourceString.
	ice SetDescription: descriptionString.
	ice SetHelpContext: anInteger.
	ice SetHelpFile: helpFilePath.
	ice SetGuid: aGUID.
	^ice errorInfo

! !
!IErrorInfo class categoriesFor: #defineFunctions!**auto generated**!public! !
!IErrorInfo class categoriesFor: #fromEXCEPINFO:guid:!instance creation!public! !
!IErrorInfo class categoriesFor: #source:description:helpContext:helpFile:guid:!instance creation!public! !

