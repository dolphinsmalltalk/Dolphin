"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ICreateErrorInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ICreateErrorInfo guid: (IID fromString: '{22f03340-547d-101b-8e65-08002b2bd119}')!
ICreateErrorInfo comment: '<ICreateErrorInfo> is a wrapper class for the custom interface ''OAIDL.ICreateErrorInfo'' from type information in the ''Ole Automation Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.
'!
!ICreateErrorInfo categoriesForClass!COM-Interfaces! !
!ICreateErrorInfo methodsFor!

errorInfo
	"Answer an IErrorInfo on the receiver's object."

	^self queryInterface: IErrorInfo!

SetDescription: szDescription
	"Invoke the SetDescription() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetDescription(
			[in] LPWSTR szDescription);

	"

	<virtual stdcall: hresult 6 lpwstr>
	^self invalidCall: _failureCode!

SetGuid: rguid
	"Invoke the SetGuid() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetGuid(
			[in] GUID* rguid);

	"

	<virtual stdcall: hresult 4 guid*>
	^self invalidCall: _failureCode!

SetHelpContext: dwHelpContext
	"Invoke the SetHelpContext() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetHelpContext(
			[in] unsigned long dwHelpContext);

	"

	<virtual stdcall: hresult 8 dword>
	^self invalidCall: _failureCode!

SetHelpFile: szHelpFile
	"Invoke the SetHelpFile() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetHelpFile(
			[in] LPWSTR szHelpFile);

	"

	<virtual stdcall: hresult 7 lpwstr>
	^self invalidCall: _failureCode!

SetSource: szSource
	"Invoke the SetSource() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetSource(
			[in] LPWSTR szSource);

	"

	<virtual stdcall: hresult 5 lpwstr>
	^self invalidCall: _failureCode! !
!ICreateErrorInfo categoriesFor: #errorInfo!accessing-interfaces!public! !
!ICreateErrorInfo categoriesFor: #SetDescription:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
!ICreateErrorInfo categoriesFor: #SetGuid:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
!ICreateErrorInfo categoriesFor: #SetHelpContext:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
!ICreateErrorInfo categoriesFor: #SetHelpFile:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
!ICreateErrorInfo categoriesFor: #SetSource:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !

!ICreateErrorInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OAIDL.ICreateErrorInfo'
		ICreateErrorInfo defineTemplate
	"

	self
		defineFunction: #SetGuid:
			argumentTypes: 'GUID*';
		defineFunction: #SetSource:
			argumentTypes: 'lpwstr';
		defineFunction: #SetDescription:
			argumentTypes: 'lpwstr';
		defineFunction: #SetHelpFile:
			argumentTypes: 'lpwstr';
		defineFunction: #SetHelpContext:
			argumentTypes: 'dword'
!

fromEXCEPINFO: excepInfo guid: id
	"Answer a new instance of the receiver on a system extended error object
	with details from the <EXCEPINFO> structure, excepInfo."

	| answer |
	answer := self new.
	id notNull ifTrue: [answer SetGuid: id].
	^answer
		SetSource: excepInfo wstrSource;
		SetDescription: excepInfo wstrDescription;
		SetHelpContext: excepInfo dwHelpContext;
		SetHelpFile: excepInfo wstrHelpFile;
		yourself!

new
	"Answer a new instance of the receiver on a new error info. object (implemented by the system)"

	| answer |
	answer := self newPointer.
	OLEAutLibrary default createErrorInfo: answer.
	^answer! !
!ICreateErrorInfo class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ICreateErrorInfo class categoriesFor: #fromEXCEPINFO:guid:!instance creation!public! !
!ICreateErrorInfo class categoriesFor: #new!instance creation!public! !

