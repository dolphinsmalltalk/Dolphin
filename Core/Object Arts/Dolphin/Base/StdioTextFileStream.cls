"Filed out from Dolphin Smalltalk 7"!

StdioFileStream subclass: #StdioTextFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioTextFileStream guid: (GUID fromString: '{8a9acce8-979d-4821-aa11-a5b4157634af}')!
StdioTextFileStream isAbstract: true!
StdioTextFileStream comment: ''!
!StdioTextFileStream categoriesForClass!Collections-Streams! !
!StdioTextFileStream methodsFor!

cr
	"Store the line delimiter character sequence (as required by
	the environment) as the next element(s) of the receiver."

	"Implementation Note: Assumes the receiver is in text mode, and 
	will translate the single LF character to a CR/LF pair on output."

	self nextPut: $\n!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^#text!

getString: aString
	^self subclassResponsibility!

isText
	"Answer whether the receiver's data is characters.
	X3J20 (draft) includes rational as to why this message is not called #isCharacter."

	^true!

next
	"Answer a <Character> being the next of the receiver's future sequence values. Raise an
	error if at EOF."

	^(self bufferPrototype decodeNextFrom: self) ifNil: [self errorEndOfStream]!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| block end |
	end := startInteger + countInteger - 1.
	block := self bufferClass
				coerceString: ((startInteger == 1 and: [end == aSequenceableCollection size])
						ifTrue: [aSequenceableCollection]
						ifFalse: [aSequenceableCollection copyFrom: startInteger to: end]).
	self nextPutAll: block.
	^aSequenceableCollection!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	| buf answer len last blockSize |
	self atEnd ifTrue: [^''].
	blockSize := 128.
	answer := self contentsSpecies writeStream: blockSize.
	buf := self bufferClass newFixed: blockSize - 1.
	
	[| read |
	(self getString: buf) == 0
		ifTrue: 
			["Hit eof"
			^answer contents].
	read := buf strlen.
	answer
		next: read
		putAll: buf
		startingAt: 1.
	read == (blockSize - 1)]
			whileTrue.
	answer := answer contents.
	^(len := answer size) == 0
		ifTrue: [answer]
		ifFalse: 
			[last := answer at: len.
			last == $\n
				ifTrue: 
					[(len > 1 and: [(answer at: len - 1) == $\r])
						ifTrue: [answer copyFrom: 1 to: len - 2]
						ifFalse: [answer copyFrom: 1 to: len - 1]]
				ifFalse: [last == $\r ifTrue: [answer copyFrom: 1 to: len - 1] ifFalse: [answer]]]!

nextPut: aCharacter
	"Store the <Character> as the next element of the receiver."

	^self bufferPrototype encodeOn: self put: aCharacter!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	| pos ch |
	pos := self position.
	ch := self nextAvailable.
	ch notNil ifTrue: [self position: pos].
	^ch!

peekFor: aCharacter
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	| pos ch |
	pos := self position.
	^(ch := self nextAvailable) notNil
		and: [ch = aCharacter or: 
					[self position: pos.
					false]]!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: Override to provide a more efficient implementation by reading the bytes as a block.
	Note however that due to line end translations, the number of characters read will probably be significantly 
	fewer than the remaining size of the file."

	^self basicNextAvailable: self size - self position + 1! !
!StdioTextFileStream categoriesFor: #cr!accessing!public! !
!StdioTextFileStream categoriesFor: #externalType!accessing!public! !
!StdioTextFileStream categoriesFor: #getString:!accessing!private! !
!StdioTextFileStream categoriesFor: #isText!public!testing! !
!StdioTextFileStream categoriesFor: #next!accessing!public! !
!StdioTextFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioTextFileStream categoriesFor: #nextLine!accessing!public! !
!StdioTextFileStream categoriesFor: #nextPut:!accessing!public! !
!StdioTextFileStream categoriesFor: #peek!accessing!public! !
!StdioTextFileStream categoriesFor: #peekFor:!accessing!public! !
!StdioTextFileStream categoriesFor: #upToEnd!accessing!public! !

StdioTextFileStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
StdioTextFileStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!StdioTextFileStream class methodsFor!

encodingMode
	^$t! !
!StdioTextFileStream class categoriesFor: #encodingMode!constants!private! !

