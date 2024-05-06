"Filed out from Dolphin Smalltalk"!

ICoreWebView2Environment7 subclass: #ICoreWebView2Environment8
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2Environment8 guid: (IID fromString: '{d6eb91dd-c3d2-45e5-bd29-6dc2bc4de9cf}')!

ICoreWebView2Environment8 comment: '`ICoreWebView2Environment8` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment8'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d6eb91dd-c3d2-45e5-bd29-6dc2bc4de9cf)
]
interface ICoreWebView2Environment8 : ICoreWebView2Environment7
 {
	[id(0x60080000)]
	HRESULT __stdcall add_ProcessInfosChanged(
		[in]ICoreWebView2ProcessInfosChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60080001)]
	HRESULT __stdcall remove_ProcessInfosChanged(
		[in]EventRegistrationToken token);
	[id(0x60080002)]
	HRESULT __stdcall GetProcessInfos(
		[out, retval]ICoreWebView2ProcessInfoCollection** value);
};
```
'!

!ICoreWebView2Environment8 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2Environment8 methodsFor!

Add_ProcessInfosChanged: eventHandler token: token
	"Private - Invoke the add_ProcessInfosChanged() method of the COM object.

		HRESULT __stdcall add_ProcessInfosChanged(
			[in]ICoreWebView2ProcessInfosChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 17 ICoreWebView2ProcessInfosChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

GetProcessInfos: value
	"Private - Invoke the GetProcessInfos() method of the COM object.

		HRESULT __stdcall GetProcessInfos(
			[out, retval]ICoreWebView2ProcessInfoCollection** value);"

	<virtual stdcall: hresult 19 ICoreWebView2ProcessInfoCollection**>
	^self invalidCall: _failureCode!

Remove_ProcessInfosChanged: token
	"Private - Invoke the remove_ProcessInfosChanged() method of the COM object.

		HRESULT __stdcall remove_ProcessInfosChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 18 sqword>
	^self invalidCall: _failureCode! !

!ICoreWebView2Environment8 categoriesForMethods!
Add_ProcessInfosChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2Environment8!private! !
GetProcessInfos:!**auto generated**!COM Interfaces-ICoreWebView2Environment8!private! !
Remove_ProcessInfosChanged:!**auto generated**!COM Interfaces-ICoreWebView2Environment8!private! !
!

!ICoreWebView2Environment8 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment8'
		ICoreWebView2Environment8 defineTemplate"

	self
		defineFunction: #Add_ProcessInfosChanged:token:
			argumentTypes: 'ICoreWebView2ProcessInfosChangedEventHandler* sqword*';
		defineFunction: #Remove_ProcessInfosChanged:
			argumentTypes: 'sqword';
		defineFunction: #GetProcessInfos:
			argumentTypes: 'ICoreWebView2ProcessInfoCollection**'
! !

!ICoreWebView2Environment8 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

