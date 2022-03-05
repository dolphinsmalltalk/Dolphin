"Filed out from Dolphin Smalltalk"!

Object subclass: #SUnitAbsWrapper
	instanceVariableNames: 'model subject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitAbsWrapper guid: (GUID fromString: '{d5b2a9f9-20ff-4e62-9b3f-5fedaa755651}')!
SUnitAbsWrapper comment: ''!
!SUnitAbsWrapper categoriesForClass!Unclassified! !
!SUnitAbsWrapper methodsFor!

icon

	| iconSymbol |

	iconSymbol := self model iconSymbolFor: self subject.

	(iconSymbol isNil or: [iconSymbol == #grayBallIcon])
		ifTrue: [^self class icon].

	^iconSymbol = #redBallIcon
		ifTrue: [False icon]
		ifFalse: [
			iconSymbol = #yellowBallIcon
				ifTrue: [Icon warning]
				ifFalse: [True icon]]!

model
	"Private - Answer the value of the receiver's ''model'' instance variable."

	^model!

model: anObject
	"Private - Set the value of the receiver's ''model'' instance variable to the argument, anObject."

	model := anObject!

subject
	"Private - Answer the value of the receiver's ''subject'' instance variable."

	^subject!

subject: anObject
	"Private - Set the value of the receiver's ''subject'' instance variable to the argument, anObject."

	subject := anObject! !
!SUnitAbsWrapper categoriesForMethods!
icon!accessing!constants!public! !
model!accessing!private! !
model:!accessing!private! !
subject!accessing!private! !
subject:!accessing!private! !
!

!SUnitAbsWrapper class methodsFor!

newOn: anSUnitBrowserModel

	^self new
		model: anSUnitBrowserModel;
		yourself! !
!SUnitAbsWrapper class categoriesForMethods!
newOn:!instantiating!public! !
!

