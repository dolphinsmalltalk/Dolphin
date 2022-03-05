"Filed out from Dolphin Smalltalk"!

Object subclass: #VisualShellFinder
	instanceVariableNames: 'mouseTracker foundObject foundCursor notFoundCursor shellClassFilter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!VisualShellFinder categoriesForMethods!
cancelTrackingAt:!private!tracking! !
continueTrackingAt:from:!private!tracking! !
defaultFoundCursor!constants!public! !
defaultNotFoundCursor!constants!public! !
endTrackingAt:!private!tracking! !
findObject!commands!public! !
foundCursor:!accessing!public! !
initialize!private! !
notFoundCursor:!accessing!public! !
setCursor:!private!tracking! !
shellClassFilter!accessing!public! !
shellClassFilter:!accessing!public! !
startTrackingAt:!private!tracking! !
value!public! !
visualShellAt:!helpers!public! !
!

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
!VisualShellFinder class categoriesForMethods!
for:!public! !
forAnyOf:!public! !
new!public! !
!

