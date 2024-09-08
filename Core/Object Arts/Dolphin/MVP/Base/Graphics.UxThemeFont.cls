"Filed out from Dolphin Smalltalk"!

Graphics.SystemFont
	subclass: #'Graphics.UxThemeFont'
	instanceVariableNames: 'themedObject'
	classVariableNames: ''
	imports: #(#{OS.ThemeConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'FontNames'
				-> (IdentityDictionary withAll: {
								16r321 -> #caption.
								16r322 -> #smallCaption.
								16r323 -> #menu.
								16r324 -> #status.
								16r325 -> #messageBox.
								16r326 -> #iconTitle
							})
		}!

Graphics.UxThemeFont guid: (Core.GUID fromString: '{d0d280e2-2bf1-4921-b969-8efb0270983f}')!

Graphics.UxThemeFont comment: ''!

!Graphics.UxThemeFont methodsFor!

getLogFont
	^logfont := UxTheme getThemeSysFont: (themedObject ifNotNil: [themedObject theme]) iFontId: id!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	(FontNames lookup: id)
		ifNil: 
			[aStream
				nextPut: $(;
				display: self class;
				nextPutAll: ' fromId: ';
				print: id.
			themedObject
				ifNotNil: 
					[aStream
						nextPutAll: ' themedObject: ';
						print: themedObject].
			aStream nextPut: $)]
		ifNotNil: 
			[:name |
			aStream
				display: self class;
				space;
				nextPutAll: name.
			themedObject
				ifNotNil: 
					[aStream
						nextPutAll: ': ';
						print: themedObject]]!

setId: anInteger themedObject: anObjectWithTheme
	id := anInteger.
	themedObject := anObjectWithTheme.
	^self!

stbFixup: anSTBInFiler at: newObjectIndex
	dpi := User32 getDpiForSystem.
	^self!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. For theme fonts we do not want to persist the cached LOGFONT information."

	| savedHandle savedSeries savedLogFont |
	savedHandle := handle.
	savedSeries := series.
	savedLogFont := logfont.
	logfont := handle := series := nil.
	[anSTBOutFiler saveObject: self] ensure: 
			[handle := savedHandle.
			logfont := savedLogFont.
			series := savedSeries]! !

!Graphics.UxThemeFont categoriesForMethods!
getLogFont!initializing!private! !
printOn:!development!printing!public! !
setId:themedObject:!initializing!private! !
stbFixup:at:!binary filing!public! !
stbSaveOn:!binary filing!public! !
!

!Graphics.UxThemeFont class methodsFor!

caption
	^self fromId: TMT_CAPTIONFONT!

fromId: anInteger
	"Answer a new instance of the receiver representing the global theme font with the specified <integer> id."

	^self fromId: anInteger themedObject: nil!

fromId: anInteger themedObject: anObjectWithTheme
	^self new setId: anInteger themedObject: anObjectWithTheme!

iconTitle
	^self fromId: TMT_ICONTITLEFONT!

iconTitle: aThemedObject
	^self fromId: TMT_ICONTITLEFONT themedObject: aThemedObject!

menu
	^self fromId: TMT_MENUFONT!

messageBox
	^self fromId: TMT_MSGBOXFONT!

smallCaption
	^self fromId: TMT_SMALLCAPTIONFONT!

status
	^self fromId: TMT_STATUSFONT! !

!Graphics.UxThemeFont class categoriesForMethods!
caption!instance creation!public! !
fromId:!instance creation!public! !
fromId:themedObject:!public! !
iconTitle!instance creation!public! !
iconTitle:!instance creation!public! !
menu!instance creation!public! !
messageBox!instance creation!public! !
smallCaption!instance creation!public! !
status!instance creation!public! !
!

