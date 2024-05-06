"Filed out from Dolphin Smalltalk"!

STBCollectionProxy subclass: #STBSortedCollectionProxy
	instanceVariableNames: 'sortAlgorithm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STBSortedCollectionProxy guid: (GUID fromString: '{87b4c6f7-026e-11d3-9fd7-00a0cc3e4a32}')!

STBSortedCollectionProxy comment: ''!

!STBSortedCollectionProxy categoriesForClass!System-Binary storage! !

!STBSortedCollectionProxy methodsFor!

sortAlgorithm
	^sortAlgorithm!

sortAlgorithm: aSortAlgorithm
	sortAlgorithm := aSortAlgorithm!

value
	"Answer a new SortedCollection with elements, array, and SortAlgorithm, sortAlgorithm."

	"Implementation Note: The collection is assumed to be sorted in the correct order, so the sort block
	is not evaluated at all. This modification for 5.02 makes it safe to at least load an STB file containing a 
	SortedCollection. Previously if the sortBlock contained malicious code, then that code would be run	
	purely as a result of realizing the content of the STB. This does mean that potentially a SortedCollection
	may not be correctly sorted if the sort criteria differ for some reason between the source image and
	the destination image. Where this is possible the application must explicitly #reSort the collection."

	^(class new: array size)
		setSortAlgorithm: sortAlgorithm;
		addAllWithoutSorting: array;
		yourself! !

!STBSortedCollectionProxy categoriesForMethods!
sortAlgorithm!accessing!private! !
sortAlgorithm:!accessing!private! !
value!converting!public! !
!

!STBSortedCollectionProxy class methodsFor!

forCollection: aSortedCollection 
	"Answer a new instance representing aSortedCollection."

	^(super forCollection: aSortedCollection)
		sortAlgorithm: aSortedCollection algorithm;
		yourself!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 0 proxy - the sort algorithm is lost."

	anSTBClassFormat version > self stbVersion 
		ifTrue: [^super stbConvertFrom: anSTBClassFormat].
	^
	[:data | 
	| convertedProxy |
	convertedProxy := self basicNew.
	1 to: data size do: [:i | convertedProxy instVarAt: i put: (data at: i)].
	convertedProxy sortAlgorithm: (SortedCollection defaultSortAlgorithmClass sortBlock: convertedProxy sortAlgorithm).
	convertedProxy]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.
		1 - sortBlock becomes sortAlgorithm"

	^1! !

!STBSortedCollectionProxy class categoriesForMethods!
forCollection:!instance creation!public! !
stbConvertFrom:!instance creation!public! !
stbVersion!instance creation!public! !
!

