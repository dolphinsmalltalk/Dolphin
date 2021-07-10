"Filed out from Dolphin Smalltalk"!

Object subclass: #XMLNode
	instanceVariableNames: ''
	classVariableNames: 'CanonicalTable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XMLNode guid: (GUID fromString: '{f5e6786e-7892-452d-a2c8-37e4dc0d3e55}')!
XMLNode comment: ''!
!XMLNode categoriesForClass!XML-Parser! !
!XMLNode methodsFor!

addContent: contentString
	SAXMalformedException signal: 'Illegal string data.'!

contentsDo: aBlock!

firstTagNamed: aSymbol
	"Return the first encountered node with the specified tag. Pass the message on"

	| answer |
	#swYAXO.
	self contentsDo: 
			[:node | 
			(answer := node firstTagNamed: aSymbol) ifNotNil: 
					[:t | 
					"sw squeak expects monadic"

					^answer]].
	^nil!

firstTagNamed: aSymbol with: aBlock
	"Return the first encountered node with the specified tag that
	allows the block to evaluate to true. Pass the message on"

	| answer |
	#swYAXO.
	self contentsDo: 
			[:node | 
			(answer := node firstTagNamed: aSymbol with: aBlock) ifNotNil: 
					[:t | 
					"sw squeak expects monadic"

					^answer]].
	^nil!

isDocument
	#swYAXO.
	^false!

isProcessingInstruction
	^false!

isTag
	^false!

isText
	^false!

printOn: stream
	#swYAXO.	"sw: changed for debugging"
	^super printOn: stream
	"self printXMLOn: (XMLWriter on: stream)"!

printXMLOn: writer
	self subclassResponsibility!

tagsNamed: aSymbol childrenDo: aOneArgumentBlock
	"Evaluate aOneArgumentBlock for all children who match"

	self contentsDo: [:each | 
		each tagsNamed: aSymbol ifReceiverDo: aOneArgumentBlock]!

tagsNamed: aSymbol childrenDoAndRecurse: aOneArgumentBlock
	"Evaluate aOneArgumentBlock for all children who match and recurse"

	self contentsDo: [:each | 
		each tagsNamed: aSymbol ifReceiverDoAndRecurse: aOneArgumentBlock]!

tagsNamed: aSymbol contentsDo: aBlock
	"Evaluate aBlock for all of the contents of the receiver.
	The receiver has no tag, so pass the message on"

	self contentsDo: [:each | each tagsNamed: aSymbol contentsDo: aBlock]!

tagsNamed: aSymbol do: aOneArgumentBlock
	"Search for nodes with tag aSymbol. When encountered evaluate aOneArgumentBlock"

	self contentsDo: [:each | each tagsNamed: aSymbol do: aOneArgumentBlock]!

tagsNamed: aSymbol ifReceiverDo: aOneArgumentBlock
	"Handled only by XMLTagNode subclass"

!

tagsNamed: aSymbol ifReceiverDoAndRecurse: aOneArgumentBlock
	"Recurse all children"

	self contentsDo: [:each | each tagsNamed: aSymbol ifReceiverDoAndRecurse: aOneArgumentBlock]!

tagsNamed: aSymbol ifReceiverOrChildDo: aOneArgumentBlock
	"Recurse all children"

	self contentsDo: [:each | each tagsNamed: aSymbol ifReceiverDo: aOneArgumentBlock]! !
!XMLNode categoriesForMethods!
addContent:!accessing!public! !
contentsDo:!enumerating!public! !
firstTagNamed:!public!searching! !
firstTagNamed:with:!public!searching! !
isDocument!public!testing! !
isProcessingInstruction!public!testing! !
isTag!public!testing! !
isText!public!testing! !
printOn:!printing!public! !
printXMLOn:!printing!public! !
tagsNamed:childrenDo:!public!searching! !
tagsNamed:childrenDoAndRecurse:!public!searching! !
tagsNamed:contentsDo:!public!searching! !
tagsNamed:do:!public!searching! !
tagsNamed:ifReceiverDo:!public!searching! !
tagsNamed:ifReceiverDoAndRecurse:!public!searching! !
tagsNamed:ifReceiverOrChildDo:!public!searching! !
!

