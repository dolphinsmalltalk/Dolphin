"Filed out from Dolphin Smalltalk"!

UI.Event
	subclass: #'UI.WindowsEvent'
	instanceVariableNames: 'message wParam lParam lResult'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.WindowsEvent guid: (Core.GUID fromString: '{87b4c482-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.WindowsEvent comment: ''!

!UI.WindowsEvent categoriesForClass!MVP-Views-Events! !

!UI.WindowsEvent methodsFor!

defaultWindowProcessing
	"Forward this event to the associated window's default window procedure and answer the
	intptr value it returns."

	^lResult
		ifNil: 
			[window
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam]!

isHandled
	"Answer whether the application has handled the event. This typically suppresses default
	handling, and the event is not passed to the default window procedure."

	^lResult notNil!

lParam
	^lParam!

lParam: anInteger 
	lParam := anInteger!

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

	| msg |
	self basicPrintOn: aStream.
	msg := View selectorForMessage: self message.
	aStream nextPut: $(.
	aStream
		print: self window;
		space.
	msg isNil
		ifTrue: 
			[self message
				printOn: aStream
				base: 16
				showRadix: true]
		ifFalse: [aStream nextPutAll: msg].
	aStream space.
	self printWParamOn: aStream.
	aStream space.
	self printLParamOn: aStream.
	aStream nextPut: $)!

printWParamOn: aStream
	aStream print: self wParam!

window: aView message: msgInteger wParam: wInteger lParam: lInteger
	"Private - Initialize the receiver's instance variables from the parameters."

	window := aView.
	message := msgInteger.
	wParam := wInteger.
	lParam := lInteger!

wParam
	^wParam! !

!UI.WindowsEvent categoriesForMethods!
defaultWindowProcessing!event handling!public! !
isHandled!public!testing! !
lParam!accessing!public! !
lParam:!accessing!public! !
lParamX!accessing!public! !
lParamY!accessing!public! !
lResult!accessing!public! !
lResult:!accessing!not an aspect!public! !
message!accessing!private! !
printLParamOn:!development!printing!private! !
printOn:!development!printing!public! !
printWParamOn:!development!printing!private! !
window:message:wParam:lParam:!initializing!private! !
wParam!accessing!public! !
!

!UI.WindowsEvent class methodsFor!

window: aView message: msgInteger wParam: wInteger lParam: lInteger 
	"Answer an instance of the receiver containing the message details specified by the
	parameters."

	"Implementation Note: The args are in the order of the receiver's instance variables, and
	all we need to do to initialize the object is copy them directly across, therefore we can
	use the special create and initialize primitive."

	<primitive: 157>
	^self new 
		window: aView
		message: msgInteger
		wParam: wInteger
		lParam: lInteger! !

!UI.WindowsEvent class categoriesForMethods!
window:message:wParam:lParam:!instance creation!public! !
!

