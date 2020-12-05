"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.RemoveClassChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassChange guid: (Core.GUID fromString: '{d652f7f1-4258-4cf0-8a95-562b45ae0e17}')!
Refactory.Browser.RemoveClassChange comment: ''!
!Refactory.Browser.RemoveClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveClassChange methodsFor!

asUndoOperation
	| classChanges |
	classChanges := CompositeRefactoryChange new.
	self changeClass withAllSubclasses do: 
			[:each |
			classChanges defineClass: each definition.
			each class instVarNames do: [:varName | classChanges addInstanceVariable: varName to: each class].
			each selectors do: [:selector | classChanges compile: (each sourceCodeAt: selector) in: each].
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
!Refactory.Browser.RemoveClassChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveClassChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.RemoveClassChange categoriesFor: #primitiveExecute!private! !
!Refactory.Browser.RemoveClassChange categoriesFor: #printOn:!printing!public! !

!Refactory.Browser.RemoveClassChange class methodsFor!

remove: aClass 
	^self new changeClass: aClass!

removeClassName: aSymbol 
	^self new changeClassName: aSymbol! !
!Refactory.Browser.RemoveClassChange class categoriesFor: #remove:!instance creation!public! !
!Refactory.Browser.RemoveClassChange class categoriesFor: #removeClassName:!instance creation!public! !

