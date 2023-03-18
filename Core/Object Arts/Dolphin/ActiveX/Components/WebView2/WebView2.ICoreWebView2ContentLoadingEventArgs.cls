"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2ContentLoadingEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ContentLoadingEventArgs guid: (OS.COM.IID fromString: '{0c8a1275-9b6b-4901-87ad-70df25bafa6e}')!
WebView2.ICoreWebView2ContentLoadingEventArgs comment: '`ICoreWebView2ContentLoadingEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContentLoadingEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0c8a1275-9b6b-4901-87ad-70df25bafa6e)
]
interface ICoreWebView2ContentLoadingEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsErrorPage(
		[out, retval]long* IsErrorPage);
	[id(0x60010001), propget]
	HRESULT __stdcall NavigationId(
		[out, retval]unsigned __int64* NavigationId);
};
```
'!
!WebView2.ICoreWebView2ContentLoadingEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ContentLoadingEventArgs methodsFor!

get_IsErrorPage: isErrorPage
	"Private - Get the value of the 'IsErrorPage' property of the receiver.

		HRESULT __stdcall IsErrorPage(
			[out, retval]long* IsErrorPage);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

get_NavigationId: navigationId
	"Private - Get the value of the 'NavigationId' property of the receiver.

		HRESULT __stdcall NavigationId(
			[out, retval]unsigned __int64* NavigationId);"

	<virtual stdcall: hresult 5 uint64*>
	^self invalidCall: _failureCode!

isErrorPage
	"Answer the <Boolean> value of the 'IsErrorPage' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsErrorPage: buf.
	^buf asBoolean!

navigationId
	"Answer the <qword> value of the 'NavigationId' property of the receiver."

	| answer |
	answer := UInt64 new.
	self get_NavigationId: answer.
	^answer asObject!

printableProperties
	^#(#navigationId #isErrorPage)! !
!WebView2.ICoreWebView2ContentLoadingEventArgs categoriesForMethods!
get_IsErrorPage:!**auto generated**!COM Interfaces-ICoreWebView2ContentLoadingEventArgs!private! !
get_NavigationId:!**auto generated**!COM Interfaces-ICoreWebView2ContentLoadingEventArgs!private! !
isErrorPage!properties!public! !
navigationId!**auto generated**!properties!public! !
printableProperties!printing!private! !
!

!WebView2.ICoreWebView2ContentLoadingEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContentLoadingEventArgs'
		ICoreWebView2ContentLoadingEventArgs defineTemplate"

	self
		defineFunction: #get_IsErrorPage:
			argumentTypes: 'sdword*';
		defineFunction: #get_NavigationId:
			argumentTypes: 'qword*'
! !
!WebView2.ICoreWebView2ContentLoadingEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

