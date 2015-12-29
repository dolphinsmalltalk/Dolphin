"Filed out from Dolphin Smalltalk X6"!

Object subclass: #NewsArchiveArticle
	instanceVariableNames: 'raw from sent subject text conversation isSelected'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NewsArchiveArticle guid: (GUID fromString: '{B6303E05-40AB-42A7-B928-F3B76D433FE4}')!
NewsArchiveArticle comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!NewsArchiveArticle categoriesForClass!IDB Goodies! !
!NewsArchiveArticle methodsFor!

conversation
	self isParsed ifFalse: [self parse].
	^conversation!

copyTo: aStream 
	aStream
		nextPutAll: '~-~-~-~-~-~';
		cr;
		nextPutAll: 'From: ';
		nextPutAll: self from;
		cr;
		nextPutAll: 'Sent: ';
		print: self sent;
		cr;
		nextPutAll: 'Subject: ';
		nextPutAll: self subject;
		cr;
		cr;
		nextPutAll: self text;
		cr!

forString: aString 
	raw := aString.
	isSelected := false!

from
	self isParsed ifFalse: [self parse].
	^from!

getHeadingFrom: aString 
	"Parse the header information
	Note: written for speed - not peer review"

	| type |
	type := aString copyFrom: 1 to: 4.
	type = 'From' ifTrue: [^self setFrom: aString].
	type = 'Sent' ifTrue: [^self setSent: aString].
	type = 'Subj' ifTrue: [^self setSubject: aString	"ignore any others"]!

icon
	"Answer self as the ListView will then send #imageIndex to this instance
	 and we can answer the appropriate icon index"

	^self!

imageIndex
	"see #icon"

	^isSelected ifTrue: [Model icon imageIndex] ifFalse: [0]!

isInConversation: aNewsArchiveArticle 
	self isParsed ifFalse: [self parse].
	^conversation = aNewsArchiveArticle conversation!

isParsed
	^raw isNil!

isSelected
	^isSelected!

parse
	"Strip and parse any header lines from the article. Whats left is the text
	Note: written for speed - not peer review"

	| begin end line |
	subject := 'No subject'.
	begin := 1.
	
	[line := raw copyFrom: begin
				to: (end := raw indexOfSubCollection: String lineDelimiter startingAt: begin) - 1.
	begin := end + String lineDelimiter size.
	line notEmpty] 
			whileTrue: [self getHeadingFrom: line].
	text := raw copyFrom: begin to: raw size.
	self assert: [from notNil & sent notNil & subject notNil].
	raw := nil!

searchFromFor: aString 
	self isParsed ifFalse: [self parse].
	^(from asLowercase indexOfSubCollection: aString) ~= 0!

searchSubjectFor: aString 
	self isParsed ifFalse: [self parse].
	^(subject asLowercase indexOfSubCollection: aString) ~= 0!

searchTextFor: aString 
	self isParsed ifFalse: [self parse].
	^(text asLowercase indexOfSubCollection: aString) ~= 0!

select
	isSelected := true!

sent
	self isParsed ifFalse: [self parse].
	^sent!

setFrom: aString 
	from := aString copyFrom: 8!

