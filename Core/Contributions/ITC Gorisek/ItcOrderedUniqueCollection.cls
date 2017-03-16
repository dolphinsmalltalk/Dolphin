"Filed out from Dolphin Smalltalk 7"!

OrderedCollection variableSubclass: #ItcOrderedUniqueCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcOrderedUniqueCollection guid: (GUID fromString: '{509b4180-a874-4e90-a994-7cc92896057e}')!
ItcOrderedUniqueCollection comment: ''!
!ItcOrderedUniqueCollection categoriesForClass!Unclassified! !
!ItcOrderedUniqueCollection methodsFor!

addAllFirst: aCollection 
	aCollection do: [:each | self addFirst: each].
	^aCollection!

addAllLast: newElements 
	newElements do: [:each | self addLast: each].
	^newElements!

addFirst: newElement 
	"Similar to Set, but ordered in the same way as OrderedCollection"

	self detect: [:each | each = newElement] ifNone: [super addFirst: newElement].
	^newElement!

addLast: newObject 
	"Similar to Set, but ordered in the same way as OrderedCollection"

	self detect: [:each | each = newObject] ifNone: [super addLast: newObject].
	^newObject!

asOrderedCollection
	"Answer an OrderedCollection containing the same elements as the receiver."

	^(OrderedCollection new: self size)
		addAll: self;
		yourself! !
!ItcOrderedUniqueCollection categoriesFor: #addAllFirst:!adding!public! !
!ItcOrderedUniqueCollection categoriesFor: #addAllLast:!adding!public! !
!ItcOrderedUniqueCollection categoriesFor: #addFirst:!adding!public! !
!ItcOrderedUniqueCollection categoriesFor: #addLast:!adding!public! !
!ItcOrderedUniqueCollection categoriesFor: #asOrderedCollection!converting!public! !

