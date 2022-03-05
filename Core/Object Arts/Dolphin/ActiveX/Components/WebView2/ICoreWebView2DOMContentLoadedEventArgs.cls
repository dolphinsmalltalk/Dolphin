"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventArgs subclass: #ICoreWebView2DOMContentLoadedEventArgs
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2DOMContentLoadedEventArgs guid: (IID fromString: '{16b1e21a-c503-44f2-84c9-70aba5031283}')!
ICoreWebView2DOMContentLoadedEventArgs comment: '`ICoreWebView2DOMContentLoadedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DOMContentLoadedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(16b1e21a-c503-44f2-84c9-70aba5031283)
]
interface ICoreWebView2DOMContentLoadedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall NavigationId(
		[out, retval]unsigned __int64* NavigationId);
};
```
'!
!ICoreWebView2DOMContentLoadedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2DOMContentLoadedEventArgs methodsFor!

get_NavigationId: navigationId
	"Private - Get the value of the 'NavigationId' property of the receiver.

		HRESULT __stdcall NavigationId(
			[out, retval]unsigned __int64* NavigationId);"

	<virtual stdcall: hresult 4 qword*>
	^self invalidCall: _failureCode!

navigationId
	"Answer the <qword> value of the 'NavigationId' property of the receiver."

	| answer |
	answer := ULARGE_INTEGER new.
	self get_NavigationId: answer.
	^answer asObject!

printableProperties
	^#(#navigationId)! !
!ICoreWebView2DOMContentLoadedEventArgs categoriesForMethods!
get_NavigationId:!**auto generated**!COM Interfaces-ICoreWebView2DOMContentLoadedEventArgs!private! !
navigationId!**auto generated**!properties!public! !
printableProperties!printing!private! !
!

!ICoreWebView2DOMContentLoadedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DOMContentLoadedEventArgs'
		ICoreWebView2DOMContentLoadedEventArgs defineTemplate"

	self
		defineFunction: #get_NavigationId:
			argumentTypes: 'qword*'
! !
!ICoreWebView2DOMContentLoadedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

