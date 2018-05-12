"Filed out from Dolphin Smalltalk 7"!

ScintillaAttribute subclass: #QueryableScintillaAttribute
	instanceVariableNames: 'view'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'queryMap'!
QueryableScintillaAttribute guid: (GUID fromString: '{dd653349-5f8c-41b5-a302-fcc645247163}')!
QueryableScintillaAttribute comment: 'QueryableScintillaAttribute is the abstract class of <ScintillaAtttribute>s that can be retrieved from the underlying control. It provides the basic mechanism for populating the attribute from the view settings.

Instance Variables:
	view		<ScintillaView> with which this attribute is associated.

Class Instance Variables:
	queryMap	<IdentityDictionary> mapping the set selector of the subclass to the windows messages that can be use to query the values from the Scintilla control'!
!QueryableScintillaAttribute categoriesForClass!MVP-Views-Support! !
!QueryableScintillaAttribute methodsFor!

populateFromView: aScintillaView at: anInteger
	id := anInteger.
	view := nil.
	self propertyMap do: 
			[:each |
			| value |
			value := aScintillaView sendMessage: each getMessage wParam: id.
			self perform: each setSelector with: (value = each defaultValue ifFalse: [value])].
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

queryMap
	^queryMap!

view: aScintillaView index: anInteger 
	^(self new)
		populateFromView: aScintillaView at: anInteger;
		yourself! !
!QueryableScintillaAttribute class categoriesFor: #queryMap!constants!private! !
!QueryableScintillaAttribute class categoriesFor: #view:index:!instance creation!public! !

