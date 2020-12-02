"Filed out from Dolphin Smalltalk 7"!

CompositeRefactoryChange subclass: #RenameVariableChange
	instanceVariableNames: 'className isMeta oldName newName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RenameVariableChange guid: (GUID fromString: '{e500a4e5-c686-4c27-903e-02242b8aa5f6}')!
RenameVariableChange isAbstract: true!
RenameVariableChange comment: ''!
!RenameVariableChange categoriesForClass!Refactory-Change Objects! !
!RenameVariableChange methodsFor!

= aRenameVariableChange 
	self class = aRenameVariableChange class ifFalse: [^false].
	^className = aRenameVariableChange changeClassName and: 
			[isMeta = aRenameVariableChange isMeta and: 
					[oldName = aRenameVariableChange oldName 
						and: [newName = aRenameVariableChange newName]]]!

changeClass
	^self changeClassName asQualifiedReference valueOrNil
		ifNotNil: [:class | isMeta ifTrue: [class class] ifFalse: [class]]!

changeClass: aBehavior 
	isMeta := aBehavior isMeta.
	className := aBehavior instanceClass name!

changeClassName
	^className!

changeClassName: aSymbol 
	className := aSymbol.
	isMeta isNil ifTrue: [isMeta := false]!

changeString
	^'Rename ' , oldName , ' to ' , newName!

displayClassName
	^isMeta 
		ifTrue: [self changeClassName , ' class']
		ifFalse: [self changeClassName asString]!

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
	^(self changeClassName hash bitXor: self oldName hash) 
		bitXor: self newName hash!

isMeta
	^isMeta!

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
!RenameVariableChange categoriesFor: #=!comparing!public! !
!RenameVariableChange categoriesFor: #changeClass!accessing!public! !
!RenameVariableChange categoriesFor: #changeClass:!accessing!public! !
!RenameVariableChange categoriesFor: #changeClassName!accessing!public! !
!RenameVariableChange categoriesFor: #changeClassName:!accessing!public! !
!RenameVariableChange categoriesFor: #changeString!printing!public! !
!RenameVariableChange categoriesFor: #displayClassName!printing!public! !
!RenameVariableChange categoriesFor: #executeNotifying:!private! !
!RenameVariableChange categoriesFor: #hash!comparing!public! !
!RenameVariableChange categoriesFor: #isMeta!private! !
!RenameVariableChange categoriesFor: #newName!accessing!public! !
!RenameVariableChange categoriesFor: #newName:!private! !
!RenameVariableChange categoriesFor: #oldName!accessing!public! !
!RenameVariableChange categoriesFor: #oldName:!private! !
!RenameVariableChange categoriesFor: #printOn:!printing!public! !
!RenameVariableChange categoriesFor: #renameVariable!private! !

!RenameVariableChange class methodsFor!

rename: oldName to: newName in: aClass 
	^(self new)
		oldName: oldName;
		newName: newName;
		changeClass: aClass;
		yourself! !
!RenameVariableChange class categoriesFor: #rename:to:in:!instance creation!public! !

