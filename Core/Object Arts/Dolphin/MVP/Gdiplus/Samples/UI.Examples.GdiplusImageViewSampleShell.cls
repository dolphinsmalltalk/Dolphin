"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.GdiplusImageViewSampleShell'
	instanceVariableNames: 'image edgeChoice viewChoice padding paddingSpinner interpolationChoice classChoice useImageClass filename'
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

	filename := FileLocator installRelative localFileSpecFor: 'Resources/DolphinSplash.png'.
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
	classChoice := self add: ChoicePresenter new name: 'classChoice'.
	padding := self add: NumberPresenter new name: 'padding'.
	paddingSpinner := self add: NumberPresenter new name: 'spinner'!

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

onViewOpened
	| paddingModel imageClasses |
	super onViewOpened.
	image view
		insets: 0;
		viewMode: #scaleToFit.
	edgeChoice choices: Graphics.Gdiplus.ImageView edgeStyles.
	viewChoice choices: Graphics.Gdiplus.ImageView viewModes.
	interpolationChoice choices: Graphics.Gdiplus.ImageView interpolationStyles.
	imageClasses := {Image. Bitmap. Graphics.Bitmap. DIBSection. Icon}.
	classChoice choices: imageClasses.
	edgeChoice model: (image view aspectValue: #imageBorder).
	viewChoice model: (image view aspectValue: #viewMode).
	interpolationChoice model: (image view aspectValue: #interpolationMode).
	paddingModel := image view aspectValue: #insets.
	padding model: paddingModel.
	paddingSpinner view range: (0 to: 100).
	paddingSpinner model: paddingModel.
	classChoice model: (self aspectValue: #useImageClass).
	self attemptDisplayOABitmap!

useImageClass
	"Answer the image class to use"

	^useImageClass!

useImageClass: aClass
	useImageClass := aClass.
	self displayImage! !

!UI.Examples.GdiplusImageViewSampleShell categoriesForMethods!
attemptDisplayOABitmap!operations!public! !
createComponents!initializing!public! !
displayImage!operations!public! !
fileOpen!commands!public! !
helpAbout!commands!public! !
initialize!event handling!public! !
onViewOpened!event handling!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d 518 #{Graphics.Point} 1001 1391 517 nil nil nil 32 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil 112 nil 5 nil nil nil 240 nil 194 #{Core.IdentityDictionary} 50 12 18 #{UI.ListBox} 50 17 nil 240 50 2 8 1144062209 1025 336 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 98 #default nil 5 nil nil nil 336 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() false 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 130 605 9 130 351 221 336 626 #horizontalExtent: 8 #(0) 336 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 1 0 0 4 0 0 0 221 1 0 0 114 0 0 0] 8 #() 130 193 193 nil 27 8 'classChoice' 18 #{UI.ListBox} 50 17 nil 240 50 2 8 1144062209 1025 832 402 434 0 nil 480 496 nil 5 nil nil nil 832 nil nil 528 560 false 578 50 2 626 #createAt:extent: 50 2 130 31 11 130 181 221 832 626 #horizontalExtent: 8 #(0) 832 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 105 0 0 0 115 0 0 0] 8 #() 800 nil 27 8 'edgeChoice' 18 #{UI.ListBox} 50 17 nil 240 50 2 8 1144062209 1025 1120 402 434 0 nil 480 496 nil 5 nil nil nil 1120 nil nil 528 560 false 578 50 2 626 #createAt:extent: 50 2 130 411 11 130 181 221 1120 626 #horizontalExtent: 8 #(0) 1120 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 205 0 0 0 5 0 0 0 39 1 0 0 115 0 0 0] 8 #() 800 nil 27 8 'interpolationChoice' 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140924416 1025 1408 nil 496 nil 5 nil nil nil 1408 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 578 50 1 626 #createAt:extent: 50 2 130 835 239 130 1 51 1408 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 1 0 0 119 0 0 0 161 1 0 0 144 0 0 0] 8 #() 800 nil 45 8 'padding' 18 #{UI.SpinButton} 50 15 nil 240 50 2 8 1140916244 1 1712 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 514 #= 8 #() 514 #hash 8 #() 1 496 nil 5 nil nil nil 1712 nil nil 518 #{UI.NullConverter} nil nil 578 50 3 626 #createAt:extent: 50 2 130 921 239 130 35 51 1712 626 #setRange: 50 1 774 #{Core.Interval} 3 201 3 1712 626 #udmSetAccel: 50 1 1350 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 1712 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 1 0 0 119 0 0 0 221 1 0 0 144 0 0 0] 8 #() 800 nil 27 8 'spinner' 18 #{UI.ListBox} 50 17 nil 240 50 2 8 1144062209 1025 2240 402 434 0 nil 480 496 nil 5 nil nil nil 2240 nil nil 528 560 false 578 50 2 626 #createAt:extent: 50 2 130 221 11 130 181 221 2240 626 #horizontalExtent: 8 #(0) 2240 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 5 0 0 0 200 0 0 0 115 0 0 0] 8 #() 800 nil 27 8 'viewChoice' nil 578 50 1 626 #createAt:extent: 50 2 130 1 1 130 969 301 240 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 150 0 0 0] 50 7 832 2240 1120 336 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 65 2672 nil nil nil 5 nil nil nil 2672 nil nil 1906 nil nil nil 578 50 2 626 #createAt:extent: 50 2 130 721 241 130 111 41 2672 626 #text: 50 1 8 'Padding:' 2672 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 104 1 0 0 120 0 0 0 159 1 0 0 140 0 0 0] 8 #() 800 nil 27 1408 1712 800 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 2978 #fixedParentRight 1 2978 #fixedParentTop 1 2978 #fixedViewTop 301 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3056 nil 112 nil 5 nil nil nil 3056 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{Graphics.Gdiplus.ImageView} 50 28 nil 3056 50 2 8 1140850944 1 3152 1778 nil false 6 #{Kernel.EqualitySearchPolicy} nil 112 nil 5 nil nil nil 3152 nil nil 1906 nil nil nil nil #normal 3 518 #{Graphics.Rectangle} 130 1 1 130 1 1 nil #default #none nil nil nil nil nil 578 50 1 626 #createAt:extent: 50 2 130 21 21 130 929 933 3152 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 218 1 0 0 220 1 0 0] 8 #() 800 nil 29 194 #{Core.IdentityDictionary} 50 2 3152 8 'image' 3282 130 21 21 130 21 21 578 50 1 626 #createAt:extent: 50 2 130 1 301 130 969 973 3056 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 228 1 0 0 124 2 0 0] 50 1 3152 800 nil 27 2946 2992 1 3008 1 2978 #fixedPreviousBottom 1 2978 #fixedParentBottom 1 550 #{Core.IdentityDictionary} 0 nil 2886 4 #{UI.MenuBar} nil true 50 2 2886 4 #{UI.Menu} nil true 50 1 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileOpen 8 '&Open ...' 9375 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 3858 nil true 50 1 3906 1 3938 #helpAbout 8 'About' 1 1 nil nil nil 8 'Help' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 578 50 2 626 #createAt:extent: 50 2 130 6143 21 130 1001 1391 32 626 #text: 50 1 8 'GdiplusImageView Sample' 32 738 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 243 13 0 0 193 2 0 0] 50 2 240 3056 800 nil 27)! !

!UI.Examples.GdiplusImageViewSampleShell class categoriesForMethods!
aboutText!enquiries!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

