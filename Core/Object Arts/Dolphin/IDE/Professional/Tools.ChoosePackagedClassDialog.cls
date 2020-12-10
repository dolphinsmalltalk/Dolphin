"Filed out from Dolphin Smalltalk 7"!

Tools.ChooseClassDialog subclass: #'Tools.ChoosePackagedClassDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ChoosePackagedClassDialog guid: (Core.GUID fromString: '{66f6e532-7d50-44b1-877b-8e46061d0277}')!
Tools.ChoosePackagedClassDialog comment: 'ChoosePackagedClassDialog is a specialised <ChooseClassDialog> that allows for filtering of the class hierarchy by package selection.
'!
!Tools.ChoosePackagedClassDialog categoriesForClass!MVP-Presenters! !
!Tools.ChoosePackagedClassDialog methodsFor!

classesPresenterClass
	^PackagedClassSelector!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	"If there is no current package, then select the root of the package tree."
	classesPresenter selectionOrNil isNil ifTrue: [classesPresenter selectPackageRoot]!

packages: aCollection 
	"Set the packages selected in the receiver. Ignored at this level."

	classesPresenter packages: aCollection! !
!Tools.ChoosePackagedClassDialog categoriesFor: #classesPresenterClass!constants!private! !
!Tools.ChoosePackagedClassDialog categoriesFor: #onViewOpened!event handling!public! !
!Tools.ChoosePackagedClassDialog categoriesFor: #packages:!public!selection! !

!Tools.ChoosePackagedClassDialog class methodsFor!

on: aModel
	"Answer an instance of the receiver not yet connected to any view
	but connected to aModel."

	"Implementation Note: Unpackaged classes do not appear in the packaged class dialog, so if
	the initial class is unpackaged we have to use the simpler dialog (#1329)."

	aModel value ifNotNil: [:class | class owningPackage isNil ifTrue: [^ChooseClassDialog on: aModel]].
	^super on: aModel!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 133 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 21 633 578 809 71 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 158 1 0 0 95 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #findClass 8 'Find...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1074 1 1106 #gotoDefinition 8 '&Goto Definition' 1 1 nil nil nil 1026 nil true 34 4 1074 1 1106 #browseClassPackage 8 'Package <1d>' 1 1 1154 nil true 1200 8 'Package.ico' 1248 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1074 1 1106 #browseClass 8 '&Class' 1 1 1154 nil true 1200 8 'ClassBrowserShell.ico' 1248 nil nil 1074 2097153 1106 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 960 706 ##(Tools.PackagedClassSelector) #resource_Choice_view nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 21 21 578 809 613 960 802 #contextMenu: 34 1 1040 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 158 1 0 0 60 1 0 0] 928 944 nil 27 170 192 34 2 960 8 'classSelector' 1180166 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 27663 nil nil nil 578 661 521 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1996777232 738 138 144 34 2 802 #createAt:extent: 34 2 578 6143 21 578 881 801 416 802 #text: 34 1 8 'Choose Packaged Class...' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 183 13 0 0 154 1 0 0] 34 2 960 640 944 nil 27 )!

uninitialize
	Smalltalk developmentSystem classChooserClass == self 
		ifTrue: [Smalltalk developmentSystem classChooserClass: nil]! !
!Tools.ChoosePackagedClassDialog class categoriesFor: #on:!instance creation!public! !
!Tools.ChoosePackagedClassDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.ChoosePackagedClassDialog class categoriesFor: #uninitialize!class hierarchy-removing!public! !

