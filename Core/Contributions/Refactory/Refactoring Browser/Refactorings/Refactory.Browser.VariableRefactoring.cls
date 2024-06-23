"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.VariableRefactoring'
	instanceVariableNames: 'class variableName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.VariableRefactoring guid: (Core.GUID fromString: '{0ef75a5c-d99d-489e-b05f-2cf5a57d0f2c}')!

Refactory.Browser.VariableRefactoring isNonInstantiable: true!

Refactory.Browser.VariableRefactoring comment: ''!

!Refactory.Browser.VariableRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.VariableRefactoring methodsFor!

replaceReferencesToVariable: sourceVariableBinding in: aCollectionOfMethods with: targetVariableBinding
	| rewriter hasSourceBinding |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '`identifier'
		withValueFrom: 
			[:variableNode |
			variableNode copyWithName: (self shortestNameToBind: targetVariableBinding from: variableNode)]
		when: [:variableNode | variableNode binding == sourceVariableBinding].
	"We rewrite any BindingReferences that bind to old variable, even if embedded in literal arrays. Symbols are not renamed."
	hasSourceBinding := [:refNode | refNode binding == sourceVariableBinding].
	rewriter
		replace: '`#literal'
		withValueFrom: 
			[:literalNode |
			literalNode rewriteQualifiedReferencesWith: 
					[:refNode |
					"When enumerating a literal array we may encounter other qualified refs than those targetting the binding we are updating"
					refNode basicBinding == sourceVariableBinding
						ifTrue: [self rewriteQualifiedReference: refNode toTarget: targetVariableBinding]
						ifFalse: [refNode copy]]]
		when: [:literalNode | literalNode isOrContainsQualifiedReferenceMatching: hasSourceBinding].
	self rewriteVariablesOfMethods: aCollectionOfMethods with: rewriter!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' variable: '.
	variableName storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPut: $)!

variable: aVarName class: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	variableName := aVarName.
	class := self classObjectFor: aClass.
! !

!Refactory.Browser.VariableRefactoring categoriesForMethods!
replaceReferencesToVariable:in:with:!private!transforming! !
storeOn:!printing!public! !
variable:class:!initialize/release!public! !
!

!Refactory.Browser.VariableRefactoring class methodsFor!

model: aRBModel variable: aVarName class: aClass
	^self new
		model: aRBModel;
		variable: aVarName class: aClass;
		yourself!

variable: aVarName class: aClass
	^self new variable: aVarName class: aClass! !

!Refactory.Browser.VariableRefactoring class categoriesForMethods!
model:variable:class:!instance creation!public! !
variable:class:!instance creation!public! !
!

