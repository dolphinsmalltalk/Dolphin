"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #ItcFullTextSearchIndex
	instanceVariableNames: 'application'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcFullTextSearchIndex guid: (GUID fromString: '{23B699BB-EF56-49B6-B983-DFE67E6B9AF7}')!
ItcFullTextSearchIndex comment: ''!
!ItcFullTextSearchIndex categoriesForClass!Unclassified! !
!ItcFullTextSearchIndex methodsFor!

application: anObject 
	application := anObject!

concatenateAll: tokens 
	| str |
	str := nil.
	tokens do: [:each | str := str add: each withDelimiter: ' '].
	^str!

convertToSearchKey: aString 
	| temp rs ws ch wasSpace |
	temp := aString copy.
	1 to: temp size
		do: 
			[:i | 
			ch := temp at: i.
			"Windows encoding"
			ch = $š ifTrue: [temp at: i put: $s].
			ch = $Š ifTrue: [temp at: i put: $S].
			ch = $è ifTrue: [temp at: i put: $c].
			ch = $È ifTrue: [temp at: i put: $C].
			ch = $ž ifTrue: [temp at: i put: $z].
			ch = $Ž ifTrue: [temp at: i put: $Z].
			ch = $æ ifTrue: [temp at: i put: $c].
			ch = $Æ ifTrue: [temp at: i put: $C].
			ch = $Ð ifTrue: [temp at: i put: $D].
			ch = $ð ifTrue: [temp at: i put: $d].
			ch = $é ifTrue: [temp at: i put: $e].
			ch = $Ô ifTrue: [temp at: i put: $O].
			ch = $Á ifTrue: [temp at: i put: $A].
			ch = $ô ifTrue: [temp at: i put: $o].
			ch = $á ifTrue: [temp at: i put: $a].
			ch = $É ifTrue: [temp at: i put: $E].

			"ISO encoding"
			ch = $¹ ifTrue: [temp at: i put: $s].
			ch = $© ifTrue: [temp at: i put: $S].
			ch = $¾ ifTrue: [temp at: i put: $z].
			ch = $® ifTrue: [temp at: i put: $Z].

			"German keyboard"
			ch = $ä ifTrue: [temp at: i put: $a].
			ch = $ö ifTrue: [temp at: i put: $o].
			ch = $ü ifTrue: [temp at: i put: $u].
			ch = $ë ifTrue: [temp at: i put: $e].
			ch = $Ä ifTrue: [temp at: i put: $A].
			ch = $Ë ifTrue: [temp at: i put: $E].
			ch = $Ö ifTrue: [temp at: i put: $O].
			ch = $Ü ifTrue: [temp at: i put: $U]].
	wasSpace := false.
	rs := ReadStream on: temp.
	ws := WriteStream on: (String new: temp size + 20).
	[rs atEnd] whileFalse: 
			[ch := rs next asUppercase.
			('@0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-' includes: ch) 
				ifTrue: 
					[wasSpace := false.
					ch = $- ifFalse: [ws nextPut: ch]]
				ifFalse: 
					[wasSpace 
						ifFalse: 
							[wasSpace := true.
							ws nextPut: $ ]]].
	^ws contents!

divideSentences: aString 
	"Metoda razbije aString na posamezne stavke."

	| str ch tokens coll |
	str := aString copy.
	1 to: str size
		do: 
			[:i | 
			ch := str at: i.
			(ch = $. and: [i > 1]) 
				ifTrue: 
					["preveri ali so pred piko same stevilke, ker potem gre za npr. 47. clen"
					| j count |
					j := i - 1.
					count := 0.
					[j > 0 and: [(str at: j) isDigit]] whileTrue: 
							[count := count + 1.
							j := j - 1].
					"v tem primeru zbrisi piko"
					((j = 0 or: [(str at: j) isLetter not]) and: [count > 0]) ifTrue: [str at: i put: $ ]].
			(ch = $; or: [ch = $: or: [ch = $!! or: [ch = $? or: [ch = $( or: [ch = $)]]]]]) 
				ifTrue: [str at: i put: $.]].
	tokens := str itcSubStrings: $..
	coll := OrderedCollection new.
	1 to: tokens size
		do: 
			[:i | 
			str := (self convertToSearchKey: (tokens at: i)) trimBlanks.
			str isEmpty 
				ifFalse: 
					["ali vsebuje vec, kot eno besedo in ni prva beseda?"
					((str includes: $ ) or: [coll isEmpty]) 
						ifTrue: [coll add: str]
						ifFalse: 
							[str size > 1 
								ifTrue: [coll at: coll size put: coll last , ' ' , str]
								ifFalse: [coll at: coll size put: coll last , str]]]].
	^coll!

fullTextSearchKeySize
	^self class fullTextSearchKeySize!

getSearchTokens: text maxSize: maxSize 
	"Private - Vrne kolekcijo vseh kombinacij zaporednih besed za tekstualno indeksiranje.
	Kombinacije zaporednih besed so omejene z dolzino stringa maxSize."

	| tokens coll n j str next |
	tokens := (text itcSubStrings: $ ) select: [:each | each size > 1].
	n := tokens size.
	coll := OrderedCollection new: n.
	1 to: n
		do: 
			[:i | 
			j := i.
			str := tokens at: j.
			[j < n and: 
					[j := j + 1.
					next := tokens at: j.
					next size + str size < maxSize]] 
				whileTrue: [str := str , ' ' , next].
			coll add: str].
	^coll!

