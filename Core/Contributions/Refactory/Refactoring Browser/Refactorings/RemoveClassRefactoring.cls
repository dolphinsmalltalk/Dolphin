"Filed out from Dolphin Smalltalk"!

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
								referencesTo: (Smalltalk associationAt: aSymbol ifAbsent: [aSymbol]))]]!

checkReferencesTo: aString 
	| className |
	#rbFix.	"Extracted from preconditions"
	className := aString asSymbol.
	self checkMethodReferencesTo: className.
!

classNames: aClassNameCollection 
	classNames := aClassNameCollection!

hasReferencesTo: aSymbol 
	| literal env |
	literal := Smalltalk associationAt: aSymbol.
	env := BrowserEnvironment new.
	env classesDo: 
			[:each | 
			(classNames includes: (each isMeta ifTrue: [each soleInstance] ifFalse: [each]) name) 
				ifFalse: 
					[(each whichSelectorsReferTo: literal) notEmpty ifTrue: [^true].
					(each whichSelectorsReferTo: aSymbol) notEmpty ifTrue: [^true]]].
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
!RemoveClassRefactoring categoriesForMethods!
checkMethodReferencesTo:!preconditions!private! !
checkReferencesTo:!preconditions!public! !
classNames:!initialize/release!public! !
hasReferencesTo:!preconditions!public! !
preconditions!preconditions!public! !
removeClasses!public!transforming! !
reparentSubclasses!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!RemoveClassRefactoring class methodsFor!

classNames: aClassNameCollection 
	^self new classNames: aClassNameCollection!

model: aRBNamespace classNames: aClassNameCollection 
	^(self new)
		model: aRBNamespace;
		classNames: aClassNameCollection;
		yourself! !
!RemoveClassRefactoring class categoriesForMethods!
classNames:!instance creation!public! !
model:classNames:!instance creation!public! !
!

