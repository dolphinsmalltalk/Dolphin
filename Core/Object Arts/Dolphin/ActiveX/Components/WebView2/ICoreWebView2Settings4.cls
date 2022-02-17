"Filed out from Dolphin Smallalk"!

ICoreWebView2Settings3 subclass: #ICoreWebView2Settings4
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Settings4 guid: (IID fromString: '{cb56846c-4168-4d53-b04f-03b6d6796ff2}')!
ICoreWebView2Settings4 comment: '`ICoreWebView2Settings4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(cb56846c-4168-4d53-b04f-03b6d6796ff2)
]
interface ICoreWebView2Settings4 : ICoreWebView2Settings3
 {
	[id(0x60040000), propget]
	HRESULT __stdcall IsPasswordAutosaveEnabled(
		[out, retval]long* value);
	[id(0x60040000), propput]
	HRESULT __stdcall IsPasswordAutosaveEnabled(
		[in]long value);
	[id(0x60040002), propget]
	HRESULT __stdcall IsGeneralAutofillEnabled(
		[out, retval]long* value);
	[id(0x60040002), propput]
	HRESULT __stdcall IsGeneralAutofillEnabled(
		[in]long value);
};
```
'!
!ICoreWebView2Settings4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Settings4 methodsFor!

get_IsGeneralAutofillEnabled: value
	"Private - Get the value of the 'IsGeneralAutofillEnabled' property of the receiver.

		HRESULT __stdcall IsGeneralAutofillEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 28 sdword*>
	^self invalidCall: _failureCode!

get_IsPasswordAutosaveEnabled: value
	"Private - Get the value of the 'IsPasswordAutosaveEnabled' property of the receiver.

		HRESULT __stdcall IsPasswordAutosaveEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 26 sdword*>
	^self invalidCall: _failureCode!

isGeneralAutofillEnabled
	"Answer the <sdword> value of the 'IsGeneralAutofillEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsGeneralAutofillEnabled: answer.
	^answer asObject!

isGeneralAutofillEnabled: value
	"Set the 'IsGeneralAutofillEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsGeneralAutofillEnabled: value!

isPasswordAutosaveEnabled
	"Answer the <sdword> value of the 'IsPasswordAutosaveEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsPasswordAutosaveEnabled: answer.
	^answer asObject!

isPasswordAutosaveEnabled: value
	"Set the 'IsPasswordAutosaveEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsPasswordAutosaveEnabled: value!

put_IsGeneralAutofillEnabled: value
	"Private - Set the value of the 'IsGeneralAutofillEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsGeneralAutofillEnabled(
			[in]long value);"

	<virtual stdcall: hresult 29 sdword>
	^self invalidCall: _failureCode!

put_IsPasswordAutosaveEnabled: value
	"Private - Set the value of the 'IsPasswordAutosaveEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsPasswordAutosaveEnabled(
			[in]long value);"

	<virtual stdcall: hresult 27 sdword>
	^self invalidCall: _failureCode! !
!ICoreWebView2Settings4 categoriesForMethods!
get_IsGeneralAutofillEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings4!private! !
get_IsPasswordAutosaveEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings4!private! !
isGeneralAutofillEnabled!**auto generated**!properties!public! !
isGeneralAutofillEnabled:!**auto generated**!properties!public! !
isPasswordAutosaveEnabled!**auto generated**!properties!public! !
isPasswordAutosaveEnabled:!**auto generated**!properties!public! !
put_IsGeneralAutofillEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings4!private! !
put_IsPasswordAutosaveEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings4!private! !
!

!ICoreWebView2Settings4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings4'
		ICoreWebView2Settings4 defineTemplate"

	self
		defineFunction: #get_IsPasswordAutosaveEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsPasswordAutosaveEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_IsGeneralAutofillEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsGeneralAutofillEnabled:
			argumentTypes: 'sdword'
! !
!ICoreWebView2Settings4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

