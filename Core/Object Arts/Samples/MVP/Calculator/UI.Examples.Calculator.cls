"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.Calculator'
	instanceVariableNames: 'input output'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.Calculator guid: (Core.GUID fromString: '{816da2f6-de4a-41df-bea6-0a549e3a715e}')!
UI.Examples.Calculator comment: 'Calculator is a <topShell> sample application which illustrates the use of the Dolphin Compiler class in a runtime application. See the package comment for more details.'!
!UI.Examples.Calculator categoriesForClass!Samples! !
!UI.Examples.Calculator methodsFor!

clearTape
	"Clears the tape output window"

	output clear
!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	input := self add: TextPresenter new name: 'input'.
	output := self add: TextPresenter new name: 'output'.
!

displayIt
	"Evaluates the contents of the input field as a Smalltalk expression and displays
	the result in the output window"

	| answer |
	self print: input value trimBlanks.
	answer := self evaluateIt.
	self print: ' = ' , answer printString.
	self printNewline!

evaluateIt
	"Evaluates the contents of the input field as a Smalltalk expression and answers the result"

	| result |
	
	[[result := Compiler evaluate: input value] on: Compiler errorClass
		do: [:x | self print: ' (' , x description , ')']] 
			on: Error
			do: [:x | self print: ' (Error: ' , x description , ')'].
	input clear.
	^result!

print: aString 
	"Private - Prints aString to the output tape"

	| stream |
	stream := String new writeStream.
	stream
		nextPutAll: output value;
		nextPutAll: aString.
	output value: stream contents.
	output view lineScroll: output view lineCount!

printNewline
	self print: String lineDelimiter! !
!UI.Examples.Calculator categoriesForMethods!
clearTape!commands!public! !
createComponents!initializing!private! !
displayIt!commands!public! !
evaluateIt!commands!public! !
print:!helpers!private! !
printNewline!private! !
!

!UI.Examples.Calculator class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Smalltalk Calculator'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\x1D6D1 color: Color skyBlue)!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10618!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default 918022 #{Graphics.Point} 781 731 551 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 34 4 410 #{UI.MultilineTextEdit} 34 16 nil 416 34 2 8 1142952260 262145 592 nil 480 nil 7 nil nil nil 592 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 11 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 1 1 498 749 421 592 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 210 0 0 0] 8 #() 498 193 193 nil 27 141 410 #{UI.MultilineTextEdit} 34 16 nil 416 34 2 8 1140920580 1025 912 nil 480 nil 7 461638 4 #{UI.Menu} nil true 34 11 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #evaluateIt 8 'Evaluate it' 1 1 nil nil nil 1026 2097153 1058 #displayIt 8 'Display it' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 1026 1 1058 #undo 8 '&Undo' 1 1 nil nil nil 1154 4097 1026 1 1058 #cutSelection 8 'Cu&t' 1 1 nil nil nil 1026 1 1058 #copySelection 8 '&Copy' 1 1 nil nil nil 1026 1 1058 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 1026 1 1058 #clearSelection 8 'De&lete' 1 1 nil nil nil 1154 4097 1026 1 1058 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil nil nil 912 nil 8 1815092992 674 nil nil 9 706 34 2 754 #createAt:extent: 34 2 498 1 431 498 749 183 912 754 #contextMenu: 34 1 992 912 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 215 0 0 0 118 1 0 0 50 1 0 0] 8 #() 896 nil 27 61 true 170 192 34 4 592 8 'output' 912 8 'input' nil 658246 4 #{UI.MenuBar} nil true 34 2 978 nil true 34 6 1026 1 1058 #evaluateIt 8 'Evaluate it' 8331 1 nil nil nil 1026 1 1058 #displayIt 8 'Display it' 8329 1 nil nil nil 1154 4097 1026 1 1058 #clearTape 8 'Clear Tape' 1 1 nil nil nil 1968 1026 1 1058 #exit 8 'Exit' 1 1 nil nil nil 8 '&Calculator' nil 1 nil nil 47311 nil nil 978 nil true 34 8 1026 1 1058 #undo 8 '&Undo' 8373 1 nil nil nil 1154 4097 1026 1 1058 #cutSelection 8 'Cu&t' 8369 1 nil nil nil 1026 1 1058 #copySelection 8 '&Copy' 8327 1 nil nil nil 1026 1 1058 #pasteClipboard 8 '&Paste' 8365 1 nil nil nil 1026 1 1058 #clearSelection 8 'De&lete' 605 1 nil nil nil 1154 4097 1026 1 1058 #selectAll 8 '&Select All' 8323 1 nil nil nil 8 '&Edit' nil 1 nil nil 47325 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 706 34 2 754 #createAt:extent: 34 2 498 12287 21 498 781 731 416 754 #text: 34 1 8 'Smalltalk Calculator' 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 133 25 0 0 119 1 0 0] 34 3 592 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 2672 nil 480 nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2672 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 2768 nil 706 34 1 754 #createAt:extent: 34 2 498 1 421 498 749 11 2672 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 210 0 0 0 118 1 0 0 215 0 0 0] 8 #() 896 nil 27 912 896 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!UI.Examples.Calculator class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!examples!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

UI.Examples.Calculator class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

