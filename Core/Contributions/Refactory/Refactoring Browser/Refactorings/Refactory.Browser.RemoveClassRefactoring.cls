"Filed out from Dolphin Smalltalk"!

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
	| refs |
	refs := self referencesToClass: aRBClass.
	(refs isEmpty or: [self shouldRemoveClass: aRBClass referencedIn: refs])
		ifFalse: [self refactoringAborted]!

classNames: aClassNameCollection 
	classNames := aClassNameCollection!

hasReferencesTo: aRBClass
	model allReferencesToClass: aRBClass do: [:each | 
		(classNames includes: each modelClass instanceClass name) ifFalse: [^true]].
	^false!

preconditions
	^classNames inject: RBCondition empty
		into: 
			[:sum :each |
			| aClass |
			aClass := self model classNamed: each.
			aClass isNil ifTrue: [self refactoringError: 'No such class'].
			sum
				& (((RBCondition isMetaclass: aClass) errorMacro: 'Cannot remove just the metaclass') not
						& ((RBCondition hasSubclasses: aClass excluding: classNames) not
								| ((RBCondition isEmptyClass: aClass) & ((RBCondition withBlock: [aClass superclass notNil])
												errorMacro: 'Cannot remove top level class when it has subclasses';
												yourself)))
							& (RBCondition withBlock: 
										[self checkReferencesTo: aClass.
										true]))]!

referencesToClass: aRBClass
	| refs |
	refs := OrderedCollection new.
	model allReferencesToClass: aRBClass
		do: [:each | (classNames includes: each modelClass instanceClass name) ifFalse: [refs addLast: each]].
	^refs!

removeClasses
	classNames do: [:each | self model removeClassNamed: each]!

reparentSubclasses
	classNames do: 
			[:each |
			| class |
			class := self model instanceClassNamed: each.
			self model reparentClasses: class subclasses copy to: class superclass]!

shouldRemoveClass: aRBClass referencedIn: aCollection
	^(self lookupOption: #removeReferencedClass)
		cull: self
		cull: aRBClass
		cull: aCollection!

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
!Refactory.Browser.RemoveClassRefactoring categoriesForMethods!
checkReferencesTo:!preconditions!private! !
classNames:!initialize/release!public! !
hasReferencesTo:!preconditions!public! !
preconditions!preconditions!public! !
referencesToClass:!helpers!private! !
removeClasses!public!transforming! !
reparentSubclasses!public!transforming! !
shouldRemoveClass:referencedIn:!private!requests! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.RemoveClassRefactoring class methodsFor!

classNames: aClassNameCollection 
	^self new classNames: aClassNameCollection!

model: aRBModel classNames: aClassNameCollection
	^self new
		model: aRBModel;
		classNames: aClassNameCollection;
		yourself! !
!Refactory.Browser.RemoveClassRefactoring class categoriesForMethods!
classNames:!instance creation!public! !
model:classNames:!instance creation!public! !
!

