"Filed out from Dolphin Smalltalk X6.1"!

HtmlContainer subclass: #HtmlTableCell
	instanceVariableNames: 'width height alignment verticalAlignment colSpan bgPicture style noWrap borderTop borderBottom borderLeft borderRight id onClick borderColor cellType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlTableCell guid: (GUID fromString: '{6ACD7CF2-3BD9-48AE-9013-C5735FD866F5}')!
HtmlTableCell comment: ''!
!HtmlTableCell categoriesForClass!Unclassified! !
!HtmlTableCell methodsFor!

alignment
	^alignment!

alignment: aStringOrSymbol 
	alignment := aStringOrSymbol asString!

bgPicture: aPictureFileName 
	bgPicture := aPictureFileName!

borderBottom
	^borderBottom!

borderBottom: anInteger 
	borderBottom := anInteger!

borderColor: aString 
	borderColor := aString!

borderLeft
	^borderLeft!

borderLeft: anInteger 
	borderLeft := anInteger!

borderRight
	^borderRight!

borderRight: anInteger 
	borderRight := anInteger!

borderTop
	^borderTop!

borderTop: anInteger 
	borderTop := anInteger!

cellType
	^cellType!

cellType: aSymbol 
	cellType := aSymbol!

colSpan
	^colSpan!

colSpan: anInteger 
	colSpan := anInteger!

defaultBackground: aColor 
	"Set background only if not already set."

	background isNil ifTrue: [background := aColor]!

generateOn: aStream 
	aStream nextPutAll: '<td'.
	id isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' id="';
				nextPutAll: id;
				nextPut: $"].
	cssClass isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' class="';
				nextPutAll: self cssClass;
				nextPut: $"].
	onClick isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onclick="';
				nextPutAll: onClick;
				nextPut: $"].
	borderTop isNil 
		ifFalse: 
			[style := style 
						add: 'border-top:' , (borderColor isNil ifTrue: ['black'] ifFalse: [borderColor]) , ' 0.5pt solid'
						withDelimiter: ';'].
	borderLeft isNil 
		ifFalse: 
			[style := style 
						add: 'border-left:' , (borderColor isNil ifTrue: ['black'] ifFalse: [borderColor]) , ' 0.5pt solid'
						withDelimiter: ';'].
	borderRight isNil 
		ifFalse: 
			[style := style 
						add: 'border-right:' , (borderColor isNil ifTrue: ['black'] ifFalse: [borderColor]) , ' 0.5pt solid'
						withDelimiter: ';'].
	borderBottom isNil 
		ifFalse: 
			[style := style 
						add: 'border-bottom:' , (borderColor isNil ifTrue: ['black'] ifFalse: [borderColor]) 
								, ' 0.5pt solid'
						withDelimiter: ';'].
	style isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: style;
				nextPut: $"].
	width isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' width="';
				nextPutAll: width;
				nextPut: $"].
	height isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' height="';
				nextPutAll: height;
				nextPut: $"].
	colSpan isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' colspan="';
				nextPutAll: colSpan printString;
				nextPut: $"].
	alignment isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' align="';
				nextPutAll: alignment;
				nextPut: $"].
	verticalAlignment isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' valign="';
				nextPutAll: verticalAlignment;
				nextPut: $"].
	background isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' bgcolor="';
				nextPutAll: background;
				nextPut: $"].
	bgPicture isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' background="';
				nextPutAll: bgPicture;
				nextPut: $"].
	noWrap = true ifTrue: [aStream nextPutAll: ' nowrap="nowrap"'].
	aStream nextPut: $>.
	contents isNil ifFalse: [contents do: [:each | each generateOn: aStream]].
	aStream nextPutAll: '</td>'!

height: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [height := aStringOrNumber printString]
		ifTrue: [height := aStringOrNumber]!

id
	^id!

id: aString 
	id := aString!

noWrap
	noWrap := true!

onClick: aString 
	onClick := aString!

style
	^style!

style: aString 
	style := aString!

verticalAlignment
	^verticalAlignment!

verticalAlignment: aStringOrSymbol 
	verticalAlignment := aStringOrSymbol asString!

width
	^width!

width: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [width := aStringOrNumber printString]
		ifTrue: [width := aStringOrNumber]!

widthPc
	(width isNilOrEmpty or: [width last ~= $%]) ifTrue: [^nil].
	^width copyFrom: 1 to: width size - 1! !
!HtmlTableCell categoriesFor: #alignment!public! !
!HtmlTableCell categoriesFor: #alignment:!public! !
!HtmlTableCell categoriesFor: #bgPicture:!public! !
!HtmlTableCell categoriesFor: #borderBottom!public! !
!HtmlTableCell categoriesFor: #borderBottom:!public! !
!HtmlTableCell categoriesFor: #borderColor:!public! !
!HtmlTableCell categoriesFor: #borderLeft!public! !
!HtmlTableCell categoriesFor: #borderLeft:!public! !
!HtmlTableCell categoriesFor: #borderRight!public! !
!HtmlTableCell categoriesFor: #borderRight:!public! !
!HtmlTableCell categoriesFor: #borderTop!public! !
!HtmlTableCell categoriesFor: #borderTop:!public! !
!HtmlTableCell categoriesFor: #cellType!public! !
!HtmlTableCell categoriesFor: #cellType:!public! !
!HtmlTableCell categoriesFor: #colSpan!public! !
!HtmlTableCell categoriesFor: #colSpan:!public! !
!HtmlTableCell categoriesFor: #defaultBackground:!public! !
!HtmlTableCell categoriesFor: #generateOn:!public! !
!HtmlTableCell categoriesFor: #height:!public! !
!HtmlTableCell categoriesFor: #id!public! !
!HtmlTableCell categoriesFor: #id:!public! !
!HtmlTableCell categoriesFor: #noWrap!public! !
!HtmlTableCell categoriesFor: #onClick:!public! !
!HtmlTableCell categoriesFor: #style!public! !
!HtmlTableCell categoriesFor: #style:!public! !
!HtmlTableCell categoriesFor: #verticalAlignment!public! !
!HtmlTableCell categoriesFor: #verticalAlignment:!public! !
!HtmlTableCell categoriesFor: #width!public! !
!HtmlTableCell categoriesFor: #width:!public! !
!HtmlTableCell categoriesFor: #widthPc!public! !

