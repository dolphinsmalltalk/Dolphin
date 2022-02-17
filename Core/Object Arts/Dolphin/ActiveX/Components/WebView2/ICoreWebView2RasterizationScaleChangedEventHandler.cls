"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2RasterizationScaleChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2RasterizationScaleChangedEventHandler guid: (IID fromString: '{9c98c8b1-ac53-427e-a345-3049b5524bbe}')!
ICoreWebView2RasterizationScaleChangedEventHandler comment: '`ICoreWebView2RasterizationScaleChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2RasterizationScaleChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9c98c8b1-ac53-427e-a345-3049b5524bbe)
]
interface ICoreWebView2RasterizationScaleChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2RasterizationScaleChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2RasterizationScaleChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* IUnknown*>
	^self invalidCall: _failureCode! !
!ICoreWebView2RasterizationScaleChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2RasterizationScaleChangedEventHandler!private! !
!

!ICoreWebView2RasterizationScaleChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2RasterizationScaleChangedEventHandler'
		ICoreWebView2RasterizationScaleChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* IUnknown*'
! !
!ICoreWebView2RasterizationScaleChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

