"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

Object subclass: #SUnitAbsWrapper
	instanceVariableNames: 'model subject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitAbsWrapper guid: (GUID fromString: '{D5B2A9F9-20FF-4E62-9B3F-5FEDAA755651}')!
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
!SUnitAbsWrapper categoriesFor: #icon!accessing!constants!public! !
!SUnitAbsWrapper categoriesFor: #model!accessing!private! !
!SUnitAbsWrapper categoriesFor: #model:!accessing!private! !
!SUnitAbsWrapper categoriesFor: #subject!accessing!private! !
!SUnitAbsWrapper categoriesFor: #subject:!accessing!private! !

!SUnitAbsWrapper class methodsFor!

newOn: anSUnitBrowserModel

	^self new
		model: anSUnitBrowserModel;
		yourself! !
!SUnitAbsWrapper class categoriesFor: #newOn:!instantiating!public! !

