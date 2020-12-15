"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WinHttp.IWinHttpRequestEvents'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WinHttp.IWinHttpRequestEvents guid: (OS.COM.IID fromString: '{f97f4e15-b787-4212-80d1-d380cbbf982e}')!
WinHttp.IWinHttpRequestEvents comment: '`IWinHttpRequestEvents` is a wrapper class for the COM interface ''WinHttp.IWinHttpRequestEvents'' generated from type information in the ''Microsoft WinHTTP Services, version 5.1'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IWinHttpRequestEvents Interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f97f4e15-b787-4212-80d1-d380cbbf982e), 
	helpstring("IWinHttpRequestEvents Interface"), 
	nonextensible, 
	oleautomation
]
interface IWinHttpRequestEvents : IUnknown
 {
	[id(0x60010000)]
	void __stdcall OnResponseStart(
		[in]long Status,
		[in]BSTR ContentType);
	[id(0x60010001)]
	void __stdcall OnResponseDataAvailable(
		[in]SAFEARRAY(BYTE)* Data);
	[id(0x60010002)]
	void __stdcall OnResponseFinished();
	[id(0x60010003)]
	void __stdcall OnError(
		[in]long ErrorNumber,
		[in]BSTR ErrorDescription);
};
```
'!
!WinHttp.IWinHttpRequestEvents categoriesForClass!COM-Interfaces!WinHttp-Interfaces! !
!WinHttp.IWinHttpRequestEvents methodsFor!

OnError: errorNumber errorDescription: errorDescription
	"Invoke the OnError() method of the COM object.

		void __stdcall OnError(
			[in]long ErrorNumber,
			[in]BSTR ErrorDescription);"

	<virtual stdcall: void 7 sdword bstr>
	^self invalidCall: _failureCode!

OnResponseDataAvailable: data
	"Invoke the OnResponseDataAvailable() method of the COM object.

		void __stdcall OnResponseDataAvailable(
			[in]SAFEARRAY(BYTE)* Data);"

	<virtual stdcall: void 5 SAFEARRAY**>
	^self invalidCall: _failureCode!

OnResponseFinished
	"Invoke the OnResponseFinished() method of the COM object.

		void __stdcall OnResponseFinished();"

	<virtual stdcall: void 6>
	^self invalidCall: _failureCode!

OnResponseStart: status contentType: contentType
	"Invoke the OnResponseStart() method of the COM object.

		void __stdcall OnResponseStart(
			[in]long Status,
			[in]BSTR ContentType);"

	<virtual stdcall: void 4 sdword bstr>
	^self invalidCall: _failureCode! !
!WinHttp.IWinHttpRequestEvents categoriesFor: #OnError:errorDescription:!**auto generated**!COM Interfaces-IWinHttpRequestEvents!public! !
!WinHttp.IWinHttpRequestEvents categoriesFor: #OnResponseDataAvailable:!**auto generated**!COM Interfaces-IWinHttpRequestEvents!public! !
!WinHttp.IWinHttpRequestEvents categoriesFor: #OnResponseFinished!**auto generated**!COM Interfaces-IWinHttpRequestEvents!public! !
!WinHttp.IWinHttpRequestEvents categoriesFor: #OnResponseStart:contentType:!**auto generated**!COM Interfaces-IWinHttpRequestEvents!public! !

!WinHttp.IWinHttpRequestEvents class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WinHttp.IWinHttpRequestEvents'
		IWinHttpRequestEvents defineTemplate"

	self
		defineFunction: #OnResponseStart:contentType:
			returnType: 'void'
			argumentTypes: 'sdword bstr';
		defineFunction: #OnResponseDataAvailable:
			returnType: 'void'
			argumentTypes: 'SAFEARRAY**';
		defineFunction: #OnResponseFinished
			returnType: 'void';
		defineFunction: #OnError:errorDescription:
			returnType: 'void'
			argumentTypes: 'sdword bstr'
! !
!WinHttp.IWinHttpRequestEvents class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

