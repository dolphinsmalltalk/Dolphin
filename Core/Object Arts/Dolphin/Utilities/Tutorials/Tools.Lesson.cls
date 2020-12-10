"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.Lesson'
	instanceVariableNames: 'title contents'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Lesson guid: (Core.GUID fromString: '{430b4d82-364a-44fc-9c2b-5b546c048ef9}')!
Tools.Lesson comment: ''!
!Tools.Lesson categoriesForClass!Unclassified! !
!Tools.Lesson methodsFor!

contents
	^ contents ifNil: [contents := '']
!

contents: aString
	contents := aString
!

title
	^ title ifNil: [title := '']
!

title: aString
	title := aString
! !
!Tools.Lesson categoriesFor: #contents!accessing!public! !
!Tools.Lesson categoriesFor: #contents:!accessing!public! !
!Tools.Lesson categoriesFor: #title!accessing!public! !
!Tools.Lesson categoriesFor: #title:!accessing!public! !

!Tools.Lesson class methodsFor!

icon
	^Tools.AbstractTutorial icon!

title: aTitle contents: someContents
	^ (self new)
		title: aTitle;
		contents: someContents
! !
!Tools.Lesson class categoriesFor: #icon!constants!public! !
!Tools.Lesson class categoriesFor: #title:contents:!instance creation!public! !

