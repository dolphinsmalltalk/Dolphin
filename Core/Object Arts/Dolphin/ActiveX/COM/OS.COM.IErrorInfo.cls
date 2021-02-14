"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IErrorInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IErrorInfo guid: (OS.COM.IID fromString: '{1cf2b120-547d-101b-8e65-08002b2bd119}')!
OS.COM.IErrorInfo comment: '`OS.COM.IErrorInfo` is a wrapper class for the standard OLE Automation interface IErrorInfo.

IErrorInfo is the interface used to make available extended error information to a client when an exception occurs and an HRESULT failure code is returned.'!
!OS.COM.IErrorInfo categoriesForClass!COM-Interfaces! !
!OS.COM.IErrorInfo methodsFor!

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
	ex scode: E_FAIL.	"No other hresult available, caller might be able to substitute something more specific"
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
	^self invalidCall: _failureCode!

GetGUID: pGUID
	"Invoke the GetGUID() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetGUID(
			[out] GUID* pGUID);

	"

	<virtual stdcall: hresult 4 guid*>
	^self invalidCall: _failureCode!

GetHelpContext: pdwHelpContext
	"Invoke the GetHelpContext() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetHelpContext(
			[out] unsigned long* pdwHelpContext);

	"

	<virtual stdcall: hresult 8 dword*>
	^self invalidCall: _failureCode!

GetHelpFile: pBstrHelpFile
	"Invoke the GetHelpFile() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetHelpFile(
			[out] BSTR* pBstrHelpFile);

	"

	<virtual stdcall: hresult 7 bstr*>
	^self invalidCall: _failureCode!

GetSource: pBstrSource
	"Invoke the GetSource() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetSource(
			[out] BSTR* pBstrSource);

	"

	<virtual stdcall: hresult 5 bstr*>
	^self invalidCall: _failureCode!

guid
	| answer |
	answer := GUID new.
	self GetGUID: answer.
	^answer!

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
!OS.COM.IErrorInfo categoriesFor: #description!accessing!public! !
!OS.COM.IErrorInfo categoriesFor: #excepInfo!accessing!public! !
!OS.COM.IErrorInfo categoriesFor: #GetDescription:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!OS.COM.IErrorInfo categoriesFor: #GetGUID:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!OS.COM.IErrorInfo categoriesFor: #GetHelpContext:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!OS.COM.IErrorInfo categoriesFor: #GetHelpFile:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!OS.COM.IErrorInfo categoriesFor: #GetSource:!**auto generated**!COM Interfaces-OAIDL.IErrorInfo!public! !
!OS.COM.IErrorInfo categoriesFor: #guid!accessing!public! !
!OS.COM.IErrorInfo categoriesFor: #helpContext!accessing!public! !
!OS.COM.IErrorInfo categoriesFor: #helpFile!accessing!public! !
!OS.COM.IErrorInfo categoriesFor: #printOn:!printing!public! !
!OS.COM.IErrorInfo categoriesFor: #source!accessing!public! !
!OS.COM.IErrorInfo categoriesFor: #sourceInterface!accessing!public! !

!OS.COM.IErrorInfo class methodsFor!

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
! !
!OS.COM.IErrorInfo class categoriesFor: #defineFunctions!**auto generated**!public! !