setSent: aString 
	"aString is always in the format
		dd MMM yyyy hh:mm
	and uses English month names -  thats the format used when I create the archive. 
	The users locale might be different  so we can't use built in functions. 
	Note: written for speed - not peer review 
	No error checking!!
	** This is a bottleneck so edit with caution **"

	| dayOfMonth m1 monthIndex yearStart year hour minute |
	dayOfMonth := ((aString at: 8) asciiValue - 48) * 10 + (aString at: 9) asciiValue - 48.
	m1 := aString at: 11.
	monthIndex := m1 = $J 
				ifTrue: 
					[| m4 |
					(m4 := aString at: 14) = $u ifTrue: [1] ifFalse: [m4 = $e ifTrue: [6] ifFalse: [7]]]
				ifFalse: 
					[m1 = $M 
						ifTrue: [(aString at: 13) = $r ifTrue: [3] ifFalse: [5]]
						ifFalse: 
							[m1 = $A 
								ifTrue: [(aString at: 12) = $p ifTrue: [4] ifFalse: [8]]
								ifFalse: 
									[m1 = $F 
										ifTrue: [2]
										ifFalse: 
											[m1 = $S ifTrue: [9] ifFalse: [m1 = $O ifTrue: [10] ifFalse: [m1 = $N ifTrue: [11] ifFalse: [12]]]]]]].
	yearStart := (#[7 8 5 5 3 4 4 6 9 7 8 8] at: monthIndex) + 11 + 1.
	year := ((aString at: yearStart) asciiValue - 48) * 1000 
				+ (((aString at: yearStart + 1) asciiValue - 48) * 100) 
					+ (((aString at: yearStart + 2) asciiValue - 48) * 10) + (aString at: yearStart + 3) asciiValue 
				- 48.
	hour := ((aString at: yearStart + 5) asciiValue - 48) * 10 + (aString at: yearStart + 6) asciiValue 
				- 48.
	minute := ((aString at: yearStart + 8) asciiValue - 48) * 10 
				+ (aString at: yearStart + 9) asciiValue - 48.
	sent := TimeStamp date: (Date 
						newDay: dayOfMonth
						monthIndex: monthIndex
						year: year)
				time: (Time fromSeconds: hour * 3600 + (minute * 60))!

setSubject: aString 
	subject := aString copyFrom: 11.
	conversation := (subject size > 4 and: [subject beginsWith: 'Re: ']) 
				ifTrue: [(subject copyFrom: 5) trimBlanks]
				ifFalse: [subject trimBlanks]!

subject
	self isParsed ifFalse: [self parse].
	^subject!

text
	self isParsed ifFalse: [self parse].
	^text!

toggleSelection
	isSelected := isSelected not!

unSelect
	isSelected := false! !
!NewsArchiveArticle categoriesFor: #conversation!accessing!public! !
!NewsArchiveArticle categoriesFor: #copyTo:!operations!public! !
!NewsArchiveArticle categoriesFor: #forString:!initializing!public! !
!NewsArchiveArticle categoriesFor: #from!accessing!public! !
!NewsArchiveArticle categoriesFor: #getHeadingFrom:!helpers!public! !
!NewsArchiveArticle categoriesFor: #icon!accessing!public! !
!NewsArchiveArticle categoriesFor: #imageIndex!accessing!public! !
!NewsArchiveArticle categoriesFor: #isInConversation:!public!testing! !
!NewsArchiveArticle categoriesFor: #isParsed!public!testing! !
!NewsArchiveArticle categoriesFor: #isSelected!public!testing! !
!NewsArchiveArticle categoriesFor: #parse!initializing!public! !
!NewsArchiveArticle categoriesFor: #searchFromFor:!operations!public! !
!NewsArchiveArticle categoriesFor: #searchSubjectFor:!operations!public! !
!NewsArchiveArticle categoriesFor: #searchTextFor:!operations!public! !
!NewsArchiveArticle categoriesFor: #select!operations!public! !
!NewsArchiveArticle categoriesFor: #sent!accessing!public! !
!NewsArchiveArticle categoriesFor: #setFrom:!initializing!public! !
!NewsArchiveArticle categoriesFor: #setSent:!initializing!public! !
!NewsArchiveArticle categoriesFor: #setSubject:!initializing!public! !
!NewsArchiveArticle categoriesFor: #subject!accessing!public! !
!NewsArchiveArticle categoriesFor: #text!accessing!public! !
!NewsArchiveArticle categoriesFor: #toggleSelection!operations!public! !
!NewsArchiveArticle categoriesFor: #unSelect!operations!public! !

!NewsArchiveArticle class methodsFor!

forString: aString 
	^self new forString: aString! !
!NewsArchiveArticle class categoriesFor: #forString:!instance creation!public! !

