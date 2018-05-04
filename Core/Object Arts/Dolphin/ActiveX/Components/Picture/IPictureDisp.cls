"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IPictureDisp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IPictureDisp guid: (IID fromString: '{7BF80981-BF32-101A-8BBB-00AA00300CAB}')!
IPictureDisp comment: '<Picture> is a wrapper class generated for the dispatch interface ''stdole.Picture'' from type information in the ''OLE Automation'' library. It contains methods to get and set the properties and invoke the methods exposed by that interface.

The type library contains no documentation for this dispinterface

Warning: This comment was automatically generated from the dispinterface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IPictureDisp categoriesForClass!COM-Interfaces! !
!IPictureDisp methodsFor!

handle
	"Answer the <sdword> value of the 'handle' property of the object.
	
		OLE_HANDLE Handle
	"

	^(self getPropertyId: 0)
!

height
	"Answer the <sdword> value of the 'height' property of the object.
	
		OLE_YSIZE_HIMETRIC Height
	"

	^(self getPropertyId: 5)
!

hPal
	"Answer the <sdword> value of the 'hPal' property of the object.
	
		OLE_HANDLE hPal
	"

	^(self getPropertyId: 2)
!

hPal: newVal
	"Set the 'hPal' property of the object to the <sdword> value of the argument, newVal.
	
		OLE_HANDLE hPal
	"

	self setPropertyId: 2 value: newVal
!

render: hdc x: x y: y cx: cx cy: cy xSrc: xSrc ySrc: ySrc cxSrc: cxSrc cySrc: cySrc prcWBounds: prcWBounds 
	"Invoke the Render() method of the COM Object."

	(self invokeId: 6 withArguments:
			((Array new: 10)
				basicAt: 1 put: hdc;
				basicAt: 2 put: x;
				basicAt: 3 put: y;
				basicAt: 4 put: cx;
				basicAt: 5 put: cy;
				basicAt: 6 put: xSrc;
				basicAt: 7 put: ySrc;
				basicAt: 8 put: cxSrc;
				basicAt: 9 put: cySrc;
				basicAt: 10 put: prcWBounds;
				yourself))
!

type
	"Answer the <sword> value of the 'type' property of the object.
	
		short Type
	"

	^(self getPropertyId: 3)
!

width
	"Answer the <sdword> value of the 'width' property of the object.
	
		OLE_XSIZE_HIMETRIC Width
	"

	^(self getPropertyId: 4)
! !
!IPictureDisp categoriesFor: #handle!**auto generated**!properties!public! !
!IPictureDisp categoriesFor: #height!**auto generated**!properties!public! !
!IPictureDisp categoriesFor: #hPal!**auto generated**!properties!public! !
!IPictureDisp categoriesFor: #hPal:!**auto generated**!properties!public! !
!IPictureDisp categoriesFor: #render:x:y:cx:cy:xSrc:ySrc:cxSrc:cySrc:prcWBounds:!**auto generated**!methods!public! !
!IPictureDisp categoriesFor: #type!**auto generated**!properties!public! !
!IPictureDisp categoriesFor: #width!**auto generated**!properties!public! !

!IPictureDisp class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (StdPicture) for which the receiver is the default interface.
	"

	^CLSID fromString: '{0BE35204-8F91-11CE-9DE3-00AA004BB851}'
! !
!IPictureDisp class categoriesFor: #clsid!**auto generated**!constants!private! !

