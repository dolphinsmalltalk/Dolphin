"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.InlineMethodFromComponentRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineMethodFromComponentRefactoringTest guid: (Core.GUID fromString: '{1acdc4a3-ec00-4058-80d6-04c846e6c6a9}')!
Refactory.Browser.Tests.InlineMethodFromComponentRefactoringTest comment: ''!
!Refactory.Browser.Tests.InlineMethodFromComponentRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineMethodFromComponentRefactoringTest methodsFor!

setUpToInlineMethodReadingPrivateClassVariable: aBoolean
	| refactoring source refDataApp object |
	object := model classNamed: Object fullName.
	source := 'foo | a | a := RefactoryTestDataApp new. ^a refersToOwnClassVariable'.
	refDataApp := model classFor: RefactoryTestDataApp.
	(refDataApp bindingFor: 'ClassVar1') isPrivate: true.
	object
		imports: #(#{Refactory.Browser.TestData});
		compile: source classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: ((source indexOf: $^) + 1 to: source size)
				inMethod: #foo
				forClass: object.
	self setupImplementorToInlineFor: refactoring toReturn: refDataApp.
	refactoring setOption: #abstractVariables
		toUse: 
			[:ref |
			self assert: ref privateClassVarReaders single key equals: 'ClassVar1'.
			self assert: ref privateClassVarWriters isEmpty.
			aBoolean].
	refactoring.
	^refactoring!

