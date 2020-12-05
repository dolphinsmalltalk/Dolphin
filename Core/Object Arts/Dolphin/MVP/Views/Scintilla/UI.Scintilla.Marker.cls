"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.Scintilla.Marker'
	instanceVariableNames: 'view definition line handle'
	classVariableNames: ''
	imports: #(#{UI.Scintilla.ScintillaConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Marker guid: (Core.GUID fromString: '{2aad3a52-111c-4781-b79b-22f044e4a6f7}')!
UI.Scintilla.Marker comment: 'ScintillaMarkers represent the visible ''markers'' displayed in the margins of <ScintillaView>s.

Instance Variables:
	view		<ScintillaView>. View in which currently installed, or nil if inactive.
	definition		<ScintillaMarkerDefinition>. "Type" of this marker (defines glyph, etc).
	line		<integer>. Line number on which the marker is displayed.
	handle		<integer>. Handle allocated by Scintilla to uniquely identify the marker.

'!
!UI.Scintilla.Marker categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.Marker methodsFor!

addToView: aScintillaView 
	"Add this marker to the view at its currently recorded line"

	view := aScintillaView.
	handle := view 
				sendMessage: SCI_MARKERADD
				wParam: line - 1
				lParam: self definition id!

cacheCurrentLine
	"Set the line number stored in the receiver to the current line of the associated marker."

	line := self currentLine!

currentLine
	"Answer the one-based <integer> line number with which this marker is currently associated
	(the marker may have moved if the text has been edited such that lines have been shuffled)."

	^view isNil 
		ifTrue: [line]
		ifFalse: [(view sendMessage: SCI_MARKERLINEFROMHANDLE wParam: handle) + 1]!

currentPosition
	"Answer the one-based <integer> character position of the start of the line on with which this
	marker is currently associated."

	^view positionAtLine: self currentLine!

currentRange
	"Answer the <Interval> of source positions occupied by the line currently marked
	by the receiver."

	^view lineRange: self currentLine!

definition
	^definition!

handle
	^handle!

line
	"Answer the one-based <integer> line number with which this marker was originally associated.
	Note that the marker may have moved if the text has been edited causing lines to be shuffled."

	^line!

removedFromView
	view := handle := nil!

removeFromView
	view isNil ifFalse: [view removeMarker: self]!

setDefinition: aScintillaMarkerDefinition line: anInteger 
	definition := aScintillaMarkerDefinition.
	line := anInteger.
	handle := nil!

type
	^definition name!

view
	^view!

view: anObject
	view := anObject! !
!UI.Scintilla.Marker categoriesFor: #addToView:!helpers!public! !
!UI.Scintilla.Marker categoriesFor: #cacheCurrentLine!accessing!public! !
!UI.Scintilla.Marker categoriesFor: #currentLine!accessing!public! !
!UI.Scintilla.Marker categoriesFor: #currentPosition!accessing!public! !
!UI.Scintilla.Marker categoriesFor: #currentRange!accessing!public! !
!UI.Scintilla.Marker categoriesFor: #definition!helpers!public! !
!UI.Scintilla.Marker categoriesFor: #handle!accessing!private! !
!UI.Scintilla.Marker categoriesFor: #line!accessing!public! !
!UI.Scintilla.Marker categoriesFor: #removedFromView!private!removing! !
!UI.Scintilla.Marker categoriesFor: #removeFromView!public!removing! !
!UI.Scintilla.Marker categoriesFor: #setDefinition:line:!initializing!private! !
!UI.Scintilla.Marker categoriesFor: #type!accessing!public! !
!UI.Scintilla.Marker categoriesFor: #view!accessing!private! !
!UI.Scintilla.Marker categoriesFor: #view:!accessing!private! !

!UI.Scintilla.Marker class methodsFor!

definition: aScintillaMarkerDefinition line: anInteger 
	^(self new)
		setDefinition: aScintillaMarkerDefinition line: anInteger;
		yourself!

icon
	^ScintillaView icon! !
!UI.Scintilla.Marker class categoriesFor: #definition:line:!instance creation!public! !
!UI.Scintilla.Marker class categoriesFor: #icon!constants!development!public! !

