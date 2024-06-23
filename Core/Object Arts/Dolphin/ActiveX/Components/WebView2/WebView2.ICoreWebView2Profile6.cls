"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile5
	subclass: #'WebView2.ICoreWebView2Profile6'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Profile6 guid: (OS.COM.IID fromString: '{bd82fa6a-1d65-4c33-b2b4-0393020cc61b}')!

WebView2.ICoreWebView2Profile6 isEgressOnly: true!

WebView2.ICoreWebView2Profile6 comment: '`ICoreWebView2Profile6` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile6'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(bd82fa6a-1d65-4c33-b2b4-0393020cc61b)
]
interface ICoreWebView2Profile6 : ICoreWebView2Profile5
 {
	[id(0x60060000), propget]
	HRESULT __stdcall IsPasswordAutosaveEnabled(
		[out, retval]long* value);
	[id(0x60060000), propput]
	HRESULT __stdcall IsPasswordAutosaveEnabled(
		[in]long value);
	[id(0x60060002), propget]
	HRESULT __stdcall IsGeneralAutofillEnabled(
		[out, retval]long* value);
	[id(0x60060002), propput]
	HRESULT __stdcall IsGeneralAutofillEnabled(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2Profile6 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Profile6 methodsFor!

get_IsGeneralAutofillEnabled: value
	"Private - Get the value of the 'IsGeneralAutofillEnabled' property of the receiver.

		HRESULT __stdcall IsGeneralAutofillEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 21 int32*>
	^self invalidCall: _failureCode!

get_IsPasswordAutosaveEnabled: value
	"Private - Get the value of the 'IsPasswordAutosaveEnabled' property of the receiver.

		HRESULT __stdcall IsPasswordAutosaveEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 19 int32*>
	^self invalidCall: _failureCode!

put_IsGeneralAutofillEnabled: value
	"Private - Set the value of the 'IsGeneralAutofillEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall IsGeneralAutofillEnabled(
			[in]long value);"

	<virtual stdcall: hresult 22 int32>
	^self invalidCall: _failureCode!

put_IsPasswordAutosaveEnabled: value
	"Private - Set the value of the 'IsPasswordAutosaveEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall IsPasswordAutosaveEnabled(
			[in]long value);"

	<virtual stdcall: hresult 20 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Profile6 categoriesForMethods!
get_IsGeneralAutofillEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Profile6!private! !
get_IsPasswordAutosaveEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Profile6!private! !
put_IsGeneralAutofillEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Profile6!private! !
put_IsPasswordAutosaveEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Profile6!private! !
!

!WebView2.ICoreWebView2Profile6 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile6'
		ICoreWebView2Profile6 defineTemplate"

	self
		defineFunction: #get_IsPasswordAutosaveEnabled:
			argumentTypes: 'int32*';
		defineFunction: #put_IsPasswordAutosaveEnabled:
			argumentTypes: 'int32';
		defineFunction: #get_IsGeneralAutofillEnabled:
			argumentTypes: 'int32*';
		defineFunction: #put_IsGeneralAutofillEnabled:
			argumentTypes: 'int32'
! !

!WebView2.ICoreWebView2Profile6 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

