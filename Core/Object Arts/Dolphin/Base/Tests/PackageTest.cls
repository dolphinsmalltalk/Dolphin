"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #PackageTest
	instanceVariableNames: 'loadedPackages checkTimestamps defaultPackage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackageTest guid: (GUID fromString: '{0bcde90d-a936-43ee-9e4a-2bdec39abf2a}')!

PackageTest comment: ''!

!PackageTest categoriesForClass!Unclassified! !

!PackageTest methodsFor!

behaviorFromName: aSymbol
	^PackageManager current systemPackage behaviorFromName: aSymbol
		ifAbsent: [self fail: '<1p> is undefined' << aSymbol]!

checkNoTestPackageContents
	| scribbleClass |
	self deny: (Smalltalk includesKey: #ScribbleTest).
	scribbleClass := Smalltalk at: #Scribble.
	self assertIsNil: (scribbleClass compiledMethodAt: #looseA ifAbsent: []).
	self assertIsNil: (scribbleClass compiledMethodAt: #looseC ifAbsent: []).
	self assertIsNil: (scribbleClass class compiledMethodAt: #resource_Scribble_test ifAbsent: [])!

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
	scribbleTestClass := Smalltalk at: #ScribbleTest.
	self assert: (scribbleTestPackage classes identityIncludes: scribbleTestClass).
	scribbleTestResourceMethod := scribbleTestClass class
				compiledMethodAt: #resource_Default_scribble_test_view.
	self assert: scribbleTestResourceMethod owningPackage equals: scribbleTestPackage.
	scribbleClass := Smalltalk at: #Scribble.
	self assert: (scribbleClass compiledMethodAt: #looseA) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass compiledMethodAt: #looseC) owningPackage equals: scribbleTestPackage.
	self assert: (scribbleClass class compiledMethodAt: #resource_Scribble_test) owningPackage
		equals: scribbleTestPackage.
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := ResourceIdentifier class: scribbleTestClass
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	scribbleTestViewId := ResourceIdentifier class: scribbleClass name: 'Scribble test'.
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
	classNames := #(#Diary #DiaryEvent #DiaryEventEditor #DiaryTool).
	classNames do: [:each | self deny: (Smalltalk includesKey: each)].
	^classNames!

denyHexdecimalBrowserLoaded
	| classNames |
	self deny: (Package manager includesPackageNamed: 'HexdecimalBrowser').
	classNames := #(#HexadecimalBrowser #HexadecimalConverter).
	classNames do: [:each | self deny: (Smalltalk includesKey: each)].
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
	var := Package classPool associationAt: 'CheckTimestamps'.
	checkTimestamps := var value.
	var value: true.
	defaultPackage := PackageManager current defaultPackage!

tearDown
	| scribbleClass |
	Package classPool at: 'CheckTimestamps' put: checkTimestamps.
	self uninstallTestPackages.
	"Manually remove the test components in case the uninstall failed or the test package didn't load correctly."
	Smalltalk at: #ScribbleTest ifPresent: [:class | class removeFromSystem].
	scribbleClass := Smalltalk at: #Scribble.
	#(#looseA #looseC) do: [:each | scribbleClass removeSelector: each ifAbsent: []].
	#(#resource_Scribble_test) do: [:each | scribbleClass class removeSelector: each ifAbsent: []].
	Object removeSelector: #scribble ifAbsent: [].
	PackageManager current defaultPackage: defaultPackage.
	super tearDown!

testBehaviorFromName
	"Regression test for fix of bug handling class names containing non-ASCII characters. Note that such names are not syntactically valid in ANSI Smalltalk syntax, but they can easily be generated programmatically, and in future we may want to modernise the syntax to allow these."

	| subject |
	subject := (ClassBuilder forAnonymousSubclassOf: Package) createNewClass new.
	subject class compile: 'classFromName: aString ifAbsent: aBlock ^aString = ''Camión'''.
	self assert: (subject behaviorFromName: 'Camión class' ifAbsent: []) equals: true class!

testForwardRefLoadPac
	"#1720: Test loading and converting of old packages with forward reference view referereces"

	| pacName notifications |
	pacName := self resourceFilename: 'D5LoadTest.pac'.
	(FileStream write: pacName)
		nextPutAll: self d5ForwardRefTestPacContents;
		close.
	notifications := OrderedCollection new.
	[[loadedPackages := Package manager install: pacName]
		on: Notification do: [:ex | notifications add: ex. ex resume]] ensure: [File delete: pacName].
	"self assert: notifications first description equals: "!

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
	self assert: notifications third description equals: stbUpgradeMessage.
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

	| scribbleTestPackage aliasName binaryVariableName sourceVariableName testPool poolConst testPackagePath method notifications |
	testPackagePath := 'ScribbleTestPackages\7.0\ScribbleTest7.pax'.
	notifications := self loadAndTestPackage: testPackagePath.
	self assert: notifications single description
		equals: 'Loading source package ''ScribbleTest7'' from: <1d>'
				<< (self resourceFilename: testPackagePath).
	scribbleTestPackage := loadedPackages first.
	self assert: scribbleTestPackage paxVersion equals: 1.
	aliasName := #AliasToScribbleTest.
	self assert: scribbleTestPackage globalAliases asArray equals: {aliasName}.
	self assert: (Smalltalk at: aliasName) identicalTo: (Smalltalk at: #ScribbleTest).
	self assert: (scribbleTestPackage manager packageOfGlobalNamed: aliasName)
		identicalTo: scribbleTestPackage.
	binaryVariableName := #ScribbleTestBinaryGlobal.
	self assert: scribbleTestPackage binaryGlobalNames asArray equals: {binaryVariableName}.
	self assert: (scribbleTestPackage manager packageOfGlobalNamed: binaryVariableName)
		identicalTo: scribbleTestPackage.
	self assert: (Smalltalk at: binaryVariableName) equals: #('Scribble').
	self assert: scribbleTestPackage sourceGlobalNames asArray equals: #(ScribbleTestSourceGlobal).
	sourceVariableName := #ScribbleTestSourceGlobal.
	"We should still find the class binding among the packaged variables"
	self assert: (scribbleTestPackage manager packageOfGlobalNamed: sourceVariableName)
		identicalTo: scribbleTestPackage.
	testPool := Smalltalk at: sourceVariableName.
	self assert: testPool isKindOf: PoolConstantsDictionary.
	poolConst := testPool bindingFor: 'ConstantString'.
	self assert: poolConst isImmutable.
	self assert: poolConst value equals: 'abc'.
	self assert: ((Smalltalk at: #ScribbleTest) >> #string) literals first equals: poolConst.
	self assert: (Smalltalk at: #ScribbleTest) new string equals: 'abc'.
	method := Object >> #scribble.
	self assert: method owningPackage identicalTo: scribbleTestPackage.
	self assert: (method value: Object new withArguments: #()) identicalTo: (Smalltalk at: #Scribble).

	"In Dolphin 8 we can re-save the package, but not in 7, so that's all folks."

	self uninstallTestPackages.
	self checkNoTestPackageContents!

testLoadBinaryVersion0MultifilePackage
	"'Diary' is a very early sample package in binary format. It is from one of the pre-release versions of Dolphin in the initial, stbVersion 0, package definition. It is not a terribly interesting package from a test perspective as it contains only classes (no loose methods, resources, scripts, etc), but it is the earliest one I have found so far and we should be able to at least load it to exercise the STB conversions all the way up the version stack."

	| pac notifications stbUpgradeMessage classNames relPath aliases |
	classNames := self denyDiaryLoaded.
	relPath := 'PackageTests\Diary\Diary.pac'.
	"This package pre-dated MVP, and was built on the original Tool UI framework (I think). We won't be able to run any of the code, but in order to load it we'll have to add aliases for all the old UI framework classes that were subclassed."
	aliases := #(#Tool #ColumnView #CompositeToolbarView #ListSelectorModel #BarDecoratorView #PushButtonView #TextEditView #RowView #EnhancedListView)
				select: [:each | (Smalltalk includesKey: each) not and: 
							[Smalltalk at: each put: Object.
							true]].
	
	["(STBDebugger on: (FileStream read: (self resourceFilename: relPath) text: false)) traceStream: Transcript; next"
	notifications := self loadTestPackage: relPath.
	self assert: (Package manager includesPackageNamed: 'Diary').
	pac := Package manager packageNamed: 'Diary'.
	classNames do: [:each | self assert: (Smalltalk includesKey: each)].
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
			ensure: [aliases do: [:each | Smalltalk removeKey: each]]!

testLoadBinaryVersion3MultifilePackage
	"Early binary format package (stbVersion 3) from 1.0 beta 2e. The HexadecimalBrowser application in the package was based on that in the article 'Using Dolphin Smalltalk' by Wilf LaLonde and John Pugh in the JOOP Feb 97 issue. The application described in the article was written for Dolphin Beta 1, but that preceded the first MVP UI framework that arrived in beta 2.  Aside from a couple of very small tweaks related to the introduction of Unicode in 7.1, it still loads and works in Dolphin 8 more than 25 years later."

	| pac notifications stbUpgradeMessage classNames relPath hexBrowser |
	classNames := self denyHexdecimalBrowserLoaded.
	relPath := 'PackageTests\Hexadecimal Browser\HexdecimalBrowser.pac'.
	"(Tools.STBDebugger on: (FileStream read: (self resourceFilename: relPath) text: false)) traceStream: Transcript; next"
	notifications := self loadTestPackage: relPath.
	self assert: (Package manager includesPackageNamed: 'HexdecimalBrowser').
	pac := Package manager packageNamed: 'HexdecimalBrowser'.
	classNames do: [:each | self assert: (Smalltalk includesKey: each )].
	self assert: pac paxVersion equals: 1.
	self assert: pac classNames equals: classNames asSet.
	self assert: pac methodNames single equals: #Integer -> #printStringRadix:zeroPadTo:.
	self assert: (Integer >> #printStringRadix:zeroPadTo:) owningPackage identicalTo: pac.
	self assert: pac scripts keys single equals: #postinstall.
	self assert: (pac comment contains: 'JOOP Feb 97').
	self assert: pac packagePathname equals: 'Resources\Tests\' , relPath.
	self assertIsNil: (pac instVarNamed: 'doNotReuse').
	hexBrowser := (Smalltalk at: #HexadecimalBrowser) on: pac packageFileName.
	
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
	self assert: package prerequisiteNames asSortedCollection asArray
		equals: #('Dolphin' 'Dolphin MVP Base' 'Scribble').
	self assert: package classNames equals: (Set withAll: #(#ScribbleTest)).
	self assert: package methodNames equals: {#Scribble -> #looseA. #Scribble -> #looseC} asSet!

testTimestampInitialized
	self assert: Package new timestamp asInteger equals: 0!

uninstallTestPackages
	loadedPackages notNil
		ifTrue: 
			[loadedPackages do: [:each | Package manager basicUninstall: each].
			loadedPackages := nil]!

verifyAbsoluteExistingClass: aSymbol
	self behaviorFromName: aSymbol!

verifyAbsoluteExistingName: aSymbol
	self assert: (Smalltalk includesKey: aSymbol)!

verifyAbsoluteSmalltalkBindingReference: aBindingReference
	self assert: aBindingReference path size equals: 2.
	^self assert: aBindingReference path first equals: 'Smalltalk'!

verifyPackageElementNamesAreAbsolute: aPackage
	aPackage methodNames do: [:each | self verifyAbsoluteExistingClass: each key].
	aPackage classNames do: [:each | self verifyAbsoluteExistingClass: each].
	aPackage globalNames do: [:each | self verifyAbsoluteExistingName: each].
	aPackage untracedGlobals do: [:each | self verifyAbsoluteExistingName: each]!

verifyPackageElementsExist: aPackage
	aPackage classNames do: 
			[:each |
			| class |
			class := Smalltalk at: each.
			self assert: class notNil.
			self assert: class owningPackage identicalTo: aPackage].
	aPackage methodNames do: 
			[:each |
			| method |
			method := (self behaviorFromName: each key) >> each value.
			self assert: method notNil.
			self assert: method owningPackage identicalTo: aPackage].
	aPackage globalNames do: [:each | self assert: (Smalltalk includesKey: each)].
	aPackage sourceGlobalNames do: 
			[:each |
			| value |
			value := Smalltalk at: each.
			self assert: value owningPackage identicalTo: aPackage].
	aPackage untracedGlobals do: [:each | self assert: (Smalltalk includesKey: each)]!

verifyTestPackageResources: scribbleTestPackage
	| resourceIds scribbleTestDefaultViewId scribbleTestViewId |
	resourceIds := scribbleTestPackage allResourceIdentifiers.
	self assert: resourceIds size equals: 2.
	scribbleTestDefaultViewId := ResourceIdentifier class: (Smalltalk at: #ScribbleTest)
				name: 'Default scribble test view'.
	self assert: (resourceIds includes: scribbleTestDefaultViewId).
	self assert: scribbleTestDefaultViewId owningPackage equals: scribbleTestPackage.
	self assertNotNil: scribbleTestDefaultViewId resource.
	scribbleTestViewId := ResourceIdentifier class: (Smalltalk at: #Scribble) name: 'Scribble test'.
	self assert: (resourceIds includes: scribbleTestViewId).
	self assert: scribbleTestViewId owningPackage equals: scribbleTestPackage.
	self assertNotNil: scribbleTestViewId resource! !

!PackageTest categoriesForMethods!
behaviorFromName:!helpers!private! !
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
testBehaviorFromName!public!unit tests! !
testForwardRefLoadPac!public!unit tests! !
testLoad20Pac!public!unit tests! !
testLoad21Pac!public!unit tests! !
testLoad40Pac!public!unit tests! !
testLoad40Pax!public!unit tests! !
testLoad51Pac!public!unit tests! !
testLoad51Pax!public!unit tests! !
testLoad60Pac!public!unit tests! !
testLoad60Pax!public!unit tests! !
testLoad70Pax!public!unit tests! !
testLoadBinaryVersion0MultifilePackage!public!unit tests! !
testLoadBinaryVersion3MultifilePackage!public!unit tests! !
testLoadedPackagesAreWellFormed!public!unit tests! !
testLooseResourceIdentifiers!public!unit tests! !
testPropertyManager!public!unit tests! !
testStbConvertFromD5Version6!public!unit tests! !
testTimestampInitialized!public!unit tests! !
uninstallTestPackages!private!running! !
verifyAbsoluteExistingClass:!helpers!private! !
verifyAbsoluteExistingName:!helpers!private! !
verifyAbsoluteSmalltalkBindingReference:!helpers!private! !
verifyPackageElementNamesAreAbsolute:!helpers!private! !
verifyPackageElementsExist:!helpers!private! !
verifyTestPackageResources:!helpers!private! !
!

