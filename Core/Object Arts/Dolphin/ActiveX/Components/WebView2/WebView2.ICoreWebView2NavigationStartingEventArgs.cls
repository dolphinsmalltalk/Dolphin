"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs subclass: #'WebView2.ICoreWebView2NavigationStartingEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NavigationStartingEventArgs guid: (OS.COM.IID fromString: '{5b495469-e119-438a-9b18-7604f25f2e49}')!
WebView2.ICoreWebView2NavigationStartingEventArgs comment: '`ICoreWebView2NavigationStartingEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationStartingEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5b495469-e119-438a-9b18-7604f25f2e49)
]
interface ICoreWebView2NavigationStartingEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* uri);
	[id(0x60010001), propget]
	HRESULT __stdcall IsUserInitiated(
		[out, retval]long* IsUserInitiated);
	[id(0x60010002), propget]
	HRESULT __stdcall IsRedirected(
		[out, retval]long* IsRedirected);
	[id(0x60010003), propget]
	HRESULT __stdcall RequestHeaders(
		[out, retval]ICoreWebView2HttpRequestHeaders** RequestHeaders);
	[id(0x60010004), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* Cancel);
	[id(0x60010004), propput]
	HRESULT __stdcall Cancel(
		[in]long Cancel);
	[id(0x60010006), propget]
	HRESULT __stdcall NavigationId(
		[out, retval]unsigned __int64* NavigationId);
};
```
'!
!WebView2.ICoreWebView2NavigationStartingEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NavigationStartingEventArgs methodsFor!

additionalAllowedFrameAncestors
	"Answer the <lpwstr> value of the 'AdditionalAllowedFrameAncestors' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_AdditionalAllowedFrameAncestors: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

additionalAllowedFrameAncestors: value
	"Set the 'AdditionalAllowedFrameAncestors' property of the receiver to the <lpwstr> value of the argument."

	self put_AdditionalAllowedFrameAncestors: value asUtf16String!

cancel
	"Answer whether the navigation is to be cancelled."

	| answer |
	answer := BOOL newBuffer.
	self get_Cancel: answer.
	^answer asObject!

cancel: aBoolean
	"Set whether the navigation should be cancelled."

	self put_Cancel: aBoolean asParameter!

get_AdditionalAllowedFrameAncestors: value
	^E_NOTIMPL!

get_Cancel: cancel
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* Cancel);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_IsRedirected: isRedirected
	"Private - Get the value of the 'IsRedirected' property of the receiver.

		HRESULT __stdcall IsRedirected(
			[out, retval]long* IsRedirected);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode!

get_IsUserInitiated: isUserInitiated
	"Private - Get the value of the 'IsUserInitiated' property of the receiver.

		HRESULT __stdcall IsUserInitiated(
			[out, retval]long* IsUserInitiated);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

get_NavigationId: navigationId
	"Private - Get the value of the 'NavigationId' property of the receiver.

		HRESULT __stdcall NavigationId(
			[out, retval]unsigned __int64* NavigationId);"

	<virtual stdcall: hresult 10 qword*>
	^self invalidCall: _failureCode!

get_RequestHeaders: requestHeaders
	"Private - Get the value of the 'RequestHeaders' property of the receiver.

		HRESULT __stdcall RequestHeaders(
			[out, retval]ICoreWebView2HttpRequestHeaders** RequestHeaders);"

	<virtual stdcall: hresult 7 ICoreWebView2HttpRequestHeaders**>
	^self invalidCall: _failureCode!

get_uri: uri
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

isRedirected
	"Answer whether the navigation is a redirection."

	| answer |
	answer := BOOL newBuffer.
	self get_IsRedirected: answer.
	^answer asObject!

isUserInitiated
	"Answer whether the navigation is user initiated, which includes programmatic navigations."

	| answer |
	answer := BOOL newBuffer.
	self get_IsUserInitiated: answer.
	^answer asObject!

navigationId
	"Answer the <qword> value of the 'NavigationId' property of the receiver."

	| answer |
	answer := ULARGE_INTEGER new.
	self get_NavigationId: answer.
	^answer asObject!

printableProperties
	^#(#navigationId #uri)!

put_AdditionalAllowedFrameAncestors: value
	"Private - Set the value of the 'AdditionalAllowedFrameAncestors' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall AdditionalAllowedFrameAncestors(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 12 lpwstr>
	^self invalidCall: _failureCode!

put_Cancel: cancel
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <sdword> argument, cancel.

		HRESULT __stdcall Cancel(
			[in]long Cancel);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall: _failureCode!

requestHeaders
	"Answer the <ICoreWebView2HttpRequestHeaders> value of the 'RequestHeaders' property of the receiver."

	| answer |
	answer := ICoreWebView2HttpRequestHeaders newPointer.
	self get_RequestHeaders: answer.
	^answer asObject!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2NavigationStartingEventArgs categoriesForMethods!
additionalAllowedFrameAncestors!properties!public! !
additionalAllowedFrameAncestors:!properties!public! !
cancel!properties!public! !
cancel:!properties!public! !
get_AdditionalAllowedFrameAncestors:!COM Interfaces-ICoreWebView2NavigationStartingEventArgs2!private! !
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
get_IsRedirected:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
get_IsUserInitiated:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
get_NavigationId:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
get_RequestHeaders:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
isRedirected!properties!public! !
isUserInitiated!properties!public! !
navigationId!**auto generated**!properties!public! !
printableProperties!printing!private! !
put_AdditionalAllowedFrameAncestors:!COM Interfaces-ICoreWebView2NavigationStartingEventArgs2!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventArgs!private! !
requestHeaders!**auto generated**!properties!public! !
uri!properties!public! !
!

!WebView2.ICoreWebView2NavigationStartingEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationStartingEventArgs'
		ICoreWebView2NavigationStartingEventArgs defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_IsUserInitiated:
			argumentTypes: 'sdword*';
		defineFunction: #get_IsRedirected:
			argumentTypes: 'sdword*';
		defineFunction: #get_RequestHeaders:
			argumentTypes: 'ICoreWebView2HttpRequestHeaders**';
		defineFunction: #get_Cancel:
			argumentTypes: 'sdword*';
		defineFunction: #put_Cancel:
			argumentTypes: 'sdword';
		defineFunction: #get_NavigationId:
			argumentTypes: 'qword*'
! !
!WebView2.ICoreWebView2NavigationStartingEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

