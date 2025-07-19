"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ControllerOptions3
	subclass: #'WebView2.ICoreWebView2ControllerOptions4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ControllerOptions4 guid: (OS.COM.IID fromString: '{21eb052f-ad39-555e-824a-c87b091d4d36}')!

WebView2.ICoreWebView2ControllerOptions4 comment: '`ICoreWebView2ControllerOptions4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ControllerOptions4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(21eb052f-ad39-555e-824a-c87b091d4d36)
]
interface ICoreWebView2ControllerOptions4 : ICoreWebView2ControllerOptions3
 {
	[id(0x60040000), propget]
	HRESULT __stdcall AllowHostInputProcessing(
		[out, retval]long* value);
	[id(0x60040000), propput]
	HRESULT __stdcall AllowHostInputProcessing(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2ControllerOptions4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ControllerOptions4 methodsFor!

get_AllowHostInputProcessing: value
	"Private - Get the value of the 'AllowHostInputProcessing' property of the receiver.

		HRESULT __stdcall AllowHostInputProcessing(
			[out, retval]long* value);"

	<virtual stdcall: hresult 12 int32*>
	^self invalidCall: _failureCode!

put_AllowHostInputProcessing: value
	"Private - Set the value of the 'AllowHostInputProcessing' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall AllowHostInputProcessing(
			[in]long value);"

	<virtual stdcall: hresult 13 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ControllerOptions4 categoriesForMethods!
get_AllowHostInputProcessing:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions4!private! !
put_AllowHostInputProcessing:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions4!private! !
!

!WebView2.ICoreWebView2ControllerOptions4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ControllerOptions4'
		ICoreWebView2ControllerOptions4 defineTemplate"

	self
		defineFunction: #get_AllowHostInputProcessing:
			argumentTypes: 'int32*';
		defineFunction: #put_AllowHostInputProcessing:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2ControllerOptions4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

