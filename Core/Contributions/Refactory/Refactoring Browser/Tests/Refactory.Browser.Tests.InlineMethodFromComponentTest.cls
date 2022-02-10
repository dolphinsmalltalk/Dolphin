"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.InlineMethodFromComponentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineMethodFromComponentTest guid: (Core.GUID fromString: '{1acdc4a3-ec00-4058-80d6-04c846e6c6a9}')!
Refactory.Browser.Tests.InlineMethodFromComponentTest comment: ''!
!Refactory.Browser.Tests.InlineMethodFromComponentTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineMethodFromComponentTest methodsFor!

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

testModelInlineMethodWithSameVariableNames
	| class refactoring |
	model := RBModel new.
	class := model classNamed: self class fullName.
	class compile: 'a9: a b9: b ^self + a + b' classified: #accessing.
	(model classNamed: Object fullName)
		compile: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^a a9: b b9: c'
		classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (72 to: 84)
				inMethod: #foo
				forClass: (model classNamed: Object fullName).
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: Object fullName) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^a + b + c')!

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
		compile: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^c a9: b b9: a'
		classified: #accessing.
	refactoring := InlineMethodFromComponentRefactoring
				model: model
				inline: (72 to: 84)
				inMethod: #foo
				forClass: (model classNamed: Object fullName).
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: Object fullName) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^c + b + a')! !
!Refactory.Browser.Tests.InlineMethodFromComponentTest categoriesForMethods!
testInlineComponentIntoCascadedMessage!public!tests! !
testInlineComponentMethodMax!public!tests! !
testInlineComponentMethodOverriddenAbort!public!tests! !
testInlineEmptyComponentMethod!public!tests! !
testInlineMethodFromComponentFailure!failure tests!public! !
testModelInlineMethodWithSameVariableNames!public!tests! !
testModelInlineMethodWithSameVariableNames1!public!tests! !
testModelInlineMethodWithSameVariableNames2!public!tests! !
!

