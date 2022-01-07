"Filed out from Dolphin Smalltalk"!

UI.Shell subclass: #'UI.Examples.GdiplusImageViewSampleShell'
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
	#{OS.COM.Picture} valueOrNil
		ifNotNil: [:olePicture | imageClasses := imageClasses copyWith: olePicture].
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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #face3d 918022 ##(Graphics.Point) 1001 1391 551 nil nil nil 416 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 592 nil 480 nil 7 nil nil nil 592 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(Graphics.Gdiplus.ImageView) 34 28 nil 592 34 2 8 1140850944 1 688 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 480 nil 7 nil nil nil 688 nil 8 4294903833 1049094 ##(UI.NullConverter) nil nil nil nil #normal 3 1180166 ##(Graphics.Rectangle) 498 1 1 498 1 1 nil #default #none nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 21 21 498 929 933 688 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 218 1 0 0 220 1 0 0] 8 #() 498 193 193 nil 29 170 192 34 2 688 8 'image' 866 498 21 21 498 21 21 930 138 144 34 1 994 #createAt:extent: 34 2 498 1 301 498 969 973 592 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 228 1 0 0 124 2 0 0] 34 1 688 1136 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1442 #fixedParentRight 1 1442 #fixedPreviousBottom 1 1442 #fixedParentBottom 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1520 nil 480 nil 7 nil nil nil 1520 nil 170 192 34 12 410 ##(UI.TextEdit) 34 16 nil 1520 34 2 8 1140924416 1025 1616 nil 466 #default nil 7 nil nil nil 1616 nil 8 1731487344 1049670 1 ##(UI.IntegerToText) nil 8 '' 1049350 ##(OS.WindowsLocale) nil 4115 170 192 8 #() nil 1 930 138 144 34 1 994 #createAt:extent: 34 2 498 835 239 498 89 51 1616 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 1 0 0 119 0 0 0 205 1 0 0 144 0 0 0] 8 #() 1136 nil 27 8 'padding' 410 ##(UI.ListBox) 34 17 nil 1520 34 2 8 1144062209 1025 2000 787270 2 ##(UI.ListModel) 138 144 1808 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1680 nil 7 nil nil nil 2000 nil 8 1731057856 ##(UI.BasicListAbstract) 8 #() false 930 138 144 34 2 994 #createAt:extent: 34 2 498 221 11 498 181 221 2000 994 #horizontalExtent: 8 #(0) 2000 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 5 0 0 0 200 0 0 0 115 0 0 0] 8 #() 1136 nil 27 8 'viewChoice' 410 ##(UI.ListBox) 34 17 nil 1520 34 2 8 1144062209 1025 2384 2066 138 144 1808 nil 2128 1680 nil 7 nil nil nil 2384 nil 8 1731057856 ##(UI.BasicListAbstract) 2160 false 930 138 144 34 2 994 #createAt:extent: 34 2 498 411 11 498 181 221 2384 994 #horizontalExtent: 8 #(0) 2384 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 205 0 0 0 5 0 0 0 39 1 0 0 115 0 0 0] 8 #() 1136 nil 27 8 'interpolationChoice' 410 ##(UI.ListBox) 34 17 nil 1520 34 2 8 1144062209 1025 2704 2066 138 144 1808 nil 2128 1680 nil 7 nil nil nil 2704 nil 8 1731057856 ##(UI.BasicListAbstract) 2160 false 930 138 144 34 2 994 #createAt:extent: 34 2 498 31 11 498 181 221 2704 994 #horizontalExtent: 8 #(0) 2704 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 105 0 0 0 115 0 0 0] 8 #() 1136 nil 27 8 'edgeChoice' 410 ##(UI.SpinButton) 34 15 nil 1520 34 2 8 1140916244 1 3024 754 nil nil 1704454 ##(Kernel.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 3138 #hash 8 #() 1 1680 nil 7 nil nil nil 3024 nil 8 1731272832 834 nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 498 921 239 498 35 51 3024 994 #setRange: 34 1 852742 ##(Core.Interval) 3 201 3 3024 994 #udmSetAccel: 34 1 1508678 1 ##(External.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(OS.UDACCEL) nil 17 3024 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 1 0 0 119 0 0 0 221 1 0 0 144 0 0 0] 8 #() 1136 nil 27 8 'spinner' 410 ##(UI.ListBox) 34 17 nil 1520 34 2 8 1144062209 1025 3568 2066 138 144 1808 nil 2128 1680 nil 7 nil nil nil 3568 nil 8 1731057856 ##(UI.BasicListAbstract) 2160 false 930 138 144 34 2 994 #createAt:extent: 34 2 498 605 9 498 351 221 3568 994 #horizontalExtent: 8 #(0) 3568 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 1 0 0 4 0 0 0 221 1 0 0 114 0 0 0] 8 #() 1136 nil 27 8 'classChoice' nil 930 138 144 34 1 994 #createAt:extent: 34 2 498 1 1 498 969 301 1520 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 150 0 0 0] 34 7 2704 2000 2384 3568 410 ##(UI.StaticText) 34 16 nil 1520 34 2 8 1140850944 65 4048 nil nil nil 7 nil nil nil 4048 nil 8 1731345888 834 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 498 721 241 498 111 41 4048 994 #text: 34 1 8 'Padding:' 4048 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 104 1 0 0 120 0 0 0 159 1 0 0 140 0 0 0] 8 #() 1136 nil 27 1616 3024 1136 nil 27 1410 1456 1 1472 1 1442 #fixedParentTop 1 1442 #fixedViewTop 301 170 192 1808 nil 658246 4 ##(UI.MenuBar) nil true 34 2 461638 4 ##(UI.Menu) nil true 34 1 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #fileOpen 8 '&Open ...' 9375 1 nil nil nil 8 '&File' nil 1 nil nil 25897 nil nil 4466 nil true 34 1 4514 1 4546 #helpAbout 8 'About' 1 1 nil nil nil 8 'Help' nil 1 nil nil 25901 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 498 12287 21 498 1001 1391 416 994 #text: 34 1 8 'GdiplusImageView Sample' 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 243 25 0 0 193 2 0 0] 34 2 1520 592 1136 nil 27)! !
!UI.Examples.GdiplusImageViewSampleShell class categoriesForMethods!
aboutText!enquiries!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

