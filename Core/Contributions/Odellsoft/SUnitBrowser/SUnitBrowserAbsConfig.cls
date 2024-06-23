"Filed out from Dolphin Smalltalk"!

Object subclass: #SUnitBrowserAbsConfig
	instanceVariableNames: 'properties'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!SUnitBrowserAbsConfig categoriesForMethods!
initialize!initializing!private! !
properties!accessing!private! !
properties:!accessing!private! !
propertyAt:!accessing!private! !
propertyAt:put:!accessing!private! !
showBackgroundColors!configuring!public! !
showBackgroundColors:!configuring!public! !
showIcons!configuring!public! !
showIcons:!configuring!public! !
showToolbar!configuring!public! !
showToolbar:!configuring!public! !
toggleShowBackgroundColors!configuring!public! !
toggleShowIcons!configuring!public! !
toggleShowToolbar!configuring!public! !
toggleUseDisplayNames!configuring!public! !
useDisplayNames!configuring!public! !
useDisplayNames:!configuring!public! !
!

!SUnitBrowserAbsConfig class methodsFor!

new

	^super new
		initialize;
		yourself! !

!SUnitBrowserAbsConfig class categoriesForMethods!
new!instantiating!public! !
!

