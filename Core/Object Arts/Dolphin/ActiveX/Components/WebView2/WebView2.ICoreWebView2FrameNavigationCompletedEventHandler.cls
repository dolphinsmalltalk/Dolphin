"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FrameEventHandler
	subclass: #'WebView2.ICoreWebView2FrameNavigationCompletedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameNavigationCompletedEventHandler guid: (OS.COM.IID fromString: '{609302ad-0e36-4f9a-a210-6a45272842a9}')!

WebView2.ICoreWebView2FrameNavigationCompletedEventHandler comment: '`ICoreWebView2FrameNavigationCompletedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameNavigationCompletedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(609302ad-0e36-4f9a-a210-6a45272842a9)
]
interface ICoreWebView2FrameNavigationCompletedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2NavigationCompletedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2FrameNavigationCompletedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameNavigationCompletedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Frame2
	anICoreWebView2Frame2 Add_NavigationCompleted: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Frame2
	anICoreWebView2Frame2 Remove_NavigationCompleted: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2NavigationCompletedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2NavigationCompletedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameNavigationCompletedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameNavigationCompletedEventHandler!public! !
!

!WebView2.ICoreWebView2FrameNavigationCompletedEventHandler class methodsFor!

argsClass
	^ICoreWebView2NavigationCompletedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameNavigationCompletedEventHandler'
		ICoreWebView2FrameNavigationCompletedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2NavigationCompletedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frame:navigationCompleted:! !

!WebView2.ICoreWebView2FrameNavigationCompletedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

