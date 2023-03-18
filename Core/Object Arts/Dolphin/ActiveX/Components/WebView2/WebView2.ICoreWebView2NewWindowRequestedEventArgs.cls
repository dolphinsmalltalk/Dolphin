"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2NewWindowRequestedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NewWindowRequestedEventArgs guid: (OS.COM.IID fromString: '{34acb11c-fc37-4418-9132-f9c21d1eafb9}')!
WebView2.ICoreWebView2NewWindowRequestedEventArgs comment: '`ICoreWebView2NewWindowRequestedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewWindowRequestedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(34acb11c-fc37-4418-9132-f9c21d1eafb9)
]
interface ICoreWebView2NewWindowRequestedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* uri);
	[id(0x60010001), propput]
	HRESULT __stdcall NewWindow(
		[in]ICoreWebView2* NewWindow);
	[id(0x60010001), propget]
	HRESULT __stdcall NewWindow(
		[out, retval]ICoreWebView2** NewWindow);
	[id(0x60010003), propput]
	HRESULT __stdcall Handled(
		[in]long Handled);
	[id(0x60010003), propget]
	HRESULT __stdcall Handled(
		[out, retval]long* Handled);
	[id(0x60010005), propget]
	HRESULT __stdcall IsUserInitiated(
		[out, retval]long* IsUserInitiated);
	[id(0x60010006)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
	[id(0x60010007), propget]
	HRESULT __stdcall WindowFeatures(
		[out, retval]ICoreWebView2WindowFeatures** value);
};
```
'!
!WebView2.ICoreWebView2NewWindowRequestedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NewWindowRequestedEventArgs methodsFor!

get_Handled: handled
	"Private - Get the value of the 'Handled' property of the receiver.

		HRESULT __stdcall Handled(
			[out, retval]long* Handled);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

get_IsUserInitiated: isUserInitiated
	"Private - Get the value of the 'IsUserInitiated' property of the receiver.

		HRESULT __stdcall IsUserInitiated(
			[out, retval]long* IsUserInitiated);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_name: value
	^E_NOTIMPL!

get_NewWindow: newWindow
	"Private - Get the value of the 'NewWindow' property of the receiver.

		HRESULT __stdcall NewWindow(
			[out, retval]ICoreWebView2** NewWindow);"

	<virtual stdcall: hresult 6 ICoreWebView2**>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_WindowFeatures: value
	"Private - Get the value of the 'WindowFeatures' property of the receiver.

		HRESULT __stdcall WindowFeatures(
			[out, retval]ICoreWebView2WindowFeatures** value);"

	<virtual stdcall: hresult 11 ICoreWebView2WindowFeatures**>
	^self invalidCall: _failureCode!

getDeferral
	"Answer the <ICoreWebView2Deferral> result of invoking the GetDeferral() method of the COM object."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 10 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

handled
	"Answer the <Boolean> value of the 'Handled' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_Handled: buf.
	^buf asBoolean!

handled: handled
	"Set the 'Handled' property of the receiver to the <sdword> value of the argument."

	self put_Handled: handled asParameter!

isUserInitiated
	"Answer the <Boolean> value of the 'IsUserInitiated' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsUserInitiated: buf.
	^buf asBoolean!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

newWindow
	"Answer the <ICoreWebView2> value of the 'NewWindow' property of the receiver."

	| answer |
	answer := ICoreWebView2 newPointer.
	self get_NewWindow: answer.
	^answer asObject!

newWindow: newWindow
	"Set the 'NewWindow' property of the receiver to the <ICoreWebView2*> value of the argument."

	self put_NewWindow: newWindow!

printableProperties
	^#(#name #uri #isUserInitiated #windowFeatures)!

put_Handled: handled
	"Private - Set the value of the 'Handled' property of the object wrapped by the 
	 receiver to the <sdword> argument, handled.

		HRESULT __stdcall Handled(
			[in]long Handled);"

	<virtual stdcall: hresult 7 int32>
	^self invalidCall: _failureCode!

put_NewWindow: newWindow
	"Private - Set the value of the 'NewWindow' property of the object wrapped by the 
	 receiver to the <ICoreWebView2*> argument, newWindow.

		HRESULT __stdcall NewWindow(
			[in]ICoreWebView2* NewWindow);"

	<virtual stdcall: hresult 5 ICoreWebView2*>
	^self invalidCall: _failureCode!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

windowFeatures
	"Answer the <ICoreWebView2WindowFeatures> value of the 'WindowFeatures' property of the receiver."

	| answer |
	answer := ICoreWebView2WindowFeatures newPointer.
	self get_WindowFeatures: answer.
	^answer asObject! !
!WebView2.ICoreWebView2NewWindowRequestedEventArgs categoriesForMethods!
get_Handled:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
get_IsUserInitiated:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs2!private! !
get_NewWindow:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
get_WindowFeatures:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
getDeferral!**auto generated**!methods!public! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
handled!properties!public! !
handled:!properties!public! !
isUserInitiated!properties!public! !
name!properties!public! !
newWindow!**auto generated**!properties!public! !
newWindow:!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_Handled:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
put_NewWindow:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs!private! !
uri!properties!public! !
windowFeatures!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2NewWindowRequestedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewWindowRequestedEventArgs'
		ICoreWebView2NewWindowRequestedEventArgs defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_NewWindow:
			argumentTypes: 'ICoreWebView2*';
		defineFunction: #get_NewWindow:
			argumentTypes: 'ICoreWebView2**';
		defineFunction: #put_Handled:
			argumentTypes: 'sdword';
		defineFunction: #get_Handled:
			argumentTypes: 'sdword*';
		defineFunction: #get_IsUserInitiated:
			argumentTypes: 'sdword*';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**';
		defineFunction: #get_WindowFeatures:
			argumentTypes: 'ICoreWebView2WindowFeatures**'
! !
!WebView2.ICoreWebView2NewWindowRequestedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

