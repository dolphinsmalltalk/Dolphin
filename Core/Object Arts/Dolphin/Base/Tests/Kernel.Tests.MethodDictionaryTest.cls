"Filed out from Dolphin Smalltalk 7"!

Core.Tests.AbstractDictionaryTest subclass: #'Kernel.Tests.MethodDictionaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.MethodDictionaryTest guid: (Core.GUID fromString: '{d47df8c5-dba6-468f-8bf4-4211e21a132b}')!
Kernel.Tests.MethodDictionaryTest comment: ''!
!Kernel.Tests.MethodDictionaryTest categoriesForClass!Unclassified! !
!Kernel.Tests.MethodDictionaryTest methodsFor!

collectionClass
	^MethodDictionary!

key3Value
	^$c!

loadFactor
	^0.75!

testClassSizeFor
	"The capacity algorithm should be the minimum power of 2 that allows for 25% slop."

	1 to: 1024
		do: 
			[:size |
			| actualCapacity minimum |
			actualCapacity := self collectionClass sizeFor: size.
			"There must always be a minimum of 25% free"
			minimum := size / self loadFactor.
			self assert: actualCapacity >= minimum.
			"But it mustn't be a larger power of two than necessary"
			self assert: actualCapacity / 2 < minimum]!

testMaintainsLoadFactor
	"At least 25% slop should be maintained."

	| subject method |
	subject := self collectionClass new.
	self assert: subject size equals: 0.
	self assert: subject basicSize equals: 2.
	method := Object >> #size.
	"The capacity is increased to the next power of 2 that holds double the current size when the collection grows"
	#(#(#a 2) #(#b 4) #(#c 4) #(#d 8) #(#e 8) #(#f 8) #(#g 16) #(#h 16) #(#i 16) #(#j 16) #(#k 16) #(#l 16) #(#m 32))
		keysAndValuesDo: 
			[:expectedSize :each |
			| minimumSlots actualSlots expectedSlots actualSize |
			expectedSlots := each last.
			minimumSlots := expectedSize / self loadFactor.
			subject at: each first put: method.
			actualSlots := subject basicSize.
			actualSize := subject size.
			self assert: actualSlots >= minimumSlots.
			self assert: actualSize equals: expectedSize.
			self assert: actualSlots / 2 <= minimumSlots.
			self assert: actualSlots equals: expectedSlots]! !
!Kernel.Tests.MethodDictionaryTest categoriesFor: #collectionClass!helpers!private! !
!Kernel.Tests.MethodDictionaryTest categoriesFor: #key3Value!private! !
!Kernel.Tests.MethodDictionaryTest categoriesFor: #loadFactor!constants!private! !
!Kernel.Tests.MethodDictionaryTest categoriesFor: #testClassSizeFor!public!unit tests! !
!Kernel.Tests.MethodDictionaryTest categoriesFor: #testMaintainsLoadFactor!public!unit tests! !

