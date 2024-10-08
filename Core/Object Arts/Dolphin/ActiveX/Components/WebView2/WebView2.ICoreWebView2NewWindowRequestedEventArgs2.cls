﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2NewWindowRequestedEventArgs
	subclass: #'WebView2.ICoreWebView2NewWindowRequestedEventArgs2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NewWindowRequestedEventArgs2 guid: (OS.COM.IID fromString: '{bbc7baed-74c6-4c92-b63a-7f5aeae03de3}')!

WebView2.ICoreWebView2NewWindowRequestedEventArgs2 isEgressOnly: true!

WebView2.ICoreWebView2NewWindowRequestedEventArgs2 comment: '`ICoreWebView2NewWindowRequestedEventArgs2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewWindowRequestedEventArgs2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(bbc7baed-74c6-4c92-b63a-7f5aeae03de3)
]
interface ICoreWebView2NewWindowRequestedEventArgs2 : ICoreWebView2NewWindowRequestedEventArgs
 {
	[id(0x60020000), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* value);
};
```
'!

!WebView2.ICoreWebView2NewWindowRequestedEventArgs2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NewWindowRequestedEventArgs2 methodsFor!

get_name: value
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 12 lpwstr*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NewWindowRequestedEventArgs2 categoriesForMethods!
get_name:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventArgs2!private! !
!

!WebView2.ICoreWebView2NewWindowRequestedEventArgs2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewWindowRequestedEventArgs2'
		ICoreWebView2NewWindowRequestedEventArgs2 defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*'
! !

!WebView2.ICoreWebView2NewWindowRequestedEventArgs2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

