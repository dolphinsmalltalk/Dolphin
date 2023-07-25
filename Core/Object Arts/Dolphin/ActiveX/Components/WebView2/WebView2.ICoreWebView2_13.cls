"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_12
	subclass: #'WebView2.ICoreWebView2_13'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_13 guid: (OS.COM.IID fromString: '{f75f09a8-667e-4983-88d6-c8773f315e84}')!
WebView2.ICoreWebView2_13 comment: '`ICoreWebView2_13` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_13'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f75f09a8-667e-4983-88d6-c8773f315e84)
]
interface ICoreWebView2_13 : ICoreWebView2_12
 {
	[id(0x600d0000), propget]
	HRESULT __stdcall Profile(
		[out, retval]ICoreWebView2Profile** value);
};
```
'!
!WebView2.ICoreWebView2_13 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_13 methodsFor!

get_Profile: value
	"Private - Get the value of the 'Profile' property of the receiver.

		HRESULT __stdcall Profile(
			[out, retval]ICoreWebView2Profile** value);"

	<virtual stdcall: hresult 106 ICoreWebView2Profile**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_13 categoriesForMethods!
get_Profile:!**auto generated**!COM Interfaces-ICoreWebView2_13!private! !
!

!WebView2.ICoreWebView2_13 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_13'
		ICoreWebView2_13 defineTemplate"

	self
		defineFunction: #get_Profile:
			argumentTypes: 'ICoreWebView2Profile**'
! !
!WebView2.ICoreWebView2_13 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