testInlineComponentIntoCascadedMessage
	| refactoring |
	refactoring := InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (35 to: 79) for: (RefactoryTestDataApp sourceCodeAt: #inlineComponent))
				inMethod: #inlineComponent
				forClass: RefactoryTestDataApp.
	(refactoring model classFor: Behavior) compile: 'hasImmediateInstances ^self format = 0'
		classified: #accessing.
	self setupInlineExpressionFor: refactoring toReturn: false.
	"We don't want a prompt to choose between Behaviour and SmallInteger class"
	refactoring setOption: #implementorToInline
		toUse: 
			[:ref :imps |
			self assert: imps asSet equals: (refactoring model allImplementorsOf: #hasImmediateInstances).
			refactoring model classFor: Behavior].
	"ignore the fact that it is overridden"
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :selector :class |
			self assert: selector identicalTo: #hasImmediateInstances.
			self assert: class identicalTo: (refactoring model classFor: Behavior).
			true].
	self executeRefactoring: refactoring.
	self
		assert: ((refactoring model classNamed: RefactoryTestDataApp fullName) parseTreeFor: #inlineComponent)
		equals: (self
				parseMethod: 'inlineComponent
	| a aBehavior |
	a := 5.
	aBehavior := a class.
	aBehavior superclass.
	aBehavior format = 0.
	^aBehavior yourself')!

testInlineComponentMethodMax
	| refactoring class |
	refactoring := InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (47 to: 58) for: (RefactoryTestDataApp sourceCodeAt: #inlineMax))
				inMethod: #inlineMax
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: true.
	"Add a new implementation of #max: in Magnitude to inline so that we know what to expect. This is overridden in at least the Point subclass of Magnitude."
	class := refactoring model classNamed: Magnitude fullName.
	class
		compile: 'max: aMagnitude 
					"Answer the receiver or the argument, whichever has the greater magnitude."

					self > aMagnitude
						ifTrue: [^self]
						ifFalse: [^aMagnitude]'
		classified: #accessing.
	self setupImplementorToInlineFor: refactoring toReturn: class.
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :symbol :inlineClass |
			self assert: symbol identicalTo: #max:.
			self assert: inlineClass equals: class.
			true].
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineMax)
		equals: (self
				parseMethod: 'inlineMax
								| x y q |
								x := 5.
								y := 10.
								q := x + 1 > y
									ifTrue: [x + 1]
									ifFalse: [y].
								^q')!

testInlineComponentMethodOverriddenAbort
	| refactoring class |
	refactoring := InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (47 to: 58) for: (RefactoryTestDataApp sourceCodeAt: #inlineMax))
				inMethod: #inlineMax
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: true.
	class := refactoring model classNamed: Magnitude fullName.
	self setupImplementorToInlineFor: refactoring toReturn: class.
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :symbol :inlineClass |
			self assert: inlineClass identicalTo: class.
			self assert: symbol identicalTo: #max:.
			false].
	self shouldAbort: refactoring!

testInlineEmptyComponentMethod
	| refactoring implementors optionCalled |
	refactoring := InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (35 to: 91) for: (RefactoryTestDataApp sourceCodeAt: #inlineComponent))
				inMethod: #inlineComponent
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	"We don't want a prompt to choose between Object and any other #yourself implementor"
	implementors := refactoring model allImplementorsOf: #yourself.
	implementors size > 1
		ifTrue: 
			[optionCalled := false.
			refactoring setOption: #implementorToInline
				toUse: 
					[:ref :imps |
					optionCalled := true.
					self assert: imps equals: implementors.
					refactoring model classFor: Object]]
		ifFalse: [optionCalled := true].
	self executeRefactoring: refactoring.
	self assert: optionCalled.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineComponent)
		equals: (self
				parseMethod: 'inlineComponent
	| a anObject |
	a := 5.
	anObject := a class.
	anObject superclass.
	anObject hasImmediateInstances.
	^anObject')!

testInlineMethodFromComponentFailure
	self shouldFail: (InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (50 to: 64) for: (RefactoryTestDataApp sourceCodeAt: #inlineFailed))
				inMethod: #inlineFailed
				forClass: RefactoryTestDataApp)
		withMessage: 'There are no definitions of #fooMax:'!

testModelInlineClassMethodAccessingClassVariables
	| refactoring object source refDataApp |
	model := RBModel new.
	object := model classNamed: Object fullName.
	source := 'foo RefactoryTestDataApp classSideClassVarRefs'.
	refDataApp := model classFor: RefactoryTestDataApp.
	(refDataApp bindingFor: 'ClassVar2') isPrivate: true.
	(refDataApp bindingFor: 'AppConst1') isPrivate: true.
	object
		imports: #(#{Refactory.Browser.TestData});
		compile: source classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (5 to: source size)
				inMethod: #foo
				forClass: object.
	self setupImplementorToInlineFor: refactoring toReturn: refDataApp.
	"Although the method returns a class var, it is not private so we expect it to just be inlined as a fully qualified name"
	refactoring setOption: #abstractVariables
		toUse: 
			[:ref |
			self assert: ref privateClassVarReaders single key equals: 'AppConst1'.
			self assert: ref privateClassVarWriters single key equals: 'ClassVar2'.
			true].
	self executeRefactoring: refactoring.
	"The private class vars are abstracted. Public class vars are not, and the refs to these are rewritten unless initially fully-qualified."
	self assert: (object parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo
	RefactoryTestDataApp classVar2: {
				RefactoryTestDataApp.ClassVar1.
				RefactoryTestDataApp appConst1.
				#{_.RefactoryTestDataApp.ClassVar1}.
				#{Refactory.Browser.TestData.RefactoryTestDataApp.ClassVar1}.
				#{Refactory.Browser.TestData.RefactoryTestDataApp.ClassVar2}.
				#{Refactory.Browser.TestData.RefactoryTestDataApp.AppConst1}
			}').
	self
		verifyMethod: #classVar2
			of: refDataApp metaclass
			equals: 'classVar2 ^ClassVar2';
		verifyMethod: #classVar2:
			of: refDataApp metaclass
			equals: 'classVar2: anObject ClassVar2 := anObject';
		verifyMethod: #appConst1
			of: refDataApp metaclass
			equals: 'appConst1 ^AppConst1'.
	self
		deny: (refDataApp metaclass includesSelector: #classVar1);
		deny: (refDataApp metaclass includesSelector: #classVar1);
		deny: (refDataApp metaclass includesSelector: #appConst1:)!

testModelInlineMethodReadingPrivateClassVariable
	"Private class variables have to be abstracted before methods accessing them can be inlined"

	| refactoring |
	refactoring := self setUpToInlineMethodReadingPrivateClassVariable: true.
	self executeRefactoring: refactoring.
	self assert: ((model classNamed: Object fullName) parseTreeFor: #foo)
		equals: (self parseMethod: 'foo | a | a := RefactoryTestDataApp new. ^a class classVar1')!

testModelInlineMethodReadingPrivateClassVariableRefuseAbstract
	"Private class variables have to be abstracted before methods accessing them can be inlined"

	self shouldAbort: (self setUpToInlineMethodReadingPrivateClassVariable: false)!

testModelInlineMethodReadingUnqualifiedClassVariable
	| refactoring object source |
	model := RBModel new.
	object := model classNamed: Object fullName.
	source := 'foo | a | a := RefactoryTestDataApp new. ^a refersToOwnClassVariable'.
	object
		imports: #(#{Refactory.Browser.TestData});
		compile: source classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: ((source indexOf: $^) + 1 to: source size)
				inMethod: #foo
				forClass: object.
	self setupImplementorToInlineFor: refactoring toReturn: (model classFor: RefactoryTestDataApp).
	"Although the method returns a class var, it is not private so we expect it to just be inlined as a fully qualified reference"
	refactoring setOption: #abstractVariables toUse: [self fail: 'Unexpected abstract variables'].
	self executeRefactoring: refactoring.
	self assert: (object parseTreeFor: #foo)
		equals: (self parseMethod: 'foo | a | a := RefactoryTestDataApp new. ^RefactoryTestDataApp.ClassVar1')!

testModelInlineMethodWithSameVariableNames
	| class refactoring object |
	model := RBModel new.
	class := model classNamed: self class fullName.
	class compile: 'a9: a b9: b ^self + a + b' classified: #accessing.
	object := model classNamed: Object fullName.
	object
		imports: #(#{Refactory.Browser.Tests});
		compile: 'foo | a b c | a := InlineMethodFromComponentRefactoringTest new. b := 1. c := 2. ^a a9: b b9: c'
			classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (83 to: 95)
				inMethod: #foo
				forClass: (model classNamed: Object fullName).
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self assert: (object parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo | a b c | a := InlineMethodFromComponentRefactoringTest new. b := 1. c := 2. ^a + b + c')!

testModelInlineMethodWithSameVariableNames1
	| class refactoring |
	model := RBModel new.
	class := model classNamed: #'Graphics.Rectangle'.
	class compile: 'rectangleRelativeTo: aRectangle ^self origin extent: aRectangle extent'
		classified: #accessing.
	(model classNamed: Object fullName)
		compile: 'foo | aRectangle temp | aRectangle := 0@0 corner: 1@1. temp := aRectangle. ^aRectangle rectangleRelativeTo: temp'
		classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (77 to: 112)
				inMethod: #foo
				forClass: (model classNamed: Object fullName).
	self setupInlineExpressionFor: refactoring toReturn: false.
	self setupImplementorToInlineFor: refactoring toReturn: class.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: Object fullName) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo | aRectangle temp | aRectangle := 0@0 corner: 1@1. temp := aRectangle. ^aRectangle origin extent: temp extent')!

testModelInlineMethodWithSameVariableNames2
	| class refactoring |
	model := RBModel new.
	class := model classNamed: self class fullName.
	class compile: 'a9: a b9: b ^self + a + b' classified: #accessing.
	(model classNamed: Object fullName)
		imports: #(#{Refactory.Browser.Tests});
		compile: 'foo | a b c | a := InlineMethodFromComponentRefactoringTest new. b := 1. c := 2. ^c a9: b b9: a'
			classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (83 to: 95)
				inMethod: #foo
				forClass: (model classNamed: Object fullName).
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: Object fullName) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo | a b c | a := InlineMethodFromComponentRefactoringTest new. b := 1. c := 2. ^c + b + a')!

testModelInlineUnbindableReference
	| refactoring object source refDataApp |
	model := RBModel new.
	object := model classNamed: Object fullName.
	source := 'foo ^RefactoryTestDataApp refersToClassBindingNotFound'.
	refDataApp := model classFor: RefactoryTestDataApp.
	object compile: source classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (6 to: source size)
				inMethod: #foo
				forClass: object.
	self setupImplementorToInlineFor: refactoring toReturn: refDataApp.
	"Although the method returns a class var, it is not private so we expect it to just be inlined as a fully qualified name"
	refactoring setOption: #abstractVariables
		toUse: 
			[:ref |
			self fail: 'Unexpected abstract variables'.
			false].
	self executeRefactoring: refactoring.
	"The private class vars are abstracted. Public class vars are not, and the refs to these are rewritten unless initially fully-qualified."
	self assert: (object parseTreeFor: #foo) equals: (self parseMethod: 'foo ^#{_.Tests.DolphinTest} bindingOrNil')!

testModelInlineUnbindableReferenceInArray
	| refactoring object source |
	model := RBModel new.
	object := model classNamed: Object fullName.
	source := 'foo ^RefactoryTestDataApp refersToClassBindingNotFoundInArray'.
	object compile: source classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (6 to: source size)
				inMethod: #foo
				forClass: object.
	self setupImplementorToInlineFor: refactoring toReturn: (model classFor: RefactoryTestDataApp).
	refactoring setOption: #abstractVariables
		toUse: 
			[:ref |
			self fail: 'Unexpected abstract variables'.
			false].
	self executeRefactoring: refactoring.
	self assert: (object parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo ^#(#{_.Tests.DolphinTest} #{Refactory.Browser.Tests.ClassToRename} #{ClassToRename} #{Foo.ClassToRename} ) collect: [:each | each valueOrNil]')! !
!Refactory.Browser.Tests.InlineMethodFromComponentRefactoringTest categoriesForMethods!
setUpToInlineMethodReadingPrivateClassVariable:!helpers!private! !
testInlineComponentIntoCascadedMessage!public!tests! !
testInlineComponentMethodMax!public!tests! !
testInlineComponentMethodOverriddenAbort!public!tests! !
testInlineEmptyComponentMethod!public!tests! !
testInlineMethodFromComponentFailure!failure tests!public! !
testModelInlineClassMethodAccessingClassVariables!public!tests! !
testModelInlineMethodReadingPrivateClassVariable!public!tests! !
testModelInlineMethodReadingPrivateClassVariableRefuseAbstract!public!tests! !
testModelInlineMethodReadingUnqualifiedClassVariable!public!tests! !
testModelInlineMethodWithSameVariableNames!public!tests! !
testModelInlineMethodWithSameVariableNames1!public!tests! !
testModelInlineMethodWithSameVariableNames2!public!tests! !
testModelInlineUnbindableReference!public!tests! !
testModelInlineUnbindableReferenceInArray!public!tests! !
!

