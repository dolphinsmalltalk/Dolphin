"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.SmalltalkSearchCandidate'
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
!Tools.SmalltalkSearchCandidate categoriesFor: #displayOn:!displaying!public! !
!Tools.SmalltalkSearchCandidate categoriesFor: #icon!public! !
!Tools.SmalltalkSearchCandidate categoriesFor: #matchingName!accessing!public! !
!Tools.SmalltalkSearchCandidate categoriesFor: #matchingName:!accessing!public! !
!Tools.SmalltalkSearchCandidate categoriesFor: #object!accessing!public! !
!Tools.SmalltalkSearchCandidate categoriesFor: #object:!accessing!public! !

!Tools.SmalltalkSearchCandidate class methodsFor!

matchingName: aString object: anObject
	^self new
		matchingName: aString;
		object: anObject;
		yourself! !
!Tools.SmalltalkSearchCandidate class categoriesFor: #matchingName:object:!instance creation!public! !

