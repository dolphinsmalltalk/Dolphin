"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.ChangeStaticVariableQualificationRefactoring'
	instanceVariableNames: 'selector sourceInterval method sourceTree node'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ChangeStaticVariableQualificationRefactoring guid: (Core.GUID fromString: '{232e50b2-a446-425a-bfa1-64c54cd6ea29}')!

Refactory.Browser.ChangeStaticVariableQualificationRefactoring isNonInstantiable: true!

Refactory.Browser.ChangeStaticVariableQualificationRefactoring comment: ''!

!Refactory.Browser.ChangeStaticVariableQualificationRefactoring methodsFor!

buildRewriter
	^self subclassResponsibility!

compileMethod
	model compileTree: sourceTree forMethod: method!

findNodeToTransform
	node := self sourceTree.
	sourceInterval ifNotNil: [node := node whichNodeIsContainedBy: sourceInterval].
	node ifNil: [self refactoringError: 'Invalid source interval']!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition withBlock: 
					[self findNodeToTransform.
					true])!

rewrite: anInterval inMethod: aSelector forClass: aClass 
	class := aClass.
	selector := aSelector.
	sourceInterval := anInterval.
	class := self classObjectFor: aClass.
!

sourceTree
	^sourceTree
		ifNil: 
			[method := class methodFor: selector.
			sourceTree := method boundParseTree
						ifNil: [self refactoringError: 'Could not parse source']]!

transform
	| rewriter |
	rewriter := self buildRewriter.
	(rewriter executeTree: node) ifFalse: [^self].
	node = sourceTree ifFalse: [node replaceWith: rewriter tree].
	self compileMethod! !

!Refactory.Browser.ChangeStaticVariableQualificationRefactoring categoriesForMethods!
buildRewriter!private!transforming! !
compileMethod!private!transforming! !
findNodeToTransform!preconditions!private! !
preconditions!preconditions!public! !
rewrite:inMethod:forClass:!initializing!private! !
sourceTree!accessing!private! !
transform!public!transforming! !
!

!Refactory.Browser.ChangeStaticVariableQualificationRefactoring class methodsFor!

model: aRBModel rewrite: anInterval inMethod: aSelector forClass: aClass
	^self new
		model: aRBModel;
		rewrite: anInterval
			inMethod: aSelector
			forClass: aClass;
		yourself!

model: aRBModel rewriteMethod: aSelector forClass: aClass
	^self new
		model: aRBModel;
		rewrite: nil
			inMethod: aSelector
			forClass: aClass;
		yourself!

rewrite: anInterval inMethod: aSelector forClass: aClass 
	^self new 
		rewrite: anInterval
		inMethod: aSelector
		forClass: aClass!

rewriteMethod: aSelector forClass: aClass 
	^self new 
		rewrite:  nil
		inMethod: aSelector
		forClass: aClass! !

!Refactory.Browser.ChangeStaticVariableQualificationRefactoring class categoriesForMethods!
model:rewrite:inMethod:forClass:!instance creation!public! !
model:rewriteMethod:forClass:!instance creation!public! !
rewrite:inMethod:forClass:!instance creation!public! !
rewriteMethod:forClass:!instance creation!public! !
!

