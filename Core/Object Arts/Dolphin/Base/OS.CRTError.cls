"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'OS.CRTError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.CRTError guid: (Core.GUID fromString: '{259ae719-09c3-4401-a9be-6f089698b6f7}')!
OS.CRTError comment: 'Exception to represent C-runtime library errors.'!
!OS.CRTError categoriesForClass!System-Exception Handling! !
!OS.CRTError methodsFor!

_descriptionArguments
	"Answer the arguments to be substituted into the receiver's Win32 description format String."

	^{self errno. self messageText. self strerror}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%2 (16r%1!!X!!: %3)'!

errno
	"Answer the <integer> C-runtime library error number."

	^self tag!

initialize
	"Private - Initialize the receiver's instance variables. Set the tag to be the last error
	code reported by a C runtime function library (i.e. that returned by CRTLibrary>>errno)."

	self tag: Ucrt errno!

messageText
	"Answer the <readableString> message text supplied when the receiver was signalled, or, if
	none was specified, the standard error message text for the errno stored in the tag."

	(messageText isNil or: [messageText isEmpty]) ifTrue: [messageText := self strerror].
	^messageText!

strerror
	"Answer a <readableString> description of the receiver's error number."

	| buf |
	buf := String newFixed: 80.
	^(Ucrt
		strerror_s: buf
		bufferSize: buf size + 1
		errnum: self errno) == 0
		ifTrue: [buf trimNulls]
		ifFalse: [self errno printString]! !
!OS.CRTError categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
errno!accessing!public! !
initialize!initializing!private! !
messageText!accessing!public! !
strerror!accessing!public! !
!

