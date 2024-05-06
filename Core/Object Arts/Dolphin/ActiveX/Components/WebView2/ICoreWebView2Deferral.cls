"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Deferral
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2Deferral guid: (IID fromString: '{c10e7f7b-b585-46f0-a623-8befbf3e4ee0}')!

ICoreWebView2Deferral comment: '`ICoreWebView2Deferral` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Deferral'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!ICoreWebView2Deferral categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2Deferral methodsFor!

complete
	"Invoke the Complete() method of the COM object."

	^self Complete!

Complete
	"Private - Invoke the Complete() method of the COM object.

		HRESULT __stdcall Complete();"

	<virtual stdcall: hresult 4>
	^self invalidCall: _failureCode! !

!ICoreWebView2Deferral categoriesForMethods!
complete!**auto generated**!methods!public! !
Complete!**auto generated**!COM Interfaces-ICoreWebView2Deferral!private! !
!

!ICoreWebView2Deferral class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Deferral'
		ICoreWebView2Deferral defineTemplate"

	self
		defineFunction: #Complete
! !

!ICoreWebView2Deferral class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

