"Filed out from Dolphin Smalltalk"!

Graphics.Icon
	subclass: #'Graphics.NullIcon'
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
!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

printOn: aStream
	aStream
		print: Icon;
		space;
		nextPutAll: #null! !
!Graphics.NullIcon categoriesForMethods!
imageIndex!accessing!public! !
isSelfEvaluating!printing!public! !
printOn:!printing!public! !
!

!Graphics.NullIcon class methodsFor!

current
	^Current!

icon
	"Answers an Icon that can be used to represent this class"

	^self blank!

initialize
	Current := self new! !
!Graphics.NullIcon class categoriesForMethods!
current!instance creation!public! !
icon!constants!public! !
initialize!initializing!public! !
!

