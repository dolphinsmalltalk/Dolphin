"Filed out from Dolphin Smalltalk"!

ICoreWebView2_11 subclass: #ICoreWebView2_12
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2_12 guid: (IID fromString: '{35d69927-bcfa-4566-9349-6b3e0d154cac}')!

ICoreWebView2_12 comment: '`ICoreWebView2_12` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_12'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(35d69927-bcfa-4566-9349-6b3e0d154cac)
]
interface ICoreWebView2_12 : ICoreWebView2_11
 {
	[id(0x600c0000)]
	HRESULT __stdcall add_StatusBarTextChanged(
		[in]ICoreWebView2StatusBarTextChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x600c0001)]
	HRESULT __stdcall remove_StatusBarTextChanged(
		[in]EventRegistrationToken token);
	[id(0x600c0002), propget]
	HRESULT __stdcall StatusBarText(
		[out, retval]LPWSTR* value);
};
```
'!

!ICoreWebView2_12 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2_12 methodsFor!

Add_StatusBarTextChanged: eventHandler token: token
	"Private - Invoke the add_StatusBarTextChanged() method of the COM object.

		HRESULT __stdcall add_StatusBarTextChanged(
			[in]ICoreWebView2StatusBarTextChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 103 ICoreWebView2StatusBarTextChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

get_StatusBarText: value
	"Private - Get the value of the 'StatusBarText' property of the receiver.

		HRESULT __stdcall StatusBarText(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 105 lpwstr*>
	^self invalidCall: _failureCode!

Remove_StatusBarTextChanged: token
	"Private - Invoke the remove_StatusBarTextChanged() method of the COM object.

		HRESULT __stdcall remove_StatusBarTextChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 104 sqword>
	^self invalidCall: _failureCode! !

!ICoreWebView2_12 categoriesForMethods!
Add_StatusBarTextChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2_12!private! !
get_StatusBarText:!**auto generated**!COM Interfaces-ICoreWebView2_12!private! !
Remove_StatusBarTextChanged:!**auto generated**!COM Interfaces-ICoreWebView2_12!private! !
!

!ICoreWebView2_12 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_12'
		ICoreWebView2_12 defineTemplate"

	self
		defineFunction: #Add_StatusBarTextChanged:token:
			argumentTypes: 'ICoreWebView2StatusBarTextChangedEventHandler* sqword*';
		defineFunction: #Remove_StatusBarTextChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_StatusBarText:
			argumentTypes: 'lpwstr*'
! !

!ICoreWebView2_12 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

