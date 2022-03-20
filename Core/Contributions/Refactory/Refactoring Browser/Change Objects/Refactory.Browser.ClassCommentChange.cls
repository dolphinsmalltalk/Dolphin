"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassAttributeChange subclass: #'Refactory.Browser.ClassCommentChange'
	instanceVariableNames: 'comment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassCommentChange guid: (Core.GUID fromString: '{ced73fa2-3cb2-43c7-b499-0e480465eabf}')!
Refactory.Browser.ClassCommentChange comment: ''!
!Refactory.Browser.ClassCommentChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.ClassCommentChange methodsFor!

asUndoOperation
	^self copy
		comment: self changeClass comment;
		yourself!

changeString
	^'Comment <1d>' << classReference!

comment
	^comment!

comment: aString
	comment := aString!

emitAttributeOf: aClass with: aChunkSourceFiler
	aChunkSourceFiler emitCommentOfClass: aClass!

mutateAttributes: aClassAttributes
	"Alter the <ClassAttributes> argument to reflect the change described by the receiver."

	aClassAttributes comment: comment!

primitiveExecute
	self changeClass comment: self comment! !
!Refactory.Browser.ClassCommentChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
comment!accessing!public! !
comment:!accessing!public! !
emitAttributeOf:with:!printing!private! !
mutateAttributes:!helpers!private! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.ClassCommentChange class methodsFor!

comment: aString in: aClass
	^self new
		changeClass: aClass;
		comment: aString;
		yourself! !
!Refactory.Browser.ClassCommentChange class categoriesForMethods!
comment:in:!instance creation!public! !
!

