"Filed out from Dolphin Smalltalk"!

STONReaderError subclass: #DolphinSTONReaderError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSTONReaderError guid: (GUID fromString: '{d7312cd7-5a35-4ac6-a193-dc8ea803cf35}')!
DolphinSTONReaderError comment: ''!
!DolphinSTONReaderError categoriesForClass!STON-Core-Exceptions! !
!DolphinSTONReaderError methodsFor!

_descriptionArguments
	"Answer an string describing the extra information supplied when the receiver
	was raised. Here we answer the classic does not understand error."

	^{streamPosition. messageText}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^streamPosition ifNil: ['%1'] ifNotNil: ['At character %1!!d!!: %2']!

messageText
	^ messageText! !
!DolphinSTONReaderError categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
messageText!accessing!public! !
!

