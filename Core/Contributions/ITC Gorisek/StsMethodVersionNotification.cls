"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StsMethodVersionNotification
	instanceVariableNames: 'edition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsMethodVersionNotification guid: (GUID fromString: '{387b8e10-1a83-11d4-b0aa-000000000000}')!
StsMethodVersionNotification comment: ''!
!StsMethodVersionNotification categoriesForClass!Unclassified! !
!StsMethodVersionNotification methodsFor!

displayOn: aStream 
	(edition isNil or: [edition timestamp isNil]) 
		ifTrue: [aStream nextPutAll: 'Method not found in repository...']
		ifFalse: 
			[aStream
				nextPut: $(;
				nextPutAll: edition timestamp printString;
				nextPut: $).
			edition developer isNil 
				ifFalse: 
					[aStream
						nextPutAll: ' by ';
						nextPutAll: edition developer]]!

edition
	^edition!

edition: anOsmMethodEdition 
	edition := anOsmMethodEdition!

range
	^self!

start
	^0!

stop
	^0! !
!StsMethodVersionNotification categoriesFor: #displayOn:!public! !
!StsMethodVersionNotification categoriesFor: #edition!public! !
!StsMethodVersionNotification categoriesFor: #edition:!public! !
!StsMethodVersionNotification categoriesFor: #range!public! !
!StsMethodVersionNotification categoriesFor: #start!public! !
!StsMethodVersionNotification categoriesFor: #stop!public! !

