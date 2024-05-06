"Filed out from Dolphin Smalltalk"!

ICoreWebView2FocusChangedEventHandler subclass: #ICoreWebView2FocusGainedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2FocusGainedEventHandler guid: (IID fromString: '{ed0fa868-afef-4800-9392-483a8ab6a225}')!

ICoreWebView2FocusGainedEventHandler comment: ''!

!ICoreWebView2FocusGainedEventHandler categoriesForClass!COM-Interfaces! !

!ICoreWebView2FocusGainedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_GotFocus: self token: tokenBuffer!

basicUnregister
	source Remove_GotFocus: token! !

!ICoreWebView2FocusGainedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FocusGainedEventHandler class methodsFor!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#focusGained! !

!ICoreWebView2FocusGainedEventHandler class categoriesForMethods!
eventName!constants!public! !
!

