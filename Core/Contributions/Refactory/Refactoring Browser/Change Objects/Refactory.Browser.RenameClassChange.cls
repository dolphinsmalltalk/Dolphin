"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.CompositeRefactoryChange subclass: #'Refactory.Browser.RenameClassChange'
	instanceVariableNames: 'oldName newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameClassChange guid: (Core.GUID fromString: '{a88eaba4-304f-4675-8b55-d3301bc1166d}')!
Refactory.Browser.RenameClassChange comment: ''!
!Refactory.Browser.RenameClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RenameClassChange methodsFor!

= aRenameClassChange 
	super = aRenameClassChange ifFalse: [^false].
	^oldName = aRenameClassChange oldName 
		and: [newName = aRenameClassChange newName]!

changeClass
	^(oldName asQualifiedReference bindingOrNil ifNil: [newName asQualifiedReference binding]) value!

executeNotifying: aBlock
	| undos |
	#rbFix.	"For Dolphin use the ClassBuilder"
	ClassBuilder renameClass: self changeClass to: newName.
	undos := changes
				collect: [:each | (each renameChangesForClass: oldName asSymbol to: newName asSymbol) executeNotifying: aBlock].
	^self copy
		changes: undos reverse;
		rename: newName to: oldName;
		yourself!

flattenOnto: aCollection 
	aCollection 
		add: (self copy changes: (changes inject: OrderedCollection new
						into: 
							[:sum :each | 
							each flattenOnto: sum.
							sum]))!

newName
	^newName!

oldName
	^oldName!

rename: oldString to: newString 
	oldName := oldString.
	newName := newString.
	#rbFix "Set a default name?".
	name := 'Rename class ''', oldName, ''' to ''', newString, ''''!

renameChangesForClass: aClassName to: newClassName 
	| change |
	change := super renameChangesForClass: aClassName to: newClassName.
	oldName asSymbol == aClassName 
		ifTrue: [change rename: newClassName to: newName].
	^change! !
!Refactory.Browser.RenameClassChange categoriesFor: #=!comparing!public! !
!Refactory.Browser.RenameClassChange categoriesFor: #changeClass!accessing!public! !
!Refactory.Browser.RenameClassChange categoriesFor: #executeNotifying:!private! !
!Refactory.Browser.RenameClassChange categoriesFor: #flattenOnto:!private! !
!Refactory.Browser.RenameClassChange categoriesFor: #newName!private! !
!Refactory.Browser.RenameClassChange categoriesFor: #oldName!private! !
!Refactory.Browser.RenameClassChange categoriesFor: #rename:to:!initialize/release!public! !
!Refactory.Browser.RenameClassChange categoriesFor: #renameChangesForClass:to:!accessing!public! !

!Refactory.Browser.RenameClassChange class methodsFor!

rename: oldString to: newString 
	^(self new)
		rename: oldString to: newString;
		yourself! !
!Refactory.Browser.RenameClassChange class categoriesFor: #rename:to:!instance creation!public! !

