"Filed out from Dolphin Smalltalk X6"!

STBCollectionProxy subclass: #STBSortedCollectionProxy
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBSortedCollectionProxy guid: (GUID fromString: '{87B4C6F7-026E-11D3-9FD7-00A0CC3E4A32}')!
STBSortedCollectionProxy comment: ''!
!STBSortedCollectionProxy categoriesForClass!System-Binary storage! !
!STBSortedCollectionProxy methodsFor!

sortBlock: aBlock
	"Private - Set the sortBlock inst var to aBlock."

	sortBlock := aBlock
!

value
	"Answer a new SortedCollection with elements, array, and sort block, sortBlock."

	"Implementation Note: The collection is assumed to be sorted in the correct order, so the sort block
	is not evaluated at all. This modification for 5.02 makes it safe to at least load an STB file containing a 
	SortedCollection. Previously if the sortBlock contained malicious code, then that code would be run	
	purely as a result of realizing the content of the STB. This does mean that potentially a SortedCollection
	may not be correctly sorted if the sort criteria differ for some reason between the source image and
	the destination image. Where this is possible the application must explicitly #reSort the collection."

	^(class new: array size)
		sortBlock: sortBlock;
		addAllWithoutSorting: array;
		yourself! !
!STBSortedCollectionProxy categoriesFor: #sortBlock:!accessing!private! !
!STBSortedCollectionProxy categoriesFor: #value!converting!public! !

!STBSortedCollectionProxy class methodsFor!

forCollection: aSortedCollection 
	"Answer a new instance representing aSortedCollection."

	^(super forCollection: aSortedCollection)
		sortBlock: aSortedCollection sortBlock;
		yourself! !
!STBSortedCollectionProxy class categoriesFor: #forCollection:!instance creation!public! !

