"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SUnitBrowserAbsConfig
	instanceVariableNames: 'properties'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitBrowserAbsConfig guid: (GUID fromString: '{2490833e-133b-46b7-acca-aaa4c120ac4b}')!
SUnitBrowserAbsConfig comment: ''!
!SUnitBrowserAbsConfig categoriesForClass!Unclassified! !
!SUnitBrowserAbsConfig methodsFor!

initialize

	super initialize.
	self properties: IdentityDictionary new!

properties

	^properties!

properties: aDictionary

	properties := aDictionary!

propertyAt: aSymbol

	^self properties
		at: aSymbol
		ifAbsent: [nil]!

propertyAt: aSymbol put: anObject

	^self properties
		at: aSymbol
		put: anObject!

showBackgroundColors

	^self propertyAt: #showBackgroundColors!

showBackgroundColors: aBoolean

	self
		propertyAt: #showBackgroundColors
		put: aBoolean!

showIcons

	^self propertyAt: #showIcons!

showIcons: aBoolean

	self
		propertyAt: #showIcons
		put: aBoolean!

showToolbar

	^self propertyAt: #showToolbar!

showToolbar: aBoolean

	self
		propertyAt: #showToolbar
		put: aBoolean!

toggleShowBackgroundColors

	self showBackgroundColors: self showBackgroundColors not!

toggleShowIcons

	self showIcons: self showIcons not!

toggleShowToolbar

	self showToolbar: self showToolbar not!

toggleUseDisplayNames

	self useDisplayNames: self useDisplayNames not!

useDisplayNames

	^self propertyAt: #useDisplayNames!

useDisplayNames: aBoolean

	self
		propertyAt: #useDisplayNames
		put: aBoolean! !
!SUnitBrowserAbsConfig categoriesFor: #initialize!initializing!private! !
!SUnitBrowserAbsConfig categoriesFor: #properties!accessing!private! !
!SUnitBrowserAbsConfig categoriesFor: #properties:!accessing!private! !
!SUnitBrowserAbsConfig categoriesFor: #propertyAt:!accessing!private! !
!SUnitBrowserAbsConfig categoriesFor: #propertyAt:put:!accessing!private! !
!SUnitBrowserAbsConfig categoriesFor: #showBackgroundColors!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #showBackgroundColors:!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #showIcons!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #showIcons:!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #showToolbar!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #showToolbar:!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #toggleShowBackgroundColors!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #toggleShowIcons!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #toggleShowToolbar!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #toggleUseDisplayNames!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #useDisplayNames!configuring!public! !
!SUnitBrowserAbsConfig categoriesFor: #useDisplayNames:!configuring!public! !

!SUnitBrowserAbsConfig class methodsFor!

new

	^super new
		initialize;
		yourself! !
!SUnitBrowserAbsConfig class categoriesFor: #new!instantiating!public! !

