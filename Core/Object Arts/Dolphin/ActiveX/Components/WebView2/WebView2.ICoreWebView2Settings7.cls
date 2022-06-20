"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Settings6 subclass: #'WebView2.ICoreWebView2Settings7'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Settings7 guid: (OS.COM.IID fromString: '{488dc902-35ef-42d2-bc7d-94b65c4bc49c}')!
WebView2.ICoreWebView2Settings7 comment: '`ICoreWebView2Settings7` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings7'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(488dc902-35ef-42d2-bc7d-94b65c4bc49c)
]
interface ICoreWebView2Settings7 : ICoreWebView2Settings6
 {
	[id(0x60070000), propget]
	HRESULT __stdcall HiddenPdfToolbarItems(
		[out, retval]COREWEBVIEW2_PDF_TOOLBAR_ITEMS* hidden_pdf_toolbar_items);
	[id(0x60070000), propput]
	HRESULT __stdcall HiddenPdfToolbarItems(
		[in]COREWEBVIEW2_PDF_TOOLBAR_ITEMS hidden_pdf_toolbar_items);
};
```
'!
!WebView2.ICoreWebView2Settings7 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Settings7 methodsFor!

get_HiddenPdfToolbarItems: hidden_pdf_toolbar_items
	"Private - Get the value of the 'HiddenPdfToolbarItems' property of the receiver.

		HRESULT __stdcall HiddenPdfToolbarItems(
			[out, retval]COREWEBVIEW2_PDF_TOOLBAR_ITEMS* hidden_pdf_toolbar_items);"

	<virtual stdcall: hresult 34 sdword*>
	^self invalidCall: _failureCode!

put_HiddenPdfToolbarItems: hidden_pdf_toolbar_items
	"Private - Set the value of the 'HiddenPdfToolbarItems' property of the object wrapped by the 
	 receiver to the <sdword> argument, hidden_pdf_toolbar_items.

		HRESULT __stdcall HiddenPdfToolbarItems(
			[in]COREWEBVIEW2_PDF_TOOLBAR_ITEMS hidden_pdf_toolbar_items);"

	<virtual stdcall: hresult 35 sdword>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Settings7 categoriesForMethods!
get_HiddenPdfToolbarItems:!**auto generated**!COM Interfaces-ICoreWebView2Settings7!private! !
put_HiddenPdfToolbarItems:!**auto generated**!COM Interfaces-ICoreWebView2Settings7!private! !
!

!WebView2.ICoreWebView2Settings7 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings7'
		ICoreWebView2Settings7 defineTemplate"

	self
		defineFunction: #get_HiddenPdfToolbarItems:
			argumentTypes: 'sdword*';
		defineFunction: #put_HiddenPdfToolbarItems:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2Settings7 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

