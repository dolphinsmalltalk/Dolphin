"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.FontFromFontFamilyInitializer'
	instanceVariableNames: 'fontFamily emSize style unit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFromFontFamilyInitializer guid: (Core.GUID fromString: '{f4b7aa80-5fd1-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontFromFontFamilyInitializer comment: ''!
!Graphics.Gdiplus.FontFromFontFamilyInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[self species == anObject species and: 
					[fontFamily = anObject fontFamily
						and: [emSize = anObject emSize and: [style = anObject style and: [unit = anObject unit]]]]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateFont: fontFamily asParameter
		emSize: emSize
		style: style
		unit: unit
		font: gpHandle.
	^gpHandle!

emSize
	^emSize!

fontFamily
	^fontFamily!

fontFamily: aFontFamily emSize: aNumberSize style: aNumberStyle unit: aNumberUnit
	fontFamily := aFontFamily.
	emSize := aNumberSize.
	style := aNumberStyle.
	unit := aNumberUnit.
	^self!

getFamily: aGpFontHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipGetFamily: aGpFontHandle family: gpHandle.
	^FontFamily fromOwnedHandle: gpHandle!

hash
	"Answer the <integer> hash value for the receiver."

	^((((self species hash + fontFamily hash) hashMultiply + emSize hash) hashMultiply + style hash)
		hashMultiply + unit hash)
		hashMultiply!

initializeFromHandle: aGpFontHandle
	"Private - Cache all the attributes of the native Gdiplus Font identified by the specified <External.Handle> into the receiver."

	| buf |
	fontFamily := self getFamily: aGpFontHandle.
	buf := ByteArray new: 4.
	Gdip gdipGetFontSize: aGpFontHandle size: buf.
	emSize := buf floatAtOffset: 0.
	Gdip gdipGetFontStyle: aGpFontHandle style: buf.
	style := buf int32AtOffset: 0.
	Gdip gdipGetFontUnit: aGpFontHandle unit: buf.
	unit := buf int32AtOffset: 0!

isSelfEvaluating
	^true!

printAttributesOn: aStream
	aStream
		nextPutAll: 'fontFamily: ';
		print: fontFamily;
		nextPutAll: ' emSize: ';
		print: emSize;
		nextPutAll: ' style: '.
	self
		printEnum: (style bitAnd: 16r3)
		names: Gdiplus.FontStyleNames
		on: aStream.
	(style allMask: 16r4) ifTrue: [aStream nextPutAll: '|FontStyleUnderline'].
	(style allMask: 16r8) ifTrue: [aStream nextPutAll: '|FontStyleStrikeout'].
	aStream nextPutAll: ' unit: '.
	self
		printEnum: unit
		names: Gdiplus.UnitNames
		on: aStream!

style
	^style!

unit
	^unit! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
emSize!accessing!private! !
fontFamily!accessing!private! !
fontFamily:emSize:style:unit:!initializing!private! !
getFamily:!initializing!private! !
hash!comparing!public! !
initializeFromHandle:!initializing!private! !
isSelfEvaluating!public!testing! !
printAttributesOn:!printing!private! !
style!accessing!private! !
unit!accessing!private! !
!

!Graphics.Gdiplus.FontFromFontFamilyInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneFont: aHandle cloneFont: clone.
	^clone!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self new 
		fontFamily: fontFamily
		emSize: emSize
		style: style
		unit: unit!

freeHandle: aHandle
	Gdip gdipDeleteFont: aHandle! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
fontFamily:emSize:style:unit:!instance creation!public! !
freeHandle:!private!realizing/unrealizing! !
!

