"Filed out from Dolphin Smalltalk"!

RefactoryClassChange subclass: #RemoveClassChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RemoveClassChange guid: (GUID fromString: '{d652f7f1-4258-4cf0-8a95-562b45ae0e17}')!

RemoveClassChange comment: ''!

!RemoveClassChange categoriesForClass!Refactory-Change Objects! !

!RemoveClassChange methodsFor!

asUndoOperation
	| classChanges |
	classChanges := CompositeRefactoryChange new.
	self changeClass withAllSubclasses do: 
			[:each | 
			classChanges defineClass: each definition.
			each class instVarNames 
				do: [:varName | classChanges addInstanceVariable: varName to: each class].
			each selectors 
				do: [:selector | classChanges compile: (each sourceCodeAt: selector) in: each].
			each class selectors 
				do: [:selector | classChanges compile: (each class sourceCodeAt: selector) in: each class]].
	^classChanges!

changeString
	^'Remove class ', self displayClassName!

primitiveExecute
	self changeClass removeFromSystem!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeFromSystem';
		nextPut: $!!! !

!RemoveClassChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!private! !
printOn:!printing!public! !
!

!RemoveClassChange class methodsFor!

remove: aClass 
	^self new changeClass: aClass!

removeClassName: aSymbol 
	^self new changeClassName: aSymbol! !

!RemoveClassChange class categoriesForMethods!
remove:!instance creation!public! !
removeClassName:!instance creation!public! !
!

