"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #CharacterANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CharacterANSITest guid: (GUID fromString: '{bcaf0373-66ad-4e56-9524-56cd4a84e468}')!
CharacterANSITest comment: ''!
!CharacterANSITest categoriesForClass!Unclassified! !
!CharacterANSITest methodsFor!

canonicalObject
	^ Character space!

protocol
^#Character!

testXasLowercase
	" <Character>#asLowercase "
	#'Fundamental'.
"	If the receiver is equal to the value of a character literal in the receiver row of the following table, the result object must be equal to the value of the corresponding character literal in the result row.

	receiver	$A - $Z
	result		$a - $z

	An implemention may define other #asLowercase mappings.  If the receiver does not correspond to a character in the receiver row of the table and does not have an implementation defined mapping the receiver is returned as the result.
"
	self selector: #'asLowercase' inProtocol: #'Character' 
		behavesLike: #( #($A $a) #($b $b) #($1 $1) #($: $:) )!

testXasString
	" <Character>#asString "
	#'Fundamental'.
	self selector: #'asString' inProtocol: #'Character' 
		behavesLike: #( #($A 'A') #($B 'B') #($a 'a') #($1 '1') #($: ':') )!

testXasUppercase
	" <Character>#asUppercase "
	#'Fundamental'.
"	If the receiver is equal to the value of a character literal in the receiver row of the following table, the result object must be equal to the value of the corresponding character literal in the result row.

	receiver	$a - $z
	result		$A - $Z

	An implemention may define other #asUppercase mappings.  If the receiver does not correspond to a character in the receiver row of the table and does not have an implementation defined mapping the receiver is returned as the result.
"
	self selector: #'asUppercase' inProtocol: #'Character' 
		behavesLike: #( #($a $A) #($B $B) #($1 $1) #($: $:) )!

testXcodePoint
	" <Character>#codePoint "
	#'Fundamental'.
"	The following invariant must hold:

	(charFactory codePoint: x) codePoint = x

where charFactory is an object that implements <Character factory> and x is an <integer>.
"
	self value: [$a codePoint]
		should: [:r | (Character codePoint: r) codePoint = r]
		conformTo: #'Character' selector: #'codePoint'.!

testXisAlphaNumeric
	" <Character>#isAlphaNumeric "
	#'Fundamental'.
"	Return true if the receiver is either a letter or digit.  Otherwise return false.  In other words character isAlphaNumeric is true if and only if either character isLetter is true or character isDigit is true.
"
	self value: [$A isAlphaNumeric] should: [:r | r & ($A isLetter | $A isDigit)]
		conformTo: #'Character' selector: #'isAlphaNumeric'.
	self value: [$B isAlphaNumeric] should: [:r | r & ($B isLetter | $B isDigit)]
		conformTo: #'Character' selector: #'isAlphaNumeric'.
	self value: [$a isAlphaNumeric] should: [:r | r & ($a isLetter | $a isDigit)]
		conformTo: #'Character' selector: #'isAlphaNumeric'.
	self value: [$1 isAlphaNumeric] should: [:r | r & ($1 isLetter | $1 isDigit)]
		conformTo: #'Character' selector: #'isAlphaNumeric'.

	self value: [$: isAlphaNumeric] shouldnt: [:r | r & ($: isLetter | $: isDigit)]
		conformTo: #'Character' selector: #'isAlphaNumeric'.!

testXisDigit
	" <Character>#isDigit "
	#'Fundamental'.

	self 
		selector: #isDigit 
		inProtocol: #Character 
		behavesLike: #(#($1 true) #($A false) #($B false) #($b false) #($: false)).!

testXisLetter
	" <Character>#isLetter "
	| alphaChars |
	#'Fundamental'.
	alphaChars := #( $A $B $C $D $E $F $G $H $I $J $K $L $M
					$N $O $P $Q $R $S $T $U $V $W $X $Y $Z
					$a $b $c $d $e $f $g $h $i $j $k $l $m
					$n $o $p $q $r $s $t $u $v $w $x $y $z ).

	self value: [$A isLetter] should: [:r | r & (alphaChars includes: $A)]
		conformTo: #'Character' selector: #'isLetter'.
	self value: [$B isLetter] should: [:r | r & (alphaChars includes: $B)]
		conformTo: #'Character' selector: #'isLetter'.
	self value: [$a isLetter] should: [:r | r & (alphaChars includes: $a)]
		conformTo: #'Character' selector: #'isLetter'.

	self value: [$1 isLetter] shouldnt: [:r | r & (alphaChars includes: $1)]
		conformTo: #'Character' selector: #'isLetter'.
	self value: [$: isLetter] shouldnt: [:r | r & (alphaChars includes: $:)]
		conformTo: #'Character' selector: #'isLetter'.!

testXisLowercase
	" <Character>#isLowercase "
	| lowerChars |
	#'Fundamental'.
	lowerChars := #( $a $b $c $d $e $f $g $h $i $j $k $l $m
					$n $o $p $q $r $s $t $u $v $w $x $y $z ).

	self value: [$a isLowercase]
		should: [:r | r & (lowerChars includes: $a)]
		conformTo: #'Character' selector: #'isLowercase'.

	self value: [$A isLowercase]
		shouldnt: [:r | r & (lowerChars includes: $A)]
		conformTo: #'Character' selector: #'isLowercase'.
	self value: [$B isLowercase]
		shouldnt: [:r | r & (lowerChars includes: $B)]
		conformTo: #'Character' selector: #'isLowercase'.
	self value: [$1 isLowercase]
		shouldnt: [:r | r & (lowerChars includes: $1)]
		conformTo: #'Character' selector: #'isLowercase'.
	self value: [$: isLowercase]
		shouldnt: [:r | r & (lowerChars includes: $:)]
		conformTo: #'Character' selector: #'isLowercase'.!

testXisUppercase
	" <Character>#isUppercase "
	| upperChars |
	#'Fundamental'.
	upperChars := #( $A $B $C $D $E $F $G $H $I $J $K $L $M
					$N $O $P $Q $R $S $T $U $V $W $X $Y $Z ).

	self value: [$A isUppercase]
		should: [:r | r & (upperChars includes: $A)]
		conformTo: #'Character' selector: #'isUppercase'.
	self value: [$B isUppercase]
		should: [:r | r & (upperChars includes: $B)]
		conformTo: #'Character' selector: #'isUppercase'.

	self value: [$a isUppercase]
		shouldnt: [:r | r & (upperChars includes: $a)]
		conformTo: #'Character' selector: #'isUppercase'.
	self value: [$1 isUppercase]
		shouldnt: [:r | r & (upperChars includes: $1)]
		conformTo: #'Character' selector: #'isUppercase'.
	self value: [$: isUppercase]
		shouldnt: [:r | r & (upperChars includes: $:)]
		conformTo: #'Character' selector: #'isUppercase'.! !
!CharacterANSITest categoriesFor: #canonicalObject!public! !
!CharacterANSITest categoriesFor: #protocol!public! !
!CharacterANSITest categoriesFor: #testXasLowercase!public! !
!CharacterANSITest categoriesFor: #testXasString!public! !
!CharacterANSITest categoriesFor: #testXasUppercase!public! !
!CharacterANSITest categoriesFor: #testXcodePoint!public! !
!CharacterANSITest categoriesFor: #testXisAlphaNumeric!public! !
!CharacterANSITest categoriesFor: #testXisDigit!public! !
!CharacterANSITest categoriesFor: #testXisLetter!public! !
!CharacterANSITest categoriesFor: #testXisLowercase!public! !
!CharacterANSITest categoriesFor: #testXisUppercase!public! !

