﻿"Filed out from Dolphin Smalltalk"!

UI.ImageView
	subclass: #'Tools.ViewComposerArena'
	instanceVariableNames: 'composer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ViewComposerArena guid: (Core.GUID fromString: '{1cb40e20-1cef-4edd-8012-223620292a00}')!
Tools.ViewComposerArena comment: 'ViewComposerArena is used by the ViewComposer to contain the view being edited. It''s main function is to pass a #drawAdornment
message to the associated ViewComposer each time a paint message is received.'!
!Tools.ViewComposerArena categoriesForClass!MVP-Views! !
!Tools.ViewComposerArena methodsFor!

composer
	^composer!

composer: aViewComposer2 
	composer := aViewComposer2!

onLeftButtonPressed: aMouseEvent 
	^composer arenaLeftButtonPressed: aMouseEvent!

onMouseMoved: aMouseEvent 
	composer isNil ifTrue: [^nil].
	^composer arenaMouseMoved: aMouseEvent!

onPaintRequired: aPaintEvent 
	"Private - Handle the paint event.
	Notify the target that the shield requires painting."

	| answer |
	answer := super onPaintRequired: aPaintEvent.
	self composer notNil ifTrue: [self composer drawAdornment].
	^answer!

onViewClosed
	composer := nil.
	^super onViewClosed!

requestDropOperations: session
	"Private - Inform the <DragDropSession> of the receiver's supported 
	drag and drop operation symbols."

	composer requestDropOperations: session! !
!Tools.ViewComposerArena categoriesForMethods!
composer!public! !
composer:!public! !
onLeftButtonPressed:!event handling!private! !
onMouseMoved:!event handling!private! !
onPaintRequired:!event handling!private! !
onViewClosed!event handling!public! !
requestDropOperations:!drag & drop!private! !
!

