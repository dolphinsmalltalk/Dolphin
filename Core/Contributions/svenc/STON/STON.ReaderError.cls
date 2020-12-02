"Filed out from Dolphin Smalltalk 7"!

Error subclass: #STONReaderError
	instanceVariableNames: 'streamPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STONReaderError guid: (GUID fromString: '{c96113a2-1225-4af4-8f71-53e0ac1932a3}')!
STONReaderError comment: 'STONReaderError is the error/exception signalled by STONReader when illegal/incorrect input is seen. 
'!
!STONReaderError categoriesForClass!STON-Core-Exceptions! !
!STONReaderError methodsFor!

messageText
	^ streamPosition 
		ifNil: [ 
			super messageText ] 
		ifNotNil: [ :pos | 
			'At character {1}: {2}' format: 
				(Array with: streamPosition with: super messageText) ]!

streamPosition
	^ streamPosition!

streamPosition: aNumber
	streamPosition := aNumber! !
!STONReaderError categoriesFor: #messageText!accessing!public! !
!STONReaderError categoriesFor: #streamPosition!accessing!public! !
!STONReaderError categoriesFor: #streamPosition:!accessing!public! !

!STONReaderError class methodsFor!

signal: aString streamPosition: streamPosition 
	^ self new
		streamPosition: streamPosition;
		signal: aString;
		yourself! !
!STONReaderError class categoriesFor: #signal:streamPosition:!instance creation!public! !

