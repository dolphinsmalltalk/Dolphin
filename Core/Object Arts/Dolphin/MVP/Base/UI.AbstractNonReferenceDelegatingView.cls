"Filed out from Dolphin Smalltalk 7"!

AbstractDelegatingView subclass: #AbstractNonReferenceDelegatingView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractNonReferenceDelegatingView guid: (GUID fromString: '{0d2a2ef6-1bed-4665-b4c0-9a97c209b222}')!
AbstractNonReferenceDelegatingView comment: 'Adds some methods that are not appropriate for ReferenceViews. Strictly the introduction of this class is only requiredto ensure ReferenceView remains backwardly compatible.'!
!AbstractNonReferenceDelegatingView categoriesForClass!MVP-Resources-Misc! !
!AbstractNonReferenceDelegatingView methodsFor!

ambientBackcolor
	"Private - Answer the background colour that should be inherited by children of this view
	that don't have their own background colour specified. Note that if the receiver is
	transparent, then it will return 'Color none' if no other colour is set, telling the child
	to draw itself transparently if it can."

	^self parentView ambientBackcolor!

hasBorder
	"Answer whether the receiver has a border."

	^self referee hasBorder!

hasBorder: aBoolean
	"Set whether the receiver has a border."

	self referee hasBorder: aBoolean!

hasClientEdge
	"Answer whether the receiver has a client edge style."

	^self referee hasClientEdge!

hasClientEdge: aBoolean
	"Set whether the receiver has a client edge style."

	self referee hasClientEdge: aBoolean!

hasStaticEdge
	"Answer whether the receiver has a static edge style."

	^self referee hasStaticEdge!

hasStaticEdge: aBoolean
	"Set whether the receiver has a static edge style."

	self referee hasStaticEdge: aBoolean!

isEnabled
	"Answer whether the receiver is enabled."

	^self referee isEnabled!

isEnabled: aBoolean 
	self isStateRestoring ifFalse: [self referee isEnabled: aBoolean]! !
!AbstractNonReferenceDelegatingView categoriesFor: #ambientBackcolor!accessing!private! !
!AbstractNonReferenceDelegatingView categoriesFor: #hasBorder!accessing!accessing-styles!public! !
!AbstractNonReferenceDelegatingView categoriesFor: #hasBorder:!accessing!accessing-styles!public! !
!AbstractNonReferenceDelegatingView categoriesFor: #hasClientEdge!accessing!accessing-styles!public! !
!AbstractNonReferenceDelegatingView categoriesFor: #hasClientEdge:!accessing!accessing-styles!public! !
!AbstractNonReferenceDelegatingView categoriesFor: #hasStaticEdge!accessing!accessing-styles!public! !
!AbstractNonReferenceDelegatingView categoriesFor: #hasStaticEdge:!accessing!accessing-styles!public! !
!AbstractNonReferenceDelegatingView categoriesFor: #isEnabled!accessing!public!testing! !
!AbstractNonReferenceDelegatingView categoriesFor: #isEnabled:!accessing!public!state! !

