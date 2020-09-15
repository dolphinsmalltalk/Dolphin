"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #ScintillaMarker
	instanceVariableNames: 'view definition line handle'
	classVariableNames: ''
	imports: #(#{ScintillaConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
ScintillaMarker guid: (Core.GUID fromString: '{2aad3a52-111c-4781-b79b-22f044e4a6f7}')!
ScintillaMarker comment: 'ScintillaMarkers represent the visible ''markers'' displayed in the margins of <ScintillaView>s.

Instance Variables:
	view		<ScintillaView>. View in which currently installed, or nil if inactive.
	definition		<ScintillaMarkerDefinition>. "Type" of this marker (defines glyph, etc).
	line		<integer>. Line number on which the marker is displayed.
	handle		<integer>. Handle allocated by Scintilla to uniquely identify the marker.

'!
!ScintillaMarker categoriesForClass!MVP-Views-Support! !
!ScintillaMarker methodsFor!

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
!ScintillaMarker categoriesFor: #addToView:!helpers!public! !
!ScintillaMarker categoriesFor: #cacheCurrentLine!accessing!public! !
!ScintillaMarker categoriesFor: #currentLine!accessing!public! !
!ScintillaMarker categoriesFor: #currentPosition!accessing!public! !
!ScintillaMarker categoriesFor: #currentRange!accessing!public! !
!ScintillaMarker categoriesFor: #definition!helpers!public! !
!ScintillaMarker categoriesFor: #handle!accessing!private! !
!ScintillaMarker categoriesFor: #line!accessing!public! !
!ScintillaMarker categoriesFor: #removedFromView!private!removing! !
!ScintillaMarker categoriesFor: #removeFromView!public!removing! !
!ScintillaMarker categoriesFor: #setDefinition:line:!initializing!private! !
!ScintillaMarker categoriesFor: #type!accessing!public! !
!ScintillaMarker categoriesFor: #view!accessing!private! !
!ScintillaMarker categoriesFor: #view:!accessing!private! !

!ScintillaMarker class methodsFor!

definition: aScintillaMarkerDefinition line: anInteger 
	^(self new)
		setDefinition: aScintillaMarkerDefinition line: anInteger;
		yourself!

icon
	^ScintillaView icon! !
!ScintillaMarker class categoriesFor: #definition:line:!instance creation!public! !
!ScintillaMarker class categoriesFor: #icon!constants!development!public! !

