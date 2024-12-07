"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NonClientRegionChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NonClientRegionChangedEventHandler guid: (OS.COM.IID fromString: '{4a794e66-aa6c-46bd-93a3-382196837680}')!

WebView2.ICoreWebView2NonClientRegionChangedEventHandler comment: '`ICoreWebView2NonClientRegionChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NonClientRegionChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4a794e66-aa6c-46bd-93a3-382196837680)
]
interface ICoreWebView2NonClientRegionChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2CompositionController* sender,
		[in]ICoreWebView2NonClientRegionChangedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2NonClientRegionChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NonClientRegionChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_NonClientRegionChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_NonClientRegionChanged: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2CompositionController* sender,
			[in]ICoreWebView2NonClientRegionChangedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2CompositionController* ICoreWebView2NonClientRegionChangedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NonClientRegionChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NonClientRegionChangedEventHandler!public! !
!

!WebView2.ICoreWebView2NonClientRegionChangedEventHandler class methodsFor!

argsClass
	^ICoreWebView2NonClientRegionChangedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NonClientRegionChangedEventHandler'
		ICoreWebView2NonClientRegionChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2CompositionController* ICoreWebView2NonClientRegionChangedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#nonClientRegionChanged:! !

!WebView2.ICoreWebView2NonClientRegionChangedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

