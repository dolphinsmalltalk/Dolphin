"Filed out from Dolphin Smalltalk 7"!

Object subclass: #VisualShellFinder
	instanceVariableNames: 'mouseTracker foundObject foundCursor notFoundCursor shellClassFilter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VisualShellFinder guid: (GUID fromString: '{69da66cc-5c94-4f46-893b-41ba51969fb8}')!
VisualShellFinder comment: ''!
!VisualShellFinder categoriesForClass!Kernel-Objects! !
!VisualShellFinder methodsFor!

cancelTrackingAt: aPoint
	"Private - This is an auto-generated target implementation for the protocol <mouseTrackerTarget>"

!

continueTrackingAt: aPoint from: aPreviousPoint 
	| currentObject cursorToUse |
	currentObject := self visualShellAt: aPoint.
	cursorToUse := currentObject notNil ifTrue: [foundCursor] ifFalse: [notFoundCursor].
	self setCursor: cursorToUse.
	currentObject notNil ifTrue: [currentObject view beActive]!

defaultFoundCursor
	^Cursor hand!

defaultNotFoundCursor
	^Cursor help!

endTrackingAt: aPoint 
	foundObject := self visualShellAt: aPoint!

findObject
	"Start a mouse tracker to find objects beneath the mouse cursor"

	mouseTracker := MouseTracker forPresenter: View active startingAt: 0 @ 0.
	mouseTracker startTracking: self!

foundCursor: aCursorOrIcon 
	foundCursor := aCursorOrIcon asCursor!

initialize
	super initialize.
	foundCursor := self defaultFoundCursor.
	notFoundCursor := self defaultNotFoundCursor!

notFoundCursor: anObject
	notFoundCursor := anObject asCursor!

setCursor: anIconOrCursor 
	"Set the tracking cursor to anIconOrCursor. "

	"If this is an Icon then we need to create a new Cursor from the handle"

	(Cursor fromHandle: anIconOrCursor handle) makeCurrent!

shellClassFilter
	^shellClassFilter!

shellClassFilter: aSetOfShellClasses
	shellClassFilter := aSetOfShellClasses!

startTrackingAt: aPoint 
	self continueTrackingAt: aPoint from: aPoint!

value
	^foundObject!

visualShellAt: aPoint 
	"Private - Answer the visual shell found under aPoint (in desktop coordinates) or nil if none"

	| view shell |
	view := View fromPoint: aPoint.
	shell := (view notNil and: [view isDolphinWindow]) ifTrue: [view topShell].
	self shellClassFilter isNil ifTrue: [^shell].
	self shellClassFilter detect: [:each | shell isKindOf: each] ifNone: [^nil].
	^shell! !
!VisualShellFinder categoriesFor: #cancelTrackingAt:!private!tracking! !
!VisualShellFinder categoriesFor: #continueTrackingAt:from:!private!tracking! !
!VisualShellFinder categoriesFor: #defaultFoundCursor!constants!public! !
!VisualShellFinder categoriesFor: #defaultNotFoundCursor!constants!public! !
!VisualShellFinder categoriesFor: #endTrackingAt:!private!tracking! !
!VisualShellFinder categoriesFor: #findObject!commands!public! !
!VisualShellFinder categoriesFor: #foundCursor:!accessing!public! !
!VisualShellFinder categoriesFor: #initialize!private! !
!VisualShellFinder categoriesFor: #notFoundCursor:!accessing!public! !
!VisualShellFinder categoriesFor: #setCursor:!private!tracking! !
!VisualShellFinder categoriesFor: #shellClassFilter!accessing!public! !
!VisualShellFinder categoriesFor: #shellClassFilter:!accessing!public! !
!VisualShellFinder categoriesFor: #startTrackingAt:!private!tracking! !
!VisualShellFinder categoriesFor: #value!public! !
!VisualShellFinder categoriesFor: #visualShellAt:!helpers!public! !

VisualShellFinder methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!VisualShellFinder class methodsFor!

for: aShellClass 
	^self forAnyOf: (Set with: aShellClass)!

forAnyOf: aSetOfShellClasses 
	^(self new)
		shellClassFilter: aSetOfShellClasses;
		yourself!

new
	^super new initialize! !
!VisualShellFinder class categoriesFor: #for:!public! !
!VisualShellFinder class categoriesFor: #forAnyOf:!public! !
!VisualShellFinder class categoriesFor: #new!public! !

