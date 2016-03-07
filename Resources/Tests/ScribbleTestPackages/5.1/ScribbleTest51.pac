| package |
package := Package name: 'ScribbleTest51'.
package paxVersion: 0;
	basicComment: ''.


package classNames
	add: #ScribbleTest;
	yourself.

package methodNames
	add: #Scribble -> #looseA;
	add: #Scribble -> #looseC;
	yourself.

package resourceNames
	add: #Scribble -> 'Scribble test';
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package allResourceNames: (Set new
	add: #Scribble -> 'Scribble test';
	add: #ScribbleTest -> 'Default scribble test view';
	yourself).

package setPrerequisites: (IdentitySet new
	add: '..\..\..\..\..\Object Arts\Dev\Dolphin5\Object Arts\Dolphin\Base\Dolphin';
	add: '..\..\..\..\..\Object Arts\Dev\Dolphin5\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base';
	add: '..\..\..\..\..\Object Arts\Dev\Dolphin5\Object Arts\Samples\MVP\Scribble\Scribble';
	yourself).

package!

"Class Definitions"!

Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

"Global Aliases"!


"Loose Methods"!

!Scribble methodsFor!

looseA
	^#A!

looseC
	^'C'! !
!Scribble categoriesFor: #looseA!public! !
!Scribble categoriesFor: #looseC!public! !

"End of package definition"!

"Source Globals"!

"Classes"!

ScribbleTest guid: (GUID fromString: '{FB773B56-8ED4-480A-820B-C1A43F6013EA}')!
ScribbleTest comment: ''!
!ScribbleTest categoriesForClass!No category! !
!ScribbleTest methodsFor!

a
	^'A'!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents. 
	scribblePresenter := self add: Scribble new name: 'scribble'.
!

model: aListModel
	"Connects the receiver to aListModel. Since the receiver has the same model as the
	sketch pad (Scribble) component that it holds we pass this down to it."

	super model: aListModel.
	scribblePresenter model: aListModel.! !
!ScribbleTest categoriesFor: #a!public! !
!ScribbleTest categoriesFor: #createComponents!initializing!public! !
!ScribbleTest categoriesFor: #model:!accessing!public! !

!ScribbleTest class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel with: OrderedCollection new!

defaultView
	^'Default scribble test view'! !
!ScribbleTest class categoriesFor: #defaultModel!models!public! !
!ScribbleTest class categoriesFor: #defaultView!public! !

"Binary Globals"!

"Resources"!

(ResourceIdentifier class: Scribble name: 'Scribble test') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: 'IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAAOUDAAAhU1RCIDAgTgUMAAEAAABTVEJWaWV3UHJveHkAAAAA
DgENAFNUQkNsYXNzUHJveHkAAAAANgAGAFN0cmluZw0AAABDb250YWluZXJWaWV3JgAFAEFycmF5
DQAAAAAAAAAAAAAAsgAAAAIAAAA2AAwATGFyZ2VJbnRlZ2VyBAAAAAAAAEQBAAIAYAAAAAAAAAAG
AwMAUkdCAAAAAP8BAAABAQAAgQAAAAAAAAAHAAAAAAAAAAAAAAAGBwwAQm9yZGVyTGF5b3V0AAAA
AAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAFoAAAAAAAAAegAAAAAAAACSAAAADAAAAFNjcmliYmxl
Vmlld7IAAAAKAAAAAAAAAGAAAACyAAAAAgAAAOIAAAAEAAAAAAAARAEAAABAAQAABgEJAExpc3RN
b2RlbAAAAAAOAhIAU1RCQ29sbGVjdGlvblByb3h5AAAAAHoAAAAAAAAAkgAAABEAAABPcmRlcmVk
Q29sbGVjdGlvbrIAAAAAAAAAAgEAAAAAAAD/AQAA/wEAAAEBAAAAAAAABwAAAAAAAAAAAAAABgEP
AE1lc3NhZ2VTZXF1ZW5jZQAAAADKAQAAAAAAAOABAACyAAAAAQAAAAYDCwBNZXNzYWdlU2VuZAAA
AAAOAQ4AU1RCU3ltYm9sUHJveHkAAAAAkgAAABAAAABjcmVhdGVBdDpleHRlbnQ6sgAAAAIAAAAG
AgUAUG9pbnQAAAAAKQAAACkAAADCAgAAAAAAAG0CAAClAQAAQAEAAAYBDwBXSU5ET1dQTEFDRU1F
TlQAAAAANgAJAEJ5dGVBcnJheSwAAAAsAAAAAAAAAAEAAAD/////////////////////FAAAABQA
AABKAQAA5gAAAMoBAAAAAAAA4AEAAAACAAAOAhoAU1RCSWRlbnRpdHlEaWN0aW9uYXJ5UHJveHkA
AAAAegAAAAAAAACSAAAAEgAAAElkZW50aXR5RGljdGlvbmFyebIAAAACAAAAQAEAAJIAAAAIAAAA
c2NyaWJibGUGAgkAUmVjdGFuZ2xlAAAAAMICAAAAAAAAKQAAACkAAADCAgAAAAAAACkAAAApAAAA
IgIAAAAAAADKAQAAAAAAAOABAACyAAAAAQAAAGICAAAAAAAAkAIAALIAAAACAAAAwgIAAAAAAAAV
AAAAFQAAAMICAAAAAAAAvQIAAPUBAABgAAAA8gIAAAAAAAASAwAALAAAACwAAAAAAAAAAAAAAP//
//////////////////8KAAAACgAAAGgBAAAEAQAAygEAAAAAAADgAQAAsgAAAAEAAABAAQAARgUE
AAMAAABJY29uAAAAAAAAAAAQAAAADgIRAFNUQlNpbmdsZXRvblByb3h5AAAAAJoAAAAAAAAAUgAA
AAcAAABEb2xwaGluUgAAABgAAABJbWFnZVJlbGF0aXZlRmlsZUxvY2F0b3K6AAAAAAAAAFIAAAAH
AAAAY3VycmVudFIAAAARAAAAQ29udGFpbmVyVmlldy5pY28OAh8AU1RCRXh0ZXJuYWxSZXNvdXJj
ZUxpYnJhcnlQcm94eQAAAABSAAAAEAAAAGRvbHBoaW5kcjAwNS5kbGwAAAAA'))!

