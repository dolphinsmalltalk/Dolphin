"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Refactoring subclass: #'Refactory.Browser.RemoveClassRefactoring'
	instanceVariableNames: 'classNames'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassRefactoring guid: (Core.GUID fromString: '{80687cb5-257c-4125-9d59-58ebcea2ebcb}')!
Refactory.Browser.RemoveClassRefactoring comment: ''!
!Refactory.Browser.RemoveClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RemoveClassRefactoring methodsFor!

checkReferencesTo: aRBClass
	(self hasReferencesTo: aRBClass)
		ifTrue: 
			[self
				refactoringError: ('<1p> is referenced and cannot be removed safely.<n><n>Would you like to browse references?'
						expandMacrosWith: aRBClass)
				with: 
					[| searches |
					searches := OrderedCollection new.
					aRBClass bindingOrNil
						ifNotNil: [:binding | searches add: (self model environment referencesTo: binding)].
					searches add: (self model environment referencesTo: aRBClass).
					self browseEnvironments: searches]]!

classNames: aClassNameCollection 
	classNames := aClassNameCollection!

hasReferencesTo: aRBClass
	model allReferencesToClass: aRBClass do: [:each | 
		(classNames includes: each modelClass name) ifFalse: [^true]].
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
									[self checkReferencesTo: aClass.
									true])
							& ((RBCondition hasSubclasses: aClass excluding: classNames) not
									| ((RBCondition isEmptyClass: aClass) & ((RBCondition withBlock: [aClass superclass notNil])
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
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #checkReferencesTo:!preconditions!private! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #classNames:!initialize/release!public! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #hasReferencesTo:!preconditions!public! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #removeClasses!public!transforming! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #reparentSubclasses!public!transforming! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.RemoveClassRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.RemoveClassRefactoring class methodsFor!

classNames: aClassNameCollection 
	^self new classNames: aClassNameCollection!

model: aRBNamespace classNames: aClassNameCollection 
	^(self new)
		model: aRBNamespace;
		classNames: aClassNameCollection;
		yourself! !
!Refactory.Browser.RemoveClassRefactoring class categoriesFor: #classNames:!instance creation!public! !
!Refactory.Browser.RemoveClassRefactoring class categoriesFor: #model:classNames:!instance creation!public! !

