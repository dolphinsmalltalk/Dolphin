"Filed out from Dolphin Smalltalk"!

ICoreWebView2NavigationCompletedEventArgs subclass: #ICoreWebView2NavigationCompletedEventArgs2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2NavigationCompletedEventArgs2 guid: (IID fromString: '{fdf8b738-ee1e-4db2-a329-8d7d7b74d792}')!
ICoreWebView2NavigationCompletedEventArgs2 comment: '`ICoreWebView2NavigationCompletedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationCompletedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fdf8b738-ee1e-4db2-a329-8d7d7b74d792)
]
interface ICoreWebView2NavigationCompletedEventArgs2 : ICoreWebView2NavigationCompletedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall HttpStatusCode(
		[out, retval]int* http_status_code);
};
```
'!
!ICoreWebView2NavigationCompletedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2NavigationCompletedEventArgs2 methodsFor!

get_HttpStatusCode: http_status_code
	"Private - Get the value of the 'HttpStatusCode' property of the receiver.

		HRESULT __stdcall HttpStatusCode(
			[out, retval]int* http_status_code);"

	<virtual stdcall: hresult 7 sdword*>
	^self invalidCall: _failureCode! !
!ICoreWebView2NavigationCompletedEventArgs2 categoriesForMethods!
get_HttpStatusCode:!**auto generated**!COM Interfaces-ICoreWebView2NavigationCompletedEventArgs2!private! !
!

!ICoreWebView2NavigationCompletedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationCompletedEventArgs2'
		ICoreWebView2NavigationCompletedEventArgs2 defineTemplate"

	self
		defineFunction: #get_HttpStatusCode:
			argumentTypes: 'sdword*'
! !
!ICoreWebView2NavigationCompletedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

