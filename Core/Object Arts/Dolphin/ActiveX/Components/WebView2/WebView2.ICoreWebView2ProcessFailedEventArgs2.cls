"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ProcessFailedEventArgs subclass: #'WebView2.ICoreWebView2ProcessFailedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ProcessFailedEventArgs2 guid: (OS.COM.IID fromString: '{4dab9422-46fa-4c3e-a5d2-41d2071d3680}')!
WebView2.ICoreWebView2ProcessFailedEventArgs2 comment: '`ICoreWebView2ProcessFailedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessFailedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4dab9422-46fa-4c3e-a5d2-41d2071d3680)
]
interface ICoreWebView2ProcessFailedEventArgs2 : ICoreWebView2ProcessFailedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall reason(
		[out, retval]COREWEBVIEW2_PROCESS_FAILED_REASON* reason);
	[id(0x60020001), propget]
	HRESULT __stdcall ExitCode(
		[out, retval]int* ExitCode);
	[id(0x60020002), propget]
	HRESULT __stdcall ProcessDescription(
		[out, retval]LPWSTR* ProcessDescription);
	[id(0x60020003), propget]
	HRESULT __stdcall FrameInfosForFailedProcess(
		[out, retval]ICoreWebView2FrameInfoCollection** frames);
};
```
'!
!WebView2.ICoreWebView2ProcessFailedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ProcessFailedEventArgs2 methodsFor!

get_ExitCode: exitCode
	"Private - Get the value of the 'ExitCode' property of the receiver.

		HRESULT __stdcall ExitCode(
			[out, retval]int* ExitCode);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_FrameInfosForFailedProcess: frames
	"Private - Get the value of the 'FrameInfosForFailedProcess' property of the receiver.

		HRESULT __stdcall FrameInfosForFailedProcess(
			[out, retval]ICoreWebView2FrameInfoCollection** frames);"

	<virtual stdcall: hresult 8 ICoreWebView2FrameInfoCollection**>
	^self invalidCall: _failureCode!

get_ProcessDescription: processDescription
	"Private - Get the value of the 'ProcessDescription' property of the receiver.

		HRESULT __stdcall ProcessDescription(
			[out, retval]LPWSTR* ProcessDescription);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

get_reason: reason
	"Private - Get the value of the 'reason' property of the receiver.

		HRESULT __stdcall reason(
			[out, retval]COREWEBVIEW2_PROCESS_FAILED_REASON* reason);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ProcessFailedEventArgs2 categoriesForMethods!
get_ExitCode:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
get_FrameInfosForFailedProcess:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
get_ProcessDescription:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
get_reason:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs2!private! !
!

!WebView2.ICoreWebView2ProcessFailedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventArgs2'
		ICoreWebView2ProcessFailedEventArgs2 defineTemplate"

	self
		defineFunction: #get_reason:
			argumentTypes: 'sdword*';
		defineFunction: #get_ExitCode:
			argumentTypes: 'sdword*';
		defineFunction: #get_ProcessDescription:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_FrameInfosForFailedProcess:
			argumentTypes: 'ICoreWebView2FrameInfoCollection**'
! !
!WebView2.ICoreWebView2ProcessFailedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

