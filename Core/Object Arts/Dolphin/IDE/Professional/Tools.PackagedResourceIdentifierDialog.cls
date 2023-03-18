"Filed out from Dolphin Smalltalk"!

Tools.ResourceIdentifierDialog
	subclass: #'Tools.PackagedResourceIdentifierDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackagedResourceIdentifierDialog guid: (Core.GUID fromString: '{17c3843c-c032-4108-a7ef-7e784dea4647}')!
Tools.PackagedResourceIdentifierDialog comment: 'PackagedResourceIdentifierDialog is a specialised <ResourceIdentifierDialog> that uses the <PackagedClassSelector> for class selection, rather than the standard <ClassHierarchySslector>. 
'!
!Tools.PackagedResourceIdentifierDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Tools.PackagedResourceIdentifierDialog methodsFor!

classesPresenterClass
	^PackagedClassSelector! !
!Tools.PackagedResourceIdentifierDialog categoriesForMethods!
classesPresenterClass!constants!private! !
!

!Tools.PackagedResourceIdentifierDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 21 623 578 809 81 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 55 1 0 0 158 1 0 0 95 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 17 nil 410 #{UI.TextEdit} 34 16 nil 944 34 2 8 1140916224 1025 1024 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1024 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 738 34 2 786 #createAt:extent: 34 2 578 1 559 578 809 45 1024 786 #setMarginWidths: 34 1 8 #(3 3) 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 1 0 0 148 1 0 0 45 1 0 0] 8 #() 928 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 944 34 2 8 1140916224 131073 1360 nil nil nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 2097153 1377606 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 1426 nil true 34 4 1474 1 1506 #browseClassPackage 8 'Package <1d>' 1 1 1554 nil true 1586 8 'Package.ico' 1648 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 1474 1 1506 #browseClass 8 '&Class' 1 1 1554 nil true 1586 8 'ClassBrowserShell.ico' 1648 65541 nil nil nil 1474 2097153 1506 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1810 4097 1426 nil true 34 2 1426 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1426 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1360 706 #{Tools.PackagedClassSelector} #resource_Choice_view nil 738 34 2 786 #createAt:extent: 34 2 578 1 1 578 809 543 1360 786 #contextMenu: 34 1 1440 1360 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 148 1 0 0 15 1 0 0] 912 928 nil 27 170 192 34 4 1360 8 'classSelector' 1024 8 'resourceName' nil 738 34 1 786 #createAt:extent: 34 2 578 21 21 578 809 603 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 158 1 0 0 55 1 0 0] 34 2 1360 1024 928 nil 27 170 192 912 1180166 #{Graphics.Rectangle} 578 21 21 578 21 21 nil nil nil nil 57141 nil nil nil 578 421 721 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 881 801 416 786 #text: 34 1 8 'Resource Identification' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 183 25 0 0 154 1 0 0] 34 2 944 640 928 nil 27)!

uninitialize
	SmalltalkSystem.Current
		ifNotNil: 
			[:devsys |
			devsys packagedResourceIdentifierDialogClass == self
				ifTrue: [devsys packagedResourceIdentifierDialogClass: nil]]! !
!Tools.PackagedResourceIdentifierDialog class categoriesForMethods!
resource_Default_view!public!resources-views! !
uninitialize!class hierarchy-removing!public! !
!

