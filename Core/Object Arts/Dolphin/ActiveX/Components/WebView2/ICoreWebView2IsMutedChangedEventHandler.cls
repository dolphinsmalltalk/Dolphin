"Filed out from Dolphin Smallalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2IsMutedChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2IsMutedChangedEventHandler guid: (IID fromString: '{57d90347-cd0e-4952-a4a2-7483a2756f08}')!
ICoreWebView2IsMutedChangedEventHandler comment: '`ICoreWebView2IsMutedChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2IsMutedChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(57d90347-cd0e-4952-a4a2-7483a2756f08)
]
interface ICoreWebView2IsMutedChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2IsMutedChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2IsMutedChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_IsMutedChanged: self token: tokenBuffer!

basicUnregister
	source Remove_IsMutedChanged: token! !
!ICoreWebView2IsMutedChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2IsMutedChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2IsMutedChangedEventHandler'
		ICoreWebView2IsMutedChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#isMutedChanged! !
!ICoreWebView2IsMutedChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

