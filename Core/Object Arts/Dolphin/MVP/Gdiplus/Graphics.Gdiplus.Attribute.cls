"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Graphics.Gdiplus.Attribute'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Attribute guid: (Core.GUID fromString: '{6875551d-920e-4142-9d52-ca6e5e8082f3}')!

Graphics.Gdiplus.Attribute isNonInstantiable: true!

Graphics.Gdiplus.Attribute comment: ''!

!Graphics.Gdiplus.Attribute methodsFor!

= aGpAttribute 
	^self subclassResponsibility!

applyToGpObject: aGdiplusObject initializer: anObject
	self subclassResponsibility!

hash
	^self subclassResponsibility!

isDefault
	^false! !

!Graphics.Gdiplus.Attribute categoriesForMethods!
=!comparing!public! !
applyToGpObject:initializer:!operations!private! !
hash!comparing!public! !
isDefault!public!testing! !
!

!Graphics.Gdiplus.Attribute class methodsFor!

icon
	^Gdiplus icon! !

!Graphics.Gdiplus.Attribute class categoriesForMethods!
icon!constants!public! !
!

