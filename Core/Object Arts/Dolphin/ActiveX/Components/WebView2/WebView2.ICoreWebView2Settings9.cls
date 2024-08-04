"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Settings8
	subclass: #'WebView2.ICoreWebView2Settings9'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Settings9 guid: (OS.COM.IID fromString: '{0528a73b-e92d-49f4-927a-e547dddaa37d}')!

WebView2.ICoreWebView2Settings9 comment: '`ICoreWebView2Settings9` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings9'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0528a73b-e92d-49f4-927a-e547dddaa37d)
]
interface ICoreWebView2Settings9 : ICoreWebView2Settings8
 {
	[id(0x60090000), propget]
	HRESULT __stdcall IsNonClientRegionSupportEnabled(
		[out, retval]long* enabled);
	[id(0x60090000), propput]
	HRESULT __stdcall IsNonClientRegionSupportEnabled(
		[in]long enabled);
};
```
'!

!WebView2.ICoreWebView2Settings9 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Settings9 methodsFor!

get_IsNonClientRegionSupportEnabled: enabled
	"Private - Get the value of the 'IsNonClientRegionSupportEnabled' property of the receiver.

		HRESULT __stdcall IsNonClientRegionSupportEnabled(
			[out, retval]long* enabled);"

	<virtual stdcall: hresult 38 int32*>
	^self invalidCall: _failureCode!

put_IsNonClientRegionSupportEnabled: enabled
	"Private - Set the value of the 'IsNonClientRegionSupportEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, enabled.

		HRESULT __stdcall IsNonClientRegionSupportEnabled(
			[in]long enabled);"

	<virtual stdcall: hresult 39 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Settings9 categoriesForMethods!
get_IsNonClientRegionSupportEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings9!private! !
put_IsNonClientRegionSupportEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings9!private! !
!

!WebView2.ICoreWebView2Settings9 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings9'
		ICoreWebView2Settings9 defineTemplate"

	self
		defineFunction: #get_IsNonClientRegionSupportEnabled:
			argumentTypes: 'int32*';
		defineFunction: #put_IsNonClientRegionSupportEnabled:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2Settings9 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

