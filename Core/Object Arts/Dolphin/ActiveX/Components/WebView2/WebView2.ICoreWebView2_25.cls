"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_24
	subclass: #'WebView2.ICoreWebView2_25'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_25 guid: (OS.COM.IID fromString: '{b5a86092-df50-5b4f-a17b-6c8f8b40b771}')!

WebView2.ICoreWebView2_25 comment: '`ICoreWebView2_25` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_25'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b5a86092-df50-5b4f-a17b-6c8f8b40b771)
]
interface ICoreWebView2_25 : ICoreWebView2_24
 {
	[id(0x60190000)]
	HRESULT __stdcall add_SaveAsUIShowing(
		[in]ICoreWebView2SaveAsUIShowingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60190001)]
	HRESULT __stdcall remove_SaveAsUIShowing(
		[in]EventRegistrationToken token);
	[id(0x60190002)]
	HRESULT __stdcall ShowSaveAsUI(
		[in]ICoreWebView2ShowSaveAsUICompletedHandler* handler);
};
```
'!

!WebView2.ICoreWebView2_25 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_25 methodsFor!

Add_SaveAsUIShowing: eventHandler token: token
	"Private - Invoke the add_SaveAsUIShowing() method of the COM object.

		HRESULT __stdcall add_SaveAsUIShowing(
			[in]ICoreWebView2SaveAsUIShowingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 129 ICoreWebView2SaveAsUIShowingEventHandler* int64*>
	^self invalidCall: _failureCode!

Remove_SaveAsUIShowing: token
	"Private - Invoke the remove_SaveAsUIShowing() method of the COM object.

		HRESULT __stdcall remove_SaveAsUIShowing(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 130 int64>
	^self invalidCall: _failureCode!

ShowSaveAsUI: handler
	"Private - Invoke the ShowSaveAsUI() method of the COM object.

		HRESULT __stdcall ShowSaveAsUI(
			[in]ICoreWebView2ShowSaveAsUICompletedHandler* handler);"

	<virtual stdcall: hresult 131 ICoreWebView2ShowSaveAsUICompletedHandler*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_25 categoriesForMethods!
Add_SaveAsUIShowing:token:!**auto generated**!COM Interfaces-ICoreWebView2_25!private! !
Remove_SaveAsUIShowing:!**auto generated**!COM Interfaces-ICoreWebView2_25!private! !
ShowSaveAsUI:!**auto generated**!COM Interfaces-ICoreWebView2_25!private! !
!

!WebView2.ICoreWebView2_25 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_25'
		ICoreWebView2_25 defineTemplate"

	self
		defineFunction: #Add_SaveAsUIShowing:token:
			argumentTypes: 'ICoreWebView2SaveAsUIShowingEventHandler* int64*';
		defineFunction: #Remove_SaveAsUIShowing:
			argumentTypes: 'int64';
		defineFunction: #ShowSaveAsUI:
			argumentTypes: 'ICoreWebView2ShowSaveAsUICompletedHandler*'
! !

!WebView2.ICoreWebView2_25 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

