"Filed out from Dolphin Smalltalk"!

Object subclass: #Lesson
	instanceVariableNames: 'title contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Lesson guid: (GUID fromString: '{430b4d82-364a-44fc-9c2b-5b546c048ef9}')!

Lesson comment: ''!

!Lesson categoriesForClass!Unclassified! !

!Lesson methodsFor!

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

!Lesson categoriesForMethods!
contents!accessing!public! !
contents:!accessing!public! !
title!accessing!public! !
title:!accessing!public! !
!

!Lesson class methodsFor!

icon
	^AbstractTutorial icon!

title: aTitle contents: someContents
	^ (self new)
		title: aTitle;
		contents: someContents
! !

!Lesson class categoriesForMethods!
icon!constants!public! !
title:contents:!instance creation!public! !
!

