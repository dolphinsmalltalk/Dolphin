"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Core.Tests.SemVerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SemVerTest guid: (Core.GUID fromString: '{a407e9c9-f1a9-48c2-bfdb-ce30877bede0}')!
Core.Tests.SemVerTest comment: ''!
!Core.Tests.SemVerTest methodsFor!

comparisonCases
	^#('1.2.3' '1.2.4' '2.2.3' '1.3.3' '1.2.3-rc.1' '1.2.3-rc.2' '1.2.3+abcdef' '1.2.4+abcdef' '1.2.3-rc.1+abcdef')!

testComparing
	| cases |
	cases := self comparisonCases.
	cases do: 
			[:string1 |
			| hash1 semver1 |
			semver1 := SemVer fromString: string1.
			hash1 := semver1 hash.
			cases do: 
					[:string2 |
					| semver2 |
					semver2 := SemVer fromString: string2.
					string1 = string2
						ifTrue: 
							[self assert: semver2 hash equals: hash1.
							self assert: semver1 equals: semver2.
							self assert: semver1 <=> semver2 equals: 0.
							self assert: semver1 <==> semver2 equals: 0]
						ifFalse: 
							[self deny: semver2 hash equals: hash1.
							self deny: semver1 equals: semver2]]]!

testEqualPrecedence
	"See SemVer.org for precedence rules"

	#('1.0.0' '1.0.0+20130313144700' '1.0.0-beta.1+exp.sha.5114f85' '1.0.0-beta.1' '1.0.0+21AF26D3----117B344092BD' '1.0.0')
		pairsDo: 
			[:a :b |
			| subject1 subject2 |
			subject1 := SemVer fromString: a.
			self assert: subject1 displayString equals: a.
			subject2 := SemVer fromString: b.
			self assert: subject2 displayString equals: b.
			self assert: subject1 <=> subject2 equals: 0]!

testFromGitDescription
	#('8.0.0-1-gf2bcc911d' '8.0.1-rc.1+gf2bcc911d' 'v2.0.0-61-g2f5ef23' '2.0.1-rc.61+g2f5ef23' 'v2.0.1-0-g2f5ef23' '2.0.1+g2f5ef23')
		pairsDo: 
			[:case :expected |
			| actual |
			actual := SemVer fromGitDescription: case.
			self assert: actual equals: (SemVer fromString: expected).
			self assert: actual displayString equals: expected]!

testInvalidVersions
	"Invalid semantic versions from https://regex101.com/r/vkijKf/1/"

	#('1' '1.2' '1.2.3-0123' '1.2.3-0123.0123' '1.1.2+.123' '+invalid' '-invalid' '-invalid+invalid' '-invalid.01' 'alpha' 'alpha.beta' 'alpha.beta.1' 'alpha.1' 'alpha+beta' 'alpha_beta' 'alpha.' 'alpha..' 'beta' '1.0.0-alpha_beta' '-alpha.' '1.0.0-alpha..' '1.0.0-alpha..1' '1.0.0-alpha...1' '1.0.0-alpha....1' '1.0.0-alpha.....1' '1.0.0-alpha......1' '1.0.0-alpha.......1' '01.1.1' '1.01.1' '1.1.01' '1.2' '1.2.3.DEV' '1.2-SNAPSHOT' '1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788' '1.2-RC-SNAPSHOT' '-1.0.3-gamma+b7718' '+justmeta' '9.8.7+meta+meta' '9.8.7-whatever+meta+meta' '99999999999999999999999.999999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12' '1.0.A' '1.2.3a')
		do: 
			[:each |
			self deny: (SemVer isValid: each).
			self should: [SemVer fromString: each] raise: InvalidFormat]!

testPrecedence
	"See semver.org for precedence rules. The test cases are from there."

	| cases |
	cases := #('0.0.0-rc.1' '0.0.0-rc.2' '0.0.0-rc.2.a' '0.0.0-rc.2a' '0.0.0' '0.0.1' '0.0.2+bdef' '0.1.0' '1.0.0-alpha' '1.0.0-alpha.1' '1.0.0-alpha.beta' '1.0.0-beta' '1.0.0-beta.2' '1.0.0-beta.11' '1.0.0-rc.1' '1.0.0' '2.0.0' '2.1.0' '2.1.1').
	1 to: cases size
		do: 
			[:i |
			| semver1 semver2 |
			semver1 := SemVer fromString: (cases at: i).
			1 to: i - 1
				do: 
					[:j |
					semver2 := SemVer fromString: (cases at: j).
					self assert: (semver1 <=> semver2) > 0.
					self assert: semver2 < semver1.
					self assert: semver2 <= semver1.
					self assert: semver1 > semver2.
					self assert: semver1 >= semver2].
			semver2 := SemVer fromString: (cases at: i).
			self assert: semver1 equals: semver2.
			self assert: (semver1 <=> semver2) equals: 0.
			self deny: semver2 < semver1.
			self deny: semver1 > semver2.
			self assert: semver2 <= semver1.
			self assert: semver2 >= semver1.
			i + 1 to: cases size
				do: 
					[:j |
					semver2 := SemVer fromString: (cases at: j).
					self assert: (semver1 <=> semver2) < 0.
					self assert: semver2 >= semver1.
					self assert: semver2 > semver1.
					self assert: semver1 < semver2.
					self assert: semver1 <= semver2]]!

