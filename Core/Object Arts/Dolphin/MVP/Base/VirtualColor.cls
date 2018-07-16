"Filed out from Dolphin Smalltalk 7"!

Color subclass: #VirtualColor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VirtualColor guid: (GUID fromString: '{aa0eebfb-75db-4ed8-a11f-55ac6b62948e}')!
VirtualColor isAbstract: true!
VirtualColor comment: '`VirtualColor` is the abstract class of `Color`s with an indirectly stored or calculated color value that can vary at run time.'!
!VirtualColor categoriesForClass!Drawing! !
!VirtualColor methodsFor!

actualColor
	^self subclassResponsibility!

asIndexedColor
	"Answer the receiver as an IndexedColour."

	^self actualColor asIndexedColor!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^self actualColor asParameter!

asRGB
	"Answer the receiver as an RGB"

	^self actualColor asRGB!

isDefault
	"Answer whether the <Color> to which the receiver resolves is 'Color default'"

	^self actualColor isDefault!

isNone
	"Answer whether the <Color> to which the receiver resolves is 'Color none'"

	^self actualColor isNone! !
!VirtualColor categoriesFor: #actualColor!accessing!private! !
!VirtualColor categoriesFor: #asIndexedColor!converting!public! !
!VirtualColor categoriesFor: #asParameter!converting!public! !
!VirtualColor categoriesFor: #asRGB!converting!public! !
!VirtualColor categoriesFor: #isDefault!public!testing! !
!VirtualColor categoriesFor: #isNone!public!testing! !

