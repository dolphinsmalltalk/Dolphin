"Filed out from Dolphin Smalltalk"!

ScribbleDocument
	subclass: #'UI.Examples.EtchASketchDocument'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.EtchASketchDocument guid: (Core.GUID fromString: '{2971e17d-6207-4ede-b010-6a4262f924e5}')!
UI.Examples.EtchASketchDocument comment: ''!
!UI.Examples.EtchASketchDocument categoriesForClass!MVP-Presenters! !
!UI.Examples.EtchASketchDocument class methodsFor!

fileType
	^#('Etch-a-Sketch Files (*.sketch)' '*.sketch')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376838 1 #{UI.ResourceIdentifier} #{UI.Examples.EtchASketch} #resource_Default_view nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 722 1169 683 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 722 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 658246 4 #{UI.MenuBar} nil true 34 1 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #fileNew 8 '&New' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'DocumentShell.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 994 1 1026 #fileOpen 8 '&Open…' 9375 1 1074 nil true 1106 8 'OpenWorkspace.ico' 1168 65541 nil nil nil 994 1 1026 #fileSave 8 '&Save' 9383 1 1074 nil true 1106 8 'FileSave.ico' 1168 65541 nil nil nil 994 1 1026 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 21821 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 626 34 1 674 #createAt:extent: 34 2 722 12287 21 722 1201 801 416 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 1 528 832 nil 27)!

scribblePresenterClass
	^EtchASketch! !
!UI.Examples.EtchASketchDocument class categoriesForMethods!
fileType!constants!public! !
resource_Default_view!public!resources-views! !
scribblePresenterClass!constants!private! !
!

