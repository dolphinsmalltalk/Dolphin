"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ProcessFailedEventArgs2
	subclass: #'WebView2.ICoreWebView2ProcessFailedEventArgs3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ProcessFailedEventArgs3 guid: (OS.COM.IID fromString: '{ab667428-094d-5fd1-b480-8b4c0fdbdf2f}')!

WebView2.ICoreWebView2ProcessFailedEventArgs3 comment: '`ICoreWebView2ProcessFailedEventArgs3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessFailedEventArgs3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ab667428-094d-5fd1-b480-8b4c0fdbdf2f)
]
interface ICoreWebView2ProcessFailedEventArgs3 : ICoreWebView2ProcessFailedEventArgs2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall FailureSourceModulePath(
		[out, retval]LPWSTR* value);
};
```
'!

!WebView2.ICoreWebView2ProcessFailedEventArgs3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ProcessFailedEventArgs3 methodsFor!

get_FailureSourceModulePath: value
	"Private - Get the value of the 'FailureSourceModulePath' property of the receiver.

		HRESULT __stdcall FailureSourceModulePath(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 9 lpwstr*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ProcessFailedEventArgs3 categoriesForMethods!
get_FailureSourceModulePath:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventArgs3!private! !
!

!WebView2.ICoreWebView2ProcessFailedEventArgs3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventArgs3'
		ICoreWebView2ProcessFailedEventArgs3 defineTemplate"

	self
		defineFunction: #get_FailureSourceModulePath:
			argumentTypes: 'lpwstr*'
! !

!WebView2.ICoreWebView2ProcessFailedEventArgs3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

