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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 519 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 160 nil nil nil 7 nil nil nil 160 582 1 #{UI.ResourceIdentifier} #{UI.Examples.EtchASketch} #resource_Default_view nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 354 1169 683 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 354 193 193 nil 27 550 #{Core.IdentityDictionary} 1 160 8 'scribble' nil 2886 4 #{UI.MenuBar} nil true 50 1 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'DocumentShell.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 626 1 658 #fileOpen 8 '&Open…' 9375 1 706 nil true 738 8 'OpenWorkspace.ico' 800 65541 nil nil nil 626 1 658 #fileSave 8 '&Save' 9383 1 706 nil true 738 8 'FileSave.ico' 800 65541 nil nil nil 626 1 658 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 47537 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 258 50 1 306 #createAt:extent: 50 2 354 6143 21 354 1201 801 32 402 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 50 1 160 464 nil 27)!

scribblePresenterClass
	^EtchASketch! !
!UI.Examples.EtchASketchDocument class categoriesForMethods!
fileType!constants!public! !
resource_Default_view!public!resources-views! !
scribblePresenterClass!constants!private! !
!

