"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler guid: (OS.COM.IID fromString: '{74f712e0-8165-43a9-a13f-0cce597e75df}')!

WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler comment: '`ICoreWebView2LaunchingExternalUriSchemeEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(74f712e0-8165-43a9-a13f-0cce597e75df)
]
interface ICoreWebView2LaunchingExternalUriSchemeEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2LaunchingExternalUriSchemeEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_LaunchingExternalUriScheme: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_LaunchingExternalUriScheme: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2LaunchingExternalUriSchemeEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2LaunchingExternalUriSchemeEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2LaunchingExternalUriSchemeEventHandler!public! !
!

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler class methodsFor!

argsClass
	^ICoreWebView2LaunchingExternalUriSchemeEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler'
		ICoreWebView2LaunchingExternalUriSchemeEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2LaunchingExternalUriSchemeEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#launchingExternalUriScheme:! !

!WebView2.ICoreWebView2LaunchingExternalUriSchemeEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

