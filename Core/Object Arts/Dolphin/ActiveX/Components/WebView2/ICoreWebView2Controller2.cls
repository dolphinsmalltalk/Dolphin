﻿"Filed out from Dolphin Smalltalk"!

ICoreWebView2Controller subclass: #ICoreWebView2Controller2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Controller2 guid: (IID fromString: '{c979903e-d4ca-4228-92eb-47ee3fa96eab}')!
ICoreWebView2Controller2 comment: '`ICoreWebView2Controller2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Controller2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c979903e-d4ca-4228-92eb-47ee3fa96eab)
]
interface ICoreWebView2Controller2 : ICoreWebView2Controller
 {
	[id(0x60020000), propget]
	HRESULT __stdcall DefaultBackgroundColor(
		[out, retval]COREWEBVIEW2_COLOR* backgroundColor);
	[id(0x60020000), propput]
	HRESULT __stdcall DefaultBackgroundColor(
		[in]COREWEBVIEW2_COLOR backgroundColor);
};
```
'!
!ICoreWebView2Controller2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Controller2 methodsFor!

get_DefaultBackgroundColor: backgroundColor
	"Private - Get the value of the 'DefaultBackgroundColor' property of the receiver.

		HRESULT __stdcall DefaultBackgroundColor(
			[out, retval]COREWEBVIEW2_COLOR* backgroundColor);"

	<virtual stdcall: hresult 27 qword*>
	^self invalidCall: _failureCode!

put_DefaultBackgroundColor: backgroundColor
	"Private - Set the value of the 'DefaultBackgroundColor' property of the object wrapped by the 
	 receiver to the <COREWEBVIEW2_COLOR> argument, backgroundColor.

		HRESULT __stdcall DefaultBackgroundColor(
			[in]COREWEBVIEW2_COLOR backgroundColor);"

	<virtual stdcall: hresult 28 qword>
	^self invalidCall: _failureCode! !
!ICoreWebView2Controller2 categoriesForMethods!
get_DefaultBackgroundColor:!COM Interfaces-ICoreWebView2Controller2!private! !
put_DefaultBackgroundColor:!COM Interfaces-ICoreWebView2Controller2!private! !
!

!ICoreWebView2Controller2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Controller2'
		ICoreWebView2Controller2 defineTemplate"

	self
		defineFunction: #get_DefaultBackgroundColor:
			argumentTypes: 'qword*';
		defineFunction: #put_DefaultBackgroundColor:
			argumentTypes: 'qword'
! !
!ICoreWebView2Controller2 class categoriesForMethods!
defineFunctions!initializing!public! !
!
