﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2NavigationCompletedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NavigationCompletedEventArgs guid: (OS.COM.IID fromString: '{30d68b7d-20d9-4752-a9ca-ec8448fbb5c1}')!

WebView2.ICoreWebView2NavigationCompletedEventArgs isEgressOnly: true!

WebView2.ICoreWebView2NavigationCompletedEventArgs comment: '`ICoreWebView2NavigationCompletedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationCompletedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(30d68b7d-20d9-4752-a9ca-ec8448fbb5c1)
]
interface ICoreWebView2NavigationCompletedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsSuccess(
		[out, retval]long* IsSuccess);
	[id(0x60010001), propget]
	HRESULT __stdcall WebErrorStatus(
		[out, retval]COREWEBVIEW2_WEB_ERROR_STATUS* WebErrorStatus);
	[id(0x60010002), propget]
	HRESULT __stdcall NavigationId(
		[out, retval]unsigned __int64* NavigationId);
};
```
'!

!WebView2.ICoreWebView2NavigationCompletedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NavigationCompletedEventArgs methodsFor!

get_HttpStatusCode: http_status_code
	"Private - Get the value of the 'HttpStatusCode' property of the receiver.

		HRESULT __stdcall HttpStatusCode(
			[out, retval]int* http_status_code);"

	^E_NOTIMPL!

get_IsSuccess: isSuccess
	"Private - Get the value of the 'IsSuccess' property of the receiver.

		HRESULT __stdcall IsSuccess(
			[out, retval]long* IsSuccess);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_NavigationId: navigationId
	"Private - Get the value of the 'NavigationId' property of the receiver.

		HRESULT __stdcall NavigationId(
			[out, retval]unsigned __int64* NavigationId);"

	<virtual stdcall: hresult 6 uint64*>
	^self invalidCall: _failureCode!

get_WebErrorStatus: webErrorStatus
	"Private - Get the value of the 'WebErrorStatus' property of the receiver.

		HRESULT __stdcall WebErrorStatus(
			[out, retval]COREWEBVIEW2_WEB_ERROR_STATUS* WebErrorStatus);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

httpStatusCode
	"Answer the <integer> value of the 'HttpStatusCode' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_HttpStatusCode: buf.
	^buf asSignedInteger!

isSuccess
	"Answer the <Boolean> value of the 'IsSuccess' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsSuccess: buf.
	^buf asBoolean!

navigationId
	"Answer the <integer> value of the 'NavigationId' property of the receiver."

	| buf |
	buf := UInt64Bytes new.
	self get_NavigationId: buf.
	^buf asInteger!

printableProperties
	^#(#navigationId #isSuccess #webErrorStatus #httpStatusCode)!

webErrorStatus
	"Answer the COREWEBVIEW2_WEB_ERROR_STATUS enumeration value of the 'WebErrorStatus' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_WebErrorStatus: buf.
	^buf asSignedInteger! !

!WebView2.ICoreWebView2NavigationCompletedEventArgs categoriesForMethods!
get_HttpStatusCode:!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs2!private! !
get_IsSuccess:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs!private! !
get_NavigationId:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs!private! !
get_WebErrorStatus:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs!private! !
httpStatusCode!properties!public! !
isSuccess!properties!public! !
navigationId!properties!public! !
printableProperties!printing!private! !
webErrorStatus!properties!public! !
!

!WebView2.ICoreWebView2NavigationCompletedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationCompletedEventArgs'
		ICoreWebView2NavigationCompletedEventArgs defineTemplate"

	self
		defineFunction: #get_IsSuccess:
			argumentTypes: 'sdword*';
		defineFunction: #get_WebErrorStatus:
			argumentTypes: 'sdword*';
		defineFunction: #get_NavigationId:
			argumentTypes: 'qword*'
!

latestDerivation
	^##(super latestDerivation)! !

!WebView2.ICoreWebView2NavigationCompletedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

