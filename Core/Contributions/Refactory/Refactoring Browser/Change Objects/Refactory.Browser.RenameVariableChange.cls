"Filed out from Dolphin Smalltalk"!

Refactory.Browser.CompositeRefactoryChange
	subclass: #'Refactory.Browser.RenameVariableChange'
	instanceVariableNames: 'oldName newName classReference'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameVariableChange guid: (Core.GUID fromString: '{e500a4e5-c686-4c27-903e-02242b8aa5f6}')!
Refactory.Browser.RenameVariableChange isNonInstantiable: true!
Refactory.Browser.RenameVariableChange comment: ''!
!Refactory.Browser.RenameVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RenameVariableChange methodsFor!

= aRenameVariableChange
	self class = aRenameVariableChange class ifFalse: [^false].
	^classReference = aRenameVariableChange classReference
		and: [oldName = aRenameVariableChange oldName and: [newName = aRenameVariableChange newName]]!

changeClass
	^classReference valueOrNil!

changeClass: aBehavior
	classReference := aBehavior fullName asQualifiedReference!

changeClassName
	^classReference asString!

changeClassName: aString
	| wasMeta |
	wasMeta := classReference notNil and: [classReference isMeta].
	classReference := BindingReference pathString: aString.
	wasMeta ifTrue: [classReference := classReference meta]!

changeString
	^'Rename ' , oldName , ' to ' , newName!

classReference
	^classReference!

executeNotifying: aBlock
	| undo |
	#rbFix.	"Rather than doing the change as an add, copy values, and then remove, we just rename the variable directly in the class. This is particularly advantageous when renaming an instance variable since it remains in the same position (important for use of #instVarAt: and if the class' instances have saved using STB). With this change the #addNewVariable, #copyOldValuesToNewVariable, and #removeOldVariable methods are not required, being replaced with #renameVariable."
	self renameVariable.
	undo := self basicExecuteNotifying: aBlock.
	undo
		oldName: newName;
		newName: oldName.
	^undo!

hash
	^(classReference hash bitXor: self oldName hash) 
		bitXor: self newName hash!

isMeta
	^classReference isMeta!

newName
	^newName!

newName: aString 
	newName := aString!

oldName
	^oldName!

oldName: aString
	oldName := aString!

printOn: aStream
	aStream nextPutAll: self displayString!

renameVariable
	^self subclassResponsibility! !
!Refactory.Browser.RenameVariableChange categoriesForMethods!
=!comparing!public! !
changeClass!accessing!public! !
changeClass:!accessing!public! !
changeClassName!accessing!public! !
changeClassName:!accessing!public! !
changeString!printing!public! !
classReference!accessing!public! !
executeNotifying:!applying!private! !
hash!comparing!public! !
isMeta!private!testing! !
newName!accessing!public! !
newName:!accessing!private! !
oldName!accessing!public! !
oldName:!accessing!private! !
printOn:!printing!public! !
renameVariable!applying!private! !
!

!Refactory.Browser.RenameVariableChange class methodsFor!

rename: oldName to: newName in: aClass 
	^(self new)
		oldName: oldName;
		newName: newName;
		changeClass: aClass;
		yourself! !
!Refactory.Browser.RenameVariableChange class categoriesForMethods!
rename:to:in:!instance creation!public! !
!

