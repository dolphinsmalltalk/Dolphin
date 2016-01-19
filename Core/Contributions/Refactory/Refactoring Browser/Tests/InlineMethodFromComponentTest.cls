"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #InlineMethodFromComponentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineMethodFromComponentTest guid: (GUID fromString: '{1ACDC4A3-EC00-4058-80D6-04C846E6C6A9}')!
InlineMethodFromComponentTest comment: ''!
!InlineMethodFromComponentTest categoriesForClass!Refactory-Testing! !
!InlineMethodFromComponentTest methodsFor!

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
				= (RBParser 
						parseMethod: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^a + b + c')!

testModelInlineMethodWithSameVariableNames1
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: #Rectangle.
	class 
		compile: 'rectangleRelativeTo: aRectangle ^self origin extent: aRectangle extent'
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
				= (RBParser 
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
				= (RBParser 
						parseMethod: 'foo | a b c | a := InlineMethodFromComponentTest new. b := 1. c := 2. ^c + b + a')! !
!InlineMethodFromComponentTest categoriesFor: #testInlineMethodFromComponentFailure!failure tests!public! !
!InlineMethodFromComponentTest categoriesFor: #testModelInlineMethodWithSameVariableNames!public!tests! !
!InlineMethodFromComponentTest categoriesFor: #testModelInlineMethodWithSameVariableNames1!public!tests! !
!InlineMethodFromComponentTest categoriesFor: #testModelInlineMethodWithSameVariableNames2!public!tests! !

