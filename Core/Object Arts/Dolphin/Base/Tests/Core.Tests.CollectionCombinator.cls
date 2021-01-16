"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Core.Tests.CollectionCombinator'
	instanceVariableNames: 'resultProcessingBlock collectionOfArrays buffer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.CollectionCombinator guid: (Core.GUID fromString: '{569a1b4b-4d9d-4ddb-ab24-54771e8598e6}')!
Core.Tests.CollectionCombinator comment: 'For a collection of collections, enumerate all elements of the cartesian product. The code shows how recursion is used to implement variable nesting of loops.
The cartesian product is usually a huge collection, that should not be kept in memory. Therefore the user of the class has to provide a block with one argument that is called each time a tuple is constructed. When possible, that block should not build a collection of all these tuples, but should immediately drop unsuitable tuples. 
To get a first impression, try this with ''inspect it'':

     | result |
     result := OrderedCollection new.
    CollectionCombinator new
         forArrays:  (OrderedCollection with: #(#a #b #c)
                                             with: #(1 2 3 4 5)
                                             with: #(''v'' ''w'' ''x'' ''y'' ''z'')
                                             with: #(''one'' ''two'' ''three'')
                         )
         processWith: [:item |result addLast: item].
    result
         '!
!Core.Tests.CollectionCombinator categoriesForClass!BlockCLosures-Tests! !
!Core.Tests.CollectionCombinator methodsFor!

combineFromIdx: myIdx

   "  this method is recursive. Recursion runs from values 1 to  collectionOfArrays size  of parameter myIdx. Each time it is called, this method has the responsiblity to provide all possible values for one index position of the result tuples. That index position is given by the value of  myIdx."

   (collectionOfArrays at: myIdx) do:
     [:item |
       buffer at: myIdx put: item.
       myIdx = collectionOfArrays size
         ifTrue: [resultProcessingBlock value: buffer shallowCopy]
         ifFalse: [self combineFromIdx: myIdx + 1]
    ].

  " The buffer is a shared object and its contents are later changed. It is therefore necessary to make a copy. "!

forArrays: anArray processWith: aBlock
	"  anArray is a kind of a sequenceable collection of arrays.
    aBlock is a block with one argument, that is used to process a  tuple immediately after it is constructed. "

	collectionOfArrays := anArray.
	resultProcessingBlock := aBlock.
	buffer := Array new: anArray size.
	self combineFromIdx: 1! !
!Core.Tests.CollectionCombinator categoriesFor: #combineFromIdx:!helpers!private! !
!Core.Tests.CollectionCombinator categoriesFor: #forArrays:processWith:!helpers!private! !

