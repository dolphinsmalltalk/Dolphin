"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Controller3
	subclass: #'WebView2.ICoreWebView2Controller4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Controller4 guid: (OS.COM.IID fromString: '{97d418d5-a426-4e49-a151-e1a10f327d9e}')!
WebView2.ICoreWebView2Controller4 comment: '`ICoreWebView2Controller4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Controller4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(97d418d5-a426-4e49-a151-e1a10f327d9e)
]
interface ICoreWebView2Controller4 : ICoreWebView2Controller3
 {
	[id(0x60040000), propget]
	HRESULT __stdcall AllowExternalDrop(
		[out, retval]long* value);
	[id(0x60040000), propput]
	HRESULT __stdcall AllowExternalDrop(
		[in]long value);
};
```
'!
!WebView2.ICoreWebView2Controller4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Controller4 methodsFor!

get_AllowExternalDrop: value
	"Private - Get the value of the 'AllowExternalDrop' property of the receiver.

		HRESULT __stdcall AllowExternalDrop(
			[out, retval]long* value);"

	<virtual stdcall: hresult 37 int32*>
	^self invalidCall: _failureCode!

put_AllowExternalDrop: value
	"Private - Set the value of the 'AllowExternalDrop' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall AllowExternalDrop(
			[in]long value);"

	<virtual stdcall: hresult 38 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Controller4 categoriesForMethods!
get_AllowExternalDrop:!**auto generated**!COM Interfaces-ICoreWebView2Controller4!private! !
put_AllowExternalDrop:!**auto generated**!COM Interfaces-ICoreWebView2Controller4!private! !
!

!WebView2.ICoreWebView2Controller4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Controller4'
		ICoreWebView2Controller4 defineTemplate"

	self
		defineFunction: #get_AllowExternalDrop:
			argumentTypes: 'sdword*';
		defineFunction: #put_AllowExternalDrop:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2Controller4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

