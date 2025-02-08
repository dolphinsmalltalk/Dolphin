"Filed out from Dolphin Smalltalk"!

OS.StdioFileStream
	subclass: #'OS.StdioTextFileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.StdioTextFileStream guid: (Core.GUID fromString: '{8a9acce8-979d-4821-aa11-a5b4157634af}')!

OS.StdioTextFileStream isNonInstantiable: true!

OS.StdioTextFileStream comment: '`OS.StdioTextFileStream` is the abstract class of `StdioFileStream`s for streaming over textual data.'!

!OS.StdioTextFileStream categoriesForClass!Collections-Streams! !

!OS.StdioTextFileStream methodsFor!

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

	^self decodeNext ifNil: [self errorEndOfStream]!

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
	self prepareToRead.
	
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

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: Override to provide a more efficient implementation by reading the bytes as a block.
	Note however that due to line end translations, the number of characters read will probably be significantly 
	fewer than the remaining size of the file."

	^self basicNextAvailable: self size - self position + 1!

xnext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| block end |
	end := startInteger + countInteger - 1.
	block := self bufferClass
				coerceString: ((startInteger == 1 and: [end == aSequenceableCollection size])
						ifTrue: [aSequenceableCollection]
						ifFalse: [aSequenceableCollection copyFrom: startInteger to: end]).
	self nextPutAll: block.
	^aSequenceableCollection! !

!OS.StdioTextFileStream categoriesForMethods!
externalType!accessing!public! !
getString:!private!reading! !
isText!public!testing! !
next!public!reading! !
nextLine!public!reading! !
nextPut:!public!writing! !
upToEnd!public!reading! !
xnext:putAll:startingAt:!public!writing! !
!

!OS.StdioTextFileStream class methodsFor!

encodingMode
	^$t! !

!OS.StdioTextFileStream class categoriesForMethods!
encodingMode!constants!private! !
!

