"Filed out from Dolphin Smalltalk X6"!

Object subclass: #IdeExtensions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdeExtensions guid: (GUID fromString: '{BF74C765-F92C-4517-85D5-B758A2DE23CF}')!
IdeExtensions comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdeExtensions categoriesForClass!IDB Goodies! !
!IdeExtensions class methodsFor!

extendedClasses
	self subclassResponsibility!

extendMenuIn: aBrowser 
	!

extendToolbarIn: aBrowser 
	!

initializeAfterLoad
	super initializeAfterLoad.
	self isExtension 
		ifTrue: 
			[self extendedClasses do: 
					[:each | 
					each 
						when: #viewOpened:
						send: #onBrowserOpened:
						to: self]]!

isExtension
	^false!

onBrowserClosed: aBrowser 
	aBrowser view menuBar free!

onBrowserOpened: aBrowser 
	aBrowser 
		when: #viewClosed
		send: #onBrowserClosed:
		to: self
		with: aBrowser.
	self
		extendMenuIn: aBrowser;
		extendToolbarIn: aBrowser!

uninitialize
	self isExtension ifFalse: [^self].
	self extendedClasses do: [:each | each removeEventsTriggeredFor: self]!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class. This includes any specific #uninitialize
	implementation (but note that #uninitialize is only sent to classes which directly implement
	#uninitialize, otherwise we'd probably end up damaging superclasses which are not being
	removed).
	Implementation Note: This is one of those cases where we want subclasses to inherit the
	uninitialize, so override to always call it."

	self uninitialize! !
!IdeExtensions class categoriesFor: #extendedClasses!accessing!public! !
!IdeExtensions class categoriesFor: #extendMenuIn:!operations!public! !
!IdeExtensions class categoriesFor: #extendToolbarIn:!operations!public! !
!IdeExtensions class categoriesFor: #initializeAfterLoad!initializing!public! !
!IdeExtensions class categoriesFor: #isExtension!constants!public! !
!IdeExtensions class categoriesFor: #onBrowserClosed:!event handling!public! !
!IdeExtensions class categoriesFor: #onBrowserOpened:!event handling!public! !
!IdeExtensions class categoriesFor: #uninitialize!class hierarchy-removing!public! !
!IdeExtensions class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!private! !

