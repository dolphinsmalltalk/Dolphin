"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest
	subclass: #'Refactory.Browser.Tests.AddClassChangeTest'
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
	^self subjectClass definition: self definitionWithEverything!

definitionWithEverything
	^'Core.Model
	subclass: #''Refactory.Browser.Tests.ClassWithEverything''
	instanceVariableNames: ''instvar1 instvar2''
	classVariableNames: ''ClassVar1 ClassVar2''
	imports: #(#{UI private} #{Core.Missing})
	classInstanceVariableNames: ''classInstVar1 classInstVar2''
	classConstants: { ''ClassConst1'' -> 16r1. ''ClassConst2'' -> 16r2 }'!

subjectClass
	^AddClassChange!

testAsUndoCreate
	| subject undo |
	subject := self canonicalSubject.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: RemoveClassChange.
	self assert: undo classReference equals: subject classReference.
	"Until the change is applied, the undo's beforeText will be empty because the class does not exist"
	self assert: undo beforeText equals: ''.
	self assert: undo afterText equals: ''!

testAsUndoModify
	| subject undo definition |
	definition := ClassDetails fromClass: ClassToRename.
	definition imports: #(#{Refactory.Browser.TestData}).
	definition classInstanceVariableNames: #().
	definition classConstants: { 'ClassConst1' -> 16r2. 'ClassConst3' -> '3' }.
	subject := self subjectClass details: definition.
	self assert: subject beforeText equals: ClassToRename definition.
	self assert: subject afterText
		equals: 'Core.Model
	subclass: #''Refactory.Browser.Tests.ClassToRename''
	instanceVariableNames: ''rewriteRule builder class''
	classVariableNames: ''ClassVar1''
	imports: #(#{Refactory.Browser.TestData})
	classInstanceVariableNames: ''''
	classConstants: { ''ClassConst1'' -> 16r2. ''ClassConst3'' -> ''3'' }'.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo changeClass identicalTo: subject changeClass.
	self assert: undo afterText equals: ClassToRename definition.
	self assert: undo details imports equals: #()!

testDetails
	| subject details |
	subject := self canonicalSubject.
	details := subject details.
	self assert: details kindOfSubclass equals: 'subclass:'.
	self assert: details instanceVariableNames equals: #('instvar1' 'instvar2').
	self assert: details classVariableNames equals: #('ClassVar1' 'ClassVar2').
	self assert: details imports equals: {UI fullyQualifiedReference private. #{Core.Missing}}.
	self assert: details classInstanceVariableNames equals: #('classInstVar1' 'classInstVar2').
	self assert: details classConstants equals: {'ClassConst1' -> 16r1. 'ClassConst2' -> 16r2}.
	"Not everything is included in the class definition message though"
	self assertIsNil: details guid.
	self assertIsNil: details comment.
	self assertIsNil: details categoryNames.
	self assertIsNil: details package!

testPrinting
	| subject details newDefinitionString |
	details := ClassDetails fromClass: TestCase.
	details
		instanceVariableString: 'foo bar';
		classInstanceVariableString: 'blah'.
	newDefinitionString := details printString.
	subject := self subjectClass definition: newDefinitionString.
	self assert: subject beforeText equals: TestCase definition.
	self assert: subject afterText equals: newDefinitionString.
	self assert: subject changeString equals: 'Define ' , TestCase fullName.
	self assert: subject printString equals: newDefinitionString , '!!' , String lineDelimiter!

testPrintingLegacyClass
	| subject definitionString |
	definitionString := 'Presenter subclass: #Scribble
	instanceVariableNames: ''newStroke trackingCanvas''
	classVariableNames: ''''
	poolDictionaries: ''''
	classInstanceVariableNames: '''''.
	subject := self subjectClass definition: definitionString.
	self assert: subject beforeText
		equals: (#{Smalltalk.Scribble} valueOrNil ifNil: [''] ifNotNil: [:scribble | scribble definition]).
	self assert: subject afterText equals: definitionString.
	self assert: subject changeString equals: 'Define Scribble'.
	self assert: subject printString equals: definitionString , '!!
!!Scribble categoriesForClass!!Unclassified!! !!
'!

testPrintingNewClass
	| subject |
	subject := self canonicalSubject.
	self assert: subject beforeText equals: ''.
	self assert: subject afterText equals: self definitionWithEverything.
	self assert: subject changeString equals: 'Define Refactory.Browser.Tests.ClassWithEverything'.
	self assert: subject printString equals: self definitionWithEverything , '!!
'!

testPrintingNewLegacyClass
	| subject definitionString |
	definitionString := 'Presenter subclass: #Scribble2
	instanceVariableNames: ''newStroke trackingCanvas''
	classVariableNames: ''''
	poolDictionaries: ''''
	classInstanceVariableNames: '''''.
	subject := self subjectClass
				definition: (definitionString copyReplaceAll: '#Scribble2' with: '#''Smalltalk.Scribble2''').
	self assert: subject beforeText equals: ''.
	self assert: subject afterText equals: definitionString.
	self assert: subject changeString equals: 'Define Smalltalk.Scribble2'.
	self assert: subject printString equals: definitionString ,  '!!
!!Scribble2 categoriesForClass!!Unclassified!! !!
'!

testRootClass
	| subject details munger |
	details := ClassDetails fromClass: Object.
	details instanceVariableString: 'foo bar'.
	subject := self subjectClass details: details.
	self assert: subject beforeText equals: Object definition.
	munger := 
			[:definition |
			definition copyReplaceAll: 'instanceVariableNames: ''''' with: 'instanceVariableNames: ''foo bar'''].
	self assert: subject afterText equals: (munger value: Object definition).
	self assert: subject changeString equals: 'Define Core.Object'.
	self assert: subject printString equals: subject afterText, '!!
Core.Object guid: (Core.GUID fromString: ''{87b4c451-026e-11d3-9fd7-00a0cc3e4a32}'')!!
Core.Object comment: ', Object comment printString, '!!
!!Core.Object categoriesForClass!!Kernel-Objects!! !!
'! !
!Refactory.Browser.Tests.AddClassChangeTest categoriesForMethods!
canonicalSubject!helpers!private! !
definitionWithEverything!helpers!private! !
subjectClass!constants!private! !
testAsUndoCreate!public!unit tests! !
testAsUndoModify!public!unit tests! !
testDetails!public!unit tests! !
testPrinting!public!unit tests! !
testPrintingLegacyClass!public!unit tests! !
testPrintingNewClass!public!unit tests! !
testPrintingNewLegacyClass!public!unit tests! !
testRootClass!public!unit tests! !
!