getSearchTokensForSearch: text maxSize: maxSize 
	"Private - Vrne kolekcijo vseh kombinacij zaporednih besed za tekstualno indeksiranje.
	Kombinacije zaporednih besed so omejene z dolzino stringa maxSize.
	Vrne kolekcijo kolekcij, kjer vsebovane kolekcije vsebujejo besede po katerih se isce paralelno."

	| tokens coll |
	tokens := (text itcSubStrings: $ ) select: [:each | each size > 1].
	tokens isNilOrEmpty ifTrue: [^nil].
	coll := OrderedCollection new.
	0 to: tokens size do: [:i | coll addAll: (self getTokensCombinations: i tokens: tokens)].
	^coll!

getTokensCombinations: i tokens: tokens 
	| coll str |
	i = 0 ifTrue: [^Array with: (Array with: (self concatenateAll: tokens))].
	coll := OrderedCollection new.
	1 to: tokens size - i
		do: 
			[:j | 
			str := self concatenateAll: (tokens copyFrom: 1 to: j).
			(self getTokensCombinations: i - 1 tokens: (tokens copyFrom: j + 1 to: tokens size)) 
				do: [:each | coll add: (Array with: str) , each]].
	^coll!

indicesForConvertToSearchKey: aString 
	| temp rs ws ch wasSpace indices index |
	indices := OrderedCollection new: aString size.
	temp := aString copy.
	1 to: temp size
		do: 
			[:i | 
			ch := temp at: i.
			"Windows encoding"
			ch = $š ifTrue: [temp at: i put: $s].
			ch = $Š ifTrue: [temp at: i put: $S].
			ch = $è ifTrue: [temp at: i put: $c].
			ch = $È ifTrue: [temp at: i put: $C].
			ch = $ž ifTrue: [temp at: i put: $z].
			ch = $Ž ifTrue: [temp at: i put: $Z].
			ch = $æ ifTrue: [temp at: i put: $c].
			ch = $Æ ifTrue: [temp at: i put: $C].
			ch = $Ð ifTrue: [temp at: i put: $D].
			ch = $ð ifTrue: [temp at: i put: $d].
			ch = $é ifTrue: [temp at: i put: $e].
			ch = $Ô ifTrue: [temp at: i put: $O].
			ch = $Á ifTrue: [temp at: i put: $A].
			ch = $ô ifTrue: [temp at: i put: $o].
			ch = $á ifTrue: [temp at: i put: $a].
			ch = $É ifTrue: [temp at: i put: $E].

			"ISO encoding"
			ch = $¹ ifTrue: [temp at: i put: $s].
			ch = $© ifTrue: [temp at: i put: $S].
			ch = $¾ ifTrue: [temp at: i put: $z].
			ch = $® ifTrue: [temp at: i put: $Z].

			"German keyboard"
			ch = $ä ifTrue: [temp at: i put: $a].
			ch = $ö ifTrue: [temp at: i put: $o].
			ch = $ü ifTrue: [temp at: i put: $u].
			ch = $ë ifTrue: [temp at: i put: $e].
			ch = $Ä ifTrue: [temp at: i put: $A].
			ch = $Ë ifTrue: [temp at: i put: $E].
			ch = $Ö ifTrue: [temp at: i put: $O].
			ch = $Ü ifTrue: [temp at: i put: $U]].
	wasSpace := false.
	rs := ReadStream on: temp.
	ws := WriteStream on: (String new: temp size + 20).
	index := 1.
	[rs atEnd] whileFalse: 
			[ch := rs next asUppercase.
			('@0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-' includes: ch) 
				ifTrue: 
					[wasSpace := false.
					ch = $- 
						ifFalse: 
							[indices add: index.
							ws nextPut: ch]]
				ifFalse: 
					[wasSpace 
						ifFalse: 
							[wasSpace := true.
							indices add: index.
							ws nextPut: $ ]].
			index := index + 1].
	^indices!

maxKeyFor: aString 
	| k |
	k := ByteArray new: self fullTextSearchKeySize + 9.
	k atAllPut: 255.
	k 
		replaceFrom: 1
		to: aString size
		with: aString
		startingAt: 1.
	^k! !
!ItcFullTextSearchIndex categoriesFor: #application:!public! !
!ItcFullTextSearchIndex categoriesFor: #concatenateAll:!private! !
!ItcFullTextSearchIndex categoriesFor: #convertToSearchKey:!private! !
!ItcFullTextSearchIndex categoriesFor: #divideSentences:!private! !
!ItcFullTextSearchIndex categoriesFor: #fullTextSearchKeySize!public! !
!ItcFullTextSearchIndex categoriesFor: #getSearchTokens:maxSize:!private! !
!ItcFullTextSearchIndex categoriesFor: #getSearchTokensForSearch:maxSize:!private! !
!ItcFullTextSearchIndex categoriesFor: #getTokensCombinations:tokens:!private! !
!ItcFullTextSearchIndex categoriesFor: #indicesForConvertToSearchKey:!private! !
!ItcFullTextSearchIndex categoriesFor: #maxKeyFor:!private! !

!ItcFullTextSearchIndex class methodsFor!

fullTextSearchKeySize
	^40! !
!ItcFullTextSearchIndex class categoriesFor: #fullTextSearchKeySize!public! !

