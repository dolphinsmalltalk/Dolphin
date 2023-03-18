"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassModificationChange
	subclass: #'Refactory.Browser.ClassImportsChange'
	instanceVariableNames: 'imports'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassImportsChange guid: (Core.GUID fromString: '{0de17edc-6eb7-4c7f-a0f9-85cd5c482bb2}')!
Refactory.Browser.ClassImportsChange comment: ''!
!Refactory.Browser.ClassImportsChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.ClassImportsChange methodsFor!

= anObject
	self class = anObject class ifFalse: [^false].
	^classReference = anObject classReference and: [imports = anObject imports]!

asUndoOperation
	^self copy
		imports: self changeClass imports;
		yourself!

changeString
	^'Change imports into <1d>' << {classReference. imports}!

hash
	^classReference hash bitXor: imports hash!

imports
	^imports!

imports: aCollection
	imports := aCollection asArray collect: [:each | each realReference asFullyQualifiedReference]!

mutateClassDetails: aClassDetails
	aClassDetails imports: imports!

primitiveExecute
	self changeClass imports: imports!

printOn: aStream
	aStream
		display: classReference;
		nextPutAll: ' imports: ';
		print: imports;
		nextPutAll: '!!'! !
!Refactory.Browser.ClassImportsChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
changeString!printing!public! !
hash!comparing!public! !
imports!public! !
imports:!accessing!private! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
!

!Refactory.Browser.ClassImportsChange class methodsFor!

import: anArrayOfBindingReferences into: aClass
	^self new
		changeClass: aClass;
		imports: anArrayOfBindingReferences;
		yourself! !
!Refactory.Browser.ClassImportsChange class categoriesForMethods!
import:into:!instance creation!public! !
!

