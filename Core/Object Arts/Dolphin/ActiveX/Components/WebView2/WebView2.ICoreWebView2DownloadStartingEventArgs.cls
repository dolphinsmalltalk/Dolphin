﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2DownloadStartingEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DownloadStartingEventArgs guid: (OS.COM.IID fromString: '{e99bbe21-43e9-4544-a732-282764eafa60}')!

WebView2.ICoreWebView2DownloadStartingEventArgs isEgressOnly: true!

WebView2.ICoreWebView2DownloadStartingEventArgs comment: '`ICoreWebView2DownloadStartingEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DownloadStartingEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e99bbe21-43e9-4544-a732-282764eafa60)
]
interface ICoreWebView2DownloadStartingEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall DownloadOperation(
		[out, retval]ICoreWebView2DownloadOperation** DownloadOperation);
	[id(0x60010001), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* Cancel);
	[id(0x60010001), propput]
	HRESULT __stdcall Cancel(
		[in]long Cancel);
	[id(0x60010003), propget]
	HRESULT __stdcall ResultFilePath(
		[out, retval]LPWSTR* ResultFilePath);
	[id(0x60010003), propput]
	HRESULT __stdcall ResultFilePath(
		[in]LPWSTR ResultFilePath);
	[id(0x60010005), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* Handled);
	[id(0x60010005), propput]
	HRESULT __stdcall Handled(
		[in]long Handled);
	[id(0x60010007)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!

!WebView2.ICoreWebView2DownloadStartingEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2DownloadStartingEventArgs methodsFor!

downloadOperation
	"Answer the <ICoreWebView2DownloadOperation> value of the 'DownloadOperation' property of the receiver."

	| answer |
	answer := ICoreWebView2DownloadOperation newPointer.
	self get_DownloadOperation: answer.
	^answer asObject!

get_Cancel: cancel
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* Cancel);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

get_DownloadOperation: downloadOperation
	"Private - Get the value of the 'DownloadOperation' property of the receiver.

		HRESULT __stdcall DownloadOperation(
			[out, retval]ICoreWebView2DownloadOperation** DownloadOperation);"

	<virtual stdcall: hresult 4 ICoreWebView2DownloadOperation**>
	^self invalidCall: _failureCode!

get_Handled: handled
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* Handled);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_ResultFilePath: resultFilePath
	"Private - Get the value of the 'ResultFilePath' property of the receiver.

		HRESULT __stdcall ResultFilePath(
			[out, retval]LPWSTR* ResultFilePath);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 11 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

printableProperties
	^#(#downloadOperation resultFilePath)!

put_Cancel: cancel
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <sdword> argument, cancel.

		HRESULT __stdcall Cancel(
			[in]long Cancel);"

	<virtual stdcall: hresult 6 int32>
	^self invalidCall: _failureCode!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	<virtual stdcall: hresult 10 int32>
	^self invalidCall: _failureCode!

put_ResultFilePath: resultFilePath
	"Private - Set the value of the 'ResultFilePath' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, resultFilePath.

		HRESULT __stdcall ResultFilePath(
			[in]LPWSTR ResultFilePath);"

	<virtual stdcall: hresult 8 lpwstr>
	^self invalidCall: _failureCode!

resultFilePath
	"Answer the <lpwstr> value of the 'ResultFilePath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ResultFilePath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

resultFilePath: resultFilePath
	"Set the 'ResultFilePath' property of the receiver to the <lpwstr> value of the argument."

	self put_ResultFilePath: resultFilePath asUtf16String! !

!WebView2.ICoreWebView2DownloadStartingEventArgs categoriesForMethods!
downloadOperation!**auto generated**!properties!public! !
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
get_DownloadOperation:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
get_ResultFilePath:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
printableProperties!printing!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
put_ResultFilePath:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventArgs!private! !
resultFilePath!properties!public! !
resultFilePath:!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2DownloadStartingEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DownloadStartingEventArgs'
		ICoreWebView2DownloadStartingEventArgs defineTemplate"

	self
		defineFunction: #get_DownloadOperation:
			argumentTypes: 'ICoreWebView2DownloadOperation**';
		defineFunction: #get_Cancel:
			argumentTypes: 'sdword*';
		defineFunction: #put_Cancel:
			argumentTypes: 'sdword';
		defineFunction: #get_ResultFilePath:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_ResultFilePath:
			argumentTypes: 'lpwstr';
		defineFunction: #get_Handled:
			argumentTypes: 'sdword*';
		defineFunction: #put_Handled:
			argumentTypes: 'sdword';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !

!WebView2.ICoreWebView2DownloadStartingEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

