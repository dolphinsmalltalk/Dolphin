"Filed out from Dolphin Smalltalk 7"!

StringTest subclass: #SymbolTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SymbolTest guid: (GUID fromString: '{da460501-580d-4216-8409-405ab77a12aa}')!
SymbolTest comment: 'This is the unit test for the class Symbol. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!SymbolTest categoriesForClass!Unclassified! !
!SymbolTest methodsFor!

newCollection: aCollection
	^(self newCopy: aCollection) asSymbol!

newCopy: aCollection
	^String withAll: (self assimilateElements: aCollection)!

testAtPut
	| literal |
	literal := #abc.
	(Array with: 0 with: literal size + 1) 
		do: [:each | self should: [literal at: each put: $x] raise: BoundsError].
	1 to: literal size
		do: [:each | self should: [literal at: each put: $x] raise: Processor constWriteSignal]!

testInstVarAtPut
	| literal |
	literal := #abc.
	(Array with: 0 with: literal size + 1) 
		do: [:each | self should: [literal instVarAt: each put: $x] raise: BoundsError].
	1 to: literal size
		do: [:each | self should: [literal instVarAt: each put: $x] raise: Processor constWriteSignal]!

testPrintLiteral
	self assert: #_ printString = '#_'.
	self assert: #'1' printString = '#''1'''.
	self assert: #'urn:foo' printString = '#''urn:foo'''.
	self assert: #urn:foo: printString = '#urn:foo:'.
	self assert: #':' printString = '#'':'''.
	self assert: #'::' printString = '#''::'''.
	self assert: #'u::' printString = '#''u::'''.
	self assert: #'u:u' printString = '#''u:u'''

!

testPrintString
	"Test whether all non-literal symbols print correctly as quoted symbols"

	"Unquoted"

	#('at:' 'a') , VMLibrary default specialSelectors do: 
			[:each |
			| print sym |
			sym := each asSymbol.
			"Sanity check"
			self assert: (SmalltalkScanner isSelector: sym).
			print := sym printString.
			self deny: (print includes: $')].
	"Quoted, e.g. integers, and symbols containing other syntactically relevant characters"
	#('' '1' 'A#' 'PL/M' '::' '!!STL' 'Object class' 'reply-to' ) do: 
			[:each |
			"Sanity check"
			| print |
			self deny: (SmalltalkScanner isSelector: each).
			"Should print quoted"
			print := each asSymbol printString.
			self assert: (print second == $' and: [print last == $'])]!

testReplaceFromToWithStartingAt
	self 
		should: [super testReplaceFromToWithStartingAt]
		raise: Error
		matching: [:ex | ex messageText = 'Symbol should not implement #replaceFrom:to:with:startingAt:']!

testReplaceIdentityWith
	self should: [super testReplaceIdentityWith] raise: Processor constWriteSignal! !
!SymbolTest categoriesFor: #newCollection:!helpers!private! !
!SymbolTest categoriesFor: #newCopy:!helpers!private! !
!SymbolTest categoriesFor: #testAtPut!public!unit tests! !
!SymbolTest categoriesFor: #testInstVarAtPut!public!unit tests! !
!SymbolTest categoriesFor: #testPrintLiteral!public!unit tests! !
!SymbolTest categoriesFor: #testPrintString!helpers!public! !
!SymbolTest categoriesFor: #testReplaceFromToWithStartingAt!public!unit tests! !
!SymbolTest categoriesFor: #testReplaceIdentityWith!public!unit tests! !

