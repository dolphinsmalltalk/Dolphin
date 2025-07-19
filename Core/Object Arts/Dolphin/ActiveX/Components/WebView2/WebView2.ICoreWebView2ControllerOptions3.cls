"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ControllerOptions2
	subclass: #'WebView2.ICoreWebView2ControllerOptions3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ControllerOptions3 guid: (OS.COM.IID fromString: '{b32b191a-8998-57ca-b7cb-e04617e4ce4a}')!

WebView2.ICoreWebView2ControllerOptions3 comment: '`ICoreWebView2ControllerOptions3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ControllerOptions3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b32b191a-8998-57ca-b7cb-e04617e4ce4a)
]
interface ICoreWebView2ControllerOptions3 : ICoreWebView2ControllerOptions2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall DefaultBackgroundColor(
		[out, retval]COREWEBVIEW2_COLOR* value);
	[id(0x60030000), propput]
	HRESULT __stdcall DefaultBackgroundColor(
		[in]COREWEBVIEW2_COLOR value);
};
```
'!

!WebView2.ICoreWebView2ControllerOptions3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ControllerOptions3 methodsFor!

get_DefaultBackgroundColor: value
	"Private - Get the value of the 'DefaultBackgroundColor' property of the receiver.

		HRESULT __stdcall DefaultBackgroundColor(
			[out, retval]COREWEBVIEW2_COLOR* value);"

	<virtual stdcall: hresult 10 uint32*>
	^self invalidCall: _failureCode!

put_DefaultBackgroundColor: value
	"Private - Set the value of the 'DefaultBackgroundColor' property of the object wrapped by the 
	 receiver to the <COREWEBVIEW2_COLOR> argument, value.

		HRESULT __stdcall DefaultBackgroundColor(
			[in]COREWEBVIEW2_COLOR value);"

	<virtual stdcall: hresult 11 uint32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ControllerOptions3 categoriesForMethods!
get_DefaultBackgroundColor:!COM Interfaces-ICoreWebView2ControllerOptions3!private! !
put_DefaultBackgroundColor:!COM Interfaces-ICoreWebView2ControllerOptions3!private! !
!

!WebView2.ICoreWebView2ControllerOptions3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ControllerOptions3'
		ICoreWebView2ControllerOptions3 defineTemplate"

	self
		defineFunction: #get_DefaultBackgroundColor:
			argumentTypes: 'uint32*';
		defineFunction: #put_DefaultBackgroundColor:
			argumentTypes: 'uint32'
! !

!WebView2.ICoreWebView2ControllerOptions3 class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

