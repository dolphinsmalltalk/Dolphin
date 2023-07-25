"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ControllerOptions
	subclass: #'WebView2.ICoreWebView2ControllerOptions2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ControllerOptions2 guid: (OS.COM.IID fromString: '{06c991d8-9e7e-11ed-a8fc-0242ac120002}')!
WebView2.ICoreWebView2ControllerOptions2 comment: '`ICoreWebView2ControllerOptions2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ControllerOptions2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(06c991d8-9e7e-11ed-a8fc-0242ac120002)
]
interface ICoreWebView2ControllerOptions2 : ICoreWebView2ControllerOptions
 {
	[id(0x60020000), propget]
	HRESULT __stdcall ScriptLocale(
		[out, retval]LPWSTR* locale);
	[id(0x60020000), propput]
	HRESULT __stdcall ScriptLocale(
		[in]LPWSTR locale);
};
```
'!
!WebView2.ICoreWebView2ControllerOptions2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ControllerOptions2 methodsFor!

get_ScriptLocale: locale
	"Private - Get the value of the 'ScriptLocale' property of the receiver.

		HRESULT __stdcall ScriptLocale(
			[out, retval]LPWSTR* locale);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

put_ScriptLocale: locale
	"Private - Set the value of the 'ScriptLocale' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, locale.

		HRESULT __stdcall ScriptLocale(
			[in]LPWSTR locale);"

	<virtual stdcall: hresult 9 lpwstr>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ControllerOptions2 categoriesForMethods!
get_ScriptLocale:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions2!private! !
put_ScriptLocale:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions2!private! !
!

!WebView2.ICoreWebView2ControllerOptions2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ControllerOptions2'
		ICoreWebView2ControllerOptions2 defineTemplate"

	self
		defineFunction: #get_ScriptLocale:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_ScriptLocale:
			argumentTypes: 'lpwstr'
! !
!WebView2.ICoreWebView2ControllerOptions2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

