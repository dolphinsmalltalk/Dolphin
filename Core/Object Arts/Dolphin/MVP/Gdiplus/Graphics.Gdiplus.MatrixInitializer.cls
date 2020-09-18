"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.MatrixInitializer'
	instanceVariableNames: 'm11 m12 m21 m22 m31 m32'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.MatrixInitializer guid: (Core.GUID fromString: '{1a1a5ea6-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.MatrixInitializer comment: ''!
!Graphics.Gdiplus.MatrixInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.MatrixInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateMatrix2: m11
		m12: m12
		m21: m21
		m22: m22
		dx: m31
		dy: m32
		matrix: gpHandle.
	^gpHandle!

m11: aReal11 m12: aReal12 m21: aReal21 m22: aReal22 m31: aReal31 m32: aReal32
	m11 := aReal11.
	m12 := aReal12.
	m21 := aReal21.
	m22 := aReal22.
	m31 := aReal31.
	m32 := aReal32! !
!Graphics.Gdiplus.MatrixInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.MatrixInitializer categoriesFor: #m11:m12:m21:m22:m31:m32:!initializing!private! !

!Graphics.Gdiplus.MatrixInitializer class methodsFor!

m11: aReal11 m12: aReal12 m21: aReal21 m22: aReal22 m31: aReal31 m32: aReal32
	^self new 
		m11: aReal11
		m12: aReal12
		m21: aReal21
		m22: aReal22
		m31: aReal31
		m32: aReal32! !
!Graphics.Gdiplus.MatrixInitializer class categoriesFor: #m11:m12:m21:m22:m31:m32:!instance creation!public! !

