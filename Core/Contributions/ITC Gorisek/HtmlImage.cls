"Filed out from Dolphin Smalltalk X6.1"!

HtmlElement subclass: #HtmlImage
	instanceVariableNames: 'name width height link tooltip'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlImage guid: (GUID fromString: '{8BF6A226-AA5B-4885-AB90-880E47B7231E}')!
HtmlImage comment: ''!
!HtmlImage categoriesForClass!Unclassified! !
!HtmlImage methodsFor!

generateOn: aStream 
	link notNil ifTrue: [aStream nextPutAll: '<a href="' , link , '">'].
	aStream
		nextPutAll: '<img border="0" src="';
		nextPutAll: name.
	width isNumber 
		ifTrue: 
			[aStream
				nextPutAll: '" width="';
				nextPutAll: width printString].
	height isNumber 
		ifTrue: 
			[aStream
				nextPutAll: '" height="';
				nextPutAll: height printString].
	aStream nextPutAll: '" alt="'.
	tooltip isNilOrEmpty 
		ifFalse: 
			[aStream
				nextPutAll: tooltip;
				nextPutAll: '" title="';
				nextPutAll: tooltip].
	aStream nextPutAll: '"/>'.
	link notNil ifTrue: [aStream nextPutAll: '</a>']!

height: anInteger 
	height := anInteger!

link: anURL 
	link := anURL!

name: aString 
	name := aString!

tooltip: aString 
	tooltip := aString!

width: anInteger 
	width := anInteger! !
!HtmlImage categoriesFor: #generateOn:!public! !
!HtmlImage categoriesFor: #height:!public! !
!HtmlImage categoriesFor: #link:!public! !
!HtmlImage categoriesFor: #name:!public! !
!HtmlImage categoriesFor: #tooltip:!public! !
!HtmlImage categoriesFor: #width:!public! !

!HtmlImage class methodsFor!

name: aString

	^self new name: aString!

width: width height: height name: aString

	^self new width: width; height: height; name: aString!

width: width name: aString

	^self new width: width; name: aString! !
!HtmlImage class categoriesFor: #name:!public! !
!HtmlImage class categoriesFor: #width:height:name:!public! !
!HtmlImage class categoriesFor: #width:name:!public! !

