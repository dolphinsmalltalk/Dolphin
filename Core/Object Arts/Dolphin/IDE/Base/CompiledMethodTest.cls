"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CompiledMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompiledMethodTest guid: (GUID fromString: '{32df31e4-99ba-44fb-aaac-99e5dfe82c94}')!
CompiledMethodTest comment: 'This is the unit test for the class CompiledMethod. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!CompiledMethodTest categoriesForClass!Tests-Kernel-Methods! !
!CompiledMethodTest methodsFor!

returnPlusOne: anInteger
	^anInteger + 1.!

returnTrue
	^true!

testExtraIndex
	| subject copy |
	subject := String >> #=.
	self assert: subject extraIndex equals: 219.
	copy := subject copy.
	copy extraIndex: 0.
	self assert: copy argumentCount equals: 1.
	copy extraIndex: 219.
	self assert: copy header equals: subject header!

testIsQuick
	| method |
	method := self class compiledMethodAt: #returnTrue.
	self assert: method extraIndex equals: 2.
	method := self class compiledMethodAt: #returnPlusOne:.
	self deny: method extraIndex equals: 5!

testIsSimpleSelfSend
	"CompiledCode>>isSimpleSelfSend: is used for finding methods of two basic forms: `^self message`, and `self message`. ClassDescription>>comment is an example of the former, and ClassDescription>>comment: the latter."

	| subject |
	#(#comment #comment:)
		do: [:each | self assert: (ClassDescription >> each isSimpleSelfSend: #subclassResponsibility)].
	"CompiledCode>>isAbstract refers to #subclassResponsibility, but is not a simple sender of it."
	subject := CompiledCode >> #isAbstract.
	self assert: (subject refersToLiteral: #subclassResponsibility).
	self deny: (subject isSimpleSelfSend: #subclassResponsibility).
	"Simple sends of something else."
	subject := ArrayedCollection >> #add:.
	self assert: (subject isSimpleSelfSend: #shouldNotImplement).
	self deny: (subject isSimpleSelfSend: #subclassResponsibility).
	"A few methods with no literals at all, with and without packed bytecodes"
	{Association >> #key. Association >> #key:. Association >> #key:value:}
		do: [:each | self deny: (each isSimpleSelfSend: #subclassResponsibility)]!

testValueWithReceiverArguments
	| method value |
	method := self class compiledMethodAt: #returnTrue.
	self should: [method value: nil withArguments: #()] raise: Error.
	value := method value: self withArguments: #().
	self assert: value equals: true.
	method := self class compiledMethodAt: #returnPlusOne:.
	value := method value: self withArguments: #(1).
	self assert: value equals: 2! !
!CompiledMethodTest categoriesFor: #returnPlusOne:!examples!public! !
!CompiledMethodTest categoriesFor: #returnTrue!examples!public! !
!CompiledMethodTest categoriesFor: #testExtraIndex!public!testing / testing! !
!CompiledMethodTest categoriesFor: #testIsQuick!public!testing / testing! !
!CompiledMethodTest categoriesFor: #testIsSimpleSelfSend!public!testing / testing! !
!CompiledMethodTest categoriesFor: #testValueWithReceiverArguments!public!testing / evaluating! !

