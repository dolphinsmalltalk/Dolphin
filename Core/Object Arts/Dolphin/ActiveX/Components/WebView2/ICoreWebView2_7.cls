"Filed out from Dolphin Smalltalk"!

ICoreWebView2_6 subclass: #ICoreWebView2_7
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2_7 guid: (IID fromString: '{79c24d83-09a3-45ae-9418-487f32a58740}')!

ICoreWebView2_7 comment: '`ICoreWebView2_7` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_7'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(79c24d83-09a3-45ae-9418-487f32a58740)
]
interface ICoreWebView2_7 : ICoreWebView2_6
 {
	[id(0x60070000)]
	HRESULT __stdcall PrintToPdf(
		[in]LPWSTR ResultFilePath,
		[in]ICoreWebView2PrintSettings* printSettings,
		[in]ICoreWebView2PrintToPdfCompletedHandler* handler);
};
```
'!

!ICoreWebView2_7 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2_7 methodsFor!

canPrintToPdf
	^true!

PrintToPdf: resultFilePath printSettings: printSettings handler: handler
	"Private - Invoke the PrintToPdf() method of the COM object.

		HRESULT __stdcall PrintToPdf(
			[in]LPWSTR ResultFilePath,
			[in]ICoreWebView2PrintSettings* printSettings,
			[in]ICoreWebView2PrintToPdfCompletedHandler* handler);"

	<virtual stdcall: hresult 81 lpwstr ICoreWebView2PrintSettings* ICoreWebView2PrintToPdfCompletedHandler*>
	^self invalidCall: _failureCode! !

!ICoreWebView2_7 categoriesForMethods!
canPrintToPdf!public!testing! !
PrintToPdf:printSettings:handler:!**auto generated**!COM Interfaces-ICoreWebView2_7!private! !
!

!ICoreWebView2_7 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_7'
		ICoreWebView2_7 defineTemplate"

	self
		defineFunction: #PrintToPdf:printSettings:handler:
			argumentTypes: 'lpwstr ICoreWebView2PrintSettings* ICoreWebView2PrintToPdfCompletedHandler*'
! !

!ICoreWebView2_7 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

