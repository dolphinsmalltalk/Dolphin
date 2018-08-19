"Filed out from Dolphin Smalltalk 7"!

ColorRef subclass: #ColorDefault
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorDefault guid: (GUID fromString: '{dc49f7c0-bb6c-444b-9e28-9342285c1880}')!
ColorDefault comment: '`ColorDefault` is the special ColorRef which represents the default colour for something, whatever that might be. Typically it is used with `ControlView`s to specify that the control should draw itself usings its default background or foreground colour.

`ColorDefault`s singleton instance is accessed using the expression `Color default`.

The superclass `code` instance variable has the value `Win32Constants.CLR_DEFAULT`.

'!
!ColorDefault categoriesForClass!Unclassified! !
!ColorDefault methodsFor!

isDefault
	"Answer whether the receiver is the special <Color> representing the default colour. Which
	colour this represents in practice will depend on context."

	^true!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream
		display: Color;
		space;
		display: #default! !
!ColorDefault categoriesFor: #isDefault!public!testing! !
!ColorDefault categoriesFor: #printOn:!development!printing!public! !

!ColorDefault class methodsFor!

initialize
	Color addClassConstant: 'Default'
		value: (self basicNew
				setCode: CLR_DEFAULT;
				isImmutable: true;
				yourself)! !
!ColorDefault class categoriesFor: #initialize!public! !

