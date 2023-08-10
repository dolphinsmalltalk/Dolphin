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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 550 #{Core.IdentityDictionary} 2 18 #{UI.MoenTreeView} 50 30 nil 32 50 2 8 1409286144 262145 208 1094 3 #{UI.TreeModel} nil 6 #{Kernel.IdentitySearchPolicy} 774 #{UI.TreeNode} nil nil nil 178 0 6 #{Graphics.Color} #default nil 517 nil nil nil 208 2566 #{UI.MoenTreeNode} nil 1030 #{UI.MoenContour} nil nil nil nil 518 #{Graphics.Point} 1 1 496 nil nil nil nil nil 7 518 #{Core.Message} #displayString 8 #() #{UI.MoenTreeView} 268435457 482 5 3 1350 1 #{Graphics.IconImageManager} 482 1 1 41 nil 774 #{Graphics.Pen} nil true 262 #{OS.LOGPEN} 8 #[0 0 0 0 1 0 0 0 0 0 0 0 192 192 192 0] 482 33 33 482 19999 19999 114721 608 482 35 1 nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 482 1 1 482 701 245 208 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 122 0 0 0] 8 #() 482 193 193 nil 27 8 'syntaxTree' 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1445007428 262145 976 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 5 nil nil nil 976 nil 8 1367644576 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 178 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 386 #gray 386 #white 1 nil nil nil nil #callTip nil nil nil #normal 1202 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkMethodStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 178 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 976 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 146 0 9215 nil nil 146 1 81 386 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 178 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 178 1 #container 1184 nil nil nil nil #{Core.AnsiString} nil 178 3 1 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 976 386 #commonGreen 3 3 1 nil nil nil nil nil nil 3 1602 3 976 386 #blue 5 3 3 nil nil nil nil nil nil 5 1602 5 976 386 #red 1 3 5 nil nil nil nil nil nil nil nil 178 3 #Error 1202 1031 386 #firebrick 386 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1202 1029 nil 386 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 1202 1027 386 #darkGoldenrod 386 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 754 50 7 802 #createAt:extent: 50 2 482 1 255 482 701 247 976 802 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 976 nil 3 nil nil nil nil 2002 3 976 33 nil 3 67108863 nil nil 2002 5 976 nil nil 3 8 4261412864 nil nil 976 802 #tabWidth: 8 #(4) 976 802 #maxCompletionListHeight: 8 #(9) 976 802 #sciSetTechnology: 8 #(1) 976 802 #sciSetFontQuality: 8 #(3) 976 802 #sciSetSelectionLayer: 8 #(1) 976 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 127 0 0 0 94 1 0 0 250 0 0 0] 8 #() 944 nil 45 8 'source' nil 754 50 1 802 #createAt:extent: 50 2 482 6143 21 482 701 501 32 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 3 208 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2448 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2448 nil 1 #left nil nil nil 482 1 1 482 9 9 nil 2544 nil 754 50 1 802 #createAt:extent: 50 2 482 1 245 482 701 11 2448 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 122 0 0 0 94 1 0 0 127 0 0 0] 8 #() 944 nil 27 976 944 nil 27)! !
!Tools.AstPlugin class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

