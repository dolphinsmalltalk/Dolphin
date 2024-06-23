"Filed out from Dolphin Smalltalk"!

UI.Scintilla.Attribute
	subclass: #'UI.Scintilla.QueryableAttribute'
	instanceVariableNames: 'view'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Scintilla.QueryableAttribute guid: (Core.GUID fromString: '{dd653349-5f8c-41b5-a302-fcc645247163}')!

UI.Scintilla.QueryableAttribute isNonInstantiable: true!

UI.Scintilla.QueryableAttribute comment: '`QueryableScintillaAttribute` is the abstract class of `ScintillaAtttribute`s that can be retrieved from the underlying control. It provides the basic mechanism for populating the attribute from the view settings.

##Instance Variables:
  `view`		`ScintillaView` with which this attribute is associated.
'!

!UI.Scintilla.QueryableAttribute categoriesForClass!MVP-Views-Support! !

!UI.Scintilla.QueryableAttribute methodsFor!

populateFromView: aScintillaView at: anInteger
	id := anInteger.
	view := nil.
	self class propertyDescriptors do: [:each | each getAttribute: self ofView: aScintillaView].
	view := aScintillaView!

postCopy
	view := nil.
	^super postCopy!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !

!UI.Scintilla.QueryableAttribute categoriesForMethods!
populateFromView:at:!initializing!private! !
postCopy!copying!public! !
view!accessing!private! !
view:!accessing!private! !
!

!UI.Scintilla.QueryableAttribute class methodsFor!

view: aScintillaView index: anInteger 
	^(self new)
		populateFromView: aScintillaView at: anInteger;
		yourself! !

!UI.Scintilla.QueryableAttribute class categoriesForMethods!
view:index:!instance creation!public! !
!

