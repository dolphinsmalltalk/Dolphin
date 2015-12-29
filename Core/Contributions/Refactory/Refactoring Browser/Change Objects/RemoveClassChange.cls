"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoryClassChange subclass: #RemoveClassChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveClassChange comment: ''!

RemoveClassChange guid: (GUID fromString: '{D652F7F1-4258-4CF0-8A95-562B45AE0E17}')!

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
!RemoveClassChange categoriesFor: #asUndoOperation!converting!public! !
!RemoveClassChange categoriesFor: #changeString!printing!public! !
!RemoveClassChange categoriesFor: #primitiveExecute!*-unclassified!private! !
!RemoveClassChange categoriesFor: #printOn:!printing!public! !

!RemoveClassChange class methodsFor!

remove: aClass 
	^self new changeClass: aClass!

removeClassName: aSymbol 
	^self new changeClassName: aSymbol! !
!RemoveClassChange class categoriesFor: #remove:!instance creation!public! !
!RemoveClassChange class categoriesFor: #removeClassName:!instance creation!public! !

