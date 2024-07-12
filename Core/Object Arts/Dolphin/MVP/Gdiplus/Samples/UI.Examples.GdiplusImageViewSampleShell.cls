"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.GdiplusImageViewSampleShell'
	instanceVariableNames: 'image edgeChoice viewChoice interpolationChoice classChoice useImageClass filename statusModel'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.GdiplusImageViewSampleShell guid: (Core.GUID fromString: '{8645634f-e895-424a-a4c8-4db4afb9647e}')!

UI.Examples.GdiplusImageViewSampleShell comment: 'GdiplusImageViewSampleShell

Evaluate
	GdiplusImageViewSampleShell show

Instance Variables:
	image			<ImagePresenter>
	edgeChoice		<ChoicePresenter>
	viewChoice		<ChoicePresenter>
	padding			<NumberPresenter>
	interpolationChoice		<ChoicePresenter>
	classChoice		<ChoicePresenter>
	useImageClass		<GdiplusImage class>
	filename			<String>

'!

!UI.Examples.GdiplusImageViewSampleShell categoriesForClass!MVP-Presenters! !

!UI.Examples.GdiplusImageViewSampleShell methodsFor!

attemptDisplayOABitmap
	"Try opening an OA bitmap ... will show warning icon in deployed version"

	filename := FileLocator installRelative localFileSpecFor: 'Resources/Splash.jpg'.
	[self displayImage] on: Error
		do: 
			[:e |
			Transcript
				print: e;
				cr]!

createComponents
	super createComponents.
	image := self add: ImagePresenter new name: 'image'.
	edgeChoice := self add: ChoicePresenter new name: 'edgeChoice'.
	viewChoice := self add: ChoicePresenter new name: 'viewChoice'.
	interpolationChoice := self add: ChoicePresenter new name: 'interpolationChoice'.
	classChoice := self add: ChoicePresenter new name: 'classChoice'!

createSchematicWiring
	super createSchematicWiring.
	viewChoice when: #valueChanged send: #onViewChoiceChanged to: self!

displayImage
	| theImage |
	self caption: filename.
	theImage := self useImageClass fromFile: filename.
	theImage handle.
	image value: theImage!

fileOpen
	| newFilename |
	newFilename := FileOpenDialog new
				fileTypes: {FileDialog allFilesType};
				showModal.
	newFilename notNil
		ifTrue: 
			[filename := newFilename.
			self displayImage]!

helpAbout
	(MessageBox new)
		caption: 'About ' , self class name asString;
		icon: self class icon;
		text: self class aboutText;
		open!

initialize
	useImageClass := Image.
	super initialize!

onPositionChanged: aPositionEvent
	self updateStatus.
	^super onPositionChanged: aPositionEvent!

onViewChoiceChanged
	self updateStatus!

