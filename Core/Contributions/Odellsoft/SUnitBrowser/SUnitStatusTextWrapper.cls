"Filed out from Dolphin Smalltalk"!

SUnitAbsWrapper subclass: #SUnitStatusTextWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitStatusTextWrapper guid: (GUID fromString: '{a7174fb3-d519-4e52-9a7c-d777937cad5f}')!
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
!SUnitStatusTextWrapper categoriesForMethods!
icon!accessing!public! !
text!accessing!public! !
text:!accessing!private! !
!

!SUnitStatusTextWrapper class methodsFor!

newOn: aString model: anSUnitBrowserModel

	^(self newOn: anSUnitBrowserModel)
		text: aString;
		yourself! !
!SUnitStatusTextWrapper class categoriesForMethods!
newOn:model:!instantiating!public! !
!

