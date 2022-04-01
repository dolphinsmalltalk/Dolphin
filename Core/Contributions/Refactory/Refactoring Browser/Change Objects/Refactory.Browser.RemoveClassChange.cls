"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassModificationChange subclass: #'Refactory.Browser.RemoveClassChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassChange guid: (Core.GUID fromString: '{d652f7f1-4258-4cf0-8a95-562b45ae0e17}')!
Refactory.Browser.RemoveClassChange comment: ''!
!Refactory.Browser.RemoveClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveClassChange methodsFor!

afterText
	^''!

asUndoOperation
	| classChanges |
	classChanges := CompositeRefactoryChange new.
	self changeClass withAllSubclasses do: 
			[:each |
			classChanges defineClassWithDetails: (ClassDetails fromClass: each).
			each selectors asSortedArray
				do: [:selector | classChanges compile: (each sourceCodeAt: selector) in: each].
			each class selectors asSortedArray
				do: [:selector | classChanges compile: (each class sourceCodeAt: selector) in: each class]].
	^classChanges!

changeString
	^'Remove class <1d>' << classReference!

mutateClassDetails: aClassDetails
	self shouldNotImplement!

primitiveExecute
	self changeClass removeFromSystem!

printOn: aStream
	aStream
		display: classReference;
		space;
		nextPutAll: #removeFromSystem;
		nextPut: $!!! !
!Refactory.Browser.RemoveClassChange categoriesForMethods!
afterText!printing!public! !
asUndoOperation!converting!public! !
changeString!printing!public! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
!

!Refactory.Browser.RemoveClassChange class methodsFor!

remove: aClass 
	^self new changeClass: aClass!

removeClassName: aSymbol 
	^self new changeClassName: aSymbol! !
!Refactory.Browser.RemoveClassChange class categoriesForMethods!
remove:!instance creation!public! !
removeClassName:!instance creation!public! !
!

