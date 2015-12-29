"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

SUnitAbsWrapper subclass: #SUnitStatusTextWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitStatusTextWrapper guid: (GUID fromString: '{A7174FB3-D519-4E52-9A7C-D777937CAD5F}')!
SUnitStatusTextWrapper comment: ''!
!SUnitStatusTextWrapper categoriesForClass!Unclassified! !
!SUnitStatusTextWrapper methodsFor!

icon
	| iconSymbol |

	iconSymbol := self model resultStateColorSymbol.

	(iconSymbol isNil or: [iconSymbol == #gray])
		ifTrue: [^self class icon].

	^iconSymbol = #red
		ifTrue: [False icon]
		ifFalse: [
			iconSymbol = #yellow
				ifTrue: [Icon warning]
				ifFalse: [True icon]]!

text
	"Private - Answer the value of the receiver's ''text'' instance variable."

	^self subject!

text: anObject
	"Private - Set the value of the receiver's ''text'' instance variable to the argument, anObject."

	self subject: anObject! !
!SUnitStatusTextWrapper categoriesFor: #icon!accessing!public! !
!SUnitStatusTextWrapper categoriesFor: #text!accessing!public! !
!SUnitStatusTextWrapper categoriesFor: #text:!accessing!private! !

!SUnitStatusTextWrapper class methodsFor!

newOn: aString model: anSUnitBrowserModel

	^(self newOn: anSUnitBrowserModel)
		text: aString;
		yourself! !
!SUnitStatusTextWrapper class categoriesFor: #newOn:model:!instantiating!public! !

