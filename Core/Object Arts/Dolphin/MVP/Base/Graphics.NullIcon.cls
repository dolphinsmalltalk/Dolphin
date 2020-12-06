"Filed out from Dolphin Smalltalk 7"!

Graphics.Icon subclass: #'Graphics.NullIcon'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.NullIcon guid: (Core.GUID fromString: '{126acbb6-e8df-45a9-80c0-8caf5f16875e}')!
Graphics.NullIcon comment: ''!
!Graphics.NullIcon categoriesForClass!Graphics-Tools! !
!Graphics.NullIcon methodsFor!

imageIndex
	"Answer the image index of the receiver in our ImageManager of all icons."

	^0
! !
!Graphics.NullIcon categoriesFor: #imageIndex!accessing!public! !

!Graphics.NullIcon class methodsFor!

current
	^Current!

icon
	"Answers an Icon that can be used to represent this class"

	^self blank!

initialize
	Current := self new! !
!Graphics.NullIcon class categoriesFor: #current!instance creation!public! !
!Graphics.NullIcon class categoriesFor: #icon!constants!public! !
!Graphics.NullIcon class categoriesFor: #initialize!initializing!public! !

