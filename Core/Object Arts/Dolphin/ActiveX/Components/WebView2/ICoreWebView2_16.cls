"Filed out from Dolphin Smalltalk"!

ICoreWebView2_15 subclass: #ICoreWebView2_16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2_16 guid: (IID fromString: '{0eb34dc9-9f91-41e1-8639-95cd5943906b}')!

ICoreWebView2_16 comment: '`ICoreWebView2_16` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_16'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0eb34dc9-9f91-41e1-8639-95cd5943906b)
]
interface ICoreWebView2_16 : ICoreWebView2_15
 {
	[id(0x60100000)]
	HRESULT __stdcall Print(
		[in]ICoreWebView2PrintSettings* printSettings,
		[in]ICoreWebView2PrintCompletedHandler* handler);
	[id(0x60100001)]
	HRESULT __stdcall ShowPrintUI(
		[in]COREWEBVIEW2_PRINT_DIALOG_KIND printDialogKind);
	[id(0x60100002)]
	HRESULT __stdcall PrintToPdfStream(
		[in]ICoreWebView2PrintSettings* printSettings,
		[in]ICoreWebView2PrintToPdfStreamCompletedHandler* handler);
};
```
'!

!ICoreWebView2_16 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2_16 methodsFor!

Print: printSettings handler: handler
	"Invoke the Print() method of the COM object.

		HRESULT __stdcall Print(
			[in]ICoreWebView2PrintSettings* printSettings,
			[in]ICoreWebView2PrintCompletedHandler* handler);"

	<virtual stdcall: hresult 114 ICoreWebView2PrintSettings* ICoreWebView2PrintCompletedHandler*>
	^self invalidCall: _failureCode!

PrintToPdfStream: printSettings handler: handler
	"Invoke the PrintToPdfStream() method of the COM object.

		HRESULT __stdcall PrintToPdfStream(
			[in]ICoreWebView2PrintSettings* printSettings,
			[in]ICoreWebView2PrintToPdfStreamCompletedHandler* handler);"

	<virtual stdcall: hresult 116 ICoreWebView2PrintSettings* ICoreWebView2PrintToPdfStreamCompletedHandler*>
	^self invalidCall: _failureCode!

ShowPrintUI: printDialogKind
	"Invoke the ShowPrintUI() method of the COM object.

		HRESULT __stdcall ShowPrintUI(
			[in]COREWEBVIEW2_PRINT_DIALOG_KIND printDialogKind);"

	<virtual stdcall: hresult 115 sdword>
	^self invalidCall: _failureCode! !

!ICoreWebView2_16 categoriesForMethods!
Print:handler:!**auto generated**!COM Interfaces-ICoreWebView2_16!public! !
PrintToPdfStream:handler:!**auto generated**!COM Interfaces-ICoreWebView2_16!public! !
ShowPrintUI:!**auto generated**!COM Interfaces-ICoreWebView2_16!public! !
!

!ICoreWebView2_16 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_16'
		ICoreWebView2_16 defineTemplate"

	self
		defineFunction: #Print:handler:
			argumentTypes: 'ICoreWebView2PrintSettings* ICoreWebView2PrintCompletedHandler*';
		defineFunction: #ShowPrintUI:
			argumentTypes: 'sdword';
		defineFunction: #PrintToPdfStream:handler:
			argumentTypes: 'ICoreWebView2PrintSettings* ICoreWebView2PrintToPdfStreamCompletedHandler*'
! !

!ICoreWebView2_16 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

