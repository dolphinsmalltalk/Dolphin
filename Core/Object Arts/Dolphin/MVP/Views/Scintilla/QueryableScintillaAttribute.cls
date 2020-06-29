"Filed out from Dolphin Smalltalk 7"!

ScintillaAttribute subclass: #QueryableScintillaAttribute
	instanceVariableNames: 'view'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
QueryableScintillaAttribute guid: (GUID fromString: '{dd653349-5f8c-41b5-a302-fcc645247163}')!
QueryableScintillaAttribute comment: '`QueryableScintillaAttribute` is the abstract class of `ScintillaAtttribute`s that can be retrieved from the underlying control. It provides the basic mechanism for populating the attribute from the view settings.

##Instance Variables:
  `view`		`ScintillaView` with which this attribute is associated.
'!
!QueryableScintillaAttribute categoriesForClass!MVP-Views-Support! !
!QueryableScintillaAttribute methodsFor!

populateFromView: aScintillaView at: anInteger
	id := anInteger.
	view := nil.
	self class propertyMap do: [:each | each getAttribute: self ofView: aScintillaView].
	view := aScintillaView!

postCopy
	view := nil.
	^super postCopy!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !
!QueryableScintillaAttribute categoriesFor: #populateFromView:at:!initializing!private! !
!QueryableScintillaAttribute categoriesFor: #postCopy!copying!public! !
!QueryableScintillaAttribute categoriesFor: #view!accessing!private! !
!QueryableScintillaAttribute categoriesFor: #view:!accessing!private! !

!QueryableScintillaAttribute class methodsFor!

view: aScintillaView index: anInteger 
	^(self new)
		populateFromView: aScintillaView at: anInteger;
		yourself! !
!QueryableScintillaAttribute class categoriesFor: #view:index:!instance creation!public! !

