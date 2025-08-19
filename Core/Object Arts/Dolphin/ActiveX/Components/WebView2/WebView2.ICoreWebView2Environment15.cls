"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment14
	subclass: #'WebView2.ICoreWebView2Environment15'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Environment15 guid: (OS.COM.IID fromString: '{2ac5ebfb-e654-5961-a667-7971885c7b27}')!

WebView2.ICoreWebView2Environment15 comment: '`ICoreWebView2Environment15` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment15'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2ac5ebfb-e654-5961-a667-7971885c7b27)
]
interface ICoreWebView2Environment15 : ICoreWebView2Environment14
 {
	[id(0x600f0000)]
	HRESULT __stdcall CreateFindOptions(
		[out, retval]ICoreWebView2FindOptions** value);
};
```
'!

!WebView2.ICoreWebView2Environment15 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Environment15 methodsFor!

CreateFindOptions: value
	"Private - Invoke the CreateFindOptions() method of the COM object.

		HRESULT __stdcall CreateFindOptions(
			[out, retval]ICoreWebView2FindOptions** value);"

	<virtual stdcall: hresult 30 ICoreWebView2FindOptions**>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Environment15 categoriesForMethods!
CreateFindOptions:!**auto generated**!COM Interfaces-ICoreWebView2Environment15!private! !
!

!WebView2.ICoreWebView2Environment15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment15'
		ICoreWebView2Environment15 defineTemplate"

	self
		defineFunction: #CreateFindOptions:
			argumentTypes: 'ICoreWebView2FindOptions**'
! !

!WebView2.ICoreWebView2Environment15 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

