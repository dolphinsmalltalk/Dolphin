"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.ClassCommentChange'
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

changeClass: aBehavior
	super changeClass: aBehavior.
	classReference := classReference instance!

changeString
	^'Comment ' , self displayClassName!

comment
	^comment!

comment: aString
	comment := aString!

primitiveExecute
	self changeClass comment: self comment!

printOn: aStream
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' comment: ';
		print: (self comment copyReplaceAll: '!!' with: '!!!!');
		nextPutAll: '!!'! !
!Refactory.Browser.ClassCommentChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.ClassCommentChange categoriesFor: #changeClass:!accessing!public! !
!Refactory.Browser.ClassCommentChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.ClassCommentChange categoriesFor: #comment!accessing!public! !
!Refactory.Browser.ClassCommentChange categoriesFor: #comment:!accessing!public! !
!Refactory.Browser.ClassCommentChange categoriesFor: #primitiveExecute!accessing!public! !
!Refactory.Browser.ClassCommentChange categoriesFor: #printOn:!printing!public! !

!Refactory.Browser.ClassCommentChange class methodsFor!

comment: aString in: aClass
	^self new
		changeClass: aClass;
		comment: aString;
		yourself! !
!Refactory.Browser.ClassCommentChange class categoriesFor: #comment:in:!instance creation!private! !

