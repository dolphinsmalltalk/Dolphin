"Filed out from Dolphin Smalltalk"!

ToolbarButton subclass: #ToolbarIconButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ToolbarIconButton guid: (GUID fromString: '{eb590073-1214-495b-94ba-9bd4ca08bd32}')!

ToolbarIconButton comment: '`ToolbarIconButton` represents a user defined button for a `Toolbar` where the button image is dynamically generated from the `Image` (typically an `Icon`) held by the associated `CommandDescription`. In general, `ToolbarIconButton`s are much easier to use than `ToolbarBitmapButton`s since they don''t require the creation of a separate image strip bitmap for each of the sizes of toolbar button that may be required.  If you change the `#bitmapSize` aspect of the parent toolbar, the contained `ToolbarIconButton`s will automatically re-render themselves at the new size, making use of the services of the `IconImageManager` to generate appropriate bitmap images for the revised extent.

e.g. 
```
"Evaluate the following expressions one at a time"
tb := Toolbar new hasFlatAppearance: true; isTransparent: true; show; extent: 300@ 64; zOrderTop; yourself.
ClassBrowserAbstract withAllSubclassesDo: [:each | 
	tb addItem: (ToolbarIconButton command: #myCommand description: ''My Command'' image: each icon)].
tb bitmapSize: 24@24.
tb bitmapSize: 32@32.
tb bitmapSize: 48@48.
tb destroy.
```
'!

!ToolbarIconButton categoriesForClass!MVP-Views-Support! !

!ToolbarIconButton methodsFor!

imageIndexIn: aToolbar
	"Private - Add a bitmap representation of the receiver's command's icon to the Toolbar.
	Answer the index of the bitmap from aToolbar's registered bitmaps."

	"We don't need to retain the Bitmap, the Toolbar class will hold on to it (not the toolbar control itself, unfortunately)."

	^aToolbar addBitmap: self renderBitmap index: 0!

renderBitmap
	| image |
	image := self commandDescription image ifNil: [self class defaultImage].
	^image imageManager bitmapForIcon: image extent: self toolbar scaledBitmapSize!

setCommandDescription: aCommandDescription
	self initialize.
	commandDescription := aCommandDescription.
	^self! !

!ToolbarIconButton categoriesForMethods!
imageIndexIn:!operations!private! !
renderBitmap!private! !
setCommandDescription:!initializing!private! !
!

!ToolbarIconButton class methodsFor!

command: aCommand description: aStringDescription image: anImage 
	"Answer a new instance of the receiver issuing aCommand with aStringDescription and anImage"

	| command |
	command := CommandDescription 
				command: aCommand
				description: aStringDescription
				image: anImage.
	^self commandDescription: command!

commandDescription: aCommandDescription 
	"Answer a new instance of the receiver containing a bitmap for aCommandDescription"

	^(self basicNew)
		setCommandDescription: aCommandDescription!

defaultImage
	^Object icon!

new
	"Answer a new default ToolbarButton"

	^self 
		command: #noCommand
		description: 'No command'
		image: Object icon!

onStartup
!

stbConvertFrom: anSTBClassFormat
	"Version 1 is refactored so that bitmap and bitmapIndex instance variables are no longer inherited.

	Version 0 inst var layout was:
		ToolbarItem
			1: commandId
			2: unused
			3: window (toolbar)
			4: style
			5: commandDescription
		ToolbarButton
			6: bitmap
			7: bitmapIndex
		ToolbarIconButton

	Version 1 inst var layout is:
		ToolbarItem
			1: toolbar
		ToolbarButton (now abstract)
			2: style
			3: commandDescription
			4: commandId
		ToolbarIconButton
	"

	^
	[:data |
	| newInstance |
	newInstance := self basicNew.
	1 to: 3 do: [:i | newInstance instVarAt: i put: (data at: i + 2)].
	newInstance instVarAt: 4 put: (data at: 1).
	newInstance]! !

!ToolbarIconButton class categoriesForMethods!
command:description:image:!instance creation!public! !
commandDescription:!instance creation!public! !
defaultImage!public! !
new!instance creation!public! !
onStartup!public! !
stbConvertFrom:!binary filing!private! !
!

