﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Settings2
	subclass: #'WebView2.ICoreWebView2Settings3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Settings3 guid: (OS.COM.IID fromString: '{fdb5ab74-af33-4854-84f0-0a631deb5eba}')!

WebView2.ICoreWebView2Settings3 isEgressOnly: true!

WebView2.ICoreWebView2Settings3 comment: '`ICoreWebView2Settings3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fdb5ab74-af33-4854-84f0-0a631deb5eba)
]
interface ICoreWebView2Settings3 : ICoreWebView2Settings2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall AreBrowserAcceleratorKeysEnabled(
		[out, retval]long* AreBrowserAcceleratorKeysEnabled);
	[id(0x60030000), propput]
	HRESULT __stdcall AreBrowserAcceleratorKeysEnabled(
		[in]long AreBrowserAcceleratorKeysEnabled);
};
```
'!

!WebView2.ICoreWebView2Settings3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Settings3 methodsFor!

get_AreBrowserAcceleratorKeysEnabled: areBrowserAcceleratorKeysEnabled
	"Private - Get the value of the 'AreBrowserAcceleratorKeysEnabled' property of the receiver.

		HRESULT __stdcall AreBrowserAcceleratorKeysEnabled(
			[out, retval]long* AreBrowserAcceleratorKeysEnabled);"

	<virtual stdcall: hresult 24 int32*>
	^self invalidCall: _failureCode!

put_AreBrowserAcceleratorKeysEnabled: areBrowserAcceleratorKeysEnabled
	"Private - Set the value of the 'AreBrowserAcceleratorKeysEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, areBrowserAcceleratorKeysEnabled.

		HRESULT __stdcall AreBrowserAcceleratorKeysEnabled(
			[in]long AreBrowserAcceleratorKeysEnabled);"

	<virtual stdcall: hresult 25 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Settings3 categoriesForMethods!
get_AreBrowserAcceleratorKeysEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings3!private! !
put_AreBrowserAcceleratorKeysEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings3!private! !
!

!WebView2.ICoreWebView2Settings3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings3'
		ICoreWebView2Settings3 defineTemplate"

	self
		defineFunction: #get_AreBrowserAcceleratorKeysEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_AreBrowserAcceleratorKeysEnabled:
			argumentTypes: 'sdword'
! !

!WebView2.ICoreWebView2Settings3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

