"Filed out from Dolphin Smallalk"!

ICoreWebView2_5 subclass: #ICoreWebView2_6
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2_6 guid: (IID fromString: '{499aadac-d92c-4589-8a75-111bfc167795}')!
ICoreWebView2_6 comment: '`ICoreWebView2_6` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_6'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(499aadac-d92c-4589-8a75-111bfc167795)
]
interface ICoreWebView2_6 : ICoreWebView2_5
 {
	[id(0x60060000)]
	HRESULT __stdcall OpenTaskManagerWindow();
};
```
'!
!ICoreWebView2_6 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2_6 methodsFor!

OpenTaskManagerWindow
	"Private - Invoke the OpenTaskManagerWindow() method of the COM object.

		HRESULT __stdcall OpenTaskManagerWindow();"

	<virtual stdcall: hresult 80>
	^self invalidCall: _failureCode! !
!ICoreWebView2_6 categoriesForMethods!
OpenTaskManagerWindow!**auto generated**!COM Interfaces-ICoreWebView2_6!private! !
!

!ICoreWebView2_6 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_6'
		ICoreWebView2_6 defineTemplate"

	self
		defineFunction: #OpenTaskManagerWindow
! !
!ICoreWebView2_6 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

