"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Settings7
	subclass: #'WebView2.ICoreWebView2Settings8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Settings8 guid: (OS.COM.IID fromString: '{9e6b0e8f-86ad-4e81-8147-a9b5edb68650}')!
WebView2.ICoreWebView2Settings8 comment: '`ICoreWebView2Settings8` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings8'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9e6b0e8f-86ad-4e81-8147-a9b5edb68650)
]
interface ICoreWebView2Settings8 : ICoreWebView2Settings7
 {
	[id(0x60080000), propget]
	HRESULT __stdcall IsReputationCheckingRequired(
		[out, retval]long* value);
	[id(0x60080000), propput]
	HRESULT __stdcall IsReputationCheckingRequired(
		[in]long value);
};
```
'!
!WebView2.ICoreWebView2Settings8 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Settings8 methodsFor!

get_IsReputationCheckingRequired: value
	"Private - Get the value of the 'IsReputationCheckingRequired' property of the receiver.

		HRESULT __stdcall IsReputationCheckingRequired(
			[out, retval]long* value);"

	<virtual stdcall: hresult 36 int32*>
	^self invalidCall: _failureCode!

put_IsReputationCheckingRequired: value
	"Private - Set the value of the 'IsReputationCheckingRequired' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall IsReputationCheckingRequired(
			[in]long value);"

	<virtual stdcall: hresult 37 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Settings8 categoriesForMethods!
get_IsReputationCheckingRequired:!**auto generated**!COM Interfaces-ICoreWebView2Settings8!private! !
put_IsReputationCheckingRequired:!**auto generated**!COM Interfaces-ICoreWebView2Settings8!private! !
!

!WebView2.ICoreWebView2Settings8 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings8'
		ICoreWebView2Settings8 defineTemplate"

	self
		defineFunction: #get_IsReputationCheckingRequired:
			argumentTypes: 'int32*';
		defineFunction: #put_IsReputationCheckingRequired:
			argumentTypes: 'int32'
! !
!WebView2.ICoreWebView2Settings8 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

