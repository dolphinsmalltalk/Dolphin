"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.SmalltalkSearchCandidate'
	instanceVariableNames: 'matchingName object'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkSearchCandidate guid: (Core.GUID fromString: '{e0f86cc7-411b-41a6-b274-74a691097987}')!
Tools.SmalltalkSearchCandidate comment: ''!
!Tools.SmalltalkSearchCandidate categoriesForClass!Kernel-Objects! !
!Tools.SmalltalkSearchCandidate methodsFor!

displayOn: aPuttableStream
	aPuttableStream nextPutAll: matchingName!

icon
	^object icon!

matchingName
	^matchingName!

matchingName: aString
	matchingName := aString!

object
	^object!

object: anObject
	object := anObject! !
!Tools.SmalltalkSearchCandidate categoriesForMethods!
displayOn:!displaying!public! !
icon!public! !
matchingName!accessing!public! !
matchingName:!accessing!public! !
object!accessing!public! !
object:!accessing!public! !
!

!Tools.SmalltalkSearchCandidate class methodsFor!

matchingName: aString object: anObject
	^self new
		matchingName: aString;
		object: anObject;
		yourself! !
!Tools.SmalltalkSearchCandidate class categoriesForMethods!
matchingName:object:!instance creation!public! !
!

