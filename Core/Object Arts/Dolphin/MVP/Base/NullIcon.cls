"Filed out from Dolphin Smalltalk X6"!

Icon subclass: #NullIcon
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NullIcon guid: (GUID fromString: '{126ACBB6-E8DF-45A9-80C0-8CAF5F16875E}')!
NullIcon comment: ''!
!NullIcon categoriesForClass!Graphics-Tools! !
!NullIcon methodsFor!

imageIndex
	"Answer the image index of the receiver in our ImageManager of all icons."

	^0
! !
!NullIcon categoriesFor: #imageIndex!accessing!public! !

!NullIcon class methodsFor!

current
	^Current!

icon
	"Answers an Icon that can be used to represent this class"

	^self blank!

initialize
	Current := self new! !
!NullIcon class categoriesFor: #current!instance creation!public! !
!NullIcon class categoriesFor: #icon!constants!public! !
!NullIcon class categoriesFor: #initialize!initializing!public! !

