"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_27
	subclass: #'WebView2.ICoreWebView2_28'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_28 guid: (OS.COM.IID fromString: '{62e50381-5bf5-51a8-aae0-f20a3a9c8a90}')!

WebView2.ICoreWebView2_28 comment: '`ICoreWebView2_28` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_28'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(62e50381-5bf5-51a8-aae0-f20a3a9c8a90)
]
interface ICoreWebView2_28 : ICoreWebView2_27
 {
	[id(0x601c0000), propget]
	HRESULT __stdcall Find(
		[out, retval]ICoreWebView2Find** value);
};
```
'!

!WebView2.ICoreWebView2_28 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_28 methodsFor!

get_Find: value
	"Private - Get the value of the 'Find' property of the receiver.

		HRESULT __stdcall Find(
			[out, retval]ICoreWebView2Find** value);"

	<virtual stdcall: hresult 136 ICoreWebView2Find**>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_28 categoriesForMethods!
get_Find:!**auto generated**!COM Interfaces-ICoreWebView2_28!private! !
!

!WebView2.ICoreWebView2_28 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_28'
		ICoreWebView2_28 defineTemplate"

	self
		defineFunction: #get_Find:
			argumentTypes: 'ICoreWebView2Find**'
! !

!WebView2.ICoreWebView2_28 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

