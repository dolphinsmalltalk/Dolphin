"Filed out from Dolphin Smalltalk 7"!

Object subclass: #XMLNode
	instanceVariableNames: ''
	classVariableNames: 'CanonicalTable'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!XMLNode categoriesFor: #addContent:!accessing!public! !
!XMLNode categoriesFor: #contentsDo:!enumerating!public! !
!XMLNode categoriesFor: #firstTagNamed:!public!searching! !
!XMLNode categoriesFor: #firstTagNamed:with:!public!searching! !
!XMLNode categoriesFor: #isDocument!public!testing! !
!XMLNode categoriesFor: #isProcessingInstruction!public!testing! !
!XMLNode categoriesFor: #isTag!public!testing! !
!XMLNode categoriesFor: #isText!public!testing! !
!XMLNode categoriesFor: #printOn:!printing!public! !
!XMLNode categoriesFor: #printXMLOn:!printing!public! !
!XMLNode categoriesFor: #tagsNamed:childrenDo:!public!searching! !
!XMLNode categoriesFor: #tagsNamed:childrenDoAndRecurse:!public!searching! !
!XMLNode categoriesFor: #tagsNamed:contentsDo:!public!searching! !
!XMLNode categoriesFor: #tagsNamed:do:!public!searching! !
!XMLNode categoriesFor: #tagsNamed:ifReceiverDo:!public!searching! !
!XMLNode categoriesFor: #tagsNamed:ifReceiverDoAndRecurse:!public!searching! !
!XMLNode categoriesFor: #tagsNamed:ifReceiverOrChildDo:!public!searching! !

