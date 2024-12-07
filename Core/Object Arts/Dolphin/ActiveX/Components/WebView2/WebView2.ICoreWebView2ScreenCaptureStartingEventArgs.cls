"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2ScreenCaptureStartingEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ScreenCaptureStartingEventArgs guid: (OS.COM.IID fromString: '{892c03fd-aee3-5eba-a1fa-6fd2f6484b2b}')!

WebView2.ICoreWebView2ScreenCaptureStartingEventArgs comment: '`ICoreWebView2ScreenCaptureStartingEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ScreenCaptureStartingEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(892c03fd-aee3-5eba-a1fa-6fd2f6484b2b)
]
interface ICoreWebView2ScreenCaptureStartingEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* value);
	[id(0x60010000), propput]
	HRESULT __stdcall Cancel(
		[in]long value);
	[id(0x60010002), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* value);
	[id(0x60010002), propput]
	HRESULT __stdcall Handled(
		[in]long value);
	[id(0x60010004), propget]
	HRESULT __stdcall OriginalSourceFrameInfo(
		[out, retval]ICoreWebView2FrameInfo** value);
	[id(0x60010005)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** value);
};
```
'!

!WebView2.ICoreWebView2ScreenCaptureStartingEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ScreenCaptureStartingEventArgs methodsFor!

get_Cancel: value
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_Handled: value
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_OriginalSourceFrameInfo: value
	"Private - Get the value of the 'OriginalSourceFrameInfo' property of the receiver.

		HRESULT __stdcall OriginalSourceFrameInfo(
			[out, retval]ICoreWebView2FrameInfo** value);"

	<virtual stdcall: hresult 8 ICoreWebView2FrameInfo**>
	^self invalidCall: _failureCode!

GetDeferral: value
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** value);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

originalSourceFrameInfo
	"Answer the <ICoreWebView2FrameInfo> value of the 'OriginalSourceFrameInfo' property of the receiver."

	| answer |
	answer := ICoreWebView2FrameInfo newPointer.
	self get_OriginalSourceFrameInfo: answer.
	^answer asObject!

printableProperties
	^#(#originalSourceFrameInfo cancel handled)!

put_Cancel: value
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall Cancel(
			[in]long value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode!

put_Handled: value
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall Handled(
			[in]long value);"

	<virtual stdcall: hresult 7 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ScreenCaptureStartingEventArgs categoriesForMethods!
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventArgs!private! !
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventArgs!private! !
get_OriginalSourceFrameInfo:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventArgs!private! !
originalSourceFrameInfo!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventArgs!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventArgs!private! !
!

!WebView2.ICoreWebView2ScreenCaptureStartingEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ScreenCaptureStartingEventArgs'
		ICoreWebView2ScreenCaptureStartingEventArgs defineTemplate"

	self
		defineFunction: #get_Cancel:
			argumentTypes: 'int32*';
		defineFunction: #put_Cancel:
			argumentTypes: 'int32';
		defineFunction: #get_Handled:
			argumentTypes: 'int32*';
		defineFunction: #put_Handled:
			argumentTypes: 'int32';
		defineFunction: #get_OriginalSourceFrameInfo:
			argumentTypes: 'ICoreWebView2FrameInfo**';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !

!WebView2.ICoreWebView2ScreenCaptureStartingEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

