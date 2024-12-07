"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs guid: (OS.COM.IID fromString: '{07d1a6c3-7175-4ba1-9306-e593ca07e46c}')!

WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs isEgressOnly: true!

WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs comment: '`ICoreWebView2LaunchingExternalUriSchemeEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(07d1a6c3-7175-4ba1-9306-e593ca07e46c)
]
interface ICoreWebView2LaunchingExternalUriSchemeEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall InitiatingOrigin(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propget]
	HRESULT __stdcall IsUserInitiated(
		[out, retval]long* value);
	[id(0x60010003), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* value);
	[id(0x60010003), propput]
	HRESULT __stdcall Cancel(
		[in]long value);
	[id(0x60010005)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** value);
};
```
'!

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs methodsFor!

get_Cancel: value
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* value);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

get_InitiatingOrigin: value
	"Private - Get the value of the 'InitiatingOrigin' property of the receiver.

		HRESULT __stdcall InitiatingOrigin(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_IsUserInitiated: value
	"Private - Get the value of the 'IsUserInitiated' property of the receiver.

		HRESULT __stdcall IsUserInitiated(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_uri: value
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

GetDeferral: value
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** value);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

initiatingOrigin
	"Answer the <lpwstr> value of the 'InitiatingOrigin' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_InitiatingOrigin: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

isUserInitiated
	"Answer the <Boolean> value of the 'IsUserInitiated' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsUserInitiated: buf.
	^buf asBoolean!

printableProperties
	^#(#uri #isUserInitiated #initiatingOrigin)!

put_Cancel: value
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall Cancel(
			[in]long value);"

	<virtual stdcall: hresult 8 int32>
	^self invalidCall: _failureCode!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs categoriesForMethods!
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventArgs!private! !
get_InitiatingOrigin:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventArgs!private! !
get_IsUserInitiated:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventArgs!private! !
initiatingOrigin!properties!public! !
isUserInitiated!properties!public! !
printableProperties!printing!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventArgs!private! !
uri!properties!public! !
!

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs'
		ICoreWebView2LaunchingExternalUriSchemeEventArgs defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_InitiatingOrigin:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_IsUserInitiated:
			argumentTypes: 'int32*';
		defineFunction: #get_Cancel:
			argumentTypes: 'int32*';
		defineFunction: #put_Cancel:
			argumentTypes: 'int32';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

