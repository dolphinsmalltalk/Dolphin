"Filed out from Dolphin Smalltalk"!

Tools.KeyedAspect
	subclass: #'Tools.StackFrameSlot'
	instanceVariableNames: 'index'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.StackFrameSlot guid: (Core.GUID fromString: '{3c431618-bcf4-4123-b9e8-6f18344e5764}')!

Tools.StackFrameSlot comment: ''!

!Tools.StackFrameSlot categoriesForClass!Attribute-Definition! !

!Tools.StackFrameSlot methodsFor!

index
	^index!

index: aString
	index := aString!

readFrom: anObject
	^[anObject at: index] on: Error do: [:ex | ex]!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	self isWriteable ifFalse: [self error: 'Attempt to modify read-only aspect ', self printString].
	^subjectObject at: index put: valueObject! !

!Tools.StackFrameSlot categoriesForMethods!
index!accessing!public! !
index:!accessing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!Tools.StackFrameSlot class methodsFor!

local: aString index: anInteger
	^(self key: aString)
		index: anInteger;
		yourself! !

!Tools.StackFrameSlot class categoriesForMethods!
local:index:!public! !
!

