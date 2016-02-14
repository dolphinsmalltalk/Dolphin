"Filed out from Dolphin Smalltalk 7"!

ScintillaAttribute subclass: #QueryableScintillaAttribute
	instanceVariableNames: 'view'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'queryMap'!
QueryableScintillaAttribute guid: (GUID fromString: '{DD653349-5F8C-41B5-A302-FCC645247163}')!
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
	self class queryMap 
		ifNotNil: 
			[:map | 
			map keysAndValuesDo: 
					[:eachSetter :eachGetMessage | 
					self perform: eachSetter with: (aScintillaView sendMessage: eachGetMessage wParam: id)]].
	view := aScintillaView!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !
!QueryableScintillaAttribute categoriesFor: #populateFromView:at:!initializing!private! !
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

