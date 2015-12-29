"Filed out from Dolphin Smalltalk X6.1"!

Event subclass: #WindowsEvent
	instanceVariableNames: 'message wParam lParam lResult'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
WindowsEvent guid: (GUID fromString: '{87B4C482-026E-11D3-9FD7-00A0CC3E4A32}')!
WindowsEvent comment: ''!
!WindowsEvent categoriesForClass!MVP-Views-Events! !
!WindowsEvent methodsFor!

handle: wndHandle message: msgInteger wParam: wInteger lParam: lInteger 
	"Private - Initialize the receiver's instance variables from the parameters."

	hWnd := wndHandle.
	message := msgInteger.
	wParam := wInteger.
	lParam := lInteger!

hwnd
	^hWnd!

isHandled
	"Answer whether the application has handled the event. This typically suppresses default
	handling, and the event is not passed to the default window procedure."

	^lResult notNil!

lParam
	^lParam!

lParamX
	"Answer the X-value signed integer packed into the low half of the receiver's lParam field.
	Note that this could be a 16 or 32-bit value depending on whether the host OS is 32 or
	64-bit"

	^self lParam lowPartSigned!

lParamY
	"Answer the Y-value signed integer packed into the high half of the receiver's lParam field.
	Note that this could be a 16 or 32-bit value depending on whether the host OS is 32 or
	64-bit"

	^self lParam highPartSigned!

lResult
	"Answer the LRESULT value for this message to be returned to windows. Normally nil unless an
	event handler wishes to suppress default message handling."

	^lResult!

lResult: anObject 
	"Set the result of the event to the argument. Note that a non-nil value will suppress
	default message handling."

	lResult := anObject asUIntPtr!

message
	^message!

printLParamOn: aStream 
	"Private - Append a textual representation of the receiver's lParam to aStream, in a format
	appropriate for the type of event."

	aStream print: self lParam!

printOn: aStream 
	"Append a textual representation of the receiver to aStream."

	| msg window |
	self basicPrintOn: aStream.
	msg := View selectorForMessage: self message.
	aStream nextPut: $(.
	window := self window.
	aStream
		print: (window ifNil: [self hwnd]);
		space.
	msg isNil ifTrue: [self message printOn: aStream base: 16] ifFalse: [aStream nextPutAll: msg].
	aStream
		space;
		print: self wParam;
		space.
	self printLParamOn: aStream.
	aStream nextPut: $)!

wParam
	^wParam! !
!WindowsEvent categoriesFor: #handle:message:wParam:lParam:!initializing!private! !
!WindowsEvent categoriesFor: #hwnd!accessing!private! !
!WindowsEvent categoriesFor: #isHandled!public!testing! !
!WindowsEvent categoriesFor: #lParam!accessing!public! !
!WindowsEvent categoriesFor: #lParamX!accessing!public! !
!WindowsEvent categoriesFor: #lParamY!accessing!public! !
!WindowsEvent categoriesFor: #lResult!accessing!public! !
!WindowsEvent categoriesFor: #lResult:!accessing!public! !
!WindowsEvent categoriesFor: #message!accessing!private! !
!WindowsEvent categoriesFor: #printLParamOn:!printing!private! !
!WindowsEvent categoriesFor: #printOn:!development!printing!public! !
!WindowsEvent categoriesFor: #wParam!accessing!public! !

!WindowsEvent class methodsFor!

fromMSG: aMSG 
	"Answer an instance of the receiver instantiated from the Win32 message, aMSG."

	^self 
		handle: aMSG hwnd
		message: aMSG message
		wParam: aMSG wParam
		lParam: aMSG lParam!

handle: wndHandle message: msgInteger wParam: wInteger lParam: lInteger 
	"Answer an instance of the receiver containing the message details specified by the
	parameters."

	"Implementation Note: The args are in the order of the receiver's instance variables, and
	all we need to do to initialize the object is copy them directly across, therefore we can
	use the special create and initialize primitive."

	<primitive: 157>
	^self new 
		handle: wndHandle
		message: msgInteger
		wParam: wInteger
		lParam: lInteger! !
!WindowsEvent class categoriesFor: #fromMSG:!instance creation!public! !
!WindowsEvent class categoriesFor: #handle:message:wParam:lParam:!instance creation!public! !

