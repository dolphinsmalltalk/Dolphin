﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Settings4
	subclass: #'WebView2.ICoreWebView2Settings5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Settings5 guid: (OS.COM.IID fromString: '{183e7052-1d03-43a0-ab99-98e043b66b39}')!

WebView2.ICoreWebView2Settings5 isEgressOnly: true!

WebView2.ICoreWebView2Settings5 comment: '`ICoreWebView2Settings5` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings5'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(183e7052-1d03-43a0-ab99-98e043b66b39)
]
interface ICoreWebView2Settings5 : ICoreWebView2Settings4
 {
	[id(0x60050000), propget]
	HRESULT __stdcall IsPinchZoomEnabled(
		[out, retval]long* enabled);
	[id(0x60050000), propput]
	HRESULT __stdcall IsPinchZoomEnabled(
		[in]long enabled);
};
```
'!

!WebView2.ICoreWebView2Settings5 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Settings5 methodsFor!

get_IsPinchZoomEnabled: enabled
	"Private - Get the value of the 'IsPinchZoomEnabled' property of the receiver.

		HRESULT __stdcall IsPinchZoomEnabled(
			[out, retval]long* enabled);"

	<virtual stdcall: hresult 30 int32*>
	^self invalidCall: _failureCode!

put_IsPinchZoomEnabled: enabled
	"Private - Set the value of the 'IsPinchZoomEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall IsPinchZoomEnabled(
			[in]long enabled);"

	<virtual stdcall: hresult 31 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Settings5 categoriesForMethods!
get_IsPinchZoomEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings5!private! !
put_IsPinchZoomEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings5!private! !
!

!WebView2.ICoreWebView2Settings5 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings5'
		ICoreWebView2Settings5 defineTemplate"

	self
		defineFunction: #get_IsPinchZoomEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsPinchZoomEnabled:
			argumentTypes: 'sdword'
! !

!WebView2.ICoreWebView2Settings5 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

