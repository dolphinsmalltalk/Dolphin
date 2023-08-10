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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 781 731 519 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 2 18 #{UI.MultilineTextEdit} 50 20 nil 32 50 2 8 1140920580 1025 224 nil 112 nil 7 2886 4 #{UI.Menu} nil true 50 11 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #evaluateIt 8 'Evaluate it' 1 1 nil nil nil 338 2097153 370 #displayIt 8 'Display it' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 338 1 370 #undo 8 '&Undo' 1 1 nil nil nil 466 4097 338 1 370 #cutSelection 8 'Cu&t' 1 1 nil nil nil 338 1 370 #copySelection 8 '&Copy' 1 1 nil nil nil 338 1 370 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 338 1 370 #clearSelection 8 'De&lete' 1 1 nil nil nil 466 4097 338 1 370 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil nil nil 224 nil 8 1853175488 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 1 431 130 749 183 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 215 0 0 0 118 1 0 0 50 1 0 0] 8 #() 130 193 193 nil 45 61 18 #{UI.MultilineTextEdit} 50 20 nil 32 50 2 8 1142952260 262145 1088 nil 112 nil 7 nil nil nil 1088 nil 8 1853175488 850 nil nil 11 #focusLost nil nil nil 882 50 1 930 #createAt:extent: 50 2 130 1 1 130 749 421 1088 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 210 0 0 0] 8 #() 1072 nil 45 141 true 550 #{Core.IdentityDictionary} 2 224 8 'input' 1088 8 'output' nil 2886 4 #{UI.MenuBar} nil true 50 2 290 nil true 50 6 338 1 370 #evaluateIt 8 'Evaluate it' 8331 1 nil nil nil 338 1 370 #displayIt 8 'Display it' 8329 1 nil nil nil 466 4097 338 1 370 #clearTape 8 'Clear Tape' 1 1 nil nil nil 1568 338 1 370 #exit 8 'Exit' 1 1 nil nil nil 8 '&Calculator' nil 1 nil nil 47093 nil nil 290 nil true 50 8 338 1 370 #undo 8 '&Undo' 8373 1 nil nil nil 466 4097 338 1 370 #cutSelection 8 'Cu&t' 8369 1 nil nil nil 338 1 370 #copySelection 8 '&Copy' 8327 1 nil nil nil 338 1 370 #pasteClipboard 8 '&Paste' 8365 1 nil nil nil 338 1 370 #clearSelection 8 'De&lete' 605 1 nil nil nil 466 4097 338 1 370 #selectAll 8 '&Select All' 8323 1 nil nil nil 8 '&Edit' nil 1 nil nil 47107 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 50 2 930 #createAt:extent: 50 2 130 6143 21 130 781 731 32 930 #text: 50 1 8 'Smalltalk Calculator' 32 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 119 1 0 0] 50 3 1088 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2272 nil 112 nil 519 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2272 nil 1 #left nil nil nil 130 1 1 130 9 9 nil 2368 nil 882 50 1 930 #createAt:extent: 50 2 130 1 421 130 749 11 2272 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 210 0 0 0 118 1 0 0 215 0 0 0] 8 #() 1072 nil 27 224 1072 nil 27)!

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

