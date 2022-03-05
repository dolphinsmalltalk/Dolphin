"Filed out from Dolphin Smalltalk"!

ExternalLibrary subclass: #Msimg32Library
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Msimg32Library guid: (GUID fromString: '{5a76781d-d74e-48fe-8991-46ae340fcc94}')!
Msimg32Library comment: 'Deprecated. Use equivalent functions in GDILIbrary instead.'!
!Msimg32Library categoriesForClass!Deprecated! !
!Msimg32Library methodsFor!

alphaBlend: hdcDest nXOriginDest: nXOriginDest nYOriginDest: nYOriginDest nWidthDest: nWidthDest nHeightDest: nHeightDest hdcSrc: hdcSrc nXOriginSrc: nXOriginSrc nYOriginSrc: nYOriginSrc nWidthSrc: nWidthSrc nHeightSrc: nHeightSrc blend: blend
	Notification deprecated.
	^GDILibrary default
		gdiAlphaBlend: hdcDest
		xoriginDest: nXOriginDest
		yoriginDest: nYOriginDest
		wDest: nWidthDest
		hDest: nHeightDest
		hdcSrc: hdcSrc
		xoriginSrc: nXOriginSrc
		yoriginSrc: nYOriginSrc
		wSrc: nWidthSrc
		hSrc: nHeightSrc
		ftn: blend!

gradientFill: hdc pVertex: pVertex dwNumVertex: dwNumVertex pMesh: pMesh dwNumMesh: dwNumMesh dwMode: dwMode
	Notification deprecated.
	^GDILibrary default
		gdiGradientFill: hdc
		pVertex: pVertex
		nVertex: dwNumVertex
		pMesh: pMesh
		nCount: dwNumMesh
		ulMode: dwMode!

transparentBlt: hdcDest nXOriginDest: nXOriginDest nYOriginDest: nYOriginDest nWidthDest: nWidthDest nHeightDest: nHeightDest hdcSrc: hdcSrc nXOriginSrc: nXOriginSrc nYOriginSrc: nYOriginSrc nWidthSrc: nWidthSrc nHeightSrc: nHeightSrc crTransparent: crTransparent
	Notification deprecated.
	^GDILibrary default
		gdiTransparentBlt: hdcDest
		xoriginDest: nXOriginDest
		yoriginDest: nYOriginDest
		wDest: nWidthDest
		hDest: nHeightDest
		hdcSrc: hdcSrc
		xoriginSrc: nXOriginSrc
		yoriginSrc: nYOriginSrc
		wSrc: nWidthSrc
		hSrc: nHeightSrc
		crTransparent: crTransparent! !
!Msimg32Library categoriesForMethods!
alphaBlend:nXOriginDest:nYOriginDest:nWidthDest:nHeightDest:hdcSrc:nXOriginSrc:nYOriginSrc:nWidthSrc:nHeightSrc:blend:!public!win32 functions-bitmap! !
gradientFill:pVertex:dwNumVertex:pMesh:dwNumMesh:dwMode:!**auto generated**!public! !
transparentBlt:nXOriginDest:nYOriginDest:nWidthDest:nHeightDest:hdcSrc:nXOriginSrc:nYOriginSrc:nWidthSrc:nHeightSrc:crTransparent:!**auto generated**!public! !
!

!Msimg32Library class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'msimg32'! !
!Msimg32Library class categoriesForMethods!
fileName!constants!public! !
!

