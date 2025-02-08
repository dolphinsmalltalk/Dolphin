"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.PackageTest'
	instanceVariableNames: 'loadedPackages checkTimestamps defaultPackage'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.PackageTest guid: (Core.GUID fromString: '{0bcde90d-a936-43ee-9e4a-2bdec39abf2a}')!

Kernel.Tests.PackageTest comment: ''!

!Kernel.Tests.PackageTest methodsFor!

checkNoTestPackageContents
	| scribbleClass |
	self deny: #{Smalltalk.ScribbleTest} isDefined.
	scribbleClass := #{Smalltalk.Scribble} value.
	self assertIsNil: (scribbleClass compiledMethodAt: #looseA ifAbsent: nil).
	self assertIsNil: (scribbleClass compiledMethodAt: #looseC ifAbsent: nil).
	self assertIsNil: (scribbleClass class compiledMethodAt: #resource_Scribble_test ifAbsent: nil).
	self deny: (SharedPool allSubclasses anySatisfy: [:each | each name = #ScribbleTestSourceGlobal])!

checkTestPackageContents
	| scribbleTestPackage scribbleTestClass scribbleTest scribbleTestResourceMethod scribbleTestDefaultViewId scribbleTestViewId scribbleClass resourceIds |
	scribbleTestPackage := loadedPackages first.
	self assert: (scribbleTestPackage name beginsWith: 'ScribbleTest').
	scribbleTestPackage name = 'ScribbleTest20'
		ifTrue: 
			[self assert: (scribbleTestPackage instVarNamed: 'scripts')
				equals: (IdentityDictionary withAll: {
								#preinstall
									-> 'Transcript nextPutAll: ''A blast from the Dolphin 2.0 past is about to arrive''; cr'
							})]
		ifFalse: [self assertIsNil: (scribbleTestPackage instVarNamed: 'scripts')].
	self verifyPackageElementNamesAreAbsolute: scribbleTestPackage.
	scribbleTestClass := #{Smalltalk.ScribbleTest} value.
	self assert: (scribbleTestPackage classes identityIncludes: scribbleTestClass).
	scribbleTestResourceMethod := scribbleTestClass class
				compiledMethodAt: #resource_Default_scribble_test_view.
	self assert: scribbleTestResourceMethod owningPackage equals: scribbleTestPackage.
	scribbleClass := #{Smalltalk.Scribble} value.
	self assert: (scribbleClass compiledMethodAt: #looseA) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass compiledMethodAt: #looseC) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass class compiledMethodAt: #resource_Scribble_test) owningPackage
		equals: scribbleTestPackage.
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := UI.ResourceIdentifier class: scribbleTestClass
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	scribbleTestViewId := UI.ResourceIdentifier class: scribbleClass name: 'Scribble test'.
	self assert: (resourceIds includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage equals: scribbleTestPackage.
	
	[scribbleTest := scribbleTestClass show.
	self assert: scribbleTest a equals: 'A']
			ensure: [scribbleTest view topView destroy]!

d5ForwardRefTestPacContents
	^'| package |
package := Package name: ''D5LoadTest''.
package paxVersion: 0;
	basicComment: ''''.


package resourceNames
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package allResourceNames: (Set new
	add: #Presenter -> ''D6'';
	add: #Shell -> ''D6'';
	add: #Toolbar -> ''D6'';
	yourself).

package setPrerequisites: (IdentitySet new
	add: ''Object Arts\Dolphin\Base\Dolphin'';
	add: ''Object Arts\Dolphin\MVP\Views\Common Controls\Dolphin Common Controls'';
	add: ''Object Arts\Dolphin\MVP\Views\Control Bars\Dolphin Control Bars'';
	add: ''Object Arts\Dolphin\MVP\Base\Dolphin MVP Base'';
	yourself).

package!!

"Class Definitions"!!


"Global Aliases"!!


"Loose Methods"!!

"End of package definition"!!

"Source Globals"!!

"Classes"!!

"Binary Globals"!!

"Resources"!!

(ResourceIdentifier class: Presenter name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALoGAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAADQAAAENvbnRhaW5lclZpZXdiAAAA
DwAAAAAAAAAAAAAAYgAAAAIAAACCAAAABAAAAAAAAEQBAAIAoAEAAAAAAAAAAAAAAAAAAAcAAAAA
AAAAAAAAAAAAAACgAQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2Vx
dWVuY2UAAAAAygAAAAAAAADQAAAAYgAAAAEAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABS
AAAAEAAAAGNyZWF0ZUF0OmV4dGVudDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAAMICAAAA
AAAAvQIAAPUBAACgAQAABgEPAFdJTkRPV1BMQUNFTUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAA
AP////////////////////8FAAAABQAAAGMBAAD/AAAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAA
AAAAAJoAAAAAAAAAUgAAABcAAABEb2xwaGluIENvbW1vbiBDb250cm9sc1IAAAAZAAAATXVsdGlw
bGVTZWxlY3Rpb25MaXN0Vmlld2IAAAAeAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAASRABRAEE
AABAAwAARgMJAAIAAABMaXN0TW9kZWwAAAAAygAAAAAAAADQAAAAIAIAAAAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAADAAAAFNlYXJjaFBvbGlj
eboAAAAAAAAAUgAAAAgAAABpZGVudGl0eQAAAAAAAAAABwAAAAAAAAAAAAAAAAAAAEADAAAAAAAA
ggAAAAgAAAAzA///AAAAAJoAAAAAAAAAwAEAAFIAAAARAAAAQmFzaWNMaXN0QWJzdHJhY3SaAAAA
AAAAAGADAABSAAAAEgAAAEljb25pY0xpc3RBYnN0cmFjdOoDAAAAAAAAmgAAAAAAAADAAQAAUgAA
ABAAAABJY29uSW1hZ2VNYW5hZ2VyugAAAAAAAABSAAAABwAAAGN1cnJlbnQAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAADKAAAAAAAAANAAAABiAAAAAQAAAEYMDgAFAAAATGlzdFZpZXdDb2x1bW4AAAAA
UgAAAAgAAABDb2x1bW4gMckAAAC6AAAAAAAAAFIAAAAEAAAAbGVmdGAEAACaAAAAAAAAABAEAABS
AAAAEAAAAFNvcnRlZENvbGxlY3Rpb24AAAAAAAAAAEADAAAAAAAAAQAAAAAAAAAAAAAAugAAAAAA
AABSAAAABgAAAHJlcG9ydGIAAAAAAAAAAAAAAGEAAAAAAAAAAAAAADICAAAAAAAAygAAAAAAAADQ
AAAAYgAAAAIAAAByAgAAAAAAAJACAABiAAAAAgAAAMICAAAAAAAAbwAAAEcAAADCAgAAAAAAAJEB
AACNAQAAQAMAAHICAAAAAAAAugAAAAAAAABSAAAABQAAAHRleHQ6YgAAAAEAAABSAAAACAAAAENv
bHVtbiAxQAMAAPICAAAAAAAAcgAAACwAAAAsAAAAAAAAAAEAAAD/////////////////////NwAA
ACMAAAD/AAAA6QAAAMoAAAAAAAAA0AAAACACAADCAgAAAAAAAMEAAADBAAAAAAAAABcAAACaAQAA
AAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJlbmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAA
AgAAAIIAAAAEAAAAAAAARAEAAgCwBgAAAAAAAAAAAAAAAAAABwAAAAAAAAAAAAAAAAAAALAGAAAG
AhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAMgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAHICAAAAAAAAkAIAAGIAAAACAAAAwgIAAAAAAABRAAAACwAAAMICAAAAAAAA4QEAAFEAAACw
BgAA8gIAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8oAAAABQAAABgB
AAAtAAAAYgAAAAAAAACgBgAAAAAAABUAAACgBgAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAA
ABAAAAAOAhEAU1RCU2luZ2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAA
GAAAAEltYWdlUmVsYXRpdmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABEA
AABDb250YWluZXJWaWV3Lmljbw4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFyeVByb3h5AAAA
AFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAA=''))!!

(ResourceIdentifier class: Shell name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAALUEAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAEAAAAERvbHBoaW4gTVZQIEJhc2VSAAAACQAAAFNoZWxsVmlld2IAAAAbAAAA
AAAAAAAAAABiAAAAAgAAAAEAngEBAAIAoAEAAAAAAAAAAAAAAAAAAAcCAAAAAAAAAAAAAAAAAACg
AQAAAAAAAOoAAAAAAAAAAAEAAGIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAA
AAAAAAAAAAAAAAEAAAAAAAAAAAAAAAYBDwBNZXNzYWdlU2VxdWVuY2UAAAAAygAAAAAAAADQAAAA
YgAAAAIAAAAGAwsATWVzc2FnZVNlbmQAAAAAugAAAAAAAABSAAAAEAAAAGNyZWF0ZUF0OmV4dGVu
dDpiAAAAAgAAAAYCBQBQb2ludAAAAAALAAAACwAAALICAAAAAAAATQMAAOcCAACgAQAAYgIAAAAA
AAC6AAAAAAAAAFIAAAAIAAAAbWVudUJhcjpiAAAAAQAAAAAAAACgAQAABgEPAFdJTkRPV1BMQUNF
TUVOVAAAAAByAAAALAAAACwAAAAAAAAAAAAAAP////////////////////8FAAAABQAAAKsBAAB4
AQAAygAAAAAAAADQAAAAYgAAAAIAAACaAQAAAAAAAJoAAAAAAAAAwAEAAFIAAAANAAAAUmVmZXJl
bmNlVmlld2IAAAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgBwAwAAAAAAAAAA
AAAAAAAABwAAAAAAAAAAAAAAAAAAAHADAAAGAhIAUmVzb3VyY2VJZGVudGlmaWVyAAAAAJoAAAAA
AAAAwAEAAFIAAAAJAAAAUHJlc2VudGVyUgAAAAIAAABENgAAAAAiAgAAAAAAAMoAAAAAAAAA0AAA
AGIAAAABAAAAYgIAAAAAAACAAgAAYgAAAAIAAACyAgAAAAAAAHkAAACDAAAAsgIAAAAAAAB3AgAA
dwIAAHADAAAiAwAAAAAAAHIAAAAsAAAALAAAAAAAAAABAAAA/////////////////////zwAAABB
AAAAdwEAAHwBAABiAAAAAAAAALICAAAAAAAAwQAAAMEAAAAAAAAAFQAAAJoBAAAAAAAAgAMAAGIA
AAAOAAAAAAAAAKABAABiAAAAAgAAAIIAAAAEAAAAAAAARAEAAgDQBAAAAAAAAAAAAAAAAAAABwAA
AAAAAAAAAAAAAAAAANAEAADSAwAAAAAAAJoAAAAAAAAAUgAAABQAAABEb2xwaGluIENvbnRyb2wg
QmFyc1IAAAAHAAAAVG9vbGJhclIAAAACAAAARDYAAAAAIgIAAAAAAADKAAAAAAAAANAAAABiAAAA
AQAAAGICAAAAAAAAgAIAAGIAAAACAAAAsgIAAAAAAAApAAAACwAAALICAAAAAAAA9QEAAFsAAADQ
BAAAIgMAAAAAAAByAAAALAAAACwAAAAAAAAAAQAAAP////////////////////8UAAAABQAAAA4B
AAAyAAAAsAQAAMAEAAAAAAAAFQAAAMAEAAAAAAAAFQAAAEYFBAADAAAASWNvbgAAAAAAAAAAEAAA
AA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIAAAAHAAAARG9scGhpblIAAAAYAAAA
SW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAABwAAAGN1cnJlbnRSAAAADQAAAFNo
ZWxsVmlldy5pY28OAh8AU1RCRXh0ZXJuYWxSZXNvdXJjZUxpYnJhcnlQcm94eQAAAABSAAAAEAAA
AGRvbHBoaW5kcjAwNS5kbGwAAAAA''))!!

(ResourceIdentifier class: Toolbar name: ''D6'') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: ''IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAAFUFAAAhU1RCIDEgTggMAAoAAABTVEJWaWV3UHJveHkAAAAA
mgAAAAAAAABSAAAAFAAAAERvbHBoaW4gQ29udHJvbCBCYXJzUgAAAAcAAABUb29sYmFyYgAAABkA
AAAAAAAAAAAAAGIAAAACAAAAggAAAAQAAAAECwBEAQACAKABAAAAAAAABgELAFN5c3RlbUNvbG9y
AAAAAB8AAAAAAAAABwIAAAAAAAAGBAQARm9udAAAAAAAAAAAEAAAAAYBBwBMT0dGT05UAAAAAHIA
AAA8AAAA8////wAAAAAAAAAAAAAAAJABAAAAAAAAAwIBIkFyaWFsAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAABgIFAFBvaW50AAAAAMEAAADBAAAAAAAAAKABAAAAAAAAggAAAAgAAADdA///AAAA
AOoAAAAAAAAAAAEAAGIAAAAAAAAA6gAAAAAAAAAAAQAAYgAAAAYAAADLvgAABgcNAFRvb2xiYXJC
dXR0b24AAAAAy74AAAAAAACgAQAAAQAAAEYFEgAEAAAAQ29tbWFuZERlc2NyaXB0aW9uAAAAALoA
AAAAAAAAUgAAAAkAAABub0NvbW1hbmRSAAAACgAAAE5vIGNvbW1hbmQBAAAAAQAAAAAAAABGCAYA
AwAAAEJpdG1hcAAAAAAAAAAAEAAAAA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIA
AAAHAAAARG9scGhpblIAAAAYAAAASW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAA
BwAAAGN1cnJlbnRSAAAACQAAAFRvb2xzLmJtcA4CHwBTVEJFeHRlcm5hbFJlc291cmNlTGlicmFy
eVByb3h5AAAAAFIAAAAQAAAAZG9scGhpbmRyMDA1LmRsbAAAAAAAAAAABwAAAIICAAAAAAAAIQcA
ACEAAABHAAAAzb4AAPICAAAAAAAAzb4AAAAAAACgAQAAAQAAABIDAAAAAAAAMAMAAFADAAABAAAA
AQAAAAAAAABiAwAAAAAAAAAAAAAQAAAAkAMAAPADAAAQBAAAAAAAAAUAAAAAAAAARwAAAM++AADy
AgAAAAAAAM++AAAAAAAAoAEAAAEAAAASAwAAAAAAADADAABQAwAAAQAAAAEAAAAAAAAAYgMAAAAA
AAAAAAAAEAAAAJADAADwAwAAEAQAAAAAAAAFAAAAAAAAAEcAAABiAAAAAwAAAAADAABABAAAcAQA
AOoAAAAAAAAA8AAAAGIAAAACAAAAcAMAAAEAAAAAAAAAIAAAAAAAAACCAgAAAAAAACEAAAAhAAAA
ggIAAAAAAAAtAAAALQAAAAAAAAAGAwoARmxvd0xheW91dAAAAAABAAAAAQAAALoAAAAAAAAAUgAA
AAQAAABsZWZ0BgEPAE1lc3NhZ2VTZXF1ZW5jZQAAAADKAAAAAAAAANAAAABiAAAAAgAAAAYDCwBN
ZXNzYWdlU2VuZAAAAAC6AAAAAAAAAFIAAAAQAAAAY3JlYXRlQXQ6ZXh0ZW50OmIAAAACAAAAggIA
AAAAAAALAAAACwAAAIICAAAAAAAAvQIAADMAAACgAQAAcgUAAAAAAAC6AAAAAAAAAFIAAAAKAAAA
dXBkYXRlU2l6ZWIAAAAAAAAAoAEAAAYBDwBXSU5ET1dQTEFDRU1FTlQAAAAAcgAAACwAAAAsAAAA
AAAAAAAAAAD/////////////////////BQAAAAUAAABjAQAAHgAAAMoAAAAAAAAA0AAAAMACAACC
AgAAAAAAAMEAAADBAAAAAAAAABMAAABGBQQAAwAAAEljb24AAAAAAAAAABAAAAAOAhEAU1RCU2lu
Z2xldG9uUHJveHkAAAAAmgAAAAAAAABSAAAABwAAAERvbHBoaW5SAAAAGAAAAEltYWdlUmVsYXRp
dmVGaWxlTG9jYXRvcroAAAAAAAAAUgAAAAcAAABjdXJyZW50UgAAABYAAABDb250cm9sQmFyQWJz
dHJhY3QuaWNvDgIfAFNUQkV4dGVybmFsUmVzb3VyY2VMaWJyYXJ5UHJveHkAAAAAUgAAABAAAABk
b2xwaGluZHIwMDUuZGxsAAAAAA==''))!!


'!

denyDiaryLoaded
	| classNames |
	self deny: (Package manager includesPackageNamed: 'Diary').
	classNames := #(#{Smalltalk.Diary} #{Smalltalk.DiaryEvent} #{Smalltalk.DiaryEventEditor} #{Smalltalk.DiaryTool}).
	classNames do: [:each | self deny: each isDefined].
	^classNames!

denyHexdecimalBrowserLoaded
	| classNames |
	self deny: (Package manager includesPackageNamed: 'HexdecimalBrowser').
	classNames := #(#{Smalltalk.HexadecimalBrowser} #{Smalltalk.HexadecimalConverter}).
	classNames do: [:each | self deny: each isDefined].
	self deny: (Integer includesSelector: #printStringRadix:zeroPadTo:).
	^classNames!

loadAndTestPackage: aString
	| notifications |
	self checkNoTestPackageContents.
	notifications := self loadTestPackage: aString.
	self checkTestPackageContents.
	^notifications!

loadTestAndUninstallPackage: aString
	| notifications |
	notifications := self loadAndTestPackage: aString.
	self assert: loadedPackages first paxVersion equals: 1.
	self uninstallTestPackages.
	self checkNoTestPackageContents.
	^notifications!

loadTestPackage: aString
	| notifications packageFilename |
	packageFilename := self resourceFilename: aString.
	notifications := OrderedCollection new.
	loadedPackages := [Package manager install: packageFilename] on: Notification
				do: 
					[:ex |
					"Ignore package loading notification"
					notifications add: ex.
					ex resume].
	self assert: notifications size > 0.
	^notifications!

setUp
	| var |
	super setUp.
	var := Package classPool associationAt: 'CheckTimestamps'.
	checkTimestamps := var value.
	var value: true.
	defaultPackage := PackageManager current defaultPackage!

tearDown
	| scribbleClass |
	Package classPool at: 'CheckTimestamps' put: checkTimestamps.
	self uninstallTestPackages.
	"Manually remove the test components in case the uninstall failed or the test package didn't load correctly."
	#{Smalltalk.ScribbleTest} ifDefined: [:class | class removeFromSystem].
	scribbleClass := #{Smalltalk.Scribble} value.
	#(#looseA #looseC) do: [:each | scribbleClass removeSelector: each ifAbsent: nil].
	#(#resource_Scribble_test) do: [:each | scribbleClass class removeSelector: each ifAbsent: nil].
	PackageManager current defaultPackage: defaultPackage.
	super tearDown!

testForwardRefLoadPac
	"#1720: Test loading and converting of old packages with forward reference view referereces"

	| pacName notifications |
	pacName := self resourceFilename: 'D5LoadTest.pac'.
	(File write: pacName)
		write: self d5ForwardRefTestPacContents;
		close.
	notifications := OrderedCollection new.
	[[loadedPackages := Package manager install: pacName]
		on: Notification do: [:ex | notifications add: ex. ex resume]] ensure: [File delete: pacName].
	"self assert: notifications first description equals: "!

testLegacyFormatErrorAliasToQualifiedName
	| package ref filer filerClass |
	package := Package new.
	package paxVersion: 1.
	ref := #{Smalltalk.TestCase}.
	self assert: ref value identicalTo: XProgramming.SUnit.TestCase.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag class isMeta]!

testLegacyFormatErrorMethodOfNamespacedClass
	| package filerClass filer method |
	package := Package new.
	package paxVersion: 1.
	method := self class >> self selector.
	package addLooseMethod: method.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = (MethodName method: method)]!

testLegacyFormatErrorQualifiedAliasName
	| package filerClass filer ref |
	package := Package new.
	package paxVersion: 1.
	ref := #{XProgramming.SUnit.ExampleTestResource}.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = ref]!

testLegacyFormatErrorQualifiedBinaryVariableName
	| package filerClass filer ref |
	package := Package new.
	package paxVersion: 1.
	ref := #{Kernel.SourceFiles}.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag == ref]!

testLegacyFormatErrorQualifiedClassName
	| package filerClass filer |
	package := Package new.
	package paxVersion: 1.
	package classNames add: self class fullyQualifiedReference.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = self class asQualifiedReference]!

testLegacyFormatErrorQualifiedSourceVariableName
	| package anonClass filerClass filer pool ref |
	package := Package new.
	package paxVersion: 1.
	"PoolConstantDictionary instances only support Smalltalk as their environment because it is only used for legacy packages, but we want to test a theoretical sourceObject that can live in any Namespace."
	anonClass := Smalltalk.PoolConstantsDictionary newAnonymousSubclass.
	anonClass compile: 'environment ^Kernel.Tests'.
	pool := anonClass named: #TestPool.
	self class environment at: #TestPool put: pool.
	
	[ref := #{Kernel.Tests.TestPool}.
	package basicAddVariableNamed: ref.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag == ref]]
			ensure: [self class environment removeKey: #TestPool]!

testLegacyFormatErrorQualifiedSuperclassName
	"Test that if a class in Smalltalk is defined as a subclass of a class that is not bindable from Smalltalk, that it cannot be a member of a legacy format package (because the superclass will not be bindable without a qualified name)."

	| package filerClass filer testClass |
	package := Package new.
	package paxVersion: 1.
	testClass := self class
				subclass: #__Foo__
				instanceVariableNames: ''
				classVariableNames: ''
				imports: #()
				classInstanceVariableNames: ''
				classConstants: {}.
	
	[package classNames add: testClass fullyQualifiedReference.
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag == self class]]
			ensure: [testClass removeFromSystem]!

testLegacyFormatErrorQualifiedUntracedVariable
	| package filerClass filer ref |
	package := Package new.
	package paxVersion: 1.
	ref := #{XProgramming.SUnit.ExampleTestResource}.
	package setUntracedVariables: (Set with: ref).
	filerClass := package sourceFilerClass.
	self assert: filerClass equals: LegacyChunkSourceFiler.
	filer := filerClass on: String writeStream.
	self
		should: [package fileOutOn: filer]
		raise: SourceFormatNotSupportedError
		matching: [:ex | ex tag = ref]!

testLoad20Pac
	"Early format binary package, recreated in D2.0. Similar to the 2.1 package (STB filer version 0, package STB version 4), but the embedded view resource has earlier versions.
	The package was recreated using an old copy of D2 (surprisingly it still runs fine more than 25 years later) and porting in the ScribbleTest code."

	| pac notifications stbUpgradeMessage |
	pac := 'ScribbleTestPackages\2.0\ScribbleTest20.pac'.
	notifications := self loadTestAndUninstallPackage: pac.
	self assert: notifications size equals: 4.
	stbUpgradeMessage := 'Converting package from version 4 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications second description
		equals: 'Loading package ''ScribbleTest20'' from: <1d>' << (self resourceFilename: pac).
	"The package object is deserialized twice"
	stbUpgradeMessage := 'Converting package from version 4 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications fourth description
		equals: 'The package ''ScribbleTest20'' was saved with a different version of the Dolphin VM (98.2). 
It will probably load, but it may not operate correctly. 
If you experience subsequent problems please contact the package supplier for an updated version.'!

testLoad21Pac
	"The 2.1 packages were a mix of text and binary. The package itself was binary filed, and the view resources also.
	The test 2.1 package contains a stb version 1 Views and so exercises the whole stb conversion stack. We don't have anything with version 0, but that predated the first commercial release."

	| scribble21 notifications stbUpgradeMessage |
	scribble21 := 'ScribbleTestPackages\2.1\ScribbleTest21.pac'.
	notifications := self loadTestAndUninstallPackage: scribble21.
	self assert: notifications size equals: 4.
	stbUpgradeMessage := 'Converting package from version 4 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications second description
		equals: 'Loading package ''ScribbleTest21'' from: <1d>' << (self resourceFilename: scribble21).
	"The package object is deserialized twice"
	stbUpgradeMessage := 'Converting package from version 4 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications fourth description
		equals: 'The package ''ScribbleTest21'' was saved with a different version of the Dolphin VM (98.2). 
It will probably load, but it may not operate correctly. 
If you experience subsequent problems please contact the package supplier for an updated version.'!

testLoad40Pac
	| notifications scribble4pac |
	scribble4pac := 'ScribbleTestPackages\4.0\ScribbleTest4.pac'.
	notifications := self loadTestAndUninstallPackage: scribble4pac.
	self assert: notifications single description
		equals: 'Loading package ''ScribbleTest4'' from: <1d>' << (self resourceFilename: scribble4pac)!

testLoad40Pax
	| scribble4pax notifications |
	scribble4pax := 'ScribbleTestPackages\4.0\ScribbleTest4.pax'.
	notifications := self loadTestAndUninstallPackage: scribble4pax.
	self assert: notifications size equals: 2.
	self assert: notifications first description
		equals: 'Loading source package ''ScribbleTest4'' from: <1d>'
				<< (self resourceFilename: scribble4pax).
	self assert: notifications second description
		equals: 'ReferenceView can''t load ''Scribble.Scribble test'''!

testLoad51Pac
	| notifications scribble51pac |
	scribble51pac := 'ScribbleTestPackages\5.1\ScribbleTest51.pac'.
	notifications := self loadTestAndUninstallPackage: scribble51pac.
	self assert: notifications single description
		equals: 'Loading package ''ScribbleTest51'' from: <1d>' << (self resourceFilename: scribble51pac)!

testLoad51Pax
	| notifications scribble51pax |
	scribble51pax := 'ScribbleTestPackages\5.1\ScribbleTest51.pax'.
	notifications := self loadTestAndUninstallPackage: scribble51pax.
	self assert: notifications size equals: 2.
	self assert: notifications first description
		equals: 'Loading source package ''ScribbleTest51'' from: <1d>'
				<< (self resourceFilename: scribble51pax).
	self assert: notifications second description
		equals: 'ReferenceView can''t load ''Scribble.Scribble test'''!

testLoad60Pac
	| notifications scribble6pac |
	scribble6pac := 'ScribbleTestPackages\6.0\ScribbleTest6.pac'.
	notifications := self loadTestAndUninstallPackage: scribble6pac.
	self assert: notifications single description
		equals: 'Loading package ''ScribbleTest6'' from: <1d>' << (self resourceFilename: scribble6pac)!

testLoad60Pax
	| notifications scribble6pax |
	scribble6pax := 'ScribbleTestPackages\6.0\ScribbleTest6.pax'.
	notifications := self loadTestAndUninstallPackage: scribble6pax.
	self assert: notifications single description
		equals: 'Loading source package ''ScribbleTest6'' from: <1d>'
				<< (self resourceFilename: scribble6pax)!

testLoad70Pax
	"Test loading of D7 package in version 1 pax format."

	| scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool poolConst testPackagePath filer actual expected method notifications |
	testPackagePath := 'ScribbleTestPackages\7.0\ScribbleTest7.pax'.
	notifications := self loadAndTestPackage: testPackagePath.
	self assert: notifications single description
		equals: 'Loading source package ''ScribbleTest7'' from: <1d>'
				<< (self resourceFilename: testPackagePath).
	scribbleTestPackage := loadedPackages first.
	self assert: scribbleTestPackage paxVersion equals: 1.
	aliasName := #{Smalltalk.AliasToScribbleTest}.
	self assert: scribbleTestPackage aliasVariableNames asArray equals: { aliasName }.
	self assert: aliasName value identicalTo: #{Smalltalk.ScribbleTest} value.
	self assert: (scribbleTestPackage manager packageOfVariableNamed: aliasName)
		identicalTo: scribbleTestPackage.
	binaryVariableName := #{Smalltalk.ScribbleTestBinaryGlobal}.
	self assert: scribbleTestPackage binaryVariableNames asArray equals: { binaryVariableName }.
	self assert: (scribbleTestPackage manager packageOfVariableNamed: binaryVariableName)
		identicalTo: scribbleTestPackage.
	self assert: binaryVariableName value equals: #('Scribble').
	self assert: scribbleTestPackage sourceVariableNames asArray equals: #().
	sourceVariableName := #{Smalltalk.ScribbleTestSourceGlobal}.
	"We should still find the class binding among the packaged variables"
	self assert: (scribbleTestPackage manager packageOfVariableNamed: sourceVariableName)
		identicalTo: scribbleTestPackage.
	self assert: (scribbleTestPackage classNames includes: sourceVariableName).
	testPool := sourceVariableName value.
	self assert: testPool isKindOf: SharedPool class.
	poolConst := testPool bindingFor: 'ConstantString'.
	self assert: poolConst isClassVariable.
	self assert: poolConst isImmutable.
	self assert: poolConst value equals: 'abc'.
	self
		assert: (MethodName className: #{Smalltalk.ScribbleTest} selector: #string) value literals first
		equals: poolConst.
	self assert: #{Smalltalk.ScribbleTest} value new string equals: 'abc'.
	method := Object >> #scribble.
	self assert: method environment identicalTo: Smalltalk.
	self assert: method owningPackage identicalTo: scribbleTestPackage.
	self assert: (method value: Object new withArguments: #()) identicalTo: #{Smalltalk.Scribble} value.

	"Now verify it round trips"
	filer := scribbleTestPackage sourceFilerClass on: String writeStream.
	filer fileOutPackage: scribbleTestPackage.
	actual := filer stream contents.
	expected := File
				readAllText: (File change: (self resourceFilename: testPackagePath) extension: 'pac').
	"
	Smalltalk.DiffBrowser compare: actual with: expected
	"
	self assert: actual equals: expected.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoad72Pax
	"Test loading of the interim 2.0 package format which uses BindingReferences, but not namespace qualified names."

	| testPackagePath scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool notifications |
	testPackagePath := 'ScribbleTestPackages\7.2\ScribbleTest72.pax'.
	notifications := self loadAndTestPackage: testPackagePath.
	self assert: notifications single description
		equals: 'Loading source package ''ScribbleTest72'' from: <1d>'
				<< (self resourceFilename: testPackagePath).
	scribbleTestPackage := loadedPackages first.
	"Package gets downgraded to version 1 format as we don't want to support the interim source format going forward"
	self assert: scribbleTestPackage paxVersion equals: 1.
	aliasName := #{Smalltalk.AliasToScribbleTest}.
	self assert: scribbleTestPackage aliasVariableNames asArray equals: { aliasName }.
	self assert: aliasName value identicalTo: #{Smalltalk.ScribbleTest} value.
	binaryVariableName := #{Smalltalk.ScribbleTestBinaryGlobal}.
	self assert: scribbleTestPackage binaryVariableNames asArray equals: { binaryVariableName }.
	self assert: binaryVariableName value equals: #('Scribble').
	sourceVariableName := #{Smalltalk.ScribbleTestSourceGlobal}.
	self assert: scribbleTestPackage sourceVariableNames asArray equals: #().
	self assert: (scribbleTestPackage classNames includes: sourceVariableName).
	testPool := sourceVariableName value.
	self assert: testPool isKindOf: SharedPool class.
	self verifyTestPackageResources: scribbleTestPackage.
	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoadBinaryVersion0MultifilePackage
	"'Diary' is a very early sample package in binary format. It is from one of the pre-release versions of Dolphin in the initial, stbVersion 0, package definition. It is not a terribly interesting package from a test perspective as it contains only classes (no loose methods, resources, scripts, etc), but it is the earliest one I have found so far and we should be able to at least load it to exercise the STB conversions all the way up the version stack."

	| pac notifications stbUpgradeMessage classNames relPath aliases |
	classNames := self denyDiaryLoaded.
	relPath := 'PackageTests\Diary\Diary.pac'.
	"This package pre-dated MVP, and was built on the original Tool UI framework (I think). We won't be able to run any of the code, but in order to load it we'll have to add aliases for all the old UI framework classes that were subclassed."
	aliases := #(#{Smalltalk.Tool} #{Smalltalk.ColumnView} #{Smalltalk.CompositeToolbarView} #{Smalltalk.ListSelectorModel} #{Smalltalk.BarDecoratorView} #{Smalltalk.PushButtonView} #{Smalltalk.TextEditView} #{Smalltalk.RowView} #{Smalltalk.EnhancedListView})
				select: [:each | each isDefined not and: 
							[each declare value: Object.
							true]].
	
	["(Tools.STBDebugger on: (FileStream read: (self resourceFilename: relPath) text: false)) traceStream: Transcript; next"
	notifications := self loadTestPackage: relPath.
	self assert: (Package manager includesPackageNamed: 'Diary').
	pac := Package manager packageNamed: 'Diary'.
	classNames do: [:each | self assert: each isDefined].
	self assert: pac isLegacySourceFormat.
	self assert: pac paxVersion equals: 1.
	self assert: pac classNames equals: classNames asSet.
	self assert: pac methodNames isEmpty.
	self assert: pac scripts isEmpty.
	self assert: pac comment isEmpty.
	self assert: pac packagePathname equals: 'Resources\Tests\' , relPath.
	self assertIsNil: (pac instVarNamed: 'doNotReuse').
	self uninstallTestPackages.
	self denyDiaryLoaded.
	self assert: notifications size equals: 4.
	stbUpgradeMessage := 'Converting package from version 0 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications second description
		equals: 'Loading package ''Diary'' from: <1d>' << (self resourceFilename: relPath).
	stbUpgradeMessage := 'Converting package from version 0 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications fourth description
		equals: 'The package ''Diary'' was saved with a different version of the Dolphin VM (unknown). 
It will probably load, but it may not operate correctly. 
If you experience subsequent problems please contact the package supplier for an updated version.']
			ensure: [aliases do: [:each | each undeclare]]!

testLoadBinaryVersion3MultifilePackage
	"Early binary format package (stbVersion 3) from 1.0 beta 2e. The HexadecimalBrowser application in the package was based on that in the article 'Using Dolphin Smalltalk' by Wilf LaLonde and John Pugh in the JOOP Feb 97 issue. The application described in the article was written for Dolphin Beta 1, but that preceded the first MVP UI framework that arrived in beta 2.  Aside from a couple of very small tweaks related to the introduction of Unicode in 7.1, it still loads and works in Dolphin 8 more than 25 years later."

	| pac notifications stbUpgradeMessage classNames relPath hexBrowser |
	classNames := self denyHexdecimalBrowserLoaded.
	relPath := 'PackageTests\Hexadecimal Browser\HexdecimalBrowser.pac'.
	"(Tools.STBDebugger on: (FileStream read: (self resourceFilename: relPath) text: false)) traceStream: Transcript; next"
	notifications := self loadTestPackage: relPath.
	self assert: (Package manager includesPackageNamed: 'HexdecimalBrowser').
	pac := Package manager packageNamed: 'HexdecimalBrowser'.
	classNames do: [:each | self assert: each isDefined].
	self assert: pac isLegacySourceFormat.
	self assert: pac paxVersion equals: 1.
	self assert: pac classNames equals: classNames asSet.
	self assert: pac methodNames single
		equals: (MethodName class: Integer selector: #printStringRadix:zeroPadTo:).
	self assert: (Integer >> #printStringRadix:zeroPadTo:) owningPackage identicalTo: pac.
	self assert: pac scripts keys single equals: #postinstall.
	self assert: (pac comment contains: 'JOOP Feb 97').
	self assert: pac packagePathname equals: 'Resources\Tests\' , relPath.
	self assertIsNil: (pac instVarNamed: 'doNotReuse').
	hexBrowser := #{Smalltalk.HexadecimalBrowser} value on: pac packageFileName.
	
	[hexBrowser createView: hexBrowser class defaultView.
	hexBrowser view
		extent: 700 @ 350;
		show]
			ensure: [hexBrowser view destroy].
	self uninstallTestPackages.
	self denyHexdecimalBrowserLoaded.
	self assert: notifications size equals: 5.
	stbUpgradeMessage := 'Converting package from version 3 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications second description
		equals: 'Loading package ''HexdecimalBrowser'' from: <1d>' << (self resourceFilename: relPath).
	stbUpgradeMessage := 'Converting package from version 3 to: <1d>' << Package stbVersion.
	self assert: notifications first description equals: stbUpgradeMessage.
	self assert: notifications fourth description
		equals: 'The package ''HexdecimalBrowser'' was saved with a different version of the Dolphin VM (unknown). 
It will probably load, but it may not operate correctly. 
If you experience subsequent problems please contact the package supplier for an updated version.'.
	"Notification from the (modified) post install script - originally this opened a message box, which has been hacked out"
	self assert: notifications fifth description
		equals: 'Installed HexadecimalBrowser: Please see package comments for notes on this release.'!

testLoadedPackagesAreWellFormed
	Package manager packages do: 
			[:each |
			self verifyPackageElementNamesAreAbsolute: each.
			self verifyPackageElementsExist: each]!

testLooseResourceIdentifiers
	| all loose notLoose |
	loose := Package manager looseResourceIdentifiers.
	self assert: (loose allSatisfy: [:each | each owningClass owningPackage ~= each owningPackage]).
	all := Smalltalk developmentSystem allResourceIdentifiers.
	self assert: (loose difference: all) isEmpty.
	notLoose := all difference: loose.
	self assert: (notLoose allSatisfy: [:each | each owningClass owningPackage = each owningPackage])!

testPropertyManager
	self verifyPropertyManagerOf: Package new!

testStbConvertFromD5Version6
	"STB version 6 Scribble package from Dolphin 4 or 5."

	| bytes package |
	bytes := #[33 83 84 66 32 49 32 70 15 7 0 6 0 0 0 80 97 99 107 97 103 101 0 0 0 0 82 0 0 0 12 0 0 0 83 99 114 105 98 98 108 101 84 101 115 116 82 0 0 0 83 0 0 0 68 58 92 100 101 118 92 98 108 97 105 114 109 99 103 92 68 111 108 112 104 105 110 92 82 101 115 111 117 114 99 101 115 92 84 101 115 116 115 92 83 99 114 105 98 98 108 101 84 101 115 116 80 97 99 107 97 103 101 115 92 53 46 49 92 83 99 114 105 98 98 108 101 84 101 115 116 53 49 46 112 97 99 82 0 0 0 0 0 0 0 202 0 0 0 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 11 0 0 0 73 100 101 110 116 105 116 121 83 101 116 98 0 0 0 1 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 12 0 0 0 83 99 114 105 98 98 108 101 84 101 115 116 202 0 0 0 0 0 0 0 154 0 0 0 0 0 0 0 0 2 0 0 82 0 0 0 12 0 0 0 80 108 117 103 103 97 98 108 101 83 101 116 98 0 0 0 2 0 0 0 6 2 11 0 65 115 115 111 99 105 97 116 105 111 110 0 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 8 0 0 0 83 99 114 105 98 98 108 101 186 0 0 0 0 0 0 0 82 0 0 0 6 0 0 0 108 111 111 115 101 65 146 2 0 0 0 0 0 0 176 2 0 0 186 0 0 0 0 0 0 0 82 0 0 0 6 0 0 0 108 111 111 115 101 67 202 0 0 0 0 0 0 0 240 1 0 0 98 0 0 0 0 0 0 0 202 0 0 0 0 0 0 0 240 1 0 0 98 0 0 0 3 0 0 0 0 2 0 0 82 0 0 0 16 0 0 0 68 111 108 112 104 105 110 32 77 86 80 32 66 97 115 101 82 0 0 0 8 0 0 0 83 99 114 105 98 98 108 101 0 0 0 0 234 0 0 0 0 0 0 0 0 1 0 0 48 3 0 0 202 0 0 0 0 0 0 0 96 2 0 0 98 0 0 0 1 0 0 0 146 2 0 0 0 0 0 0 176 2 0 0 82 0 0 0 13 0 0 0 83 99 114 105 98 98 108 101 32 116 101 115 116 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	package := Object fromBinaryStoreBytes: bytes.
	self assert: package name equals: 'ScribbleTest'.
	self assert: package prerequisiteNames isKindOf: Array.
	self assert: package prerequisiteNames asSortedArray equals: #('Dolphin' 'Dolphin MVP Base' 'Scribble').
	self assert: package classNames equals: (Set withAll: #(#{Smalltalk.ScribbleTest})).
	self assert: package methodNames equals: {MethodName className: #{Smalltalk.Scribble} selector: #looseA. MethodName className: #{Smalltalk.Scribble} selector: #looseC} asSet!

testTimestampInitialized
	self assert: Package new timestamp asInteger equals: 0!

uninstallTestPackages
	loadedPackages notNil
		ifTrue: 
			[loadedPackages do: [:each | Package manager basicUninstall: each].
			loadedPackages := nil]!

verifyAbsoluteExistingName: aBindingReference
	self deny: aBindingReference isRelative.
	self assert: aBindingReference isDefined!

verifyAbsoluteSmalltalkBindingReference: aBindingReference
	self assert: aBindingReference path size equals: 2.
	^self assert: aBindingReference path first equals: 'Smalltalk'!

verifyPackageElementNamesAreAbsolute: aPackage
	aPackage methodNames do: 
			[:each |
			self verifyAbsoluteExistingName: each className.
			self assertNotNil: each valueOrNil].
	aPackage classNames do: [:each | self verifyAbsoluteExistingName: each].
	aPackage variableNames do: [:each | self verifyAbsoluteExistingName: each].
	aPackage untracedVariables do: [:each | self verifyAbsoluteExistingName: each].
	aPackage isLegacySourceFormat ifFalse: [^self].
	aPackage classNames do: [:each | self verifyAbsoluteSmalltalkBindingReference: each].
	aPackage variableNames do: [:each | self verifyAbsoluteSmalltalkBindingReference: each].
	aPackage untracedVariables do: [:each | self verifyAbsoluteSmalltalkBindingReference: each]!

verifyPackageElementsExist: aPackage
	aPackage classNames do: [:each | | class |
		class := each valueOrNil.
		self assert: class notNil.
		self assert: class owningPackage identicalTo: aPackage].
	aPackage methodNames do: [:each | | method |
		method := each valueOrNil.
		self assert: method notNil.
		self assert: method owningPackage identicalTo: aPackage].
	aPackage variableNames do: [:each | self assert: each isDefined].
	aPackage sourceVariableNames do: [:each |
		| value |
		value := each value.
		self assert: value owningPackage identicalTo: aPackage].
	aPackage untracedVariables do: [:each | self assert: each isDefined]!

verifyTestPackageResources: scribbleTestPackage
	| resourceIds scribbleTestDefaultViewId scribbleTestViewId |
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := UI.ResourceIdentifier class: #{Smalltalk.ScribbleTest} value
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	self assertNotNil: scribbleTestDefaultViewId resource.
	scribbleTestViewId := UI.ResourceIdentifier class: #{Smalltalk.Scribble} value name: 'Scribble test'.
	self assert: (resourceIds includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage equals: scribbleTestPackage.
	self assertNotNil: scribbleTestViewId resource! !

!Kernel.Tests.PackageTest categoriesForMethods!
checkNoTestPackageContents!helpers!private! !
checkTestPackageContents!helpers!private! !
d5ForwardRefTestPacContents!constants!private! !
denyDiaryLoaded!helpers!private! !
denyHexdecimalBrowserLoaded!helpers!private! !
loadAndTestPackage:!helpers!private! !
loadTestAndUninstallPackage:!helpers!private! !
loadTestPackage:!helpers!private! !
setUp!private!running! !
tearDown!private!running! !
testForwardRefLoadPac!public!unit tests! !
testLegacyFormatErrorAliasToQualifiedName!public!unit tests! !
testLegacyFormatErrorMethodOfNamespacedClass!public!unit tests! !
testLegacyFormatErrorQualifiedAliasName!public!unit tests! !
testLegacyFormatErrorQualifiedBinaryVariableName!public!unit tests! !
testLegacyFormatErrorQualifiedClassName!public!unit tests! !
testLegacyFormatErrorQualifiedSourceVariableName!public!unit tests! !
testLegacyFormatErrorQualifiedSuperclassName!public!unit tests! !
testLegacyFormatErrorQualifiedUntracedVariable!public!unit tests! !
testLoad20Pac!public!unit tests! !
testLoad21Pac!public!unit tests! !
testLoad40Pac!public!unit tests! !
testLoad40Pax!public!unit tests! !
testLoad51Pac!public!unit tests! !
testLoad51Pax!public!unit tests! !
testLoad60Pac!public!unit tests! !
testLoad60Pax!public!unit tests! !
testLoad70Pax!public!unit tests! !
testLoad72Pax!public!unit tests! !
testLoadBinaryVersion0MultifilePackage!public!unit tests! !
testLoadBinaryVersion3MultifilePackage!public!unit tests! !
testLoadedPackagesAreWellFormed!public!unit tests! !
testLooseResourceIdentifiers!public!unit tests! !
testPropertyManager!public! !
testStbConvertFromD5Version6!public! !
testTimestampInitialized!public!unit tests! !
uninstallTestPackages!private!running! !
verifyAbsoluteExistingName:!helpers!private! !
verifyAbsoluteSmalltalkBindingReference:!helpers!private! !
verifyPackageElementNamesAreAbsolute:!helpers!private! !
verifyPackageElementsExist:!helpers!private! !
verifyTestPackageResources:!helpers!private! !
!

