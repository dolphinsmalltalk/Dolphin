"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2RasterizationScaleChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
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

basicRegister: tokenBuffer
	source Add_RasterizationScaleChanged: self token: tokenBuffer!

basicUnregister
	source Remove_RasterizationScaleChanged: token! !
!ICoreWebView2RasterizationScaleChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2RasterizationScaleChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2RasterizationScaleChangedEventHandler'
		ICoreWebView2RasterizationScaleChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#rasterizationScaleChanged! !
!ICoreWebView2RasterizationScaleChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

