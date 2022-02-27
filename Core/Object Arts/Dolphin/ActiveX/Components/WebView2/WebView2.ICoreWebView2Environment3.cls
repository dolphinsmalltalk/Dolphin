"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Environment2 subclass: #'WebView2.ICoreWebView2Environment3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Environment3 guid: (OS.COM.IID fromString: '{80a22ae3-be7c-4ce2-afe1-5a50056cdeeb}')!
WebView2.ICoreWebView2Environment3 comment: '`ICoreWebView2Environment3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(80a22ae3-be7c-4ce2-afe1-5a50056cdeeb)
]
interface ICoreWebView2Environment3 : ICoreWebView2Environment2
 {
	[id(0x60030000)]
	HRESULT __stdcall CreateCoreWebView2CompositionController(
		wireHWND ParentWindow,
		ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);
	[id(0x60030001)]
	HRESULT __stdcall CreateCoreWebView2PointerInfo(
		[out, retval]ICoreWebView2PointerInfo** pointerInfo);
};
```
'!
!WebView2.ICoreWebView2Environment3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Environment3 methodsFor!

CreateCoreWebView2CompositionController: parentWindow handler: handler
	"Private - Invoke the CreateCoreWebView2CompositionController() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2CompositionController(
			wireHWND ParentWindow,
			ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);"

	<virtual stdcall: hresult 10 handle ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler*>
	^self invalidCall: _failureCode!

CreateCoreWebView2PointerInfo: pointerInfo
	"Private - Invoke the CreateCoreWebView2PointerInfo() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2PointerInfo(
			[out, retval]ICoreWebView2PointerInfo** pointerInfo);"

	<virtual stdcall: hresult 11 ICoreWebView2PointerInfo**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Environment3 categoriesForMethods!
CreateCoreWebView2CompositionController:handler:!**auto generated**!COM Interfaces-ICoreWebView2Environment3!private! !
CreateCoreWebView2PointerInfo:!**auto generated**!COM Interfaces-ICoreWebView2Environment3!private! !
!

!WebView2.ICoreWebView2Environment3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment3'
		ICoreWebView2Environment3 defineTemplate"

	self
		defineFunction: #CreateCoreWebView2CompositionController:handler:
			argumentTypes: 'handle ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler*';
		defineFunction: #CreateCoreWebView2PointerInfo:
			argumentTypes: 'ICoreWebView2PointerInfo**'
! !
!WebView2.ICoreWebView2Environment3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