testReadFromPartial
	| stream remainder |
	#(#('0.0.4a' '0.0.4' 'a') #('0.0.4-0%' '0.0.4-0' '%')) do: 
			[:each |
			| string subject |
			string := each first.
			"Not a valid SemVer as a whole string."
			self deny: (SemVer isValid: string).
			stream := string readStream.
			subject := SemVer readFrom: stream.
			self assert: subject equals: (SemVer fromString: each second).
			remainder := stream upToEnd.
			self assert: remainder equals: each third]!

testValidVersions
	"Valid semantic versions from https://regex101.com/r/vkijKf/1/"

	#(#('0.0.4' 0 0 4 nil nil) #('1.2.3' 1 2 3 nil nil) #('10.20.30' 10 20 30 nil nil) #('1.1.2-prerelease+meta' 1 1 2 'prerelease' 'meta') #('1.1.2+meta' 1 1 2 nil 'meta') #('1.1.2+meta-valid' 1 1 2 nil 'meta-valid') #('1.0.0-alpha' 1 0 0 'alpha' nil) #('1.0.0-beta' 1 0 0 'beta' nil) #('1.0.0-alpha.beta' 1 0 0 'alpha.beta' nil) #('1.0.0-alpha.beta.1' 1 0 0 'alpha.beta.1' nil) #('1.0.0-alpha.1' 1 0 0 'alpha.1' nil) #('1.0.0-alpha0.valid' 1 0 0 'alpha0.valid' nil) #('1.0.0-alpha.0valid' 1 0 0 'alpha.0valid' nil) #('1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay' 1 0 0 'alpha-a.b-c-somethinglong' 'build.1-aef.1-its-okay') #('1.0.0-rc.1+build.1' 1 0 0 'rc.1' 'build.1') #('2.0.0-rc.1+build.123' 2 0 0 'rc.1' 'build.123') #('1.2.3-beta' 1 2 3 'beta' nil) #('10.2.3-DEV-SNAPSHOT' 10 2 3 'DEV-SNAPSHOT' nil) #('1.2.3-SNAPSHOT-123' 1 2 3 'SNAPSHOT-123' nil) #('1.0.0' 1 0 0 nil nil) #('2.0.0' 2 0 0 nil nil) #('1.1.7' 1 1 7 nil nil) #('2.0.0+build.1848' 2 0 0 nil 'build.1848') #('2.0.1-alpha.1227' 2 0 1 'alpha.1227' nil) #('1.0.0-alpha+beta' 1 0 0 'alpha' 'beta') #('1.2.3----RC-SNAPSHOT.12.9.1--.12+788' 1 2 3 '---RC-SNAPSHOT.12.9.1--.12' '788') #('1.2.3----R-S.12.9.1--.12+meta' 1 2 3 '---R-S.12.9.1--.12' 'meta') #('1.2.3----RC-SNAPSHOT.12.9.1--.12' 1 2 3 '---RC-SNAPSHOT.12.9.1--.12' nil) #('1.0.0+0.build.1-rc.10000aaa-kk-0.1' 1 0 0 nil '0.build.1-rc.10000aaa-kk-0.1') #('99999999999999999999999.999999999999999999.99999999999999999' 99999999999999999999999 999999999999999999 99999999999999999 nil nil) #('1.0.0-0A.is.legal' 1 0 0 '0A.is.legal' nil))
		do: 
			[:each |
			| string subject |
			string := each first.
			self assert: (SemVer isValid: string).
			subject := SemVer fromString: string.
			self assert: subject major equals: each second.
			self assert: subject minor equals: each third.
			self assert: subject patch equals: each fourth.
			self assert: subject prerelease equals: each fifth.
			self assert: subject buildmetadata equals: each sixth.
			self assert: subject displayString equals: string.
			self assert: subject printString equals: 'a SemVer(<p>)' << string]! !
!Core.Tests.SemVerTest categoriesForMethods!
comparisonCases!constants!private! !
testComparing!public!unit tests! !
testEqualPrecedence!public!unit tests! !
testFromGitDescription!public!unit tests! !
testInvalidVersions!public!unit tests! !
testPrecedence!public!unit tests! !
testReadFromPartial!public! !
testValidVersions!public!unit tests! !
!

