"Filed out from Dolphin Smalltalk"!

Icon subclass: #NullIcon
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NullIcon guid: (GUID fromString: '{126acbb6-e8df-45a9-80c0-8caf5f16875e}')!

NullIcon comment: ''!

!NullIcon categoriesForClass!Graphics-Tools! !

!NullIcon methodsFor!

imageIndex
	"Answer the image index of the receiver in our ImageManager of all icons."

	^0
! !

!NullIcon categoriesForMethods!
imageIndex!accessing!public! !
!

!NullIcon class methodsFor!

current
	^Current!

icon
	"Answers an Icon that can be used to represent this class"

	^self blank!

initialize
	Current := self new! !

!NullIcon class categoriesForMethods!
current!instance creation!public! !
icon!constants!public! !
initialize!initializing!public! !
!

