"Filed out from Dolphin Smalltalk"!

Core.Magnitude
	subclass: #'Core.SemVer'
	instanceVariableNames: 'major minor patch prerelease buildmetadata'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SemVer guid: (Core.GUID fromString: '{4ec303dc-a331-4b39-8270-93794e0bf42c}')!
Core.SemVer comment: '`SemVer` implements the [SemVer 2.0](https://semver.org/) specification.

## Instance Variables:
  `major`			`<integer>` major version number from the semver
  `minor`			`<integer>` minor version number from the semver
  `patch`			`<integer>` patch version number from the semver
  `prerelease`		`<readableString>` pre-release field of the semver, when present (else nil)
  `buildmetadata`	`<readableString>` build-metadata field of the semver, when present (else nil). See [Build metadata](https://semver.org/#spec-item-10)

## Class Variables:
  `RegEx`		`IRegExp2`

'!
!Core.SemVer categoriesForClass!Kernel-Objects! !
!Core.SemVer methodsFor!

< aSemVer
	"Answer whether the receiver is less than the <SemVer>, operand."

	"For precedence rules see semver.org"

	^major < aSemVer major or: 
			[major = aSemVer major and: 
					[minor < aSemVer minor or: 
							[minor = aSemVer minor
								and: [patch < aSemVer patch or: [patch = aSemVer patch and: [(self comparePrerelease: aSemVer) < 0]]]]]]!

<=> aSemVer
	"Answer the receiver's <integer> collation order with respect to the <SemVer> argument. Colloquially known as the spaceship operator.
	The answer is < 0 if the receiver should collate before the argument, 0 if they have the same collation order, or > 0 if the receiver should collate after the argument."

	"Note that because the build-metadata is ignored for ordering purposes, but not for equality comparisons, it is possible that following expression may be true:
		`semVerA ~= semVerB and: [semVerA <=> semVerB = 0]`
	"

	"The ordering rules are logical, but non-trivial, mainly in relation to the treatment of pre-release qualifiers. See the [semver.org precedence rules](https://semver.org/#spec-item-11)."

	| cmp |
	(cmp := major <=> aSemVer major) == 0
		ifTrue: 
			[(cmp := minor <=> aSemVer minor) == 0
				ifTrue: [(cmp := patch <=> aSemVer patch) == 0 ifTrue: [cmp := self comparePrerelease: aSemVer]]].
	^cmp!

= anObject
	"Answer whether the receiver is equivalent to the argument. The answer will be false unless the argument is a kind of `SemVer` with equivalent major, minor, patch, prerelease and buildmetadata."

	^anObject species == self species and: 
			[anObject major = major and: 
					[anObject minor = minor and: 
							[anObject patch = patch
								and: [anObject prerelease = prerelease and: [anObject buildmetadata = buildmetadata]]]]]!

buildmetadata
	"Answer a <readableString> representing the receiver's build-metadata, e.g. the Git commit id, or nil if not present."

	"The [SemVer metadata section](https://semver.org/#spec-item-10) is the optional final section of the SemVer that follows the + separator, and consists of sequence of parts consisting only of ASCII alphanumerics and the hyphen character. If there is more than one part they are dot-separated."

	^buildmetadata!

comparePrerelease: aSemVer
	"Private - Compare the prerelease fields of the receiver and argument, which are assumed to have equal M.N.P.
	Answer `-1` if the receiver represents an earlier release, `0` if the receiver and argument are the same release (or different builds of it), or `1` if the receiver is a later release.
	The [precedence rules](https://semver.org/#spec-item-11) are fairly complex, but involve splitting the pre-release into the parts that are separated by dots, and then comparing them individually."

	| comparandPrerel parts comparandParts partsCount comparandPartsCount |
	comparandPrerel := aSemVer prerelease.
	comparandPrerel = prerelease ifTrue: [^0].
	prerelease
		ifNil: 
			["Can only be here if otherPrerel is not nil, so receiver not a pre-release, argument is. Receiver must be later."
			^1].
	"Receiver has prelease..."
	comparandPrerel
		ifNil: 
			["...comparand does not, so receiver is earlier"
			^-1].
	"Receiver and comparand have different prerelease fields. Need to compare component by component."
	parts := $. split: prerelease.
	comparandParts := $. split: comparandPrerel.
	partsCount := parts size.
	comparandPartsCount := comparandParts size.
	1 to: (partsCount min: comparandPartsCount)
		do: 
			[:i |
			| receiverPart comparandPart |
			receiverPart := parts at: i.
			comparandPart := comparandParts at: i.
			receiverPart = comparandPart
				ifFalse: 
					[| receiverInt comparandInt |
					receiverInt := self readIntegerPrerelPart: receiverPart.
					comparandInt := self readIntegerPrerelPart: comparandPart.
					receiverInt
						ifNil: 
							[comparandInt
								ifNil: 
									[| strcmp |
									"Neither part is numeric; perform ordinal string comparison"
									strcmp := receiverPart compareOrdinals: comparandPart ignoringCase: false.
									strcmp == 0 ifFalse: [^strcmp]]
								ifNotNil: 
									["Receiver part non-numeric, other numeric. Receiver is a later release"
									^1]]
						ifNotNil: 
							[comparandInt
								ifNil: 
									["Receiver part numeric, other non-numeric, receiver earlier"
									^-1]
								ifNotNil: 
									[| cmp |
									"Both parts numeric"
									cmp := receiverInt <=> comparandInt.
									cmp == 0 ifFalse: [^cmp]]]]].
	^partsCount <=> comparandPartsCount!

displayOn: aStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see, which in this case is the full SemVer string."

	aStream
		print: major;
		nextPut: $.;
		print: minor;
		nextPut: $.;
		print: patch.
	prerelease
		ifNotNil: 
			[aStream
				nextPut: $-;
				nextPutAll: prerelease].
	buildmetadata
		ifNotNil: 
			[aStream
				nextPut: $+;
				nextPutAll: buildmetadata]!

hash
	"Answer a `SmallInteger` hash value for the receiver which obeys the invariant that any two objects which compare equal (using #=) must have the same hash value (but not necessarily vice-versa)."

	| hash |
	hash := (major hash hashMultiply + minor hash) hashMultiply + patch hash.
	prerelease ifNotNil: [hash := hash hashMultiply + prerelease hash].
	buildmetadata ifNotNil: [hash := hash hashMultiply + buildmetadata hash].
	^hash!

major
	"Answer the <integer> [major version](https://semver.org/#spec-item-8) number."

	^major!

major: majorIntegre minor: minorInteger patch: patchInteger prerelease: prerelString buildmetadata: metadataString
	major := majorIntegre.
	minor := minorInteger.
	patch := patchInteger.
	prerelease := prerelString.
	buildmetadata := metadataString.
	^self!

majorMinor
	"Answer a <readableString> consisting of the decimal representation of the receiver's major and minor versions, separated by a dot. Note that this will not be a valid SemVer as it has only two components."

	^(String writeStream: 4)
		print: major;
		nextPut: $.;
		print: minor;
		contents!

majorMinorPatch
	"Answer a <readableString> consisting of the decimal representation of the receiver's major, minor, and patch versions, separated by a dot."

	^(String writeStream: 9)
		print: major;
		nextPut: $.;
		print: minor;
		nextPut: $.;
		print: patch;
		contents!

minor
	"Answer the <integer> [minor version](https://semver.org/#spec-item-7) number."

	^minor!

patch
	"Answer the <integer> [patch version](https://semver.org/#spec-item-6) number."

	^patch!

prerelease
	"Answer a <readableString> representing the receiver's pre-release information, e.g. 'rc.1' as a convention for release candidate 1. If there is no prerelease specified, this will be nil."

	"The [SemVer prerelease section](https://semver.org/#spec-item-9) follows the optional hyphen separator after MAJOR.MINOR.PATCH, and consists of sequence of parts consisting only of ASCII alphanumerics and the hyphen character. If there is more than one part they are dot-separated."

	^prerelease!

printOn: aStream
	super printOn: aStream.
	aStream
		nextPutAll: '(''';
		display: self;
		nextPutAll: ''')'!

readIntegerPrerelPart: aString
	^aString isEmpty
		ifFalse: 
			[| stream int |
			stream := aString readStream.
			int := Integer readFrom: stream.
			stream atEnd ifTrue: [int]]! !
!Core.SemVer categoriesForMethods!
<!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
buildmetadata!accessing!public! !
comparePrerelease:!comparing!private! !
displayOn:!displaying!public! !
hash!comparing!public! !
major!accessing!public! !
major:minor:patch:prerelease:buildmetadata:!initializing!private! !
majorMinor!accessing!public! !
majorMinorPatch!accessing!public! !
minor!accessing!public! !
patch!accessing!public! !
prerelease!accessing!public! !
printOn:!printing!public! !
readIntegerPrerelPart:!helpers!private! !
!

!Core.SemVer class methodsFor!

fromGitDescription: aString
	"Answer a new instance formed from git describe output. This assumes that the git repo providing the description is using M.N.P tags and that RC numbers should be generated for commits past the last tag as prerelease version. These are assumed to be towards the next patch, so the patch number is bumped, i.e. the pre-releases precede the release with the same M.N.P, but without the prerelease field. The use of 'commits past tag' to generate pre-release versions is not part of the SemVer spec, but is a convenient way of automatically generating suitable unique versions from the git repo state.
	
	e.g.
		c:\Dolphin>git describe --tag --always --long
		8.0.0-1-gf2bcc911d
		
		SemVer fromGitDescription: '8.0.0-1-gf2bcc911d' 
			=> a SemVer('8.0.1-rc.1+gf2bcc911d')
	"

	| splits mnp prerelease commits major minor patch |
	splits := $- split: aString.
	mnp := $. split: splits first.
	major := mnp first readStream.
	major peekFor: $v.
	major := Integer readFrom: major.
	minor := Integer fromString: mnp second.
	patch := Integer fromString: mnp third.
	commits := Integer fromString: splits second.
	prerelease := commits ~~ 0
				ifTrue: 
					[patch := patch + 1.
					'rc.' , commits printString].
	^self
		major: major
		minor: minor
		patch: patch
		prerelease: prerelease
		buildmetadata: splits last!

fromString: aString
	"Answer a new instance of the receiver parsed from the SemVer representation in the argument. If the format is invalid, and error will be thrown."

	| instance stream |
	stream := aString readStream.
	instance := self readFrom: stream.
	(instance isNil or: [stream atEnd not]) ifTrue: [InvalidFormat signal: aString with: self].
	^instance!

isValid: aString
	"Answer whether the argument is in valid SemVer format."

	| stream |
	stream := aString readStream.
	^(self readFrom: stream) notNil and: [stream atEnd]!

major: majorInteger minor: minorInteger patch: patchInteger prerelease: prerelString buildmetadata: metadataString
	"Answer a new instance of the receiver with the specified version fields."

	<primitive: 157>
	^self new
		major: majorInteger
		minor: minorInteger
		patch: patchInteger
		prerelease: prerelString
		buildmetadata: metadataString!

readFrom: aReadStream
	^(SemVerParser on: aReadStream) parse! !
!Core.SemVer class categoriesForMethods!
fromGitDescription:!instance creation!public! !
fromString:!instance creation!public! !
isValid:!enquiries!public! !
major:minor:patch:prerelease:buildmetadata:!public! !
readFrom:!public! !
!

