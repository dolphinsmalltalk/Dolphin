"Filed out from Dolphin Smalltalk"!

Shell subclass: #GdiplusImageViewSampleShell
	instanceVariableNames: 'image edgeChoice viewChoice interpolationChoice classChoice useImageClass filename statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusImageViewSampleShell guid: (GUID fromString: '{8645634f-e895-424a-a4c8-4db4afb9647e}')!

GdiplusImageViewSampleShell comment: 'GdiplusImageViewSampleShell

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

!GdiplusImageViewSampleShell categoriesForClass!MVP-Presenters! !

!GdiplusImageViewSampleShell methodsFor!

attemptDisplayOABitmap
	"Try opening an OA bitmap ... will show warning icon in deployed version"

	filename := FileLocator installRelative localFileSpecFor: 'Resources/Splash.jpg'.
	[self displayImage] on: Error do: [:e | ]!

createComponents
	super createComponents.
	image := self add: ImagePresenter new name: 'image'.
	edgeChoice := self add: ChoicePresenter new name: 'edgeChoice'.
	viewChoice := self add: ChoicePresenter new name: 'viewChoice'.
	interpolationChoice := self add: ChoicePresenter new name: 'interpolationChoice'.
	classChoice := self add: ChoicePresenter new name: 'classChoice'.
!

createSchematicWiring
	super createSchematicWiring.
	viewChoice when: #valueChanged send: #onViewChoiceChanged to: self!

displayImage
	| theImage |
	theImage := self useImageClass fromFile: filename.
	theImage handle.
	image value: theImage!

fileOpen
	| newFilename |
	newFilename := (FileOpenDialog new)
				fileTypes: (Array with: FileDialog allFilesType);
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
	useImageClass := GdiplusImage.
	super initialize!

onPositionChanged: aPositionEvent
	self updateStatus.
	^super onPositionChanged: aPositionEvent!

onViewChoiceChanged
	self updateStatus!

onViewOpened
	super onViewOpened.
	edgeChoice choices: GdiplusImageView edgeStyles.
	viewChoice choices: GdiplusImageView viewModes.
	interpolationChoice choices: GdiplusImageView interpolationStyles.
	classChoice choices: {GdiplusImage. GdiplusBitmap. Bitmap. Icon}.
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

!GdiplusImageViewSampleShell categoriesForMethods!
attemptDisplayOABitmap!operations!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayImage!operations!public! !
fileOpen!commands!public! !
helpAbout!commands!public! !
initialize!event handling!public! !
onPositionChanged:!event handling!public! !
onViewChoiceChanged!public! !
onViewOpened!event handling!public! !
updateStatus!event handling!public! !
useImageClass!accessing!public! !
useImageClass:!accessing!public! !
!

!GdiplusImageViewSampleShell class methodsFor!

aboutText
	^'GdiplusImageViewSampleShell

Copyright: 2003
  Steve Waring <swaring@ozemail.com.au>


DISCLAIMER: This software is freely provided purely as a sample and as such it
is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE' 
		formatWith: SessionManager current versionInfo productVersionString!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 43 in: (ExternalResourceLibrary open: 'Shell32')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 1021 721 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil 480 nil 5 nil nil nil 560 nil 170 192 34 8 410 ##(Smalltalk.ListBox) 34 17 nil 560 34 2 8 1144062209 1025 656 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 #default nil 5 nil nil nil 656 nil 8 1758868288 ##(Smalltalk.BasicListAbstract) 8 #() false 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[94 1 0 0 5 0 0 0 184 1 0 0 115 0 0 0] 193 688 8 '' 656 3 8 #() 498 193 193 nil 27 8 'classChoice' 410 ##(Smalltalk.ListBox) 34 17 nil 560 34 2 8 1144062209 1025 1120 722 138 144 768 nil 800 816 nil 5 nil nil nil 1120 nil 8 1758868288 ##(Smalltalk.BasicListAbstract) 848 false 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[110 0 0 0 5 0 0 0 200 0 0 0 115 0 0 0] 193 1152 8 '' 1120 3 8 #() 498 193 193 nil 27 8 'viewChoice' 410 ##(Smalltalk.ListBox) 34 17 nil 560 34 2 8 1144062209 1025 1424 722 138 144 768 nil 800 816 nil 5 nil nil nil 1424 nil 8 1758868288 ##(Smalltalk.BasicListAbstract) 848 false 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[15 0 0 0 5 0 0 0 105 0 0 0 115 0 0 0] 193 1456 8 '' 1424 3 8 #() 498 193 193 nil 27 8 'edgeChoice' 410 ##(Smalltalk.ListBox) 34 17 nil 560 34 2 8 1144062209 1025 1728 722 138 144 768 nil 800 816 nil 5 nil nil nil 1728 nil 8 1758868288 ##(Smalltalk.BasicListAbstract) 848 false 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[205 0 0 0 5 0 0 0 89 1 0 0 115 0 0 0] 193 1760 8 '' 1728 3 8 #() 498 193 193 nil 27 8 'interpolationChoice' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 16 3 0 0 129 0 0 0] 193 592 8 '' 560 3 34 4 1424 1120 1728 656 498 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1409288460 1 2208 nil 816 nil 5 nil nil nil 2208 nil 8 1758805184 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 301 2208 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 4 1 ##(Smalltalk.Message) 8 'doIt' 8 '[:rect | (rect ifNotNil: [rect extent]) displayString]' 8 #[31 105 17 222 3 226 0 110 60 159 106] #extent #displayString 2368 #ifNotNil: 7 257 nil 2354 0 nil 2386 5 1 2352 8 'doIt' 8 '[:image | (Icon fromId: ''EXTENT.ICO'') imageIndex]' 8 #[33 105 45 30 178 161 106] 983558 ##(Smalltalk.VariableBinding) #Icon ##(Smalltalk.Icon) 8 'EXTENT.ICO' #fromId: #imageIndex 2464 7 257 nil nil 8 'extentStatus' nil nil nil 34 1 2336 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2208 nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 7 2 0 0 16 3 0 0 29 2 0 0] 193 2240 8 '' 2208 3 8 #() 498 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2832 nil 480 nil 5 nil nil nil 2832 530 1 1 nil nil nil nil 410 ##(Smalltalk.GdiplusImageView) 34 28 nil 2832 34 2 8 1140850944 1 2912 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 480 nil 5 nil nil nil 2912 nil 8 4294903833 852486 ##(Smalltalk.NullConverter) nil nil nil nil #normal 3 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 nil #default #none nil nil nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[10 0 0 0 10 0 0 0 6 3 0 0 124 1 0 0] 193 2944 nil 2912 930 #text: 34 1 8 '' 2912 3 8 #() 498 193 193 nil 29 170 192 34 2 2912 8 'image' 3090 498 21 21 498 21 21 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 129 0 0 0 16 3 0 0 7 2 0 0] 193 2864 8 '' 2832 3 34 1 2912 498 193 193 nil 27 170 192 768 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 2 265030 4 ##(Smalltalk.Menu) nil true 34 1 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileOpen 8 '&Open ...' 9375 1 nil nil nil 8 '&File' nil 1 nil nil 12999 nil nil 3698 nil true 34 1 3746 1 3778 #helpAbout 8 'About' 1 1 nil nil nil 8 'Help' nil 1 nil nil 13003 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 866 138 144 34 1 930 #createWindow: 34 1 978 3090 498 1 1 498 1601 1201 193 448 8 'GdiplusImageView Sample' 416 1 34 3 560 2832 2208 498 193 193 nil 27 )! !

!GdiplusImageViewSampleShell class categoriesForMethods!
aboutText!enquiries!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

