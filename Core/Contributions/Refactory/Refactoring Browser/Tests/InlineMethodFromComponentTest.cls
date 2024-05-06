"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #InlineMethodFromComponentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InlineMethodFromComponentTest guid: (GUID fromString: '{1acdc4a3-ec00-4058-80d6-04c846e6c6a9}')!

InlineMethodFromComponentTest comment: ''!

!InlineMethodFromComponentTest categoriesForClass!Refactory-Testing! !

!InlineMethodFromComponentTest methodsFor!

testInlineComponentIntoCascadedMessage
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := InlineMethodFromComponentRefactoring
						inline: (self convertInterval: (35 to: 79) for: (RefactoryTestDataApp sourceCodeAt: #inlineComponent))
						inMethod: #inlineComponent
						forClass: RefactoryTestDataApp.
			(refactoring model classNamed: #Behavior) compile: 'hasImmediateInstances ^self format = 0'
				classified: #(#accessing).
			self setupInlineExpressionFor: refactoring toReturn: false.
			#rbFix.	"We don't want a prompt to choose between Behaviour and SmallInteger class"
			refactoring options at: #implementorToInline
				put: [:ref :imps | (imps select: [:each | each name == #Behavior]) first].
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #inlineComponent)
		equals: (RBParser
				parseMethod: 'inlineComponent
	| a aBehavior |
	a := 5.
	aBehavior := a class.
	aBehavior superclass.
	aBehavior format = 0.
	^aBehavior yourself')!

testInlineComponentMethodMax
	| refactoring |
	self proceedThroughWarning: 
			[| class |
			refactoring := InlineMethodFromComponentRefactoring
						inline: (self convertInterval: (47 to: 58) for: (RefactoryTestDataApp sourceCodeAt: #inlineMax))
						inMethod: #inlineMax
						forClass: RefactoryTestDataApp.
			self setupInlineExpressionFor: refactoring toReturn: true.
			class := refactoring model classNamed: #Magnitude.
			class
				compile: 'max: aMagnitude 
					"Answer the receiver or the argument, whichever has the greater magnitude."

					self > aMagnitude
						ifTrue: [^self]
						ifFalse: [^aMagnitude]'
				classified: #(#accessing).
			self setupImplementorToInlineFor: refactoring toReturn: class.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #inlineMax)
		equals: (RBParser
				parseMethod: 'inlineMax
								| x y q |
								x := 5.
								y := 10.
								q := x + 1 > y
									ifTrue: [x + 1]
									ifFalse: [y].
								^q')!

testInlineEmptyComponentMethod
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := InlineMethodFromComponentRefactoring
						inline: (self convertInterval: (35 to: 91) for: (RefactoryTestDataApp sourceCodeAt: #inlineComponent))
						inMethod: #inlineComponent
						forClass: RefactoryTestDataApp.
			self setupInlineExpressionFor: refactoring toReturn: false.
			#rbFix.	"We don't want a prompt to choose between Object and any other #yourself implementor"
			refactoring options at: #implementorToInline
				put: [:ref :imps | (imps select: [:each | each name == #Object]) first].
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #inlineComponent)
		equals: (RBParser
				parseMethod: 'inlineComponent
	| a anObject |
	a := 5.
	anObject := a class.
	anObject superclass.
	anObject hasImmediateInstances.
	^anObject')!

testInlineMethodFromComponentFailure
	self shouldFail: (InlineMethodFromComponentRefactoring 
				inline: (self convertInterval: (50 to: 64)
						for: (RefactoryTestDataApp sourceCodeAt: #inlineFailed))
				inMethod: #inlineFailed
				forClass: RefactoryTestDataApp)!

testModelInlineMethodWithSameVariableNames
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class compile: 'a9: a b9: b ^self + a + b' classified: #(#accessing).
	(model classNamed: #Object)
		compile: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^a a9: b b9: c'
		classified: #(#accessing).
	self proceedThroughWarning: 
			[refactoring := InlineMethodFromComponentRefactoring
						model: model
						inline: (72 to: 84)
						inMethod: #foo
						forClass: (model classNamed: #Object).
			self setupInlineExpressionFor: refactoring toReturn: false.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #Object) parseTreeFor: #foo)
		equals: (RBParser
				parseMethod: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^a + b + c')!

testModelInlineMethodWithSameVariableNames1
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: #Rectangle.
	class compile: 'rectangleRelativeTo: aRectangle ^self origin extent: aRectangle extent'
		classified: #(#accessing).
	(model classNamed: #Object)
		compile: 'foo | aRectangle temp | aRectangle := 0@0 corner: 1@1. temp := aRectangle. ^aRectangle rectangleRelativeTo: temp'
		classified: #(#accessing).
	self proceedThroughWarning: 
			[refactoring := InlineMethodFromComponentRefactoring
						model: model
						inline: (77 to: 112)
						inMethod: #foo
						forClass: (model classNamed: #Object).
			self setupInlineExpressionFor: refactoring toReturn: false.
			self setupImplementorToInlineFor: refactoring toReturn: class.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #Object) parseTreeFor: #foo)
		equals: (RBParser
				parseMethod: 'foo | aRectangle temp | aRectangle := 0@0 corner: 1@1. temp := aRectangle. ^aRectangle origin extent: temp extent')!

testModelInlineMethodWithSameVariableNames2
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class compile: 'a9: a b9: b ^self + a + b' classified: #(#accessing).
	(model classNamed: #Object)
		compile: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^c a9: b b9: a'
		classified: #(#accessing).
	self proceedThroughWarning: 
			[refactoring := InlineMethodFromComponentRefactoring
						model: model
						inline: (72 to: 84)
						inMethod: #foo
						forClass: (model classNamed: #Object).
			self setupInlineExpressionFor: refactoring toReturn: false.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #Object) parseTreeFor: #foo)
		equals: (RBParser
				parseMethod: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^c + b + a')! !

!InlineMethodFromComponentTest categoriesForMethods!
testInlineComponentIntoCascadedMessage!public!tests! !
testInlineComponentMethodMax!public!tests! !
testInlineEmptyComponentMethod!public!tests! !
testInlineMethodFromComponentFailure!failure tests!public! !
testModelInlineMethodWithSameVariableNames!public!tests! !
testModelInlineMethodWithSameVariableNames1!public!tests! !
testModelInlineMethodWithSameVariableNames2!public!tests! !
!