onViewOpened
	super onViewOpened.
	edgeChoice choices: Graphics.Gdiplus.ImageView edgeStyles.
	viewChoice choices: Graphics.Gdiplus.ImageView viewModes.
	interpolationChoice choices: Graphics.Gdiplus.ImageView interpolationStyles.
	classChoice choices: { Image. Bitmap. Graphics.Bitmap. DIBSection. Icon }.
	edgeChoice model: (image view aspectValue: #imageBorder).
	viewChoice model: (image view aspectValue: #viewMode).
	interpolationChoice model: (image view aspectValue: #interpolationMode).
	classChoice model: (self aspectValue: #useImageClass).
	statusModel := nil asValue.
	(self view viewNamed: 'extentStatus') model: statusModel.
	self attemptDisplayOABitmap!

updateStatus
	statusModel value: image view imageRectangle!

useImageClass
	"Answer the image class to use"

	^useImageClass!

useImageClass: aClass
	useImageClass := aClass.
	self displayImage! !

!UI.Examples.GdiplusImageViewSampleShell categoriesForMethods!
attemptDisplayOABitmap!operations!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayImage!operations!public! !
fileOpen!commands!public! !
helpAbout!commands!public! !
initialize!event handling!public! !
onPositionChanged:!event handling!public! !
onViewChoiceChanged!event handling!public! !
onViewOpened!event handling!public! !
updateStatus!public!updating! !
useImageClass!accessing!public! !
useImageClass:!accessing!public! !
!

!UI.Examples.GdiplusImageViewSampleShell class methodsFor!

aboutText
	^'GdiplusImageViewSampleShell

Copyright: 2003
  Steve Waring <swaring@ozemail.com.au>


DISCLAIMER: This software is freely provided purely as a sample and as such it
is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE' 
		formatWith: SessionManager current productVersion!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 43 in: (ResourceLibrary open: 'Shell32')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d 518 #{Graphics.Point} 1601 1201 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 192 nil 112 nil 5 nil nil nil 192 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ListBox} 50 17 nil 192 50 2 8 1144062209 1025 304 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 98 #default nil 5 nil nil nil 304 nil nil 518 #{Core.Message} #shortName 8 #() 8 #() false 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[96 1 0 0 4 0 0 0 216 1 0 0 114 0 0 0] 193 336 8 '' 304 594 #horizontalExtent: 8 #(0) 304 3 8 #() 130 193 193 nil 27 8 'classChoice' 18 #{UI.ListBox} 50 17 nil 192 50 2 8 1144062209 1025 816 370 402 0 nil 448 464 nil 5 nil nil nil 816 nil nil 482 #displayString 8 #() 528 false 546 50 2 594 #createWindow: 50 1 642 674 8 #[15 0 0 0 5 0 0 0 105 0 0 0 115 0 0 0] 193 848 8 '' 816 594 #horizontalExtent: 8 #(0) 816 3 8 #() 130 193 193 nil 27 8 'edgeChoice' 18 #{UI.ListBox} 50 17 nil 192 50 2 8 1144062209 1025 1152 370 402 0 nil 448 464 nil 5 nil nil nil 1152 nil nil 912 528 false 546 50 2 594 #createWindow: 50 1 642 674 8 #[205 0 0 0 5 0 0 0 89 1 0 0 115 0 0 0] 193 1184 8 '' 1152 594 #horizontalExtent: 8 #(0) 1152 3 8 #() 130 193 193 nil 27 8 'interpolationChoice' 18 #{UI.ListBox} 50 17 nil 192 50 2 8 1144062209 1025 1456 370 402 0 nil 448 464 nil 5 nil nil nil 1456 nil nil 912 528 false 546 50 2 594 #createWindow: 50 1 642 674 8 #[110 0 0 0 5 0 0 0 200 0 0 0 115 0 0 0] 193 1488 8 '' 1456 594 #horizontalExtent: 8 #(0) 1456 3 8 #() 130 193 193 nil 27 8 'viewChoice' nil 546 50 1 594 #createWindow: 50 1 642 674 8 #[0 0 0 0 0 0 0 0 16 3 0 0 129 0 0 0] 193 224 8 '' 192 3 50 4 816 1456 1152 304 130 193 193 nil 27 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1409288460 1 1920 nil 464 nil 517 nil nil nil 1920 nil nil 258 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 301 1920 nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 4 1 480 8 'doIt' 8 '[:rect | (rect ifNotNil: [rect extent]) displayString]' 8 #[31 105 17 222 3 226 0 110 60 159 106] #extent #displayString 2064 #ifNotNil: 7 257 nil 2050 0 nil 2082 5 1 480 8 'doIt' 8 '[:image | (Graphics.Icon fromId: ''EXTENT.ICO'') imageIndex]' 8 #[33 105 45 30 178 161 106] 1094 2 #{Kernel.VariableBinding} #Icon #{Graphics.Icon} #{Graphics} 1 8 'EXTENT.ICO' #fromId: #imageIndex 2160 7 257 nil nil 8 'extentStatus' nil nil nil 50 1 2032 1094 1 #{UI.StatusBarNullItem} 8705 1 1920 nil nil 546 50 1 594 #createWindow: 50 1 642 674 8 #[0 0 0 0 9 2 0 0 16 3 0 0 29 2 0 0] 193 1952 8 '' 1920 3 8 #() 130 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2512 nil 112 nil 5 nil nil nil 2512 162 1 1 nil nil nil nil 18 #{Graphics.Gdiplus.ImageView} 50 28 nil 2512 50 2 8 1140850944 1 2592 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 112 nil 5 nil nil nil 2592 nil nil 518 #{UI.NullConverter} nil nil nil nil #normal 3 518 #{Graphics.Rectangle} 130 1 1 130 1 1 nil #default #none nil nil nil nil nil 546 50 2 594 #createWindow: 50 1 642 674 8 #[10 0 0 0 10 0 0 0 6 3 0 0 126 1 0 0] 193 2624 nil 2592 594 #text: 50 1 8 '' 2592 3 8 #() 130 193 193 nil 29 258 #{Core.IdentityDictionary} 50 2 2592 8 'image' 2754 130 21 21 130 21 21 546 50 1 594 #createWindow: 50 1 642 674 8 #[0 0 0 0 129 0 0 0 16 3 0 0 9 2 0 0] 193 2544 8 '' 2512 3 50 1 2592 130 193 193 nil 27 550 #{Core.IdentityDictionary} 0 nil 2886 4 #{UI.MenuBar} nil true 50 2 2886 4 #{UI.Menu} nil true 50 1 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileOpen 8 '&Open ...' 9375 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 3346 nil true 50 1 3394 1 3426 #helpAbout 8 'About' 1 1 nil nil nil 8 'Help' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 546 50 1 594 #createWindow: 50 1 642 674 8 #[255 14 0 0 10 0 0 0 31 18 0 0 98 2 0 0] 193 80 8 'GdiplusImageView Sample' 32 1 50 3 192 2512 1920 130 193 193 nil 27)! !

!UI.Examples.GdiplusImageViewSampleShell class categoriesForMethods!
aboutText!enquiries!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

