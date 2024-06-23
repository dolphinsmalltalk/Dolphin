"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment5
	subclass: #'WebView2.ICoreWebView2Environment6'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Environment6 guid: (OS.COM.IID fromString: '{e59ee362-acbd-4857-9a8e-d3644d9459a9}')!

WebView2.ICoreWebView2Environment6 isEgressOnly: true!

WebView2.ICoreWebView2Environment6 comment: '`ICoreWebView2Environment6` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment6'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e59ee362-acbd-4857-9a8e-d3644d9459a9)
]
interface ICoreWebView2Environment6 : ICoreWebView2Environment5
 {
	[id(0x60060000)]
	HRESULT __stdcall CreatePrintSettings(
		[out, retval]ICoreWebView2PrintSettings** printSettings);
};
```
'!

!WebView2.ICoreWebView2Environment6 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2Environment6 methodsFor!

CreatePrintSettings: printSettings
	"Private - Invoke the CreatePrintSettings() method of the COM object.

		HRESULT __stdcall CreatePrintSettings(
			[out, retval]ICoreWebView2PrintSettings** printSettings);"

	<virtual stdcall: hresult 15 ICoreWebView2PrintSettings**>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2Environment6 categoriesForMethods!
CreatePrintSettings:!**auto generated**!COM Interfaces-ICoreWebView2Environment6!private! !
!

!WebView2.ICoreWebView2Environment6 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment6'
		ICoreWebView2Environment6 defineTemplate"

	self
		defineFunction: #CreatePrintSettings:
			argumentTypes: 'ICoreWebView2PrintSettings**'
! !

!WebView2.ICoreWebView2Environment6 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

