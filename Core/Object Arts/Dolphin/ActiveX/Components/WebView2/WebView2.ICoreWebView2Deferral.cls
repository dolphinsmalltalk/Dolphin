"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2Deferral'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Deferral guid: (OS.COM.IID fromString: '{c10e7f7b-b585-46f0-a623-8befbf3e4ee0}')!
WebView2.ICoreWebView2Deferral comment: '`ICoreWebView2Deferral` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Deferral'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c10e7f7b-b585-46f0-a623-8befbf3e4ee0)
]
interface ICoreWebView2Deferral : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Complete();
};
```
'!
!WebView2.ICoreWebView2Deferral categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Deferral methodsFor!

complete
	"Invoke the Complete() method of the COM object."

	^self Complete!

Complete
	"Private - Invoke the Complete() method of the COM object.

		HRESULT __stdcall Complete();"

	<virtual stdcall: hresult 4>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Deferral categoriesFor: #complete!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Deferral categoriesFor: #Complete!**auto generated**!COM Interfaces-ICoreWebView2Deferral!private! !

!WebView2.ICoreWebView2Deferral class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Deferral'
		ICoreWebView2Deferral defineTemplate"

	self
		defineFunction: #Complete
! !
!WebView2.ICoreWebView2Deferral class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