(ResourceIdentifier class: ScribbleTest name: 'Default scribble test view') assign: (Object fromBinaryStoreBytes:
(ByteArray fromBase64String: 'IVNUQiAxIEYCDAABAAAAVmlld1Jlc291cmNlAAAAAA4BJABTVEJSZXNvdXJjZVNUQkJ5dGVBcnJh
eUFjY2Vzc29yUHJveHkAAAAAcgAAAKQDAAAhU1RCIDAgTgUMAAEAAABTVEJWaWV3UHJveHkAAAAA
DgENAFNUQkNsYXNzUHJveHkAAAAANgAGAFN0cmluZw0AAABDb250YWluZXJWaWV3JgAFAEFycmF5
DQAAAAAAAAAAAAAAsgAAAAIAAAA2AAwATGFyZ2VJbnRlZ2VyBAAAAAAAAEQBAAIAYAAAAAAAAAAA
AAAAAAAAAAcAAAAAAAAAAAAAAAYHDABCb3JkZXJMYXlvdXQAAAAAAQAAAAEAAAAAAAAAAAAAAAAA
AAAAAAAAWgAAAAAAAAB6AAAAAAAAAJIAAAANAAAAUmVmZXJlbmNlVmlld7IAAAAMAAAAAAAAAGAA
AACyAAAAAgAAAOIAAAAEAAAAAAAARAEAAgAgAQAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAABgIS
AFJlc291cmNlSWRlbnRpZmllcgAAAAB6AAAAAAAAAJIAAAAIAAAAU2NyaWJibGWSAAAADQAAAFNj
cmliYmxlIHRlc3QAAAAABgEPAE1lc3NhZ2VTZXF1ZW5jZQAAAAAOAhIAU1RCQ29sbGVjdGlvblBy
b3h5AAAAAHoAAAAAAAAAkgAAABEAAABPcmRlcmVkQ29sbGVjdGlvbrIAAAABAAAABgMLAE1lc3Nh
Z2VTZW5kAAAAAA4BDgBTVEJTeW1ib2xQcm94eQAAAACSAAAAEAAAAGNyZWF0ZUF0OmV4dGVudDqy
AAAAAgAAAAYCBQBQb2ludAAAAAABAAAAAQAAAKICAAAAAAAAvQIAAPUBAAAgAQAABgEPAFdJTkRP
V1BMQUNFTUVOVAAAAAA2AAkAQnl0ZUFycmF5LAAAACwAAAAAAAAAAQAAAP//////////////////
//8AAAAAAAAAAF4BAAD6AAAAsgAAAAAAAAAOAhoAU1RCSWRlbnRpdHlEaWN0aW9uYXJ5UHJveHkA
AAAAegAAAAAAAACSAAAAEgAAAElkZW50aXR5RGljdGlvbmFyebIAAAAAAAAAAAAAANIBAAAAAAAA
+gEAAAAAAAAQAgAAsgAAAAEAAABCAgAAAAAAAHACAACyAAAAAgAAAKICAAAAAAAAPQAAAEcAAACi
AgAAAAAAAL0CAAD1AQAAYAAAANICAAAAAAAA8gIAACwAAAAsAAAAAAAAAAAAAAD/////////////
////////HgAAACMAAAB8AQAAHQEAAPoBAAAAAAAAEAIAALIAAAABAAAAIAEAAEYFBAADAAAASWNv
bgAAAAAAAAAAEAAAAA4CEQBTVEJTaW5nbGV0b25Qcm94eQAAAACaAAAAAAAAAFIAAAAHAAAARG9s
cGhpblIAAAAYAAAASW1hZ2VSZWxhdGl2ZUZpbGVMb2NhdG9yugAAAAAAAABSAAAABwAAAGN1cnJl
bnRSAAAAEQAAAENvbnRhaW5lclZpZXcuaWNvDgIfAFNUQkV4dGVybmFsUmVzb3VyY2VMaWJyYXJ5
UHJveHkAAAAAUgAAABAAAABkb2xwaGluZHIwMDUuZGxsAAAAAA=='))!

