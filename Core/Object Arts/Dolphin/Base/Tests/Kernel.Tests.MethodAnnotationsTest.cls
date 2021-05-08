"Filed out from Dolphin Smalltalk 7"!

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

testPrintOn
	| subject |
	subject := MethodAnnotations
				fromPairs: {{#namespace:. {Core}}. #(#mutable #()). #(#a:b:c: #(1 '2' #three))}.
	self assert: subject printString
		equals: 'a MethodAnnotations(<namespace: Core> <mutable> <a: 1 b: ''2'' c: #three>)'!

testRefersToLiteral
	| subject |
	subject := MethodAnnotations
				fromPairs: {{#namespace:. {Core}}. #(#mutable #()). #(#a:b:c: #(1 2 3))}.
	self assert: (subject refersTo: #namespace: asLiteralOf: nil).
	self assert: (subject refersTo: Core asLiteralOf: nil).
	self deny: (subject refersTo: #Core asLiteralOf: nil).
	self assert: (subject refersTo: #mutable asLiteralOf: nil)! !
!Kernel.Tests.MethodAnnotationsTest categoriesFor: #testPrintOn!public! !
!Kernel.Tests.MethodAnnotationsTest categoriesFor: #testRefersToLiteral!public! !

