"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.AddClassChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddClassChangeTest guid: (Core.GUID fromString: '{adf6db7e-6540-455d-a255-f09b57212403}')!
Refactory.Browser.Tests.AddClassChangeTest comment: ''!
!Refactory.Browser.Tests.AddClassChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddClassChangeTest methodsFor!

canonicalSubject
	^AddClassChange definition: self definitionWithEverything!

definitionWithEverything
	^'Core.Model subclass: #''Refactory.Browser.Tests.ClassWithEverything''
	instanceVariableNames: ''instvar1 instvar2''
	classVariableNames: ''ClassVar1 ClassVar2''
	imports: #(#{UI private} #{Core.Missing})
	classInstanceVariableNames: ''classInstVar1 classInstVar2''
	classConstants: {
		''ClassConst1'' -> 16r1.
		''ClassConst2'' -> 16r2
	}'!

testAsUndoCreate
	| subject undo |
	subject := self canonicalSubject.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: RemoveClassChange.
	"Until the change is applied, the undo's beforeText will be empty because the class does not exist"
	self assert: undo beforeText equals: ''.
	self assert: undo afterText equals: ''!

testAsUndoModify
	| subject undo definition |
	definition := ClassToRename definition copyReplaceAll: 'imports: #()' with: 'imports: #(#{Refactory.Browser.TestData})'.
	subject := AddClassChange definition: definition.
	self assert: subject beforeText equals: ClassToRename definition.
	self assert: subject afterText equals: definition.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: AddClassChange.
	self assert: undo changeClass identicalTo: subject changeClass.
	self assert: undo afterText equals: subject beforeText!

testAttributes
	| subject attributes |
	subject := self canonicalSubject.
	attributes := subject attributes.
	self assert: attributes kindOfSubclass equals: 'subclass:'.
	self assert: attributes instanceVariableNames equals: #('instvar1' 'instvar2').
	self assert: attributes classVariableNames equals: #('ClassVar1' 'ClassVar2').
	self assert: attributes imports equals: {UI fullyQualifiedReference private. #{Core.Missing}}.
	self assert: attributes classInstanceVariableNames equals: #('classInstVar1' 'classInstVar2').
	self assert: attributes classConstants equals: {'ClassConst1' -> 16r1. 'ClassConst2' -> 16r2}!

testPrinting
	| subject |
	subject := self canonicalSubject.
	self assert: subject beforeText equals: ''.
	self assert: subject afterText equals: self definitionWithEverything.
	self assert: subject changeString equals: 'Define Refactory.Browser.Tests.ClassWithEverything'.
	self assert: subject printString equals: self definitionWithEverything , '!!'! !
!Refactory.Browser.Tests.AddClassChangeTest categoriesForMethods!
canonicalSubject!helpers!private! !
definitionWithEverything!helpers!private! !
testAsUndoCreate!public!unit tests! !
testAsUndoModify!public!unit tests! !
testAttributes!public!unit tests! !
testPrinting!public!unit tests! !
!

