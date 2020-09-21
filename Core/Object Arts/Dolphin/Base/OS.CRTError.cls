"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'External.CRTError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.CRTError guid: (Core.GUID fromString: '{259ae719-09c3-4401-a9be-6f089698b6f7}')!
External.CRTError comment: 'Exception to represent C-runtime library errors.'!
!External.CRTError categoriesForClass!System-Exception Handling! !
!External.CRTError methodsFor!

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

	self tag: CRTLibrary default errno!

messageText
	"Answer the <readableString> message text supplied when the receiver was signalled, or, if
	none was specified, the standard error message text for the errno stored in the tag."

	(messageText isNil or: [messageText isEmpty]) ifTrue: [messageText := self strerror].
	^messageText!

strerror
	"Answer a <readableString> description of the receiver's error number."

	| buf |
	buf := String newFixed: 80.
	^(CRTLibrary default
		strerror_s: buf
		bufferSize: buf size + 1
		errnum: self errno) == 0
		ifTrue: [buf trimNulls]
		ifFalse: [self errno printString]! !
!External.CRTError categoriesFor: #_descriptionArguments!displaying!public! !
!External.CRTError categoriesFor: #_descriptionFormat!displaying!public! !
!External.CRTError categoriesFor: #errno!accessing!public! !
!External.CRTError categoriesFor: #initialize!initializing!private! !
!External.CRTError categoriesFor: #messageText!accessing!public! !
!External.CRTError categoriesFor: #strerror!accessing!public! !

