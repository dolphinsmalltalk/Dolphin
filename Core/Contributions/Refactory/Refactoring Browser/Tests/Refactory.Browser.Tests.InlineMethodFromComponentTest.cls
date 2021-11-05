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
	(refactoring model classNamed: Behavior fullName) compile: 'hasImmediateInstances ^self format = 0'
		classified: #accessing.
	self setupInlineExpressionFor: refactoring toReturn: false.
	"We don't want a prompt to choose between Behaviour and SmallInteger class"
	refactoring setOption: #implementorToInline
		toUse: [:ref :imps | (imps select: [:each | each name = Behavior fullName]) first].
	"ignore the fact that it is overridden"
	refactoring setOption: #inlineOverridden toUse: [:rcvr :symbol :inlineClass | true].
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
	| refactoring class overridden |
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
	overridden := nil.
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :symbol :inlineClass |
			overridden := inlineClass methodFor: symbol.
			true].
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				parseTreeFor: #inlineMax)
		equals: (self
				parseMethod: 'inlineMax
								| x y q |
								x := 5.
								y := 10.
								q := x + 1 > y
									ifTrue: [x + 1]
									ifFalse: [y].
								^q').
	self assert: overridden modelClass equals: class.
	self assert: overridden selector equals: #max:!

testInlineComponentMethodOverriddenAbort
	| refactoring class overridden |
	refactoring := InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (47 to: 58) for: (RefactoryTestDataApp sourceCodeAt: #inlineMax))
				inMethod: #inlineMax
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: true.
	class := refactoring model classNamed: Magnitude fullName.
	self setupImplementorToInlineFor: refactoring toReturn: class.
	overridden := nil.
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :symbol :inlineClass |
			overridden := inlineClass methodFor: symbol.
			false].
	self should: [self executeRefactoring: refactoring] raise: OperationAborted.
	self assert: overridden modelClass equals: class.
	self assert: overridden selector equals: #max:!

testInlineEmptyComponentMethod
	| refactoring |
	refactoring := InlineMethodFromComponentRefactoring
				inline: (self convertInterval: (35 to: 91) for: (RefactoryTestDataApp sourceCodeAt: #inlineComponent))
				inMethod: #inlineComponent
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	#rbFix.	"We don't want a prompt to choose between Object and any other #yourself implementor"
	refactoring setOption: #implementorToInline
		toUse: [:ref :imps | (imps select: [:each | each name == #'Core.Object']) first].
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				parseTreeFor: #inlineComponent)
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
				forClass: RefactoryTestDataApp)!

testModelInlineMethodWithSameVariableNames
	| class refactoring |
	model := RBNamespace new.
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
	model := RBNamespace new.
	class := model classNamed: Graphics.Rectangle fullName.
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
	model := RBNamespace new.
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

