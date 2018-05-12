"Filed out from Dolphin Smalltalk 7"!

ToolbarButton subclass: #ToolbarIconButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolbarIconButton guid: (GUID fromString: '{eb590073-1214-495b-94ba-9bd4ca08bd32}')!
ToolbarIconButton comment: 'ToolbarIconButton represents a user defined button for a <Toolbar>  the image is dynamically generated from the <Image> held by the associated <CommandDescription>. In general, ToolbarIconButtons are much easier to use than ToolbarButtons since they don''t require the creation of a separate image list bitmap for each of the sizes of toolbar button that may be required.  If you change the #bitmapSize aspect of the parent toolbar, the contained ToolbarIconButtons will automatically re-render themselves at the new size.

e.g. 

"Evaluate the following expressions one at a time"
tb := Toolbar new show.
tb extent: 300@ 64.
ClassBrowserAbstract withAllSubclassesDo: [:each | 
	tb addItem: (ToolbarIconButton command: #myCommand description: ''My Command'' image: each icon)].
tb bitmapSize: 24@24.
tb bitmapSize: 32@32.
tb bitmapSize: 48@48
tb destroy.
'!
!ToolbarIconButton categoriesForClass!MVP-Views-Support! !
!ToolbarIconButton methodsFor!

bitmap
	"Answer the bitmap for the receiver."

	bitmap isNil ifTrue: [self renderBitmap].
	^bitmap!

bitmap: aBitmap 
	self shouldNotImplement!

bitmapIndex: anInteger 
	self shouldNotImplement!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	bitmapIndex := 0
!

onStartup
	bitmap := nil!

renderBitmap
	| image |
	bitmap := Bitmap displayCompatibleWithExtent: self toolbar bitmapSize.
	(bitmap canvas)
		backcolor: Color face3d;
		erase.
	image := self commandDescription image.
	image ifNil: [image := self class defaultImage].
	(image class imageManager imageListWithExtent: bitmap extent) 
		draw: image imageIndex
		on: bitmap canvas
		at: Point zero.
	bitmapIndex := 0!

stbFixup: anSTBInFiler at: newObjectIndex
	super stbFixup: anSTBInFiler at: newObjectIndex.
	bitmap := nil.

	!

toolbar: aToolbar 
	"Private - Set the toolbar in which the receiver exists to aToolbar."

	super toolbar: aToolbar.
	bitmap := nil.
!

update
	"Private - Update the associated Toolbar if we have one"

	super update.
	bitmap := nil! !
!ToolbarIconButton categoriesFor: #bitmap!accessing!public! !
!ToolbarIconButton categoriesFor: #bitmap:!accessing!private! !
!ToolbarIconButton categoriesFor: #bitmapIndex:!accessing!private! !
!ToolbarIconButton categoriesFor: #initialize!initializing!private! !
!ToolbarIconButton categoriesFor: #onStartup!private! !
!ToolbarIconButton categoriesFor: #renderBitmap!private! !
!ToolbarIconButton categoriesFor: #stbFixup:at:!binary filing!public! !
!ToolbarIconButton categoriesFor: #toolbar:!accessing!private! !
!ToolbarIconButton categoriesFor: #update!accessing!private! !

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
		commandDescription: aCommandDescription;
		initialize!

defaultImage
	^Object icon!

new
	"Answer a new default ToolbarButton"

	^self 
		command: #noCommand
		description: 'No command'
		image: Object icon!

onStartup
	"Private - Ensure all the receiver's subinstances are in their 'invalidated' state on startup
	so that they rebuild their bitmap when required rather than attempting
	to use an old handle hanging around from the sesssion when the image was saved."

	self primAllSubinstances do: [:i | i onStartup].
! !
!ToolbarIconButton class categoriesFor: #command:description:image:!instance creation!public! !
!ToolbarIconButton class categoriesFor: #commandDescription:!instance creation!public! !
!ToolbarIconButton class categoriesFor: #defaultImage!public! !
!ToolbarIconButton class categoriesFor: #new!instance creation!public! !
!ToolbarIconButton class categoriesFor: #onStartup!event handling!private! !

