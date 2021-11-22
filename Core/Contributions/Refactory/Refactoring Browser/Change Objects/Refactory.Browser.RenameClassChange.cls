"Filed out from Dolphin Smalltalk"!

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
	^(self classReference bindingOrNil ifNil: [newName asQualifiedReference bindingOrNil]) value!

changeString
	^'ClassBuilder renameClass: <1s> to: <2p>' << {oldName. newName}!

classReference
	^oldName asQualifiedReference!

displayClassName
	^self classReference asString!

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
	aCollection add: (Tools.BasicRenameClassChange rename: oldName to: newName).
	super flattenOnto: aCollection!

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
!Refactory.Browser.RenameClassChange categoriesForMethods!
=!comparing!public! !
changeClass!accessing!public! !
changeString!printing!public! !
classReference!accessing!public! !
displayClassName!printing!public! !
executeNotifying:!private! !
flattenOnto:!private! !
newName!private! !
oldName!private! !
rename:to:!initialize/release!public! !
renameChangesForClass:to:!accessing!public! !
!

!Refactory.Browser.RenameClassChange class methodsFor!

rename: oldString to: newString 
	^(self new)
		rename: oldString to: newString;
		yourself! !
!Refactory.Browser.RenameClassChange class categoriesForMethods!
rename:to:!instance creation!public! !
!

