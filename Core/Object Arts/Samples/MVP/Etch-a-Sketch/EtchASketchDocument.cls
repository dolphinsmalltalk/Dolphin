"Filed out from Dolphin Smalltalk 7"!

ScribbleDocument subclass: #EtchASketchDocument
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EtchASketchDocument guid: (GUID fromString: '{2971e17d-6207-4ede-b010-6a4262f924e5}')!
EtchASketchDocument comment: ''!
!EtchASketchDocument categoriesForClass!MVP-Presenters! !
!EtchASketchDocument class methodsFor!

fileType
	^#('Etch-a-Sketch Files (*.sketch)' '*.sketch')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 544 nil nil nil 7 nil nil nil 544 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.EtchASketch) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 754 1169 683 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 754 193 193 nil 27 170 192 34 2 544 8 'scribble' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1026 1 1058 #fileOpen 8 '&Open...' 9375 1 1106 nil true 1152 8 'OpenWorkspace.ico' 1200 nil nil 1026 1 1058 #fileSave 8 '&Save' 9383 1 1106 nil true 1152 8 'FileSave.ico' 1200 nil nil 1026 1 1058 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 57951 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 642 138 144 34 2 706 #createAt:extent: 34 2 754 3839 21 754 1201 801 416 706 #updateMenuBar 848 416 802 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 544 864 nil 27 )!

scribblePresenterClass
	^EtchASketch! !
!EtchASketchDocument class categoriesFor: #fileType!constants!public! !
!EtchASketchDocument class categoriesFor: #resource_Default_view!public!resources-views! !
!EtchASketchDocument class categoriesFor: #scribblePresenterClass!constants!private! !

