"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.MethodAnnotationsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.MethodAnnotationsTest guid: (Core.GUID fromString: '{7c7e34ae-c64b-4a95-8ee7-28f444305c8e}')!
Kernel.Tests.MethodAnnotationsTest comment: ''!
!Kernel.Tests.MethodAnnotationsTest categoriesForClass!Unclassified! !
!Kernel.Tests.MethodAnnotationsTest methodsFor!

canonicalSubject
	^MethodAnnotations fromPairs: {{#namespace:. {Core}}. #(#mutable #()). #(#a:b:c: #(1 '2' #three))}!

emptySubject
	^MethodAnnotations new: 0!

testAnySatisfy
	self assert: (self canonicalSubject anySatisfy: [:each | each selector == #mutable])!

testAsArray
	self assert: self canonicalSubject asArray
		equals: {Message selector: #namespace: arguments: {Core}.
				Message selector: #mutable.
				Message selector: #a:b:c: arguments: #(1 '2' #three)}.
	self assert: self emptySubject asArray equals: #()!

testAsByteArray
	self should: [self canonicalSubject asByteArray] raise: OS.HRESULTError!

testAt
	| subject |
	subject := self canonicalSubject.
	self assert: (subject at: 1) equals: (Message selector: #namespace: arguments: {Core}).
	self assert: (subject at: 3) equals: (Message selector: #a:b:c: arguments: #(1 '2' #three)).
	self should: [subject at: 0] raise: BoundsError.
	self should: [subject at: 4] raise: BoundsError.
!

testAtPut
	| subject |
	subject := self canonicalSubject.
	self
		should: [subject at: 1 put: (Message selector: #a:b:c: arguments: #(1 '2' #three))]
		raise: Error
		matching: [:ex | ex messageText = 'MethodAnnotations should not implement #at:put:']!

testCollect
	| actual |
	actual := self canonicalSubject collect: [:each | each selector].
	self assert: actual equals: #(#namespace: #mutable #a:b:c:).
	self assert: (self emptySubject collect: [:each | each wibble]) equals: #()!

testCopyFromTo
	| subject |
	subject := self canonicalSubject.
	self assert: (subject copyFrom: 1 to: 2)
		equals: {Message selector: #namespace: arguments: {Core}. Message selector: #mutable}.
	self assert: (subject copyFrom: 4 to: 3) equals: #()!

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

testIndexOf
	| subject |
	subject := self canonicalSubject.
	self assert: (subject indexOf: (Message selector: #mutable)) equals: 2.
	self assert: (subject indexOf: #mutable) equals: 0!

testPrintOn
	self assert: self canonicalSubject printString
		equals: 'a MethodAnnotations(<namespace: Core> <mutable> <a: 1 b: ''2'' c: #three>)'.
	self assert: self emptySubject printString equals: 'a MethodAnnotations()'!

testRefersToLiteral
	| subject |
	subject := self canonicalSubject.
	self assert: (subject refersTo: #namespace: asLiteralOf: nil).
	self assert: (subject refersTo: Core asLiteralOf: nil).
	self deny: (subject refersTo: #Core asLiteralOf: nil).
	self assert: (subject refersTo: #mutable asLiteralOf: nil).
	"And one of the annotation message arguments"
	self assert: (subject refersTo: #three asLiteralOf: nil).
	self deny: (self emptySubject refersTo: nil asLiteralOf: nil)!

testResize
	| subject |
	subject := self canonicalSubject.
	self should: [subject resize: 2] raise: Processor constWriteSignal!

testSelect
	| actual |
	actual := self canonicalSubject select: [:each | each selector ~~ #mutable].
	self assert: actual
		equals: {Message selector: #namespace: arguments: {Core}.
				Message selector: #a:b:c: arguments: #(1 '2' #three)}.
	self assert: (self emptySubject select: [:each | each wibble]) equals: #()!

testSize
	self assert: self canonicalSubject size equals: 3.
	self assert: self emptySubject size equals: 0! !
!Kernel.Tests.MethodAnnotationsTest categoriesForMethods!
canonicalSubject!helpers!private! !
emptySubject!helpers!private! !
testAnySatisfy!public! !
testAsArray!public! !
testAsByteArray!public! !
testAt!public! !
testAtPut!public! !
testCollect!public! !
testCopyFromTo!public! !
testEnvironment!public! !
testFirst!public! !
testIdentityIndexOf!public! !
testIncludes!public! !
testIndexOf!public! !
testPrintOn!public! !
testRefersToLiteral!public! !
testResize!public! !
testSelect!public! !
testSize!public! !
!

