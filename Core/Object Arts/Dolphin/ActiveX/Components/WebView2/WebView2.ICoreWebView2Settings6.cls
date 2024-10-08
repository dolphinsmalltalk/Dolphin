﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Settings5
	subclass: #'WebView2.ICoreWebView2Settings6'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Settings6 guid: (OS.COM.IID fromString: '{11cb3acd-9bc8-43b8-83bf-f40753714f87}')!

WebView2.ICoreWebView2Settings6 isEgressOnly: true!

WebView2.ICoreWebView2Settings6 comment: '`ICoreWebView2Settings6` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings6'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(11cb3acd-9bc8-43b8-83bf-f40753714f87)
]
interface ICoreWebView2Settings6 : ICoreWebView2Settings5
 {
	[id(0x60060000), propget]
	HRESULT __stdcall IsSwipeNavigationEnabled(
		[out, retval]long* enabled);
	[id(0x60060000), propput]
	HRESULT __stdcall IsSwipeNavigationEnabled(
		[in]long enabled);
};
```
'!

!WebView2.ICoreWebView2Settings6 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Settings6 methodsFor!

get_IsSwipeNavigationEnabled: enabled
	"Private - Get the value of the 'IsSwipeNavigationEnabled' property of the receiver.

		HRESULT __stdcall IsSwipeNavigationEnabled(
			[out, retval]long* enabled);"

	<virtual stdcall: hresult 32 int32*>
	^self invalidCall: _failureCode!

put_IsSwipeNavigationEnabled: enabled
	"Private - Set the value of the 'IsSwipeNavigationEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall IsSwipeNavigationEnabled(
			[in]long enabled);"

	<virtual stdcall: hresult 33 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Settings6 categoriesForMethods!
get_IsSwipeNavigationEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings6!private! !
put_IsSwipeNavigationEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings6!private! !
!

!WebView2.ICoreWebView2Settings6 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings6'
		ICoreWebView2Settings6 defineTemplate"

	self
		defineFunction: #get_IsSwipeNavigationEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsSwipeNavigationEnabled:
			argumentTypes: 'sdword'
! !

!WebView2.ICoreWebView2Settings6 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

