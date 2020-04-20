"Filed out from Dolphin Smalltalk 7"!

Refactoring subclass: #RemoveClassRefactoring
	instanceVariableNames: 'classNames'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveClassRefactoring guid: (GUID fromString: '{80687cb5-257c-4125-9d59-58ebcea2ebcb}')!
RemoveClassRefactoring comment: ''!
!RemoveClassRefactoring categoriesForClass!Refactory-Refactorings! !
!RemoveClassRefactoring methodsFor!

checkMethodReferencesTo: aSymbol
	(self hasReferencesTo: aSymbol)
		ifTrue: 
			[self
				refactoringError: ('<1s> is referenced and cannot be removed safely.<n><n>Would you like to browse references?'
						expandMacrosWith: aSymbol)
				with: 
					[#rbFix.	"Should use refactoring environment to scope the search"
					self openBrowserOn: (self model environment
								referencesTo: aSymbol asQualifiedReference bindingOrNil ?? aSymbol)]]!

checkReferencesTo: aString 
	| className |
	#rbFix.	"Extracted from preconditions"
	className := aString asSymbol.
	self checkMethodReferencesTo: className.
!

classNames: aClassNameCollection 
	classNames := aClassNameCollection!

hasReferencesTo: aSymbol
	| binding bindingRef |
	bindingRef := aSymbol asQualifiedReference.
	BrowserEnvironment new methodsDo: 
			[:each |
			each literalsDo: 
					[:literal |
					((literal refersToLiteral: bindingRef) or: [literal refersToLiteral: aSymbol]) ifTrue: [^true]]].
	^false!

preconditions
	^classNames inject: RBCondition empty
		into: 
			[:sum :each | 
			| aClass |
			aClass := self model classNamed: each asSymbol.
			aClass isNil ifTrue: [self refactoringError: 'No such class'].
			sum 
				& (((RBCondition isMetaclass: aClass) errorMacro: 'Cannot remove just the metaclass') not 
						& (RBCondition withBlock: 
									[self checkReferencesTo: each.
									true]) 
							& ((RBCondition hasSubclasses: aClass) not | ((RBCondition isEmptyClass: aClass) 
											& ((RBCondition withBlock: [aClass superclass notNil])
													errorMacro: 'Cannot remove top level class<n>when it has subclasses';
													yourself))))]!

removeClasses
	classNames do: [:each | self model removeClassNamed: each]!

reparentSubclasses
	classNames do: 
			[:each | 
			| class |
			class := self model classNamed: each.
			self model reparentClasses: class subclasses copy to: class superclass]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' classNames: '.
	classNames asArray storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		reparentSubclasses;
		removeClasses! !
!RemoveClassRefactoring categoriesFor: #checkMethodReferencesTo:!preconditions!private! !
!RemoveClassRefactoring categoriesFor: #checkReferencesTo:!preconditions!public! !
!RemoveClassRefactoring categoriesFor: #classNames:!initialize/release!public! !
!RemoveClassRefactoring categoriesFor: #hasReferencesTo:!preconditions!public! !
!RemoveClassRefactoring categoriesFor: #preconditions!preconditions!public! !
!RemoveClassRefactoring categoriesFor: #removeClasses!public!transforming! !
!RemoveClassRefactoring categoriesFor: #reparentSubclasses!public!transforming! !
!RemoveClassRefactoring categoriesFor: #storeOn:!printing!public! !
!RemoveClassRefactoring categoriesFor: #transform!public!transforming! !

!RemoveClassRefactoring class methodsFor!

classNames: aClassNameCollection 
	^self new classNames: aClassNameCollection!

model: aRBNamespace classNames: aClassNameCollection 
	^(self new)
		model: aRBNamespace;
		classNames: aClassNameCollection;
		yourself! !
!RemoveClassRefactoring class categoriesFor: #classNames:!instance creation!public! !
!RemoveClassRefactoring class categoriesFor: #model:classNames:!instance creation!public! !

