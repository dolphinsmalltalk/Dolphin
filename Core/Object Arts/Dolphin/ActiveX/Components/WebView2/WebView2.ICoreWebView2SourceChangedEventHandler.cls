"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2SourceChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2SourceChangedEventHandler guid: (OS.COM.IID fromString: '{3c067f9f-5388-4772-8b48-79f7ef1ab37c}')!
WebView2.ICoreWebView2SourceChangedEventHandler comment: '`ICoreWebView2SourceChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SourceChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3c067f9f-5388-4772-8b48-79f7ef1ab37c)
]
interface ICoreWebView2SourceChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2SourceChangedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2SourceChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2SourceChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2SourceChangedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2SourceChangedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2SourceChangedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2SourceChangedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2SourceChangedEventHandler!private! !

!WebView2.ICoreWebView2SourceChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SourceChangedEventHandler'
		ICoreWebView2SourceChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2SourceChangedEventArgs*'
! !
!WebView2.ICoreWebView2SourceChangedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

