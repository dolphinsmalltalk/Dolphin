"Filed out from Dolphin Smalltalk"!

Tools.ChooseClassDialog
	subclass: #'Tools.ChoosePackagedClassDialog'
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
!Tools.ChoosePackagedClassDialog categoriesForMethods!
classesPresenterClass!constants!private! !
onViewOpened!event handling!public! !
packages:!public!selection! !
!

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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 610 1 1 nil nil 410 #{UI.ReferenceView} 34 14 nil 640 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 865 11 578 341 61 720 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 176 1 0 0 5 0 0 0 90 2 0 0 35 0 0 0] 8 #() 578 193 193 nil 27 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1409286144 131073 1024 nil nil nil 7 nil nil nil 1024 852806 1 #{UI.FlowLayout} 17 17 17 170 192 34 2 410 #{UI.PushButton} 34 20 nil 1024 34 2 8 1141055488 1 1152 nil nil nil 7 nil nil nil 1152 nil 8 1809920128 1377606 4 #{UI.CommandDescription} #none 8 'None' 1 1 nil nil false nil nil nil 818 34 3 866 #createAt:extent: 34 2 578 5 17 578 151 47 1152 866 #isEnabled: 8 #(false) 1152 866 #text: 34 1 8 'None' 1152 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 8 0 0 0 77 0 0 0 31 0 0 0] 8 #() 1008 nil 29 8 'none' 1180166 #{Graphics.Rectangle} 578 5 17 578 1 1 818 34 1 866 #createAt:extent: 34 2 578 1 11 578 171 61 1024 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 85 0 0 0 35 0 0 0] 34 1 1152 1008 nil 27 nil 170 192 992 1522 578 1 11 578 5 1 818 34 1 866 #createAt:extent: 34 2 578 21 633 578 1209 71 640 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 102 2 0 0 95 1 0 0] 34 2 1024 720 1008 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 1936 nil nil nil 7 461638 4 #{UI.Menu} nil true 34 3 1180742 2 #{UI.CommandMenuItem} 2097153 1234 #findClass 8 'Find…' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 2050 1 1234 #gotoDefinition 8 '&Goto Definition' 1 1 nil nil nil 2002 nil true 34 4 2050 1 1234 #browseClassPackage 8 'Package <1d>' 1 1 2114 nil true 2146 8 'Package.ico' 2208 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2050 1 1234 #browseClass 8 '&Class' 1 1 2114 nil true 2146 8 'ClassBrowserShell.ico' 2208 65541 nil nil nil 2050 2097153 1234 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1936 786 #{Tools.PackagedClassSelector} #resource_Choice_view nil 818 34 2 866 #createAt:extent: 34 2 578 21 21 578 1209 613 1936 866 #contextMenu: 34 1 2016 1936 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 60 1 0 0] 992 1008 nil 27 170 192 34 2 1936 8 'classSelector' 1522 578 21 21 578 21 21 nil nil nil nil 28153 nil nil nil 578 661 521 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 1999274064 818 34 2 866 #createAt:extent: 34 2 578 12287 21 578 1281 801 416 866 #text: 34 1 8 'Choose Packaged Class…' 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 127 26 0 0 154 1 0 0] 34 2 1936 640 1008 nil 27)!

uninitialize
	SmalltalkSystem.Current
		ifNotNil: [:devsys | devsys classChooserClass == self ifTrue: [devsys classChooserClass: nil]]! !
!Tools.ChoosePackagedClassDialog class categoriesForMethods!
on:!instance creation!public! !
resource_Default_view!public!resources-views! !
uninitialize!class hierarchy-removing!public! !
!

