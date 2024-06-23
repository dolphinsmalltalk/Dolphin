"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassAttributeChange
	subclass: #'Refactory.Browser.ClassGuidChange'
	instanceVariableNames: 'guid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ClassGuidChange guid: (Core.GUID fromString: '{46edd368-f36c-4ce2-867d-b4b4048ec5e6}')!

Refactory.Browser.ClassGuidChange comment: ''!

!Refactory.Browser.ClassGuidChange categoriesForClass!Refactory-Change Objects! !

!Refactory.Browser.ClassGuidChange methodsFor!

asUndoOperation
	^self copy
		guid: self changeClass guid;
		yourself!

changeString
	^'Set guid of <1d>' << classReference!

emitAttributeOf: aClass with: aChunkSourceFiler
	aChunkSourceFiler emitGUIDOfClass: aClass!

guid
	^guid!

guid: aString
	guid := aString!

mutateClassDetails: aClassDetails
	"Alter the <ClassDetails> argument to reflect the change described by the receiver."

	aClassDetails guid: guid!

primitiveExecute
	self changeClass guid: self guid! !

!Refactory.Browser.ClassGuidChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
emitAttributeOf:with:!printing!private! !
guid!accessing!public! !
guid:!accessing!public! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.ClassGuidChange class methodsFor!

uniquelyIdentify: aClass with: aGUID
	^self new
		changeClass: aClass;
		guid: aGUID;
		yourself! !

!Refactory.Browser.ClassGuidChange class categoriesForMethods!
uniquelyIdentify:with:!instance creation!public! !
!

