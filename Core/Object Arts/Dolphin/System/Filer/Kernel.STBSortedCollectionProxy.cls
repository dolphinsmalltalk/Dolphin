"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #'Kernel.STBSortedCollectionProxy'
	instanceVariableNames: 'class array sortAlgorithm'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBSortedCollectionProxy guid: (Core.GUID fromString: '{87b4c6f7-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBSortedCollectionProxy comment: ''!
!Kernel.STBSortedCollectionProxy categoriesForClass!System-Binary storage! !
!Kernel.STBSortedCollectionProxy methodsFor!

array: anArray
	"Private - Set the array inst var to anArray, the elements of the collection represented by the receiver.
	The use of the empty array literal enables the STBOutFiler to issue a shorter object reference for
	any subsequent empty instances of the receiver."

	array := anArray isEmpty
		ifTrue: [#()]
		ifFalse: [anArray]
!

class: aClass
	"Private - Set the class of the object represented by the receiver."

	class := aClass
!

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
		basicAddAll: array;
		yourself! !
!Kernel.STBSortedCollectionProxy categoriesForMethods!
array:!accessing!private! !
class:!accessing!private! !
sortAlgorithm!accessing!private! !
sortAlgorithm:!accessing!private! !
value!converting!public! !
!

!Kernel.STBSortedCollectionProxy class methodsFor!

forCollection: aSortedCollection
	"Answer a new instance representing aSortedCollection."

	^self basicNew
		class: aSortedCollection basicClass;
		array: aSortedCollection asArray;
		sortAlgorithm: aSortedCollection algorithm;
		yourself!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0 proxy - the sort algorithm is lost."

	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			data
				at: 3 put: (SortedCollection defaultSortAlgorithmClass newSortBlock: (data at: 3));
				becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	^anArray
		at: 3 put: (SortedCollection defaultSortAlgorithmClass newSortBlock: (anArray at: 3));
		yourself!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.
		1 - sortBlock becomes sortAlgorithm"

	^1! !
!Kernel.STBSortedCollectionProxy class categoriesForMethods!
forCollection:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbVersion!instance creation!public! !
!

