"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.MethodAnnotationsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.MethodAnnotationsTest guid: (Core.GUID fromString: '{7c7e34ae-c64b-4a95-8ee7-28f444305c8e}')!

Kernel.Tests.MethodAnnotationsTest comment: ''!

!Kernel.Tests.MethodAnnotationsTest methodsFor!

canonicalSubject
	^MethodAnnotations fromPairs: self messagePairs!

emptySubject
	^MethodAnnotations new: 0!

messagePairs
	^{{#namespace:. {Core}}.
		#(#mutable #()).
		#(#a:b:c: #(1 '2' #three)).
		#(#selector: #(#notSelector)).
		#(#notSelector: #(#selector:)).
		#(#selector: #(#notSelector2))}!

testAdd
	| subject |
	subject := self canonicalSubject.
	self
		should: [subject add: #blah]
		raise: Error
		matching: [:ex | ex description = 'MethodAnnotations should not implement #add:']!

testAnySatisfy
	self assert: (self canonicalSubject anySatisfy: [:each | each selector == #mutable])!

testAsArray
	self assert: self canonicalSubject asArray
		equals: {Message selector: #namespace: argument: Core.
				Message selector: #mutable.
				Message selector: #a:b:c: arguments: #(1 '2' #three).
				Message selector: #selector: argument: #notSelector.
				Message selector: #notSelector: argument: #selector:.
				Message selector: #selector: argument: #notSelector2}.
	self assert: self emptySubject asArray equals: #()!

testAsByteArray
	self should: [self canonicalSubject asByteArray] raise: OS.HRESULTError!

testAt
	| subject |
	subject := self canonicalSubject.
	self assert: (subject at: 1) equals: (Message selector: #namespace: arguments: {Core}).
	self assert: (subject at: 3) equals: (Message selector: #a:b:c: arguments: #(1 '2' #three)).
	self should: [subject at: 0] raise: BoundsError.
	self should: [subject at: self messagePairs size + 1] raise: BoundsError.
!

testAtPut
	| subject |
	subject := self canonicalSubject.
	self
		should: [subject at: 1 put: (Message selector: #a:b:c: arguments: #(1 '2' #three))]
		raise: Error
		matching: [:ex | ex messageText = 'MethodAnnotations should not implement #at:put:']!

testCollect
	<ignoreNotImplementedSelectors: #(wibble)>
	
	| actual |
	actual := self canonicalSubject collect: [:each | each selector].
	self assert: actual equals: #(#namespace: #mutable #a:b:c: #selector: #notSelector: #selector:).
	self assert: (self emptySubject collect: [:each | each wibble]) equals: #()!

testComparing
	| subject comparand |
	subject := self canonicalSubject.
	self deny: subject equals: Object new.
	comparand := self canonicalSubject.
	self deny: subject identicalTo: comparand.
	self assert: subject hash equals: comparand hash.
	self assert: subject equals: comparand.
	self assert: comparand equals: subject.
	comparand := MethodAnnotations fromPairs: #(#(#mutable #())).
	self deny: subject identicalTo: comparand.
	self deny: subject hash equals: comparand hash.
	self deny: subject equals: comparand.
	self deny: comparand equals: subject.!

testCopyFromTo
	| subject |
	subject := self canonicalSubject.
	self assert: (subject copyFrom: 1 to: 2)
		equals: {Message selector: #namespace: arguments: {Core}. Message selector: #mutable}.
	self assert: (subject copyFrom: 4 to: 3) equals: #()!

testDisplayOn
	self assert: self canonicalSubject displayString
		equals: '<namespace: Core> <mutable> <a: 1 b: ''2'' c: #three> <selector: #notSelector> <notSelector: #selector:> <selector: #notSelector2>'.
	self assert: self emptySubject displayString equals: ''!

testEnvironment
	self assert: self canonicalSubject environment identicalTo: Core.
	self assert: (MethodAnnotations fromPairs: #(#(#mutable #()))) environment equals: nil.
	self assert: self emptySubject environment equals: nil!

testFirst
	| empty |
	self assert: self canonicalSubject first equals: (Message selector: #namespace: arguments: {Core}).
	empty := self emptySubject.
	self should: [empty first] raise: BoundsError!

testIdentityIndexOf
	self assert: (self canonicalSubject identityIndexOf: #mutable) equals: 0!

testIncludes
	| message subject |
	message := Message selector: #namespace: arguments: {Core}.
	subject := self canonicalSubject.
	self assert: (subject includes: message).
	self deny: (subject includes: (Message selector: #wibble)).
	self deny: (subject includes: #namespace:).
	self deny: (self emptySubject includes: message)!

testIncludesSelector
	| subject |
	subject := self canonicalSubject.
	self assert: (subject includesSelector: #namespace:).
	self assert: (subject includesSelector: #mutable).
	self assert: (subject includesSelector: #notSelector:).
	self deny: (subject includesSelector: #notSelector).
	self deny: (subject includesSelector: #namespace).!

testIndexOf
	| subject |
	subject := self canonicalSubject.
	self assert: (subject indexOf: (Message selector: #mutable)) equals: 2.
	self assert: (subject indexOf: #mutable) equals: 0!

testPrintOn
	self assert: self canonicalSubject printString
		equals: 'a MethodAnnotations(<namespace: Core> <mutable> <a: 1 b: ''2'' c: #three> <selector: #notSelector> <notSelector: #selector:> <selector: #notSelector2>)'.
	self assert: self emptySubject printString equals: 'a MethodAnnotations()'!

testRefersToLiteral
	| subject |
	subject := self canonicalSubject.
	self assert: (subject refersToLiteral: #namespace:).
	self assert: (subject refersToLiteral: Core).
	self deny: (subject refersToLiteral: #Core).
	self assert: (subject refersToLiteral: #mutable).
	"And one of the annotation message arguments"
	self assert: (subject refersToLiteral: #three).
	self deny: (self emptySubject refersToLiteral: nil)!

testResize
	| subject |
	subject := self canonicalSubject.
	self should: [subject resize: 2] raise: Processor constWriteSignal!

testSelect
	<ignoreNotImplementedSelectors: #(wibble)>

	| actual |
	actual := self canonicalSubject select: [:each | each selector ~~ #mutable].
	self assert: actual
		equals: {Message selector: #namespace: arguments: {Core}.
				Message selector: #a:b:c: arguments: #(1 '2' #three).
				Message selector: #selector: arguments: #(#notSelector).
				Message selector: #notSelector: arguments: #(#selector:).
				Message selector: #selector: arguments: #(#notSelector2)}.
	self assert: (self emptySubject select: [:each | each wibble]) equals: #()!

testSelectors
	self assert: self canonicalSubject selectors
		equals: (Set withAll: #(#namespace: #selector: #notSelector: #mutable #a:b:c:)).
	self assert: self emptySubject selectors isEmpty!

testSize
	self assert: self canonicalSubject size equals: self messagePairs size.
	self assert: self emptySubject size equals: 0!

testWithSelector
	| subject |
	subject := self canonicalSubject.
	"First, and only"
	self assert: (subject withSelector: #namespace:)
		equals: {Message selector: #namespace: argument: Core}.
	"Middle and last"
	self assert: (subject withSelector: #selector:)
		equals: {Message selector: #selector: argument: #notSelector.
				Message selector: #selector: argument: #notSelector2}.
	"Penultimate"
	self assert: (subject withSelector: #notSelector:)
		equals: {Message selector: #notSelector: argument: #selector:}.
	"Shouldn't find the args that happen to be the same - this is not possible with the current representation since the args are always held in an Array, but a possible (space) optimisation would be to eschew the Array if there is only one arg, and just store the single argument in its place."
	self assert: (subject withSelector: #notSelector) isEmpty! !

!Kernel.Tests.MethodAnnotationsTest categoriesForMethods!
canonicalSubject!constants!private! !
emptySubject!constants!private! !
messagePairs!constants!helpers!private! !
testAdd!public!unit tests! !
testAnySatisfy!public!unit tests! !
testAsArray!public!unit tests! !
testAsByteArray!public!unit tests! !
testAt!public!unit tests! !
testAtPut!public!unit tests! !
testCollect!public!unit tests! !
testComparing!public!unit tests! !
testCopyFromTo!public!unit tests! !
testDisplayOn!public!unit tests! !
testEnvironment!public!unit tests! !
testFirst!public!unit tests! !
testIdentityIndexOf!public!unit tests! !
testIncludes!public!unit tests! !
testIncludesSelector!public!unit tests! !
testIndexOf!public!unit tests! !
testPrintOn!public!unit tests! !
testRefersToLiteral!public!unit tests! !
testResize!public!unit tests! !
testSelect!public!unit tests! !
testSelectors!public!unit tests! !
testSize!public!unit tests! !
testWithSelector!public!unit tests! !
!

