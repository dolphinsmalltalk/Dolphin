"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Lesson
	instanceVariableNames: 'title contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Lesson guid: (GUID fromString: '{430B4D82-364A-44FC-9C2B-5B546C048EF9}')!
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
!Lesson categoriesFor: #contents!accessing!public! !
!Lesson categoriesFor: #contents:!accessing!public! !
!Lesson categoriesFor: #title!accessing!public! !
!Lesson categoriesFor: #title:!accessing!public! !

!Lesson class methodsFor!

icon
	^AbstractTutorial icon!

title: aTitle contents: someContents
	^ (self new)
		title: aTitle;
		contents: someContents
! !
!Lesson class categoriesFor: #icon!constants!public! !
!Lesson class categoriesFor: #title:contents:!instance creation!public! !

