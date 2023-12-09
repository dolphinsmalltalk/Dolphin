"Filed out from Dolphin Smalltalk"!

UI.Menu
	subclass: #'UI.MenuBar'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.MenuBar guid: (Core.GUID fromString: '{87b4c641-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.MenuBar comment: 'MenuBar represents the special class of menus drawn horizontally across the top of the client area of a top-level view, i.e. the menu bar.
'!
!UI.MenuBar categoriesForClass!Graphics-Tools! !
!UI.MenuBar methodsFor!

createHandle
	"Private - Answer an external handle to a new menu."

	^User32 createMenu!

fromStrings: anArray
	anArray do: 
			[:each |
			self addItem: (each isString ifTrue: [MenuItem fromString: each] ifFalse: [Menu fromStrings: each])]!

isMenuBar
	"Answer whether the receiver is a menu bar rather
	than a popup menu."

	^true!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream basicPrint: self
!

queryAlong: aCommandPolicy
	"Answer a <CommandQuery> reflecting the current state of the receiver's command for the
	specified <commandPolicy>. We want top-level MenuBars to be enabled by default."

	| src |
	src := aCommandPolicy source.
	^(CommandQuery commandDescription: self commandDescription source: src)
		receiver: src topView;
		beEnabled;
		yourself!

showIn: aWindow position: aPos
	"Private - Show the receiver in aWindow at aPos."

	^self shouldNotImplement!

toStrings
	^items collect: [:each | each toStrings]! !
!UI.MenuBar categoriesForMethods!
createHandle!private!realizing/unrealizing! !
fromStrings:!converting!public! !
isMenuBar!public!testing! !
printOn:!printing!public! !
queryAlong:!operations!public! !
showIn:position:!drawing!private! !
toStrings!converting!public! !
!

