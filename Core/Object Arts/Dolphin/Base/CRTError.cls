"Filed out from Dolphin Smalltalk X6"!

Error subclass: #CRTError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTError guid: (GUID fromString: '{259AE719-09C3-4401-A9BE-6F089698B6F7}')!
CRTError comment: ''!
!CRTError categoriesForClass!Unclassified! !
!CRTError methodsFor!

_descriptionArguments
	"Answer the arguments to be substituted into the receiver's Win32 description format String."

	^Array 
		with: self errno
		with: self messageText 
		with: self strerror
!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%2 (16r%1!!X!!: %3)'!

errno
	"Answer the <integer> C-runtime library error number."

	^self tag!

initialize
	"Private - Initialize the receiver's instance variables.
	Set the details to be the last error code reported
	by a system library (i.e. that retried by KernelLibrary>>getLastError)."

	self tag: CRTLibrary default errno
!

messageText
	"Answer the <readableString> message text supplied when the receiver was signalled,
	or nil if none was provided."

	(messageText isNil or: [messageText isEmpty])
		ifTrue: [messageText := self strerror].
	^messageText!

strerror
	"Answer a <readableString> description of the receiver's error number."

	^CRTLibrary default strerror: self errno! !
!CRTError categoriesFor: #_descriptionArguments!displaying!public! !
!CRTError categoriesFor: #_descriptionFormat!displaying!public! !
!CRTError categoriesFor: #errno!accessing!public! !
!CRTError categoriesFor: #initialize!initializing!private! !
!CRTError categoriesFor: #messageText!accessing!public! !
!CRTError categoriesFor: #strerror!accessing!public! !

