"Filed out from Dolphin Smalltalk 7"!

Color subclass: #PluggableColor
	instanceVariableNames: 'valuable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableColor guid: (GUID fromString: '{74b2076a-a07a-4203-aa78-b3fc0ad65e7c}')!
PluggableColor comment: ''!
!PluggableColor categoriesForClass!Drawing! !
!PluggableColor methodsFor!

asIndexedColor
	"Answer the receiver as an IndexedColour."

	^valuable value asIndexedColor!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^valuable value asParameter!

asRGB
	"Answer the receiver as an RGB"

	^valuable value asRGB!

setValuable: aNiladicValuable 
	valuable := aNiladicValuable! !
!PluggableColor categoriesFor: #asIndexedColor!converting!public! !
!PluggableColor categoriesFor: #asParameter!converting!public! !
!PluggableColor categoriesFor: #asRGB!converting!public! !
!PluggableColor categoriesFor: #setValuable:!initializing!private! !

!PluggableColor class methodsFor!

with: aNiladicValuable 
	^self basicNew setValuable: aNiladicValuable! !
!PluggableColor class categoriesFor: #with:!instance creation!public! !

