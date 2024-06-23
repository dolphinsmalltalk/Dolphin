"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.ICreateErrorInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.ICreateErrorInfo guid: (OS.COM.IID fromString: '{22f03340-547d-101b-8e65-08002b2bd119}')!

OS.COM.ICreateErrorInfo isEgressOnly: true!

OS.COM.ICreateErrorInfo comment: '`OS.COM.ICreateErrorInfo` is a wrapper class for the custom interface ''OAIDL.ICreateErrorInfo'' from type information in the ''Ole Automation Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.
'!

!OS.COM.ICreateErrorInfo categoriesForClass!COM-Interfaces! !

!OS.COM.ICreateErrorInfo methodsFor!

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

	<virtual stdcall: hresult 8 uint32>
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

!OS.COM.ICreateErrorInfo categoriesForMethods!
errorInfo!accessing-interfaces!public! !
SetDescription:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
SetGuid:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
SetHelpContext:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
SetHelpFile:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
SetSource:!**auto generated**!COM Interfaces-OAIDL.ICreateErrorInfo!private! !
!

!OS.COM.ICreateErrorInfo class methodsFor!

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
	OleAut32 createErrorInfo: answer.
	^answer! !

!OS.COM.ICreateErrorInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
fromEXCEPINFO:guid:!instance creation!public! !
new!instance creation!public! !
!

