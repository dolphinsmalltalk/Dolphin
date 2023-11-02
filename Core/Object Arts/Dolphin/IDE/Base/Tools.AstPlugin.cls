"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserPlugin
	subclass: #'Tools.AstPlugin'
	instanceVariableNames: 'astPresenter sourcePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AstPlugin guid: (Core.GUID fromString: '{4aba7565-bc07-4387-b7e4-16e2f57f1801}')!
Tools.AstPlugin comment: '`AstPlugin` is a `<classBrowserPlugin>` that displays the syntax tree for the currently selected method alongside the source.
	
Selecting a node in the AST will select the corresponding range of source.

Since this facility is probably not of interest to most developers it is not installed as one of the default plugins. If you wish to add this plugin to all browsers please evaluate:
```
	ClassBrowserAbstract allSubclasses do: [:each | each plugins add: self]
```
Alternatively Tools/Options/Inspect Options, then double click plugins, press the * button, and choose AstPlugin from the list, Ok out. The plugin will appear in any subsequently opened browser.'!
!Tools.AstPlugin categoriesForClass!MVP-Presenters! !
!Tools.AstPlugin methodsFor!

clear
	sourcePresenter text: ''.
	astPresenter model clear!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	astPresenter := self add: TreePresenter new name: 'syntaxTree'.
	sourcePresenter := self add: SmalltalkSystem current methodWorkspaceClass new name: 'source'.
	sourcePresenter isAutoParseEnabled: false!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	astPresenter
		when: #selectionChanged
		send: #onNodeSelected
		to: self.
	(self model)
		when: #classSelected
			send: #onBrowserClassSelected
			to: self;
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self!

displayMethod
	| treeModel method |
	method := self selectedMethod.
	method isNil
		ifTrue: 
			[self clear.
			^self].
	sourcePresenter text: method getSource.
	treeModel := VirtualTreeModel withRoots: (OrderedCollection with: self browser parseTree).
	astPresenter model: treeModel!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	^aPuttableStream nextPutAll: 'Syntax Tree'!

onBrowserClassSelected
	self isCurrentCard ifTrue: [self browser ensureDefinitionVisible]!

onBrowserMethodSelected
	"Event handler for a method being selected within the receiver's associated browser. "

	self isCurrentCard ifTrue: [self displayMethod]!

onNodeSelected
	sourcePresenter
		selectionRange: (astPresenter selection ifNil: [1 to: 0] ifNotNil: [:node | node sourceInterval])!

onShownInBrowser
	"Event handler indicating that the receiver has been displayed within it's browser. "

	super onShownInBrowser.
	"For efficiency we defer the creation of the diagram until the receiver becomes the current card"
	self displayMethod!

selectedMethod
	^self browser selectedMethod! !
!Tools.AstPlugin categoriesForMethods!
clear!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayMethod!operations!private! !
displayOn:!public! !
onBrowserClassSelected!event handling!private! !
onBrowserMethodSelected!event handling!private! !
onNodeSelected!event handling!private! !
onShownInBrowser!event handling!public! !
selectedMethod!accessing!private! !
!

!Tools.AstPlugin class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1445007428 262145 224 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 5 nil nil nil 224 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 6 #{Graphics.Color} #gray 482 #white 1 nil nil nil nil #callTip nil nil nil #normal 450 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkMethodStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 418 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 224 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 146 0 9215 nil nil 146 1 81 482 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 418 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 418 1 #container 432 nil nil nil nil #{Core.AnsiString} nil 418 3 1 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 224 482 #commonGreen 3 3 1 nil nil nil nil nil nil 3 866 3 224 482 #blue 5 3 3 nil nil nil nil nil nil 5 866 5 224 482 #red 1 3 5 nil nil nil nil nil nil nil nil 418 3 #Error 450 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 450 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 450 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 7 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 255 1218 701 247 224 1170 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 224 nil 3 nil nil nil nil 1314 3 224 33 nil 3 67108863 nil nil 1314 5 224 nil nil 3 8 4261412864 nil nil 224 1170 #tabWidth: 8 #(4) 224 1170 #maxCompletionListHeight: 8 #(9) 224 1170 #sciSetTechnology: 8 #(1) 224 1170 #sciSetFontQuality: 8 #(3) 224 1170 #sciSetSelectionLayer: 8 #(1) 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 127 0 0 0 94 1 0 0 250 0 0 0] 8 #() 1218 193 193 nil 45 8 'source' 18 #{UI.MoenTreeView} 50 30 nil 32 50 2 8 1409286144 262145 1648 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 418 0 482 #default nil 517 nil nil nil 1648 2566 #{UI.MoenTreeNode} nil 1030 #{UI.MoenContour} nil nil nil nil 1218 1 1 1904 nil nil nil nil nil 7 518 #{Core.Message} #displayString 8 #() #{UI.MoenTreeView} 268435457 1218 5 3 1350 1 #{Graphics.IconImageManager} 1218 1 1 41 nil 774 #{Graphics.Pen} nil true 262 #{OS.LOGPEN} 8 #[0 0 0 0 1 0 0 0 0 0 0 0 192 192 192 0] 1218 33 33 1218 19999 19999 114721 2016 1218 35 1 nil nil nil 1122 50 1 1170 #createAt:extent: 50 2 1218 1 1 1218 701 245 1648 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 122 0 0 0] 8 #() 1616 nil 27 8 'syntaxTree' nil 1122 50 1 1170 #createAt:extent: 50 2 1218 6143 21 1218 701 501 32 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 3 1648 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2464 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2464 nil 1 #left nil nil nil 1218 1 1 1218 9 9 nil 2560 nil 1122 50 1 1170 #createAt:extent: 50 2 1218 1 245 1218 701 11 2464 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 122 0 0 0 94 1 0 0 127 0 0 0] 8 #() 1616 nil 27 224 1616 nil 27)! !
!Tools.AstPlugin class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

