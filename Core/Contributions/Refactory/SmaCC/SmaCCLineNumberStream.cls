"Filed out from Dolphin Smalltalk XP"!

SequencedStream subclass: #SmaCCLineNumberStream
	instanceVariableNames: 'sourceStream previousWasCR eolPositions lastPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCLineNumberStream guid: (GUID fromString: '{F35377DD-D193-470E-9919-C1CA925D7344}')!
SmaCCLineNumberStream comment: 'SmaCCLineNumberStream is a wrapper for streams that calculates line numbers.

Instance Variables:
	eolPositions	<OrderedCollection of: Integer>	the positions of each end of line
	lastPosition	<Integer>	the position of the last character that we have calculated the end of line information for (we know the line number for all characters before this position and don''t know anything about the characters after this position)
	previousWasCR	<Boolean>	was the previous character a CR. This is used for CR LF streams. A CR LF combination should only increment the line counter by 1
	sourceStream	<Stream>	the stream that we are wrapping

'!
!SmaCCLineNumberStream categoriesForClass!System-Name Spaces! !
!SmaCCLineNumberStream methodsFor!

atEnd
	^sourceStream atEnd!

columnNumber
	^self columnNumberFor: self position!

columnNumberFor: anInteger 
	^anInteger - (eolPositions at: (self lineNumberFor: anInteger)) + 1!

contents
	^sourceStream contents!

contentsSpecies
	^sourceStream contentsSpecies!

doesNotUnderstand: aMessage 
	^sourceStream perform: aMessage selector withArguments: aMessage arguments!

flush
	^sourceStream flush!

isReadable
	^sourceStream isReadable!

isWritable
	^sourceStream isWritable!

lineNumber
	^self lineNumberFor: self position!

lineNumberFor: anInteger
	| index start stop pos |
	pos := anInteger.
	pos >= eolPositions last ifTrue: [^eolPositions size].
	start := 1.
	stop := eolPositions size.
	[start + 1 < stop] whileTrue: 
			[index := (start + stop) // 2.
			(eolPositions at: index) <= pos 
				ifTrue: [start := index]
				ifFalse: [stop := index]].
	^start!

next
	| character streamPosition |
	character := sourceStream next.
	streamPosition := sourceStream position.
	streamPosition - 1 >= lastPosition 
		ifTrue: 
			[lastPosition := streamPosition.
			character == Character cr 
				ifTrue: 
					[eolPositions add: lastPosition.
					previousWasCR := true]
				ifFalse: 
					[character == Character lf 
						ifTrue: 
							[previousWasCR 
								ifTrue: [eolPositions at: eolPositions size put: lastPosition]
								ifFalse: [eolPositions add: lastPosition]].
					previousWasCR := false]].
	^character!

nextPut: anObject 
	^sourceStream nextPut: anObject!

on: aReadStream 
	sourceStream := aReadStream.
	eolPositions := OrderedCollection with: aReadStream position.
	lastPosition := aReadStream position.
	previousWasCR := false!

peek
	^sourceStream peek!

position
	^sourceStream position!

position: anInteger 
	anInteger > lastPosition 
		ifTrue: 
			[sourceStream position: lastPosition.
			[sourceStream position < anInteger and: [sourceStream atEnd not]] 
				whileTrue: [self next]]
		ifFalse: [sourceStream position: anInteger]!

skip: anInteger
	^self position: self position + anInteger! !
!SmaCCLineNumberStream categoriesFor: #atEnd!public!testing! !
!SmaCCLineNumberStream categoriesFor: #columnNumber!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #columnNumberFor:!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #contents!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #contentsSpecies!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #doesNotUnderstand:!error handling!public! !
!SmaCCLineNumberStream categoriesFor: #flush!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #isReadable!public!testing! !
!SmaCCLineNumberStream categoriesFor: #isWritable!public!testing! !
!SmaCCLineNumberStream categoriesFor: #lineNumber!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #lineNumberFor:!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #next!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #nextPut:!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #on:!initialize-release!public! !
!SmaCCLineNumberStream categoriesFor: #peek!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #position!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #position:!accessing!public! !
!SmaCCLineNumberStream categoriesFor: #skip:!accessing!public! !

!SmaCCLineNumberStream class methodsFor!

on: aReadStream 
	^(self basicNew)
		on: aReadStream;
		yourself! !
!SmaCCLineNumberStream class categoriesFor: #on:!instance creation!public! !

