"Filed out from Dolphin Smalltalk"!

Stream subclass: #NullStream
	instanceVariableNames: 'contentsSpecies'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NullStream guid: (GUID fromString: '{0a1bb10e-cc8e-4a43-b431-da230811ae95}')!

NullStream comment: '`NullStream` is a class of readable and writeable `Stream`s that contain no past or future sequence values (i.e. they are perpetually empty). `NullStream` implements the ANSI protocols `<puttableStream>` and `<gettableStream>` appropriately so that there is no available input to read, and all output is discarded.'!

!NullStream categoriesForClass!Unclassified! !

!NullStream methodsFor!

atEnd
	"Answer whether the receiver cannot access any more objects."

	"Always true for a NullStream."

	^true!

close
	"Relinquish any external resources associated with the receiver, and put the receiver into a 'closed' state (as appropriate to the subclass). Answer the receiver."

	^self!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements from the receiver."

	^contentsSpecies!

contentsSpecies: aClass
	contentsSpecies := aClass!

cr
	"Store the line delimiter character sequence (as required by the environment) as the next element(s) of the receiver."!

flush
	"Flush any buffered output."

	^self!

isEmpty
	"Answer whether the sets of both past and future sequence values are empty."

	"Always true for a NullStream"

	^true!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the puttableStream protocol)."

	^true!

next
	"Answer the next object accessible by the receiver. A null stream is always at its end, so this is always an end of stream error."

	^self errorEndOfStream!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	^anObject!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger to the receiver. Answer aSequenceableCollection."

	^aSequenceableCollection!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the next line delimiter. If there are no further line delimiters in the receiver, then the rest of the receiver's contents are answered. If the receiver is at its end, then an empty collection is answered."

	^contentsSpecies empty!

nextPut: anObject
	"Store the <Object> argument as the next element of the receiver. Answer the argument."

	^anObject!

nextPutAll: aCollection
	"Store the elements in the <Collection> argument as the next elements accessible by the receiver. Answer the argument."

	^aCollection!

peek
	"Answer the next element in the collection, but do not change the current position. Answer nil if the receiver is at its end."

	"A NullStream is always at its end, so this can only ever be nil."

	^nil!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject, then advance the current position and answer true. Otherwise answer false and do not change the current position."

	^false!

position
	"Answer the current <integer> position in the stream of values."

	^0!

skip: anInteger
	"Set the receiver's position reference to be the current position plus the argument, anInteger, possibly adjusting the result so as to remain within the bounds of the collection."

	anInteger < 0 ifTrue: [self error: 'Cannot move backwards in non-positionable stream'].
	anInteger timesRepeat: [self next]!

space
	"Store a space character as the next element of the receiver"!

tab
	"Store a tab character as the next element of the receiver"! !

!NullStream categoriesForMethods!
atEnd!public!testing! !
close!operations!public! !
contentsSpecies!accessing!private! !
contentsSpecies:!accessing!private! !
cr!accessing!public! !
flush!operations!public! !
isEmpty!public!testing! !
isWriteable!public!testing! !
next!accessing!public! !
next:put:!accessing!public! !
next:putAll:startingAt:!accessing!public! !
nextLine!accessing!public! !
nextPut:!adding!public! !
nextPutAll:!adding!public! !
peek!accessing!public! !
peekFor:!accessing!public! !
position!positioning!public! !
skip:!positioning!public! !
space!accessing!public! !
tab!accessing!public! !
!

NullStream methodProtocol: #gettableStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #do: #next #next: #nextLine #nextMatchFor: #peek #peekFor: #skip: #skipTo: #upTo:)!
NullStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!NullStream class methodsFor!

new
	^self basicNew
		contentsSpecies: String;
		yourself!

on: aCollection
	^self basicNew
		contentsSpecies: aCollection copyingClass;
		yourself! !

!NullStream class categoriesForMethods!
new!public! !
on:!instance creation!public! !
!

