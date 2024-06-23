"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.Lesson'
	instanceVariableNames: 'title contents'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Lesson guid: (Core.GUID fromString: '{430b4d82-364a-44fc-9c2b-5b546c048ef9}')!

Tools.Lesson comment: ''!

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

!Tools.Lesson categoriesForMethods!
contents!accessing!public! !
contents:!accessing!public! !
title!accessing!public! !
title:!accessing!public! !
!

!Tools.Lesson class methodsFor!

icon
	^AbstractTutorial icon!

title: aTitle contents: someContents
	^ (self new)
		title: aTitle;
		contents: someContents
! !

!Tools.Lesson class categoriesForMethods!
icon!constants!public! !
title:contents:!instance creation!public! !
!

