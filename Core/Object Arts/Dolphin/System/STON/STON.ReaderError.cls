"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'STON.ReaderError'
	instanceVariableNames: 'streamPosition'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.ReaderError guid: (Core.GUID fromString: '{c96113a2-1225-4af4-8f71-53e0ac1932a3}')!
STON.ReaderError comment: 'STONReaderError is the error/exception signalled by STONReader when illegal/incorrect input is seen. 
'!
!STON.ReaderError categoriesForClass!STON-Core-Exceptions! !
!STON.ReaderError methodsFor!

_descriptionArguments
	"Answer an string describing the extra information supplied when the receiver
	was raised. Here we answer the classic does not understand error."

	^{streamPosition. messageText}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^streamPosition ifNil: ['%1'] ifNotNil: ['At character %1!!d!!: %2']!

streamPosition
	^ streamPosition!

streamPosition: aNumber
	streamPosition := aNumber! !
!STON.ReaderError categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
streamPosition!accessing!public! !
streamPosition:!accessing!public! !
!

!STON.ReaderError class methodsFor!

signal: aString streamPosition: streamPosition 
	^ self new
		streamPosition: streamPosition;
		signal: aString;
		yourself! !
!STON.ReaderError class categoriesForMethods!
signal:streamPosition:!instance creation!public! !
!

